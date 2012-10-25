/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.jsptag;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dspace.app.webui.util.UIUtil;

import org.dspace.browse.BrowseException;
import org.dspace.browse.BrowseIndex;
import org.dspace.browse.CrossLinks;

import org.dspace.content.Bitstream;
import org.dspace.content.DCDate;
import org.dspace.content.DCValue;
import org.dspace.content.Item;
import org.dspace.content.Thumbnail;
import org.dspace.content.service.ItemService;

import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.Utils;

import org.dspace.sort.SortOption;
import org.dspace.storage.bitstore.BitstreamStorageManager;

import java.awt.image.BufferedImage;

import java.util.ArrayList;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.StringTokenizer;

import javax.imageio.ImageIO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.jstl.fmt.LocaleSupport;
import javax.servlet.jsp.tagext.TagSupport;
import org.dspace.content.authority.MetadataAuthorityManager;

/**
 * Tag for display a list of items
 *
 * @author Robert Tansley
 * @version $Revision: 5845 $
 */
public class ItemListTag extends TagSupport
{
    private static Logger log = Logger.getLogger(ItemListTag.class);

    /** Items to display */
    private transient Item[] items;

    /** Row to highlight, -1 for no row */
    private int highlightRow = -1;

    /** Column to emphasise - null, "title" or "date" */
    private String emphColumn;

    /** Config value of thumbnail view toggle */
    private static boolean showThumbs;

    /** Config browse/search width and height */
    private static int thumbItemListMaxWidth;

    private static int thumbItemListMaxHeight;

    /** Config browse/search thumbnail link behaviour */
    private static boolean linkToBitstream = false;

    /** Config to include an edit link */
    private boolean linkToEdit = false;

    /** Config to disable cross links */
    private boolean disableCrossLinks = false;

    /** The default fields to be displayed when listing items */
    private static final String DEFAULT_LIST_FIELDS;

    /** The default widths for the columns */
    private static final String DEFAULT_LIST_WIDTHS;

    /** The default field which is bound to the browse by date */
    private static String dateField = "dc.date.issued";

    /** The default field which is bound to the browse by title */
    private static String titleField = "dc.title";

    private static String authorField = "dc.contributor.*";

    private int authorLimit = -1;

    private transient SortOption sortOption = null;

    private static final long serialVersionUID = 348762897199116432L;

    static
    {
        getThumbSettings();

        if (showThumbs)
        {
            DEFAULT_LIST_FIELDS = "thumbnail, dc.date.issued(date), dc.title, dc.contributor.*";
            DEFAULT_LIST_WIDTHS = "*, 130, 60%, 40%";
        }
        else
        {
            DEFAULT_LIST_FIELDS = "dc.date.issued(date), dc.title, dc.contributor.*";
            DEFAULT_LIST_WIDTHS = "130, 60%, 40%";
        }

        // get the date and title fields
        String dateLine = ConfigurationManager.getProperty("webui.browse.index.date");
        if (dateLine != null)
        {
            dateField = dateLine;
        }

        String titleLine = ConfigurationManager.getProperty("webui.browse.index.title");
        if (titleLine != null)
        {
            titleField = titleLine;
        }

        String authorLine = ConfigurationManager.getProperty("webui.browse.author-field");
        if (authorLine != null)
        {
            authorField = authorLine;
        }
    }

    public ItemListTag()
    {
        super();
    }

    public int doStartTag() throws JspException
    {
        JspWriter out = pageContext.getOut();
        HttpServletRequest hrq = (HttpServletRequest) pageContext.getRequest();

        boolean emphasiseDate = false;
        boolean emphasiseTitle = false;

        if (emphColumn != null)
        {
            emphasiseDate = emphColumn.equalsIgnoreCase("date");
            emphasiseTitle = emphColumn.equalsIgnoreCase("title");
        }

        // get the elements to display
        String configLine = null;
        String widthLine  = null;

        if (sortOption != null)
        {
            if (configLine == null)
            {
                configLine = ConfigurationManager.getProperty("webui.itemlist.sort." + sortOption.getName() + ".columns");
                widthLine  = ConfigurationManager.getProperty("webui.itemlist.sort." + sortOption.getName() + ".widths");
            }

            if (configLine == null)
            {
                configLine = ConfigurationManager.getProperty("webui.itemlist." + sortOption.getName() + ".columns");
                widthLine  = ConfigurationManager.getProperty("webui.itemlist." + sortOption.getName() + ".widths");
            }
        }

        if (configLine == null)
        {
            configLine = ConfigurationManager.getProperty("webui.itemlist.columns");
            widthLine  = ConfigurationManager.getProperty("webui.itemlist.widths");
        }

        // Have we read a field configration from dspace.cfg?
        if (configLine != null)
        {
            // If thumbnails are disabled, strip out any thumbnail column from the configuration
            if (!showThumbs && configLine.contains("thumbnail"))
            {
                // Ensure we haven't got any nulls
                configLine = configLine  == null ? "" : configLine;
                widthLine  = widthLine   == null ? "" : widthLine;

                // Tokenize the field and width lines
                StringTokenizer llt = new StringTokenizer(configLine,  ",");
                StringTokenizer wlt = new StringTokenizer(widthLine, ",");

                StringBuilder newLLine = new StringBuilder();
                StringBuilder newWLine = new StringBuilder();
                while (llt.hasMoreTokens() || wlt.hasMoreTokens())
                {
                    String listTok  = llt.hasMoreTokens() ? llt.nextToken() : null;
                    String widthTok = wlt.hasMoreTokens() ? wlt.nextToken() : null;

                    // Only use the Field and Width tokens, if the field isn't 'thumbnail'
                    if (listTok == null || !listTok.trim().equals("thumbnail"))
                    {
                        if (listTok != null)
                        {
                            if (newLLine.length() > 0)
                            {
                                newLLine.append(",");
                            }

                            newLLine.append(listTok);
                        }

                        if (widthTok != null)
                        {
                            if (newWLine.length() > 0)
                            {
                                newWLine.append(",");
                            }

                            newWLine.append(widthTok);
                        }
                    }
                }

                // Use the newly built configuration file
                configLine  = newLLine.toString();
                widthLine = newWLine.toString();
            }
        }
        else
        {
            configLine = DEFAULT_LIST_FIELDS;
            widthLine = DEFAULT_LIST_WIDTHS;
        }

        // Arrays used to hold the information we will require when outputting each row
        String[] fieldArr  = configLine == null ? new String[0] : configLine.split("\\s*,\\s*");
        String[] widthArr  = widthLine  == null ? new String[0] : widthLine.split("\\s*,\\s*");
        boolean isDate[]   = new boolean[fieldArr.length];
        boolean emph[]     = new boolean[fieldArr.length];
        boolean isAuthor[] = new boolean[fieldArr.length];
        boolean viewFull[] = new boolean[fieldArr.length];
        String[] browseType = new String[fieldArr.length];
        String[] cOddOrEven = new String[fieldArr.length];

        try
        {
            // Get the interlinking configuration too
            CrossLinks cl = new CrossLinks();

            // Get a width for the table
            String tablewidth = ConfigurationManager.getProperty("webui.itemlist.tablewidth");

            // If we have column widths, output a fixed layout table - faster for browsers to render
            // but not if we have to add an 'edit item' button - we can't know how big it will be
            if (widthArr.length > 0 && widthArr.length == fieldArr.length && !linkToEdit)
            {
                // If the table width has been specified, we can make this a fixed layout
                if (!StringUtils.isEmpty(tablewidth))
                {
                    out.println("<table style=\"width: " + tablewidth + "; table-layout: fixed;\" align=\"center\" class=\"miscTableNoColor\" summary=\"This table browses all dspace content\">");
                }
                else
                {
                    // Otherwise, don't constrain the width
                    out.println("<table align=\"center\" class=\"miscTableNoColor\" summary=\"This table browses all dspace content\">");
                }

                // Output the known column widths
                out.print("<colgroup>");

                for (int w = 0; w < widthArr.length; w++)
                {
                    out.print("<col width=\"");

                    // For a thumbnail column of width '*', use the configured max width for thumbnails
                    if (fieldArr[w].equals("thumbnail") && widthArr[w].equals("*"))
                    {
                        out.print(thumbItemListMaxWidth);
                    }
                    else
                    {
                        out.print(StringUtils.isEmpty(widthArr[w]) ? "*" : widthArr[w]);
                    }

                    out.print("\" />");
                }

                out.println("</colgroup>");
            }
            else if (!StringUtils.isEmpty(tablewidth))
            {
                out.println("<table width=\"" + tablewidth + "\" style=\"word-break: break-all\" align=\"center\" class=\"miscTableNoColor\" summary=\"This table browses all dspace content\">");

            }
            else
            {
                out.println("<table align=\"center\" class=\"miscTableNoColor\" summary=\"This table browses all dspace content\">");
            }

            // Output the table headers

            for (int colIdx = 0; colIdx < fieldArr.length; colIdx++)
            {
                String field = fieldArr[colIdx].toLowerCase().trim();
                cOddOrEven[colIdx] = (((colIdx + 1) % 2) == 0 ? "Odd" : "Even");

                // find out if the field is a date
                if (field.indexOf("(date)") > 0)
                {
                    field = field.replaceAll("\\(date\\)", "");
                    isDate[colIdx] = true;
                }

                // Cache any modifications to field
                fieldArr[colIdx] = field;

                // find out if this is the author column
                if (field.equals(authorField))
                {
                    isAuthor[colIdx] = true;
                }

                // find out if this field needs to link out to other browse views
                if (cl.hasLink(field))
                {
                    browseType[colIdx] = cl.getLinkType(field);
                    viewFull[colIdx] = BrowseIndex.getBrowseIndex(browseType[colIdx]).isItemIndex();
                }

                // find out if we are emphasising this field
                if (field.equals(emphColumn))
                {
                    emph[colIdx] = true;
                }
                else if ((field.equals(dateField) && emphasiseDate) ||
                        (field.equals(titleField) && emphasiseTitle))
                {
                    emph[colIdx] = true;
                }

                // prepare the strings for the header
                String id = "t" + Integer.toString(colIdx + 1);
                String css = "";
                String message = "itemlist." + field;
                css = "item" + LocaleSupport.getLocalizedMessage(pageContext, message).replaceAll(" ","");
                String wsize = "200";
                if ( colIdx == 1 ) {
                   wsize="80";
                }
                else if ( colIdx == 2 ) {
                   wsize="400";
                }
                else if ( colIdx == 3 ) {
                   wsize="300";
                }

                // output the header
                out.println("<tr>");
                out.print("<th id=\"" + id +  "\" class=\"" + css + "\" width=\"" + wsize + "\">"
                        + (emph[colIdx] ? "<strong>" : "")
                        + LocaleSupport.getLocalizedMessage(pageContext, message)
                        + (emph[colIdx] ? "</strong>" : "") + "</th>");
                out.println("</tr>");
            }

            if (linkToEdit)
            {
                String id = "t" + Integer.toString(cOddOrEven.length + 1);
                String css = "oddRow" + cOddOrEven[cOddOrEven.length - 2] + "Col";

                // output the header
                out.println("<tr>");
                out.print("<th id=\"" + id +  "\" class=\"" + css + "\">"
                        + (emph[emph.length - 2] ? "<strong>" : "")
                        + "&nbsp;" //LocaleSupport.getLocalizedMessage(pageContext, message)
                        + (emph[emph.length - 2] ? "</strong>" : "") + "</th>");
                out.println("</tr>");
            }

            // now output each item row
            for (int i = 0; i < items.length; i++)
            {
                // now prepare the XHTML frag for this division
                String rOddOrEven;
                if (i == highlightRow)
                {
                    rOddOrEven = "highlight";
                }
                else
                {
                    rOddOrEven = ((i & 1) == 1 ? "odd" : "even");
                }

                for (int colIdx = 0; colIdx < fieldArr.length; colIdx++)
                {
                    String field = fieldArr[colIdx];

                    // get the schema and the element qualifier pair
                    // (Note, the schema is not used for anything yet)
                    // (second note, I hate this bit of code.  There must be
                    // a much more elegant way of doing this.  Tomcat has
                    // some weird problems with variations on this code that
                    // I tried, which is why it has ended up the way it is)
                    StringTokenizer eq = new StringTokenizer(field, ".");

                    String[] tokens = { "", "", "" };
                    int k = 0;
                    while(eq.hasMoreTokens())
                    {
                        tokens[k] = eq.nextToken().toLowerCase().trim();
                        k++;
                    }
                    String schema = tokens[0];
                    String element = tokens[1];
                    String qualifier = tokens[2];
                    if ( element.equals("resourcetype") ) {
                       element = "ResourceType";
                    }

                    // first get hold of the relevant metadata for this column
                    DCValue[] metadataArray;
                    String metadata = "-";
                    contextPath = hrq.getContextPath();
                    if ( schema.equals("iugonet") && element.equals("resourcename") ) {
                       metadataArray = items[i].getMetadata("iugonet","Catalog","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","DisplayData","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","NumericalData","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Instrument","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Observatory","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Repository","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Document","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Registry","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Service","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Annotation","ResourceHeaderResourceName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Person","PersonName",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       metadataArray = items[i].getMetadata("iugonet","Granule","ResourceID",Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">"
                       + Utils.addEntities(metadataArray[0].value)
                       + "</a>";
                       }
                       if ( metadata.equals("-") ) {
                       metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                       + items[i].getHandle() + "\">-</a>";
                       }
                    }
                    else if ( schema.equals("iugonet") && element.equals("ResourceType") ) {
                       metadataArray = items[i].getMetadata("iugonet","ResourceType",null,Item.ANY);
                       if ( metadataArray != null && metadataArray.length > 0 ) {
                       if ( "NumericalData".equals(metadataArray[0].value) ) {
                       metadata = "<em>" + Utils.addEntities("Data Set") + "</em>";
                       }
                       else if ( "Granule".equals(metadataArray[0].value) ) {
                       metadata = "<em>" + Utils.addEntities("Data File/Plot") + "</em>";
                       }
                       else {
                       metadata = "<em>" + Utils.addEntities(metadataArray[0].value) + "</em>";
                       }
                       }
                    }
                    else if ( schema.equals("iugonet") && element.equals("description") ) {
                       StringBuffer sb = new StringBuffer();
                       sb.append( getCatalog("ResourceHeaderDescription", i, items ) );
                       sb.append( getCatalog("TimeSpanStartDate", i, items ) );
                       sb.append( getCatalog("TimeSpanStopDate", i, items ) );
                       sb.append( getCatalog("TimeSpanRelativeStopDate", i, items ) );
                       sb.append( getCatalog("AccessInformationAccessURLURL", i, items ) );
                       sb.append( getDisplayData("ResourceHeaderDescription", i, items ) );
                       sb.append( getDisplayData("TemporalDescriptionTimeSpanStartDate", i, items ) );
                       sb.append( getDisplayData("TemporalDescriptionTimeSpanStopDate", i, items ) );
                       sb.append( getDisplayData("TemporalDescriptionTimeSpanRelativeStopDate", i, items ) );
                       sb.append( getDisplayData("AccessInformationAccessURLURL", i, items ) );
                       sb.append( getNumericalData("ResourceHeaderDescription", i, items ) );
                       sb.append( getNumericalData("TemporalDescriptionTimeSpanStartDate", i, items ) );
                       sb.append( getNumericalData("TemporalDescriptionTimeSpanStopDate", i, items ) );
                       sb.append( getNumericalData("TemporalDescriptionTimeSpanRelativeStopDate", i, items ) );
                       sb.append( getNumericalData("AccessInformationAccessURLURL", i, items ) );
                       sb.append( getInstrument("ResourceHeaderDescription", i, items ) );
                       sb.append( getInstrument("InstrumentType", i, items ) );
                       sb.append( getInstrument("InvestigationName", i, items ) );
                       sb.append( getObservatory("ResourceHeaderDescription", i, items) );
                       sb.append( getObservatory("LocationCoordinateSystemName", i, items ) );
                       sb.append( getObservatory("LocationLatitude", i, items ) );
                       sb.append( getObservatory("LocationLongitude", i, items ) );
                       sb.append( getObservatory("ResourceHeaderInformationURLURL", i, items) );
                       sb.append( getPerson("OrganizationName", i, items ) );
                       sb.append( getPerson("Email", i, items ) );
                       sb.append( getRepository("ResourceHeaderDescription", i, items) );
                       sb.append( getRepository("AccessURLURL", i, items ) );
                       sb.append( getDocument("ResourceHeaderDescription", i, items ) );
                       sb.append( getDocument("AccessInformationAccessURLURL", i, items ) );
                       sb.append( getService("ResourceHeaderDescription", i, items ) );
                       sb.append( getRegistry("ResourceHeaderDescription", i,items) );
                       sb.append( getRegistry("AccessURLURL", i, items) );
                       sb.append( getAnnotation("ResourceHeaderDescription", i, items) );
                       sb.append( getAnnotation("TimeSpanStartDate", i, items) );
                       sb.append( getAnnotation("TimeSpanStopDate", i, items) );
                       sb.append( getAnnotation("TimeSpanRelativeStopDate", i, items) );
                       sb.append( getGranule("StartDate", i, items ) );
                       sb.append( getGranule("StopDate", i, items ) );
                       sb.append( getGranule("SourceSourceType", i,items ) );
                       sb.append( getGranule("SourceURL", i, items) );
                       int sl = sb.length();
                       if ( sl < 2 ) {
                       metadata = "-";
                       }
                       else {
                       metadata = (sb.delete(sl-2,sl-1)).toString();
                       }
                    }
                    else if ( schema.equals("iugonet") && element.equals("association") ) {
                       StringBuffer sb = new StringBuffer();
                       sb.append( getCatalog("AccessInformationRepositoryID", i, items) );
                       sb.append( getDisplayData("AccessInformationRepositoryID", i, items) );
                       sb.append( getNumericalData("AccessInformationRepositoryID", i, items) );
                       sb.append( getNumericalData("InstrumentID", i, items) );
                       sb.append( getInstrument("ObservatoryID", i, items) );
                       sb.append( getGranule("ParentID", i, items) );
                       int sl = sb.length();
                       if ( sl < 2 ) {
                          metadata = "-";
                       }
                       else {
                          metadata = (sb.delete(sl-2,sl-1)).toString();
                       }
                    }
                    else {
                    if (qualifier.equals("*"))
                    {
                        metadataArray = items[i].getMetadata(schema, element, Item.ANY, Item.ANY);
                    }
                    else if (qualifier.equals(""))
                    {
                        metadataArray = items[i].getMetadata(schema, element, null, Item.ANY);
                    }
                    else
                    {
                        metadataArray = items[i].getMetadata(schema, element, qualifier, Item.ANY);
                    }

                    // save on a null check which would make the code untidy
                    if (metadataArray == null)
                    {
                        metadataArray = new DCValue[0];
                    }

                    // now prepare the content of the table division
                    // String metadata = "-";
                    if (field.equals("thumbnail"))
                    {
                        metadata = getThumbMarkup(hrq, items[i]);
                    }
                    if (metadataArray.length > 0)
                    {
                        // format the date field correctly
                        if (isDate[colIdx])
                        {
                            DCDate dd = new DCDate(metadataArray[0].value);
                            metadata = UIUtil.displayDate(dd, false, false, hrq);
                        }
                        // format the title field correctly for withdrawn items (ie. don't link)
                        else if (field.equals(titleField) && items[i].isWithdrawn())
                        {
                            metadata = Utils.addEntities(metadataArray[0].value);
                        }
                        // format the title field correctly
                        else if (field.equals(titleField))
                        {
                            metadata = "<a href=\"" + hrq.getContextPath() + "/handle/"
                            + items[i].getHandle() + "\">"
                            + Utils.addEntities(metadataArray[0].value)
                            + "</a>";
                        }
                        // format all other fields
                        else
                        {
                            // limit the number of records if this is the author field (if
                            // -1, then the limit is the full list)
                            boolean truncated = false;
                            int loopLimit = metadataArray.length;
                            if (isAuthor[colIdx])
                            {
                                int fieldMax = (authorLimit > 0 ? authorLimit : metadataArray.length);
                                loopLimit = (fieldMax > metadataArray.length ? metadataArray.length : fieldMax);
                                truncated = (fieldMax < metadataArray.length);
                                log.debug("Limiting output of field " + field + " to " + Integer.toString(loopLimit) + " from an original " + Integer.toString(metadataArray.length));
                            }

                            StringBuffer sb = new StringBuffer();
                            for (int j = 0; j < loopLimit; j++)
                            {
                                String startLink = "";
                                String endLink = "";
                                if (!StringUtils.isEmpty(browseType[colIdx]) && !disableCrossLinks)
                                {
                                    String argument;
                                    String value;
                                    if (metadataArray[j].authority != null &&
                                            metadataArray[j].confidence >= MetadataAuthorityManager.getManager()
                                                .getMinConfidence(metadataArray[j].schema, metadataArray[j].element, metadataArray[j].qualifier))
                                    {
                                        argument = "authority";
                                        value = metadataArray[j].authority;
                                    }
                                    else
                                    {
                                        argument = "value";
                                        value = metadataArray[j].value;
                                    }
                                    if (viewFull[colIdx])
                                    {
                                        argument = "vfocus";
                                    }
                                    startLink = "<a href=\"" + hrq.getContextPath() + "/browse?type=" + browseType[colIdx] + "&amp;" +
                                        argument + "=" + URLEncoder.encode(value,"UTF-8");

                                    if (metadataArray[j].language != null)
                                    {
                                        startLink = startLink + "&amp;" +
                                            argument + "_lang=" + URLEncoder.encode(metadataArray[j].language, "UTF-8");
                                    }

                                    if ("authority".equals(argument))
                                    {
                                        startLink += "\" class=\"authority " +browseType[colIdx] + "\">";
                                    }
                                    else
                                    {
                                        startLink = startLink + "\">";
                                    }
                                    endLink = "</a>";
                                }
                                sb.append(startLink);
                                sb.append(Utils.addEntities(metadataArray[j].value));
                                sb.append(endLink);
                                if (j < (loopLimit - 1))
                                {
                                    sb.append("; ");
                                }
                            }
                            if (truncated)
                            {
                                String etal = LocaleSupport.getLocalizedMessage(pageContext, "itemlist.et-al");
                                sb.append(", ").append(etal);
                            }
                            metadata = "<em>" + sb.toString() + "</em>";
                        }
                    }
                    } // iugonet

                    // prepare extra special layout requirements for dates
                    String extras = "";
                    if (isDate[colIdx])
                    {
                        extras = "nowrap=\"nowrap\" align=\"right\"";
                    }

                    String id = "t" + Integer.toString(colIdx + 1);
                    out.println("<tr>");
                    String css = "";
                    String message = "itemlist." + field;
                    css = "item" + LocaleSupport.getLocalizedMessage(pageContext, message).replaceAll(" ","");

                    out.print("<td headers=\"" + id + "\" class=\""
                        + css +"\" " + extras + ">"
			      + (emph[colIdx] ? "<strong>" : "") + metadata.replaceAll("<br >$","<br />") + (emph[colIdx] ? "</strong>" : "")
                        + "</td>");
                    out.println("</tr>");
                }

                // Add column for 'edit item' links
                if (linkToEdit)
                {
                    String id = "t" + Integer.toString(cOddOrEven.length + 1);

                        out.println("<tr>");
                        out.print("<td headers=\"" + id + "\" class=\""
                            + rOddOrEven + "Row" + cOddOrEven[cOddOrEven.length - 2] + "Col\" nowrap>"
                            + "<form method=\"get\" action=\"" + hrq.getContextPath() + "/tools/edit-item\">"
                            + "<input type=\"hidden\" name=\"handle\" value=\"" + items[i].getHandle() + "\" />"
                            + "<input type=\"submit\" value=\"Edit Item\" /></form>"
                            + "</td>");
                        out.println("</tr>");
                    }
            }

            // close the table
            out.println("</table>");
        }
        catch (IOException ie)
        {
            throw new JspException(ie);
        }
        catch (BrowseException e)
        {
            throw new JspException(e);
        }

        return SKIP_BODY;
    }

    String contextPath;
    String elem_separator = "<br />";
    String getCatalog( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Catalog","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Catalog","ResourceHeaderDescription",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessInformationAccessURLURL") ) {
            metadataArray = items[i].getMetadata("iugonet","Catalog","AccessInformationAccessURLURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("\">");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessInformationRepositoryID") ) {
           metadataArray = items[i].getMetadata("iugonet","Catalog","AccessInformationRepositoryID",Item.ANY);
           if ( metadataArray == null ) {
               metadataArray = new DCValue[0];
           }
           if ( metadataArray.length > 0 ) {
              sb.append("Repository: ");
              int loopLimit = metadataArray.length;
              for ( int j=0; j<loopLimit; j++ ) {
                  String str = "<a href=\"" + contextPath + "/browse?type=CatalogRepositoryID&amp;value=" + Utils.addEntities(metadataArray[j].value)+"\">";
                  sb.append( str );
                  sb.append( Utils.addEntities(metadataArray[j].value));
                  sb.append("</a>");
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TimeSpanStartDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Catalog","TimeSpanStartDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Start Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TimeSpanStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Catalog","TimeSpanStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TimeSpanRelativeStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Catalog","TimeSpanRelativeStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Relative Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    if ( transRelativeStopDate(metadataArray[j].value) != null ) {
                      sb.append( Utils.addEntities( transRelativeStopDate(metadataArray[j].value)+" ("+metadataArray[j].value+")") );
                    }
                    else {
                      sb.append( Utils.addEntities( metadataArray[j].value ) );
                    }
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }
    
    String getDisplayData( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","DisplayData","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","DisplayData","ResourceHeaderDescription",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessInformationAccessURLURL") ) {
            metadataArray = items[i].getMetadata("iugonet","DisplayData","AccessInformationAccessURLURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("\">");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessInformationRepositoryID") ) {
           metadataArray = items[i].getMetadata("iugonet","DisplayData","AccessInformationRepositoryID",Item.ANY);
           if ( metadataArray == null ) {
               metadataArray = new DCValue[0];
           }
           if ( metadataArray.length > 0 ) {
              sb.append("Repository: ");
              int loopLimit = metadataArray.length;
              for ( int j=0; j<loopLimit; j++ ) {
                  String str = "<a href=\"" + contextPath + "/browse?type=DisplayDataRepositoryID&amp;value=" + Utils.addEntities(metadataArray[j].value)+"\">";
                  sb.append( str );
                  sb.append( Utils.addEntities(metadataArray[j].value));
                  sb.append("</a>");
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TemporalDescriptionTimeSpanStartDate") ) {
            metadataArray = items[i].getMetadata("iugonet","DisplayData","TemporalDescriptionTimeSpanStartDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Start Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TemporalDescriptionTimeSpanStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","DisplayData","TemporalDescriptionTimeSpanStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TemporalDescriptionTimeSpanRelativeStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","DisplayData","TemporalDescriptionTimeSpanRelativeStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Relative Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    if ( transRelativeStopDate( metadataArray[j].value ) != null ) {
                      sb.append( Utils.addEntities( transRelativeStopDate( metadataArray[j].value)+" ("+metadataArray[j].value+")" ) );
                    }
                    else {
                      sb.append( Utils.addEntities(metadataArray[j].value) );
                    }
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String getNumericalData( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","NumericalData","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","NumericalData","ResourceHeaderDescription",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessInformationAccessURLURL") ) {
            metadataArray = items[i].getMetadata("iugonet","NumericalData","AccessInformationAccessURLURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("\">");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TemporalDescriptionTimeSpanStartDate") ) {
            metadataArray = items[i].getMetadata("iugonet","NumericalData","TemporalDescriptionTimeSpanStartDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Start Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TemporalDescriptionTimeSpanStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","NumericalData","TemporalDescriptionTimeSpanStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TemporalDescriptionTimeSpanRelativeStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","NumericalData","TemporalDescriptionTimeSpanRelativeStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Relative Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    if ( transRelativeStopDate(metadataArray[j].value) != null ) {
                      sb.append( Utils.addEntities(transRelativeStopDate(metadataArray[j].value)+" ("+metadataArray[j].value+")") );
                    }
                    else {
                      sb.append( Utils.addEntities(metadataArray[j].value) );
                    }
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessInformationRepositoryID") ) {
           metadataArray = items[i].getMetadata("iugonet","NumericalData","AccessInformationRepositoryID",Item.ANY);
           if ( metadataArray == null ) {
               metadataArray = new DCValue[0];
           }
           if ( metadataArray.length > 0 ) {
              sb.append("Repository: ");
              int loopLimit = metadataArray.length;
              for ( int j=0; j<loopLimit; j++ ) {
                  String str = "<a href=\"" + contextPath + "/browse?type=NumericalDataRepositoryID&amp;value=" + Utils.addEntities(metadataArray[j].value)+"\">";
                  sb.append( str );
                  sb.append( Utils.addEntities(metadataArray[j].value));
                  sb.append("</a>");
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("InstrumentID") ) {
           metadataArray = items[i].getMetadata("iugonet","NumericalData","InstrumentID",Item.ANY);
           if ( metadataArray == null ) {
               metadataArray = new DCValue[0];
           }
           if ( metadataArray.length > 0 ) {
              sb.append("Instrument: ");
              int loopLimit = metadataArray.length;
              for ( int j=0; j<loopLimit; j++ ) {
                  String str = "<a href=\"" + contextPath + "/browse?type=NumericalDataInstrumentID&amp;value=" + Utils.addEntities(metadataArray[j].value)+"\">";
                  sb.append( str );
                  sb.append( Utils.addEntities(metadataArray[j].value));
                  sb.append("</a>");
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String getInstrument( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Instrument","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Instrument","ResourceHeaderDescription",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("InstrumentType") ) {
            metadataArray = items[i].getMetadata("iugonet","Instrument","InstrumentType",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Type: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("InvestigationName") ) {
            metadataArray = items[i].getMetadata("iugonet","Instrument","InvestigationName",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Investigation Name: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ObservatoryID") ) {
            metadataArray = items[i].getMetadata("iugonet","Instrument","ObservatoryID",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                sb.append("Observatory: ");
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    String str = "<a href=\"" + contextPath + "/browse?type=InstrumentObservatoryID&amp;value=" + Utils.addEntities(metadataArray[j].value)+"\">";
                    sb.append( str );
                    sb.append( Utils.addEntities(metadataArray[j].value));
                    sb.append("</a>");
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String getObservatory( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Observatory","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Observatory","ResourceHeaderDescription",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderInformationURLURL") ) {
            metadataArray = items[i].getMetadata("iugonet","Observatory","ResourceHeaderInformationURLURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("\">");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("LocationCoordinateSystemName") ) {
            metadataArray = items[i].getMetadata("iugonet","Observatory","LocationCoordinateSystemName",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Coordinate System: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("LocationLatitude") ) {
            metadataArray = items[i].getMetadata("iugonet","Observatory","LocationLatitude",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Geographical Latitude: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("LocationLongitude") ) {
            metadataArray = items[i].getMetadata("iugonet","Observatory","LocationLongitude",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Geographical Longitude: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }


    String getPerson( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("PersonName") ) {
            metadataArray = items[i].getMetadata("iugonet","Person","PersonName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    String str = "<a href=\"" + contextPath + "/browse?type=PersonName&amp;value=" + Utils.addEntities(metadataArray[j].value) + "\">";
                    sb.append( str );
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append( "</a>" );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("OrganizationName") ) {
            metadataArray = items[i].getMetadata("iugonet","Person","OrganizationName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        if ( qualifier.equals("Email") ) {
            metadataArray = items[i].getMetadata("iugonet","Person","Email",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Email: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String getRepository( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Repository","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Repository","ResourceHeaderDescription",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessURLURL") ) {
            metadataArray = items[i].getMetadata("iugonet","Repository","AccessURLURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("\">");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String getRegistry( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Registry","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Registry","ResourceHeaderDescription",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessURLURL") ) {
            metadataArray = items[i].getMetadata("iugonet","Registry","AccessURLURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("\">");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String getDocument( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Document","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Document","ResourceHeaderDescription",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("AccessInformationAccessURLURL") ) {
            metadataArray = items[i].getMetadata("iugonet","Document","AccessInformationAccessURLURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("\">");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }    

    String getService( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Service","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Service","ResourceHeaderDescription",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String getAnnotation( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("ResourceHeaderResourceName") ) {
            metadataArray = items[i].getMetadata("iugonet","Annotation","ResourceHeaderResourceName",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ResourceHeaderDescription") ) {
            metadataArray = items[i].getMetadata("iugonet","Annotation","ResourceHeaderDescription",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TimeSpanStartDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Annotation","TimeSpanStartDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Start Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TimeSpanStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Annotation","TimeSpanStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("TimeSpanRelativeStopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Annotation","TimeSpanRelativeStopDate",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Relative Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    if ( transRelativeStopDate(metadataArray[j].value) != null ) {
                       sb.append( Utils.addEntities(transRelativeStopDate(metadataArray[j].value)+" ("+metadataArray[j].value+")") );
                    }
                    else {
                       sb.append( Utils.addEntities(metadataArray[j].value) );
                    }
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }

                }
                return sb.toString();
            }
        }
        return sb.toString();
    }


    String getGranule( String qualifier, int i, Item[] Items ) {
        DCValue[] metadataArray;
        String metadata = "-";
        StringBuffer sb = new StringBuffer();
        if ( qualifier.equals("StartDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Granule","StartDate",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Start Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("StopDate") ) {
            metadataArray = items[i].getMetadata("iugonet","Granule","StopDate",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Stop Date: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("SourceSourceType") ) {
            metadataArray = items[i].getMetadata("iugonet","Granule","SourceSourceType",Item.ANY );
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                sb.append("Source Type: ");
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("SourceURL") ) {
            metadataArray = items[i].getMetadata("iugonet","Granule","SourceURL",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    sb.append("<a href=\"");
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    String suffix[] = Utils.addEntities(metadataArray[j].value).split("\\.");
                    if ( suffix[suffix.length - 1].equals("jpg") ) {
			sb.append("\" rel=\"lightbox\" >");
		    }
		    else {
			sb.append("\">");
		    }
                    sb.append( Utils.addEntities(metadataArray[j].value) );
                    sb.append("</a>");
                    if ( j < (loopLimit-1) ) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        else if ( qualifier.equals("ParentID") ) {
            metadataArray = items[i].getMetadata("iugonet","Granule","ParentID",Item.ANY);
            if ( metadataArray == null ) {
                metadataArray = new DCValue[0];
            }
            if ( metadataArray.length > 0 ) {
                sb.append("Parent resource: ");
                int loopLimit = metadataArray.length;
                for ( int j=0; j<loopLimit; j++ ) {
                    String str = "<a href=\"" + contextPath + "/browse?type=GranuleParentID&amp;value=" + Utils.addEntities(metadataArray[j].value)+"\">";
                    sb.append( str );
                    sb.append( Utils.addEntities(metadataArray[j].value));
                    sb.append("</a>");
                    if ( j<(loopLimit-1)) {
                        sb.append(", ");
                    }
                    else {
                        sb.append(elem_separator);
                    }
                }
                return sb.toString();
            }
        }
        return sb.toString();
    }

    String transRelativeStopDate( String input ) {
        String nstr = input.trim();
        int s = nstr.length();

        int timeP = -1;
        boolean timeT = false;
        String ys = null;
        String ms = null;
        String ds = null;
        String hs = null;
        String mis = null;
        String ss = null;
        for ( int i=s-1; i>=0; i-- ) {
           char c = nstr.charAt(i);
           if ( c == 'T' ) {
              timeP = i;
              timeT = true;
           }
        }
        for ( int i=s-1; i>=0; i-- ) {
            char c = nstr.charAt(i);
            if ( c == 'P' ) {
                break;
            }
            else if ( c == 'Y' ) {
                ys = scan( "year",
                           i, nstr );
            }
            else if ( ( c == 'M' && timeT == false ) ||
                      ( c == 'M' && timeT == true  && i < timeP ) ) {
                ms = scan( "month",
                           i, nstr );
            }
            else if ( c == 'D' ) {
                ds = scan( "day",
                           i, nstr );
            }
            else if ( c == 'H' ) {
                hs = scan( "hour", i, nstr );
            }
            else if ( c == 'M' && timeT == true && i > timeP ) {
                mis = scan( "minute", i, nstr );
            }
            else if ( c == 'S' ) {
                ss = scan( "second", i, nstr );
            }
        }
        String t = "later";
        int a = nstr.charAt(0);
        if ( a == '-' ) {
            t = "ago";

        }
        String rs = null;
        if ( ys == null && ms == null && ds == null &&
             hs == null && mis == null && ss == null ) {
           return rs;
        }
        rs = "";
        if ( ys != null ) {
            rs += ys + " ";
        }
        if ( ms != null ) {
            rs  += ms + " ";
        }
        if ( ds != null ) {
            rs += ds + " ";
        }
        if ( hs != null ) {
            rs += hs + " ";
        }
        if ( mis != null ) {
            rs += mis + " ";
        }
        if ( ss != null ) {
            rs += ss + " ";
        }
        rs += t;
        return rs;
    }
  String scan( String name,
                        int p, String str ) {
        String rstr = null;
        ArrayList<Integer> ca = new ArrayList<Integer>();
        for ( int j=p-1; j>0; j-- ) {
            try {
                ca.add( 0, Integer.parseInt(String.valueOf(str.charAt(j))) );
            }
            catch ( NumberFormatException e ) {
                break;
            }
        }

        char[] cl = new char[ca.size()];
        for ( int j=0; j<ca.size(); j++ ) {
            cl[j] = String.valueOf(ca.get(j)).charAt(0);
        }

        String s = String.copyValueOf( cl );
        int i = Integer.parseInt( s );

        if ( i == 0 ) {
        }
        else if ( i == 1 ) {
            rstr = String.format( "%d %s", i, name );
        }
        else if ( i > 1 ) {
            rstr = String.format( "%d %ss", i, name );

        }
        return rstr;
    }


    public int getAuthorLimit()
    {
        return authorLimit;
    }

    public void setAuthorLimit(int al)
    {
        authorLimit = al;
    }

    public boolean getLinkToEdit()
    {
        return linkToEdit;
    }

    public void setLinkToEdit(boolean edit)
    {
        this.linkToEdit = edit;
    }

    public boolean getDisableCrossLinks()
    {
        return disableCrossLinks;
    }

    public void setDisableCrossLinks(boolean links)
    {
        this.disableCrossLinks = links;
    }

    public SortOption getSortOption()
    {
        return sortOption;
    }

    public void setSortOption(SortOption so)
    {
        sortOption = so;
    }

    /**
     * Get the items to list
     *
     * @return the items
     */
    public Item[] getItems()
    {
        return (Item[]) ArrayUtils.clone(items);
    }

    /**
     * Set the items to list
     *
     * @param itemsIn
     *            the items
     */
    public void setItems(Item[] itemsIn)
    {
        items = (Item[]) ArrayUtils.clone(itemsIn);
    }

    /**
     * Get the row to highlight - null or -1 for no row
     *
     * @return the row to highlight
     */
    public String getHighlightrow()
    {
        return String.valueOf(highlightRow);
    }

    /**
     * Set the row to highlight
     *
     * @param highlightRowIn
     *            the row to highlight or -1 for no highlight
     */
    public void setHighlightrow(String highlightRowIn)
    {
        if ((highlightRowIn == null) || highlightRowIn.equals(""))
        {
            highlightRow = -1;
        }
        else
        {
            try
            {
                highlightRow = Integer.parseInt(highlightRowIn);
            }
            catch (NumberFormatException nfe)
            {
                highlightRow = -1;
            }
        }
    }

    /**
     * Get the column to emphasise - "title", "date" or null
     *
     * @return the column to emphasise
     */
    public String getEmphcolumn()
    {
        return emphColumn;
    }

    /**
     * Set the column to emphasise - "title", "date" or null
     *
     * @param emphColumnIn
     *            column to emphasise
     */
    public void setEmphcolumn(String emphColumnIn)
    {
        emphColumn = emphColumnIn;
    }

    public void release()
    {
        highlightRow = -1;
        emphColumn = null;
        items = null;
    }

    /* get the required thumbnail config items */
    private static void getThumbSettings()
    {
        showThumbs = ConfigurationManager
                .getBooleanProperty("webui.browse.thumbnail.show");

        if (showThumbs)
        {
            thumbItemListMaxHeight = ConfigurationManager
                    .getIntProperty("webui.browse.thumbnail.maxheight");

            if (thumbItemListMaxHeight == 0)
            {
                thumbItemListMaxHeight = ConfigurationManager
                        .getIntProperty("thumbnail.maxheight");
            }

            thumbItemListMaxWidth = ConfigurationManager
                    .getIntProperty("webui.browse.thumbnail.maxwidth");

            if (thumbItemListMaxWidth == 0)
            {
                thumbItemListMaxWidth = ConfigurationManager
                        .getIntProperty("thumbnail.maxwidth");
            }
        }

        String linkBehaviour = ConfigurationManager
                .getProperty("webui.browse.thumbnail.linkbehaviour");

        if ("bitstream".equals(linkBehaviour))
        {
            linkToBitstream = true;
        }
    }

    /*
     * Get the (X)HTML width and height attributes. As the browser is being used
     * for scaling, we only scale down otherwise we'll get hideously chunky
     * images. This means the media filter should be run with the maxheight and
     * maxwidth set greater than or equal to the size of the images required in
     * the search/browse
     */
    private String getScalingAttr(HttpServletRequest hrq, Bitstream bitstream)
            throws JspException
    {
        BufferedImage buf;

        try
        {
            Context c = UIUtil.obtainContext(hrq);

            InputStream is = BitstreamStorageManager.retrieve(c, bitstream
                    .getID());

            //AuthorizeManager.authorizeAction(bContext, this, Constants.READ);
            // 	read in bitstream's image
            buf = ImageIO.read(is);
            is.close();
        }
        catch (SQLException sqle)
        {
            throw new JspException(sqle.getMessage(), sqle);
        }
        catch (IOException ioe)
        {
            throw new JspException(ioe.getMessage(), ioe);
        }

        // now get the image dimensions
        float xsize = (float) buf.getWidth(null);
        float ysize = (float) buf.getHeight(null);

        // scale by x first if needed
        if (xsize > (float) thumbItemListMaxWidth)
        {
            // calculate scaling factor so that xsize * scale = new size (max)
            float scale_factor = (float) thumbItemListMaxWidth / xsize;

            // now reduce x size and y size
            xsize = xsize * scale_factor;
            ysize = ysize * scale_factor;
        }

        // scale by y if needed
        if (ysize > (float) thumbItemListMaxHeight)
        {
            float scale_factor = (float) thumbItemListMaxHeight / ysize;

            // now reduce x size
            // and y size
            xsize = xsize * scale_factor;
            ysize = ysize * scale_factor;
        }

        StringBuffer sb = new StringBuffer("width=\"").append(xsize).append(
                "\" height=\"").append(ysize).append("\"");

        return sb.toString();
    }

    /* generate the (X)HTML required to show the thumbnail */
    private String getThumbMarkup(HttpServletRequest hrq, Item item)
            throws JspException
    {
        try
        {
            Context c = UIUtil.obtainContext(hrq);
            Thumbnail thumbnail = ItemService.getThumbnail(c, item.getID(), linkToBitstream);

            if (thumbnail == null)
            {
                return "";
            }
            StringBuffer thumbFrag = new StringBuffer();

            if (linkToBitstream)
            {
                Bitstream original = thumbnail.getOriginal();
                String link = hrq.getContextPath() + "/bitstream/" + item.getHandle() + "/" + original.getSequenceID() + "/" +
                                UIUtil.encodeBitstreamName(original.getName(), Constants.DEFAULT_ENCODING);
                thumbFrag.append("<a target=\"_blank\" href=\"" + link + "\" />");
            }
            else
            {
                String link = hrq.getContextPath() + "/handle/" + item.getHandle();
                thumbFrag.append("<a href=\"" + link + "\" />");
            }

            Bitstream thumb = thumbnail.getThumb();
            String img = hrq.getContextPath() + "/retrieve/" + thumb.getID() + "/" +
                        UIUtil.encodeBitstreamName(thumb.getName(), Constants.DEFAULT_ENCODING);
            String alt = thumb.getName();
            String scAttr = getScalingAttr(hrq, thumb);
            thumbFrag.append("<img src=\"")
                    .append(img)
                    .append("\" alt=\"").append(alt).append("\" ")
                     .append(scAttr)
                     .append("/ border=\"0\"></a>");

            return thumbFrag.toString();
        }
        catch (SQLException sqle)
        {
            throw new JspException(sqle.getMessage(), sqle);
        }
        catch (UnsupportedEncodingException e)
        {
            throw new JspException("Server does not support DSpace's default encoding. ", e);
        }
	}
    }
