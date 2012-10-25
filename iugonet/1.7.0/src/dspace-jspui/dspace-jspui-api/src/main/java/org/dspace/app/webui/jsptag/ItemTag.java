/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.jsptag;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.MissingResourceException;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.net.URL;
import java.net.HttpURLConnection;
import java.io.InputStreamReader;
import java.io.BufferedReader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.jstl.fmt.LocaleSupport;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang.ArrayUtils;
import org.apache.log4j.Logger;
import org.dspace.app.util.MetadataExposure;
import org.dspace.app.webui.util.StyleSelection;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.browse.BrowseException;
import org.dspace.content.Bitstream;
import org.dspace.content.Bundle;
import org.dspace.content.Collection;
import org.dspace.content.DCDate;
import org.dspace.content.DCValue;
import org.dspace.content.Item;
import org.dspace.content.authority.MetadataAuthorityManager;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.I18nUtil;
import org.dspace.core.PluginManager;
import org.dspace.core.Utils;

// START: ADD by N.UMEMURA, 20120705
import org.w3c.dom.Document;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.NodeList;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathConstants;
// END: ADD by N.UMEMURA, 20120705

/**
 * <P>
 * JSP tag for displaying an item.
 * </P>
 * <P>
 * The fields that are displayed can be configured in <code>dspace.cfg</code>
 * using the <code>webui.itemdisplay.(style)</code> property. The form is
 * </P>
 * 
 * <PRE>
 * 
 * &lt;schema prefix&gt;.&lt;element&gt;[.&lt;qualifier&gt;|.*][(date)|(link)], ...
 * 
 * </PRE>
 * 
 * <P>
 * For example:
 * </P>
 * 
 * <PRE>
 * 
 * dc.title = Dublin Core element 'title' (unqualified)
 * dc.title.alternative = DC element 'title', qualifier 'alternative'
 * dc.title.* = All fields with Dublin Core element 'title' (any or no qualifier)
 * dc.identifier.uri(link) = DC identifier.uri, render as a link
 * dc.date.issued(date) = DC date.issued, render as a date
 * dc.identifier.doi(doi) = DC identifier.doi, render as link to http://dx.doi.org
 * dc.identifier.hdl(handle) = DC identifier.hanlde, render as link to http://hdl.handle.net
 * dc.relation.isPartOf(resolver) = DC relation.isPartOf, render as link to the base url of the resolver 
 *                                  according to the specified urn in the metadata value (doi:xxxx, hdl:xxxxx, 
 *                                  urn:issn:xxxx, etc.)
 * 
 * </PRE>
 * 
 * <P>
 * When using "resolver" in webui.itemdisplay to render identifiers as resolvable
 * links, the base URL is taken from <code>webui.resolver.<n>.baseurl</code> 
 * where <code>webui.resolver.<n>.urn</code> matches the urn specified in the metadata value.
 * The value is appended to the "baseurl" as is, so the baseurl need to end with slash almost in any case.
 * If no urn is specified in the value it will be displayed as simple text.
 * 
 * <PRE>
 * 
 * webui.resolver.1.urn = doi
 * webui.resolver.1.baseurl = http://dx.doi.org/
 * webui.resolver.2.urn = hdl
 * webui.resolver.2.baseurl = http://hdl.handle.net/
 * 
 * </PRE>
 * 
 * For the doi and hdl urn defaults values are provided, respectively http://dx.doi.org/ and 
 * http://hdl.handle.net/ are used.<br> 
 * 
 * If a metadata value with style: "doi", "handle" or "resolver" matches a URL
 * already, it is simply rendered as a link with no other manipulation.
 * </P>
 * 
 * <PRE>
 * 
 * <P>
 * If an item has no value for a particular field, it won't be displayed. The
 * name of the field for display will be drawn from the current UI dictionary,
 * using the key:
 * </P>
 * 
 * <PRE>
 * 
 * &quot;metadata.&lt;style.&gt;.&lt;field&gt;&quot;
 * 
 * e.g. &quot;metadata.thesis.dc.title&quot; &quot;metadata.thesis.dc.contributor.*&quot;
 * &quot;metadata.thesis.dc.date.issued&quot;
 * 
 * 
 * if this key is not found will be used the more general one
 * 
 * &quot;metadata.&lt;field&gt;&quot;
 * 
 * e.g. &quot;metadata.dc.title&quot; &quot;metadata.dc.contributor.*&quot;
 * &quot;metadata.dc.date.issued&quot;
 * 
 * </PRE>
 * 
 * <P>
 * You need to specify which strategy use for select the style for an item.
 * </P>
 * 
 * <PRE>
 * 
 * plugin.single.org.dspace.app.webui.util.StyleSelection = \
 *                      org.dspace.app.webui.util.CollectionStyleSelection
 *                      #org.dspace.app.webui.util.MetadataStyleSelection
 * 
 * </PRE>
 * 
 * <P>
 * With the Collection strategy you can also specify which collections use which
 * views.
 * </P>
 * 
 * <PRE>
 * 
 * webui.itemdisplay.&lt;style&gt;.collections = &lt;collection handle&gt;, ...
 * 
 * </PRE>
 * 
 * <P>
 * FIXME: This should be more database-driven
 * </P>
 * 
 * <PRE>
 * 
 * webui.itemdisplay.thesis.collections = 123456789/24, 123456789/35
 * 
 * </PRE>
 * 
 * <P>
 * With the Metadata strategy you MUST specify which metadata use as name of the
 * style.
 * </P>
 * 
 * <PRE>
 * 
 * webui.itemdisplay.metadata-style = schema.element[.qualifier|.*]
 * 
 * e.g. &quot;dc.type&quot;
 * 
 * </PRE>
 * 
 * @author Robert Tansley
 * @version $Revision: 5845 $
 */
public class ItemTag extends TagSupport
{
    private static final String HANDLE_DEFAULT_BASEURL = "http://hdl.handle.net/";

    private static final String DOI_DEFAULT_BASEURL = "http://dx.doi.org/";

    /** Item to display */
    private transient Item item;

    /** Collections this item appears in */
    private transient Collection[] collections;

    /** The style to use - "default" or "full" */
    private String style;

    /** Whether to show preview thumbs on the item page */
    private boolean showThumbs;

    /** Default DC fields to display, in absence of configuration */
    private static String defaultFields = "dc.title, dc.title.alternative, dc.contributor.*, dc.subject, dc.date.issued(date), dc.publisher, dc.identifier.citation, dc.relation.ispartofseries, dc.description.abstract, dc.description, dc.identifier.govdoc, dc.identifier.uri(link), dc.identifier.isbn, dc.identifier.issn, dc.identifier.ismn, dc.identifier";

    /** log4j logger */
    private static Logger log = Logger.getLogger(ItemTag.class);

    private StyleSelection styleSelection = (StyleSelection) PluginManager.getSinglePlugin(StyleSelection.class);
    
    /** Hashmap of linked metadata to browse, from dspace.cfg */
    private static Map<String,String> linkedMetadata;
    
    /** Hashmap of urn base url resolver, from dspace.cfg */
    private static Map<String,String> urn2baseurl;
    
    /** regex pattern to capture the style of a field, ie <code>schema.element.qualifier(style)</code> */
    private Pattern fieldStylePatter = Pattern.compile(".*\\((.*)\\)");

    private static final long serialVersionUID = -3841266490729417240L;

    // START: ADD by N.UMEMURA, 20120705
    private DOMSource              source   = null;
    private Document               document = null;
    private DocumentBuilder        builder  = null;
    private DocumentBuilderFactory factory  = null;
    private DOMImplementation      domImpl  = null;

    static {
        int i;

        linkedMetadata = new HashMap<String, String>();
        String linkMetadata;

        i = 1;
        do {
            linkMetadata = ConfigurationManager.getProperty("webui.browse.link."+i);
            if (linkMetadata != null) {
                String[] linkedMetadataSplit = linkMetadata.split(":");
                String indexName = linkedMetadataSplit[0].trim();
                String metadataName = linkedMetadataSplit[1].trim();
                linkedMetadata.put(indexName, metadataName);
            }

            i++;
        } while (linkMetadata != null);

        urn2baseurl = new HashMap<String, String>();

        String urn;
        i = 1;
        do {
            urn = ConfigurationManager.getProperty("webui.resolver."+i+".urn");
            if (urn != null) {
                String baseurl = ConfigurationManager.getProperty("webui.resolver."+i+".baseurl");
                if (baseurl != null){
                    urn2baseurl.put(urn, baseurl);
                } else {
                    log.warn("Wrong webui.resolver configuration, you need to specify both webui.resolver.<n>.urn and webui.resolver.<n>.baseurl: missing baseurl for n = "+i);
                }
            }

            i++;
        } while (urn != null);

        // Set sensible default if no config is found for doi & handle
        if (!urn2baseurl.containsKey("doi")){
            urn2baseurl.put("doi",DOI_DEFAULT_BASEURL);
        }

        if (!urn2baseurl.containsKey("hdl")){
            urn2baseurl.put("hdl",HANDLE_DEFAULT_BASEURL);
        }
    }
    
    public ItemTag()
    {
        super();
        getThumbSettings();
    }

    public int doStartTag() throws JspException
    {
        try
        {
            if (style == null || style.equals(""))
            {
                style = styleSelection.getStyleForItem(item);
            }

            if (style.equals("full"))
            {
                renderFull();
            }
            else
            {
                render();
            }
        }
        catch (SQLException sqle)
        {
            throw new JspException(sqle);
        }
        catch (IOException ie)
        {
            throw new JspException(ie);
        }

        return SKIP_BODY;
    }

    /**
     * Get the item this tag should display
     * 
     * @return the item
     */
    public Item getItem()
    {
        return item;
    }

    /**
     * Set the item this tag should display
     * 
     * @param itemIn
     *            the item to display
     */
    public void setItem(Item itemIn)
    {
        item = itemIn;
    }

    /**
     * Get the collections this item is in
     * 
     * @return the collections
     */
    public Collection[] getCollections()
    {
        return (Collection[]) ArrayUtils.clone(collections);
    }

    /**
     * Set the collections this item is in
     * 
     * @param collectionsIn
     *            the collections
     */
    public void setCollections(Collection[] collectionsIn)
    {
        collections = (Collection[]) ArrayUtils.clone(collectionsIn);
    }

    /**
     * Get the style this tag should display
     * 
     * @return the style
     */
    public String getStyle()
    {
        return style;
    }

    /**
     * Set the style this tag should display
     * 
     * @param styleIn
     *            the Style to display
     */
    public void setStyle(String styleIn)
    {
        style = styleIn;
    }

    public void release()
    {
        style = "default";
        item = null;
        collections = null;
    }

    /**
     * Render an item in the given style
     */
    /* -------------------------------------------------------------------------- */
    /*     <<<  START: Drastic Modification by STEL N.UMEMURA, 20120704  >>>      */
    /* -------------------------------------------------------------------------- */
    private void render() throws IOException, SQLException {

        // Debug
//      System.out.println("ItemTag.java ##TRACE> item.render() START --------");

        // Debug
//      System.out.println("ItemTag.java ##DEBUG> item.getID() = [" + item.getID() + "]");

        // Define
        JspWriter out = pageContext.getOut();
        HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();
        Context context = UIUtil.obtainContext(request);

        String strDisplayMode = request.getParameter("m");
        if (strDisplayMode == null) {
            strDisplayMode = "";
        }
        final String DISPLAY_RELATIONAL_METADATA = new String("1");


        // ---- Step.1: Display Original Metadata ---- //

        // Out Token
        out.println("<!-- TOKEN [DO NOT DELETE!!] -->");
        out.println("<!-- TOKEN::METADATA_FIELD_START -->");
        out.println("<div>");

        // Exec
        DCValue[] values_tmp = item.getMetadata(Item.ANY, Item.ANY, Item.ANY, Item.ANY);
        try {
            createXML(values_tmp, strDisplayMode);
            createHTML();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        finally {
        }

        // listCollections();
        try {
            displayGoogleMap();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
        }

        // Out Token
        out.println("</div>");
        out.println("<br/>");
        out.println("<!-- TOKEN [DO NOT DELETE!!] -->");
        out.println("<!-- TOKEN::METADATA_FIELD_END -->");


        // ---- Step.2: Display Relational Metadata ---- //

        // Get Related Resource
        if (!(strDisplayMode.equals(DISPLAY_RELATIONAL_METADATA))) {

            // XML Document Exist (Normal)
            if (document != null) {

                // Define
                XPath xPath = XPathFactory.newInstance().newXPath();
                String strResourceType = new String("");

                // Set ResourceType
                try {
                    // Define
                    String xPath_ResourceType = new String("/dublin_core/dcvalue[@element='ResourceType']");
                    // Get NodeList
                    NodeList nodeResourceType = (NodeList) xPath.evaluate(xPath_ResourceType, document, XPathConstants.NODESET);
                    // Get NodeValue (Normal)
                    if (nodeResourceType.getLength() == 1) {
                        strResourceType = nodeResourceType.item(0).getTextContent();
//                      System.out.println("ItemTag.java ##DEBUG> strResourceType = [" + strResourceType + "]");
                    }
                    // Error
                    else {
                        strResourceType = "";
                    }
                }
                catch (Exception e) {
                    strResourceType = "";
                    e.printStackTrace();
                }
                finally {
                }

                // case: Granule --> DataSet
                if (strResourceType.equals("Granule")) {
                    // Define
                    String strParentID = new String("");
                    // Exec
                    try {
                        // Define
                        String xPath_ParentID = new String("/dublin_core/dcvalue[@qualifier='ParentID']");
                        // Get NodeList
                        NodeList nodeParentID = (NodeList) xPath.evaluate(xPath_ParentID, document, XPathConstants.NODESET);
                        // Get Related Resource
                        for (int i=0; i<nodeParentID.getLength(); i++) {
                            strParentID = nodeParentID.item(i).getTextContent();
//                          System.out.println("ItemTag.java ##DEBUG> strParentID[" + i + "] = [" + strParentID + "]");
                            String strHTML = getRelationalMetadata(strResourceType + "ParentID", strParentID);
                            if (strHTML == null) {
                            }
                            else if (!(strHTML.equals(""))) {
                                out.println("<div><b><a name=\"" + strParentID + "\">Data Set (Related Resource)</a></b></div>");
                                out.println(strHTML);
                            }
                        }
                    }
                    catch (Exception e) {
                        e.printStackTrace();
                    }
                    finally {
                    }
                }

                // case: NumericalData --> Instrument
                if (strResourceType.equals("NumericalData")) {
                    // Define
                    String strInstrumentID = new String("");
                    // Exec
                    try {
                        // Define
                        String xPath_InstrumentID = new String("/dublin_core/dcvalue[@qualifier='InstrumentID']");
                        // Get NodeList
                        NodeList nodeInstrumentID = (NodeList) xPath.evaluate(xPath_InstrumentID, document, XPathConstants.NODESET);
                        // Get Related Resource
                        for (int i=0; i<nodeInstrumentID.getLength(); i++) {
                            strInstrumentID = nodeInstrumentID.item(i).getTextContent();
//                          System.out.println("ItemTag.java ##DEBUG> strInstrumentID[" + i + "] = [" + strInstrumentID + "]");
                            String strHTML = getRelationalMetadata(strResourceType + "InstrumentID", strInstrumentID);
                            if (strHTML == null) {
                            }
                            else if (!(strHTML.equals(""))) {
                                out.println("<div><b><a name=\"" + strInstrumentID + "\">Instrument (Related Resource)</a></b></div>");
                                out.println(strHTML);
                            }
                        }
                    }
                    catch (Exception e) {
                        e.printStackTrace();
                    }
                    finally {
                    }
                }

                // case: Instrument --> Observatory
                if (strResourceType.equals("Instrument")) {
                    // Define
                    String strObservatoryID = new String("");
                    // Exec
                    try {
                        // Define
                        String xPath_ObservatoryID = new String("/dublin_core/dcvalue[@qualifier='ObservatoryID']");
                        // Get NodeList
                        NodeList nodeObservatoryID = (NodeList) xPath.evaluate(xPath_ObservatoryID, document, XPathConstants.NODESET);
                        // Get Related Resource
                        for (int i=0; i<nodeObservatoryID.getLength(); i++) {
                            strObservatoryID = nodeObservatoryID.item(i).getTextContent();
//                          System.out.println("ItemTag.java ##DEBUG> strObservatoryID[" + i + "] = [" + strObservatoryID + "]");
                            String strHTML = getRelationalMetadata(strResourceType + "ObservatoryID", strObservatoryID);
                            if (strHTML == null) {
                            }
                            else if (!(strHTML.equals(""))) {
                                out.println("<div><b><a name=\"" + strObservatoryID + "\">Observatory (Related Resource)</a></b></div>");
                                out.println(strHTML);
                            }
                        }
                    }
                    catch (Exception e) {
                        e.printStackTrace();
                    }
                    finally {
                    }
                }

                // case: Catalog, DisplayData, NumericalData, Instrument --> Person
                if (strResourceType.equals("Catalog") || strResourceType.equals("DisplayData")
                    || strResourceType.equals("NumericalData") || strResourceType.equals("Instrument")) {
                    // Define
                    String strPersonID = new String("");
                    // Exec
                    try {
                        // Define
                        String xPath_PersonID = new String("/dublin_core/dcvalue[@qualifier='ResourceHeaderContactPersonID']");
                        // Get NodeList
                        NodeList nodePersonID = (NodeList) xPath.evaluate(xPath_PersonID, document, XPathConstants.NODESET);
                        // Get Related Resource
                        for (int i=0; i<nodePersonID.getLength(); i++) {
                            strPersonID = nodePersonID.item(i).getTextContent();
//                          System.out.println("ItemTag.java ##DEBUG> strPersonID[" + i + "] = [" + strPersonID + "]");
                            String strHTML = getRelationalMetadata(strResourceType + "PersonID", strPersonID);
                            if (strHTML == null) {
                            }
                            else if (!(strHTML.equals(""))) {
                                out.println("<div><b><a name=\"" + strPersonID + "\">Person (Related Resource)</a></b></div>");
                                out.println(strHTML);
                            }
                        }
                    }
                    catch (Exception e) {
                        e.printStackTrace();
                    }
                    finally {
                    }

                }

            }

        }

        // File Info
        listBitstreams();

        // License
        if (ConfigurationManager.getBooleanProperty("webui.licence_bundle.show")) {
            out.println("<br/><br/>");
            showLicence();
        }

        // Debug
//      System.out.println("ItemTag.java ##TRACE> item.render() END --------");

    }
    /* -------------------------------------------------------------------------- */
    /*      <<<  END: Drastic Modification by STEL N.UMEMURA, 20120704  >>>       */
    /* -------------------------------------------------------------------------- */


    /**
     * Render full item record
     */
    private void renderFull() throws IOException, SQLException
    {
        JspWriter out = pageContext.getOut();
        HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();
        Context context = UIUtil.obtainContext(request);

        // Get all the metadata
        DCValue[] values = item.getMetadata(Item.ANY, Item.ANY, Item.ANY, Item.ANY);

        out.println("<p align=\"center\">"
                + LocaleSupport.getLocalizedMessage(pageContext,
                        "org.dspace.app.webui.jsptag.ItemTag.full") + "</p>");

        // Three column table - DC field, value, language
        out.println("<table width=\"100%\" class=\"itemDisplayTable\">");
        out.println("<tr><th id=\"s1\" class=\"standard\">"
                + LocaleSupport.getLocalizedMessage(pageContext,
                        "org.dspace.app.webui.jsptag.ItemTag.dcfield")
                + "</th><th id=\"s2\" class=\"standard\">"
                + LocaleSupport.getLocalizedMessage(pageContext,
                        "org.dspace.app.webui.jsptag.ItemTag.value")
                + "</th><th id=\"s3\" class=\"standard\">"
                + LocaleSupport.getLocalizedMessage(pageContext,
                        "org.dspace.app.webui.jsptag.ItemTag.lang")
                + "</th></tr>");

        for (int i = 0; i < values.length; i++)
        {
            if (!MetadataExposure.isHidden(context, values[i].schema, values[i].element, values[i].qualifier))
            {
                out.print("<tr><td headers=\"s1\" class=\"metadataFieldLabel\">");
                out.print(values[i].schema);
                out.print("." + values[i].element);

                if (values[i].qualifier != null)
                {
                    out.print("." + values[i].qualifier);
                }

                out.print("</td></tr><tr><td headers=\"s2\" class=\"metadataFieldValue\">");
                if ( values[i].element != null && (values[i].element).equals("ResourceType")  ) {
                    if ( (values[i].value).equals("NumericalData") ) {
                      out.print(Utils.addEntities("Data Set"));
                    }
                    else if ( (values[i].value).equals("Granule") ) {
                      out.print(Utils.addEntities("Data File/Plot") );
                    }
                    else {
                      out.print(Utils.addEntities(values[i].value));
                    }
                   
                }
                else if ( values[i].qualifier != null && (values[i].qualifier).contains("RelativeStopDate") ) {
                   if ( transRelativeStopDate(values[i].value) != null ) {
                      out.print(Utils.addEntities( transRelativeStopDate(values[i].value) + " (" + values[i].value + ")" ));
                   }
                   else {
                      out.print(Utils.addEntities(values[i].value));
                   }
                }
                else {
                   out.print(Utils.addEntities(values[i].value));
                }
                out.print("</td></tr><tr><td headers=\"s3\" class=\"metadataFieldValue\">");

                if (values[i].language == null)
                {
                    out.print("-");
                }
                else
                {
                    out.print(values[i].language);
                }

                out.println("</td></tr>");
            }
        }

        //listCollections();
        displayGoogleMap();

        out.println("</table><br/>");

        listBitstreams();

        if (ConfigurationManager
                .getBooleanProperty("webui.licence_bundle.show"))
        {
            out.println("<br/><br/>");
            showLicence();
        }
    }

    /**
     * List links to collections if information is available
     */
    private void listCollections() throws IOException
    {
        JspWriter out = pageContext.getOut();
        HttpServletRequest request = (HttpServletRequest) pageContext
                .getRequest();

        if (collections != null)
        {
            out.print("<tr><td class=\"metadataFieldLabel\">");
            if (item.getHandle()==null)  // assume workspace item
            {
                out.print(LocaleSupport.getLocalizedMessage(pageContext,
                        "org.dspace.app.webui.jsptag.ItemTag.submitted"));
            }
            else
            {
                out.print(LocaleSupport.getLocalizedMessage(pageContext,
                          "org.dspace.app.webui.jsptag.ItemTag.appears"));
            }
            out.print("</td></tr><tr><td class=\"metadataFieldValue\">");

            for (int i = 0; i < collections.length; i++)
            {
                out.print("<a href=\"");
                out.print(request.getContextPath());
                out.print("/handle/");
                out.print(collections[i].getHandle());
                out.print("\">");
                out.print(collections[i].getMetadata("name"));
                out.print("</a><br/>");
            }

            out.println("</td></tr>");
        }
    }

    /**
     * List bitstreams in the item
     */
    private void listBitstreams() throws IOException
    {
        JspWriter out = pageContext.getOut();
        HttpServletRequest request = (HttpServletRequest) pageContext
                .getRequest();

        out.print("<table align=\"center\" class=\"miscTable\"><tr>");
        out.println("<td class=\"evenRowEvenCol\"><p><strong>"
                + LocaleSupport.getLocalizedMessage(pageContext,
                        "org.dspace.app.webui.jsptag.ItemTag.files")
                + "</strong></p>");

        try
        {
        	Bundle[] bundles = item.getBundles("ORIGINAL");

        	boolean filesExist = false;
            
            for (Bundle bnd : bundles)
            {
            	filesExist = bnd.getBitstreams().length > 0;
            	if (filesExist)
            	{
            		break;
            	}
            }
            
            // if user already has uploaded at least one file
        	if (!filesExist)
        	{
        		out.println("<p>"
        				+ LocaleSupport.getLocalizedMessage(pageContext,
                            "org.dspace.app.webui.jsptag.ItemTag.files.no")
                            + "</p>");
        	}
        	else
        	{
        		boolean html = false;
        		String handle = item.getHandle();
        		Bitstream primaryBitstream = null;

        		Bundle[] bunds = item.getBundles("ORIGINAL");
        		Bundle[] thumbs = item.getBundles("THUMBNAIL");

        		// if item contains multiple bitstreams, display bitstream
        		// description
        		boolean multiFile = false;
        		Bundle[] allBundles = item.getBundles();

        		for (int i = 0, filecount = 0; (i < allBundles.length)
                    	&& !multiFile; i++)
        		{
        			filecount += allBundles[i].getBitstreams().length;
        			multiFile = (filecount > 1);
        		}

        		// check if primary bitstream is html
        		if (bunds[0] != null)
        		{
        			Bitstream[] bits = bunds[0].getBitstreams();

        			for (int i = 0; (i < bits.length) && !html; i++)
        			{
        				if (bits[i].getID() == bunds[0].getPrimaryBitstreamID())
        				{
        					html = bits[i].getFormat().getMIMEType().equals(
        							"text/html");
        					primaryBitstream = bits[i];
        				}
        			}
        		}

        		out
                    .println("<table cellpadding=\"6\"><tr><th id=\"t1\" class=\"standard\">"
                            + LocaleSupport.getLocalizedMessage(pageContext,
                                    "org.dspace.app.webui.jsptag.ItemTag.file")
                            + "</th>");

        		if (multiFile)
        		{

        			out
                        .println("<th id=\"t2\" class=\"standard\">"
                                + LocaleSupport
                                        .getLocalizedMessage(pageContext,
                                                "org.dspace.app.webui.jsptag.ItemTag.description")
                                + "</th>");
        		}

        		out.println("<th id=\"t3\" class=\"standard\">"
                    + LocaleSupport.getLocalizedMessage(pageContext,
                            "org.dspace.app.webui.jsptag.ItemTag.filesize")
                    + "</th><th id=\"t4\" class=\"standard\">"
                    + LocaleSupport.getLocalizedMessage(pageContext,
                            "org.dspace.app.webui.jsptag.ItemTag.fileformat")
                    + "</th></tr>");

            	// if primary bitstream is html, display a link for only that one to
            	// HTMLServlet
            	if (html)
            	{
            		// If no real Handle yet (e.g. because Item is in workflow)
            		// we use the 'fake' Handle db-id/1234 where 1234 is the
            		// database ID of the item.
            		if (handle == null)
            		{
            			handle = "db-id/" + item.getID();
            		}

            		out.print("<tr><td headers=\"t1\" class=\"standard\">");
                    out.print("<a target=\"_blank\" href=\"");
                    out.print(request.getContextPath());
                    out.print("/html/");
                    out.print(handle + "/");
                    out
                        .print(UIUtil.encodeBitstreamName(primaryBitstream
                                .getName(), Constants.DEFAULT_ENCODING));
                    out.print("\">");
                    out.print(primaryBitstream.getName());
                    out.print("</a>");
                    
                    
            		if (multiFile)
            		{
            			out.print("</td><td headers=\"t2\" class=\"standard\">");

            			String desc = primaryBitstream.getDescription();
            			out.print((desc != null) ? desc : "");
            		}

            		out.print("</td><td headers=\"t3\" class=\"standard\">");
                    out.print(UIUtil.formatFileSize(primaryBitstream.getSize()));
                    out.print("</td><td headers=\"t4\" class=\"standard\">");
            		out.print(primaryBitstream.getFormatDescription());
            		out
                        .print("</td><td class=\"standard\"><a target=\"_blank\" href=\"");
            		out.print(request.getContextPath());
            		out.print("/html/");
            		out.print(handle + "/");
            		out
                        .print(UIUtil.encodeBitstreamName(primaryBitstream
                                .getName(), Constants.DEFAULT_ENCODING));
            		out.print("\">"
                        + LocaleSupport.getLocalizedMessage(pageContext,
                                "org.dspace.app.webui.jsptag.ItemTag.view")
                        + "</a></td></tr>");
            	}	
            	else
            	{
            		for (int i = 0; i < bundles.length; i++)
            		{
            			Bitstream[] bitstreams = bundles[i].getBitstreams();

            			for (int k = 0; k < bitstreams.length; k++)
            			{
            				// Skip internal types
            				if (!bitstreams[k].getFormat().isInternal())
            				{

                                // Work out what the bitstream link should be
                                // (persistent
                                // ID if item has Handle)
                                String bsLink = "<a target=\"_blank\" href=\""
                                        + request.getContextPath();

                                if ((handle != null)
                                        && (bitstreams[k].getSequenceID() > 0))
                                {
                                    bsLink = bsLink + "/bitstream/"
                                            + item.getHandle() + "/"
                                            + bitstreams[k].getSequenceID() + "/";
                                }
                                else
                                {
                                    bsLink = bsLink + "/retrieve/"
                                            + bitstreams[k].getID() + "/";
                                }

                                bsLink = bsLink
                                        + UIUtil.encodeBitstreamName(bitstreams[k]
                                            .getName(),
                                            Constants.DEFAULT_ENCODING) + "\">";

            					out
                                    .print("<tr><td headers=\"t1\" class=\"standard\">");
                                out.print(bsLink);
            					out.print(bitstreams[k].getName());
                                out.print("</a>");
                                

            					if (multiFile)
            					{
            						out
                                        .print("</td><td headers=\"t2\" class=\"standard\">");

            						String desc = bitstreams[k].getDescription();
            						out.print((desc != null) ? desc : "");
            					}

            					out
                                    .print("</td><td headers=\"t3\" class=\"standard\">");
                                out.print(UIUtil.formatFileSize(bitstreams[k].getSize()));
            					out
                                .print("</td><td headers=\"t4\" class=\"standard\">");
            					out.print(bitstreams[k].getFormatDescription());
            					out
                                    .print("</td><td class=\"standard\" align=\"center\">");

            					// is there a thumbnail bundle?
            					if ((thumbs.length > 0) && showThumbs)
            					{
            						String tName = bitstreams[k].getName() + ".jpg";
                                    String tAltText = LocaleSupport.getLocalizedMessage(pageContext, "org.dspace.app.webui.jsptag.ItemTag.thumbnail");
            						Bitstream tb = thumbs[0]
                                        .	getBitstreamByName(tName);

            						if (tb != null)
            						{
            							String myPath = request.getContextPath()
                                            	+ "/retrieve/"
                                            	+ tb.getID()
                                            	+ "/"
                                            	+ UIUtil.encodeBitstreamName(tb
                                            			.getName(),
                                            			Constants.DEFAULT_ENCODING);

            							out.print(bsLink);
            							out.print("<img src=\"" + myPath + "\" ");
            							out.print("alt=\"" + tAltText
            									+ "\" /></a><br />");
            						}
            					}

            					out
                                    .print(bsLink
                                            + LocaleSupport
                                                    .getLocalizedMessage(
                                                            pageContext,
                                                            "org.dspace.app.webui.jsptag.ItemTag.view")
                                            + "</a></td></tr>");
            				}
            			}
            		}
            	}

            	out.println("</table>");
        	}
        }
        catch(SQLException sqle)
        {
        	throw new IOException(sqle.getMessage(), sqle);
        }

        out.println("</td></tr></table>");
    }

    private void getThumbSettings()
    {
        showThumbs = ConfigurationManager
                .getBooleanProperty("webui.item.thumbnail.show");
    }

    /**
     * Link to the item licence
     */
    private void showLicence() throws IOException
    {
        JspWriter out = pageContext.getOut();
        HttpServletRequest request = (HttpServletRequest) pageContext
                .getRequest();

        Bundle[] bundles = null;
        try
        {
        	bundles = item.getBundles("LICENSE");
        }
        catch(SQLException sqle)
        {
        	throw new IOException(sqle.getMessage(), sqle);
        }

        out.println("<table align=\"center\" class=\"attentionTable\"><tr>");

        out.println("<td class=\"attentionCell\"><p><strong>"
                + LocaleSupport.getLocalizedMessage(pageContext,
                        "org.dspace.app.webui.jsptag.ItemTag.itemprotected")
                + "</strong></p>");

        for (int i = 0; i < bundles.length; i++)
        {
            Bitstream[] bitstreams = bundles[i].getBitstreams();

            for (int k = 0; k < bitstreams.length; k++)
            {
                out.print("<div align=\"center\" class=\"standard\">");
                out.print("<strong><a target=\"_blank\" href=\"");
                out.print(request.getContextPath());
                out.print("/retrieve/");
                out.print(bitstreams[k].getID() + "/");
                out.print(UIUtil.encodeBitstreamName(bitstreams[k].getName(),
                        Constants.DEFAULT_ENCODING));
                out
                        .print("\">"
                                + LocaleSupport
                                        .getLocalizedMessage(pageContext,
                                                "org.dspace.app.webui.jsptag.ItemTag.viewlicence")
                                + "</a></strong></div>");
            }
        }

        out.println("</td></tr></table>");
    }

    /**
     * Return the browse index related to the field. <code>null</code> if the field is not a browse field
     * (look for <cod>webui.browse.link.<n></code> in dspace.cfg) 
     * 
     * @param field
     * @return the browse index related to the field. Null otherwise 
     * @throws BrowseException 
     */
    private String getBrowseField(String field) throws BrowseException
    {
        for (String indexName : linkedMetadata.keySet())
        {            
            StringTokenizer bw_dcf = new StringTokenizer(linkedMetadata.get(indexName), ".");
            
            String[] bw_tokens = { "", "", "" };
            int i = 0;
            while(bw_dcf.hasMoreTokens())
            {
                bw_tokens[i] = bw_dcf.nextToken().toLowerCase().trim();
                i++;
            }
            String bw_schema = bw_tokens[0];
            String bw_element = bw_tokens[1];
            String bw_qualifier = bw_tokens[2];
            
            StringTokenizer dcf = new StringTokenizer(field, ".");
            
            String[] tokens = { "", "", "" };
            int j = 0;
            while(dcf.hasMoreTokens())
            {
                tokens[j] = dcf.nextToken().toLowerCase().trim();
                j++;
            }
            String schema = tokens[0];
            String element = tokens[1];
            String qualifier = tokens[2];
            if (schema.equals(bw_schema) // schema match
                    && element.equals(bw_element) // element match
                    && (
                              (bw_qualifier != null) && ((qualifier != null && qualifier.equals(bw_qualifier)) // both not null and equals 
                                      || bw_qualifier.equals("*")) // browse link with jolly
                           || (bw_qualifier == null && qualifier == null)) // both null
                        )
            {
                return indexName;
            }
        }
        return null;
    }

    private void displayGoogleMap() throws IOException
    {
        JspWriter out = pageContext.getOut();
        HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
        String handle = item.getHandle();
        DCValue[] value = item.getMetadata("iugonet", "ResourceType", Item.ANY, Item.ANY);
        if(value[0].value.equals("Observatory")){
            DCValue[] name = item.getMetadata("iugonet", Item.ANY, "ResourceHeaderResourceName", Item.ANY);
            DCValue[] lat = item.getMetadata("iugonet", Item.ANY, "LocationLatitude", Item.ANY);
            DCValue[] lon = item.getMetadata("iugonet", Item.ANY, "LocationLongitude", Item.ANY);

            out.print("<table width=\"100%\" class=\"itemDisplayTable\">");  // ADD by N.UMEMURA, 20120724
            out.print("<tr><td class=\"metadataFieldLabel\">");
            out.print("Observatory Location on GoogleMap");
            out.print(":&nbsp;</td></tr><tr><td class=\"metadataFieldValue\">");
            out.print("<script type=\"text/javascript\">load_gmaps(" + lat[0].value + ", " + lon[0].value + ", \'" + name[0].value + "\');</script>");
            out.println("</td></tr>");
            out.println("</table>");  // ADD by N.UMEMURA, 20120724
        }
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


/* --------------------------------------------------------- */
/*  [METHOD] getRelationalMetadata                           */
/* --------------------------------------------------------- */
/*                                                           */
/*  [NEW] ver.1.00 N.UMEMURA, 20110313                       */
/*  [MOD] ver.1.01 N.UMEMURA, 20120726: comment-out          */
/* --------------------------------------------------------- */

    private String getRelationalMetadata(String strBrowseIndex, String strValue) {

        // Define
        HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();
        String strURL          = new String("");
        String strHttpContents = new String("");

        // Debug
//      System.out.println("strBrowseIndex = [" + strBrowseIndex + "]");
//      System.out.println("strValue       = [" + strValue + "]");

        // Exec
        try {

            // Initialize
            strURL =
//              request.getScheme() + "://" + request.getRemoteAddr() + request.getContextPath()
                request.getScheme() + "://localhost" + request.getContextPath()
                + "/browse?"
//              + "type="  + URLEncoder.encode("DisplayDataPersonID", "UTF-8")
                + "type="  + URLEncoder.encode(strBrowseIndex, "UTF-8")
                + "&"
                + "value=" + URLEncoder.encode(strValue, "UTF-8")
                + "&"
                + "m=1" ;
//          System.out.println("strURL = [" + strURL + "]");

            URL url = new URL(strURL);
            HttpURLConnection httpCon = (HttpURLConnection)url.openConnection();
            httpCon.setRequestMethod("GET");
            httpCon.setInstanceFollowRedirects(true);

            // Connect
            httpCon.connect();

            // Set Contents
            InputStreamReader is  = new InputStreamReader(httpCon.getInputStream());
            BufferedReader reader = new BufferedReader(is);
            String strLine = new String("");
            while((strLine = reader.readLine()) != null) {
                strHttpContents = strHttpContents + strLine;                
            }

            // Disconnect
            httpCon.disconnect();
            reader.close();

            // Substring
            String strTokenStart = new String("<!-- TOKEN::METADATA_FIELD_START -->");
            String strTokenEnd   = new String("<!-- TOKEN::METADATA_FIELD_END -->");
            strHttpContents = strHttpContents.substring(strHttpContents.indexOf(strTokenStart), strHttpContents.lastIndexOf(strTokenEnd) + strTokenEnd.length());

        }
        catch (Exception e) {
            strHttpContents = "";
        }
        finally {
            return (strHttpContents);
        }

    }

/* --------------------------------------------------------- */
/*  [METHOD] createXML                                       */
/* --------------------------------------------------------- */
/*                                                           */
/*  [NEW] ver.1.00  N.UMEMURA, 20120726                      */
/* --------------------------------------------------------- */
    private void createXML(DCValue[] values, String strDisplayMode) throws Exception {

        // Debug
//      System.out.println("ItemTag.java ##TRACE> START: ItemTag.java#createXML() --------"); 

        // Define
        String XML_ROOT_ELEMENT        = new String("dublin_core");
        String XML_CHILD_ELEMENT       = new String("dcvalue");
        String XML_ROOT_ATTRIBUTE      = new String("schema");
        String XML_ROOT_ATTRIBUTEVALUE = new String("iugonet");
        String XML_CHILD_ATTRIBUTE_0   = new String("metadata_value_id");
        String XML_CHILD_ATTRIBUTE_1   = new String("element");
        String XML_CHILD_ATTRIBUTE_2   = new String("qualifier");
        org.w3c.dom.Element ELM_ROOT  = null;
        org.w3c.dom.Element ELM_CHILD = null;


        // ---- Step.1: Create XML Builder ---- //
        factory = DocumentBuilderFactory.newInstance();
        builder = factory.newDocumentBuilder();
        domImpl = builder.getDOMImplementation();


        // ---- Step.2: Create ROOT Element ---- //
        document = domImpl.createDocument("", XML_ROOT_ELEMENT, null);
        ELM_ROOT = document.getDocumentElement();
        ELM_ROOT.setAttribute(XML_ROOT_ATTRIBUTE, XML_ROOT_ATTRIBUTEVALUE);


        // ---- Step.3: Add Related-Flag ---- //
        // Define
        ELM_CHILD = document.createElement("relatedflag");
        // Check Arg
        if (strDisplayMode == null) {
            strDisplayMode = "";
        }
        // Set Value
        if (strDisplayMode.equals("1")) {
            ELM_CHILD.appendChild(document.createTextNode("1"));
        }
        else {
            ELM_CHILD.appendChild(document.createTextNode("0"));
        }
        // Set Element
        ELM_ROOT.appendChild(ELM_CHILD);


        // ---- Step.4: Create Child Element ---- //

        // Define
        String strDC_metadata_value_id = new String("");
        String strDC_element           = new String("");
        String strDC_qualifier         = new String("");
        String strDC_value             = new String("");
// -- Option
//      String strDC_language          = new String("");
//      String strDC_schema            = new String("");
//      String strDC_authority         = new String("");
//      String strDC_confidence        = new String("");
// -- Option

        // Create Element
        for (int i=0; i<values.length; i++) {

            // Get Values from DCValue
            strDC_metadata_value_id = Integer.toString(values[i].metadata_value_id);
            strDC_element           = values[i].element;
            strDC_qualifier         = values[i].qualifier;
            strDC_value             = values[i].value;
// -- Option
//          strDC_language          = values[i].language;
//          strDC_schema            = values[i].schema;
//          strDC_authority         = values[i].authority;
//          strDC_confidence        = Integer.toString(values[i].confidence);
// -- Option

            // Check or Overwrite
            if (strDC_metadata_value_id == null) { continue; }
            if (strDC_element   == null) { continue; }
            if (strDC_qualifier == null) { strDC_qualifier = "none"; }
            if (strDC_value     == null) { strDC_value     = ""; }  // or continue?
// -- Option
//          if (strDC_language  == null) { strDC_language  = ""; }
//          if (strDC_schema    == null) { strDC_schema    = ""; }
//          if (strDC_authority == null) { strDC_authority = ""; }
//          if (strDC_confidence == null) { strDC_confidence = ""; }
// -- Option

            // Replace
            if (strDC_qualifier.contains("TimeSpanRelativeStopDate")) {
                strDC_value = transRelativeStopDate(strDC_value) + " (" + strDC_value + ")";
            }                    

            // Debug
//          System.out.println("ItemTag.java ##DEBUG> strDC_metadata_value_id = [" + strDC_metadata_value_id + "]");
//          System.out.println("ItemTag.java ##DEBUG> strDC_element    = [" + strDC_element    + "]");
//          System.out.println("ItemTag.java ##DEBUG> strDC_qualifier  = [" + strDC_qualifier  + "]");
//          System.out.println("ItemTag.java ##DEBUG> strDC_value      = [" + strDC_value      + "]");
// -- Option
//          System.out.println("ItemTag.java ##DEBUG> strDC_language   = [" + strDC_language   + "]");
//          System.out.println("ItemTag.java ##DEBUG> strDC_schema     = [" + strDC_schema     + "]");
//          System.out.println("ItemTag.java ##DEBUG> strDC_authority  = [" + strDC_authority  + "]");
//          System.out.println("ItemTag.java ##DEBUG> strDC_confidence = [" + strDC_confidence + "]");
// -- Option

            // Define
            ELM_CHILD = document.createElement(XML_CHILD_ELEMENT);

            // Set Values
            ELM_CHILD.appendChild(document.createTextNode(strDC_value));
            ELM_CHILD.setAttribute(XML_CHILD_ATTRIBUTE_0, strDC_metadata_value_id);
            ELM_CHILD.setAttribute(XML_CHILD_ATTRIBUTE_1, strDC_element);
            ELM_CHILD.setAttribute(XML_CHILD_ATTRIBUTE_2, strDC_qualifier);
// -- Option
//          ELM_CHILD.setAttribute("language",   strDC_language);
//          ELM_CHILD.setAttribute("schema",     strDC_schema);
//          ELM_CHILD.setAttribute("authority",  strDC_authority);
//          ELM_CHILD.setAttribute("confidence", strDC_confidence);
// -- Option

            // Set Element
            ELM_ROOT.appendChild(ELM_CHILD);

        }


        // ---- Step.5: Set to DOM ---- //
        source = new DOMSource(document);


        // Debug (For Developers)
//      java.io.StringWriter dbg_sw = new java.io.StringWriter();
//      javax.xml.transform.stream.StreamResult dbg_sr = new javax.xml.transform.stream.StreamResult(dbg_sw);
//      javax.xml.transform.TransformerFactory dbg_tff = javax.xml.transform.TransformerFactory.newInstance();
//      javax.xml.transform.Transformer dbg_tf = dbg_tff.newTransformer();
//      dbg_tf.transform(source, dbg_sr);
//      System.out.println("ItemTag.java ##DEBUG> XML = [" + dbg_sw.toString() + "]");


        // Debug
//      System.out.println("ItemTag.java ##END> START: ItemTag.java#createXML() --------"); 


    }


/* --------------------------------------------------------- */
/*  [METHOD] createHTML                                      */
/* --------------------------------------------------------- */
/*                                                           */
/*  [NEW] ver.1.00  N.UMEMURA, 20120726                      */
/* --------------------------------------------------------- */
    private void createHTML() throws Exception {

        // Debug
//      System.out.println("ItemTag.java ##TRACE> START: ItemTag.java#createHTML() --------"); 

        // Define
        JspWriter out = pageContext.getOut();
        String strXSLTFile = ConfigurationManager.getProperty("dspace.dir")
                             + "/webapps/iugonet/WEB-INF/xsl/ItemTag.xsl";
//      System.out.println("ItemTag.java ##DEBUG> strXSLTFile = [" + strXSLTFile + "]");

        // Exec
        TransformerFactory tff = TransformerFactory.newInstance();
        Transformer        tf  = tff.newTransformer(new StreamSource(strXSLTFile));
        tf.setOutputProperty("encoding", "UTF-8");
        tf.transform(source, new StreamResult(out));

        // Debug
//      System.out.println("ItemTag.java ##TRACE> END: ItemTag.java#createHTML() --------"); 


    }

}
