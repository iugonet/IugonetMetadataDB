/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.*;
import java.text.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.TransformerException;
import org.w3c.dom.Document;

import org.apache.log4j.Logger;
import org.dspace.app.util.OpenSearch;
import org.dspace.app.util.SyndicationFeed;
import org.dspace.app.util.Util;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.handle.HandleManager;
import org.dspace.search.DSQuery;
import org.dspace.search.QueryArgs;
import org.dspace.search.QueryResults;
import org.dspace.sort.SortOption;

/**
 * Servlet for producing OpenSearch-compliant search results, and the
 * OpenSearch description document.
 * <p>
 * OpenSearch is a specification for describing and advertising search-engines
 * and their result formats. Commonly, RSS and Atom formats are used, which
 * the current implementation supports, as is HTML (used directly in browsers).
 * NB: this is baseline OpenSearch, no extensions currently supported.
 * </p>
 * <p>
 * The value of the "scope" parameter should be absent (which means no
 * scope restriction), or the handle of a community or collection, otherwise
 * parameters exactly match those of the SearchServlet.
 * </p>
 *
 * @author Richard Rodgers
 *
 */
public class OpenSearchServlet extends DSpaceServlet
{
        private static final long serialVersionUID = 1L;
        private static String msgKey = "org.dspace.app.webui.servlet.FeedServlet";
        /** log4j category */
    private static Logger log = Logger.getLogger(OpenSearchServlet.class);
    // locale-sensitive metadata labels
    private Map<String, Map<String, String>> localeLabels = null;
    
    public void init()
    {
        localeLabels = new HashMap<String, Map<String, String>>();
    }
    
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // dispense with simple service document requests
        String scope = request.getParameter("scope");
        if (scope !=null && "".equals(scope))
        {
                scope = null;
        }
        String path = request.getPathInfo();
        if (path != null && path.endsWith("description.xml"))
        {
                String svcDescrip = OpenSearch.getDescription(scope);
                response.setContentType(OpenSearch.getContentType("opensearchdescription"));
                response.setContentLength(svcDescrip.length());
                response.getWriter().write(svcDescrip);
                return;
        }
        
        // get enough request parameters to decide on action to take
        String format = request.getParameter("format");
        if (format == null || "".equals(format))
        {
                // default to atom
                format = "atom";
        }
        
        // do some sanity checking
        if (! OpenSearch.getFormats().contains(format))
        {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
        }
        
        // then the rest - we are processing the query
        String query = request.getParameter("query");

        // ------------------------------------------- //
        //     << START: ADD UMEMURA, 2012.1.4 >>      //
        //         Copy by SearchServlet.java          //
        // ------------------------------------------- //

        /* ---- Time Range ---- */

        String datetime_start = request.getParameter("ts");
        String datetime_end   = request.getParameter("te");
        String datetime_zone  = request.getParameter("tz");
        String catalog        = request.getParameter("Catalog");
        String displaydata    = request.getParameter("DisplayData");
        String numericaldata  = request.getParameter("NumericalData");
        String person         = request.getParameter("Person");
        String instrument     = request.getParameter("Instrument");
        String observatory    = request.getParameter("Observatory");
        String repository     = request.getParameter("Repository");
        String document       = request.getParameter("Document");
        String registry       = request.getParameter("Registry");
        String service        = request.getParameter("Service");
        String annotation     = request.getParameter("Annotation");
        String granule        = request.getParameter("Granule");
/*
        System.out.println("OpenSearch query=[" + query + "]");
        System.out.println("OpenSearch ts=[" + datetime_start + "]");
        System.out.println("OpenSearch te=[" + datetime_end   + "]");
        System.out.println("OpenSearch tz=[" + datetime_zone  + "]");
*/

        // Check Time-Zone
        if ( datetime_zone != null &&
             ( datetime_zone.equals("UTC") || datetime_zone.equals("JST") ) ) {
        }
        else {
            datetime_zone = "UTC";
        }

        // Define Date Format
        String[] datetimeformat = { "yyyy-MM-dd'T'HH:mm:ss'Z'",
                                    "yyyy-MM-dd'T'HH:mm:ss",
                                    "yyyy-MM-dd'T'HH:mm",
                                    "yyyy-MM-dd'T'HH",
                                    "yyyy-MM-dd",
                                    "yyyy-MM",
                                    "yyyy" };
        String datetimeformat_search = "yyyyMMddHHmmss";

        // Define Char 'query'
        String query_datetime   = "";
        String query_datetime_g = "";

        // Define Date Char
        Date date_start = null;
        Date date_end   = null;

        // Define Current Date
        Date date_now = new Date();


        // Judge and Create 'query'

        // both datetime_start and datetime_end is entered.
        if ( datetime_start != null && datetime_start.length() > 0 &&
             datetime_end   != null && datetime_end.length() > 0 ) {
            boolean dtfmatch_start = false;
            boolean dtfmatch_end   = false;
            int dtfi;
            dtfi = 0;
            while ( dtfmatch_start == false && dtfi < datetimeformat.length ) {
                try {
                    DateFormat df = new SimpleDateFormat( datetimeformat[dtfi] );
                    df.setTimeZone( TimeZone.getTimeZone(datetime_zone) );
                    date_start = df.parse( datetime_start );
                    dtfmatch_start = true;
                }
                catch ( ParseException e ) {
                }
                dtfi++;
            }
            dtfi = 0;
            while ( dtfmatch_end == false && dtfi < datetimeformat.length ) {
                try {
                    DateFormat df = new SimpleDateFormat( datetimeformat[dtfi] );
                    df.setTimeZone( TimeZone.getTimeZone(datetime_zone) );
                    date_end = df.parse( datetime_end );
                    dtfmatch_end = true;
                }
                catch ( ParseException e ) {
                }
                dtfi++;
            }
            if ( dtfmatch_start && dtfmatch_end &&
                 date_start != null && date_end   != null ) {
                if ( date_start.after(date_end) ) {
                    Date tmp_date = date_start;
                    date_start    = date_end;
                    date_end      = tmp_date;
                    String tmp_datetime = datetime_start;
                    datetime_start      = datetime_end;
                    datetime_end        = tmp_datetime;
                }
                DateFormat sdf = new SimpleDateFormat( datetimeformat_search );
                sdf.setTimeZone( TimeZone.getTimeZone("UTC") );

                query_datetime   = String.format("((Date:[%s TO %s] OR (StartDate:[00000101000000 TO %s] AND StopDate:[%s TO 99990101000000])) OR (StartDate:[00000101000000 TO %s] NOT StopDate:[00000101000000 TO 99990101000000]))",
                                                 sdf.format(date_start), sdf.format(date_end), sdf.format(date_start), sdf.format(date_end),
                                                 sdf.format(date_end) );

                query_datetime_g = String.format("(Granule-Date:[%s TO %s] OR (Granule-StartDate:[00000101000000 TO %s] AND Granule-StopDate:[%s TO 99990101000000]))",
                                               sdf.format(date_start), sdf.format(date_end),
                                               sdf.format(date_start), sdf.format(date_end) );
                query_datetime_g = "(" + query_datetime_g + " OR " + query_datetime + ")";
            }
            else {
                System.out.println("Error: dateformat: "+datetime_start+" : "+datetime_end);
                datetime_start = "";
                datetime_end   = "";
            }

        }

        // only datetime_start is entered.
        else if ( datetime_start != null && datetime_start.length() > 0 ) {
            boolean dtfmatch = false;
            int dtfi = 0;
            while ( dtfmatch == false && dtfi < datetimeformat.length ) {
                try {
                    DateFormat df = new SimpleDateFormat( datetimeformat[dtfi] );
                    df.setTimeZone( TimeZone.getTimeZone(datetime_zone) );
                    date_start = df.parse( datetime_start );
                    dtfmatch = true;
                }
                catch ( ParseException e ) {
                }
                dtfi++;
            }
            if ( dtfmatch && date_start != null ) {
                DateFormat sdf = new SimpleDateFormat( datetimeformat_search );
                sdf.setTimeZone( TimeZone.getTimeZone("UTC") );
                query_datetime   = String.format("(Date:[%s TO 99990101000000] OR ((StartDate:[%s TO %s] OR StartDate:[00000101000000 TO %s]) NOT StopDate:[00000101000000 TO 99990101000000]))",
                                                 sdf.format(date_start), sdf.format(date_start), sdf.format(date_now), sdf.format(date_start) );
                query_datetime_g = String.format("Granule-Date:[%s TO 99990101000000]",
                                               sdf.format(date_start) );
                query_datetime_g = "(" + query_datetime_g + " OR " + query_datetime + ")";
                datetime_end = "";
            }
            else {
                System.out.println("Error: dateformat: "+datetime_start+" : "+datetime_end);
                datetime_start = "";
                datetime_end   = "";
            }
        }

        // only datetime_end is entered.
        else if ( datetime_end != null && datetime_end.length() > 0 ) {
            boolean dtfmatch = false;
            int dtfi = 0;
            while ( dtfmatch == false && dtfi < datetimeformat.length ) {
                try {
                    DateFormat df = new SimpleDateFormat( datetimeformat[dtfi] );
                    df.setTimeZone( TimeZone.getTimeZone(datetime_zone) );
                    date_end = df.parse( datetime_end );
                    dtfmatch = true;
                }
                catch ( ParseException e ) {
                }
                dtfi++;
            }
            if ( dtfmatch && date_end != null ) {
                DateFormat sdf = new SimpleDateFormat( datetimeformat_search );
                sdf.setTimeZone( TimeZone.getTimeZone("UTC") );
                query_datetime   = String.format("(Date:[00000101000000 TO %s] OR (StartDate:[00000101000000 TO %s] NOT StopDate:[00000101000000 TO 99990101000000]))",
                                                sdf.format(date_end), sdf.format(date_end) );
                query_datetime_g = String.format("Granule-Date:[00000101000000 TO %s]",
                                               sdf.format(date_end) );
                query_datetime_g = "(" + query_datetime_g + " OR " + query_datetime + ")";
                datetime_start = "";
            }
            else {
                System.out.println("Error: dateformat: "+datetime_start+" : "+datetime_end);
                datetime_start = "";
                datetime_end   = "";
            }
        }

        // both datetime_start and datetime_end is NOT entered.
        else {
            datetime_start = "";
            datetime_end   = "";
            date_start = null;
            date_end   = null;
        }


        // Create Sub Query
        String query_sub = "";
        if ( query_datetime_g != null && query_datetime_g.length() > 0 ) {
            query_sub = query_datetime_g;
        }


        /* ---- Resource Type ---- */

        ArrayList<String> resourceType = new ArrayList<String>();
        if ( catalog != null && catalog.length() > 0 ) {
            resourceType.add( catalog );
        }
        else {
            catalog = "";
        }
        if ( displaydata != null && displaydata.length() > 0 ) {
            resourceType.add( displaydata );
        }
        else {
            displaydata = "";
        }
        if ( numericaldata != null && numericaldata.length() > 0 ) {
            resourceType.add( numericaldata );
        }
        else {
            numericaldata = "";
        }
        if ( person != null && person.length() > 0 ) {
            resourceType.add( person );
        }
        else {
            person = "";
        }
        if ( instrument != null && instrument.length() > 0 ) {
            resourceType.add( instrument );
        }
        else {
            instrument = "";
        }
        if ( observatory != null && observatory.length() > 0 ) {
            resourceType.add( observatory );
        }
        else {
            observatory = "";
        }
        if ( repository != null && repository.length() > 0 ) {
            resourceType.add( repository );
        }
        else {
            repository = "";
        }
        if ( document != null && document.length() > 0 ) {
            resourceType.add( document );
        }
        else {
            document = "";
        }
        if ( registry != null && registry.length() > 0 ) {
            resourceType.add( registry );
        }
        else {
            registry = "";
        }
        if ( service != null && service.length() > 0 ) {
            resourceType.add( service );
        }
        else {
            service = "";
        }
        if ( annotation != null && annotation.length() > 0 ) {
            resourceType.add( annotation );
        }
        else {
            annotation = "";
        }
        if ( granule != null && granule.length() > 0 ) {
            resourceType.add( granule );
        }
        else {
            granule = "";
        }

        // Check parameter for Sun and preprocess
/*
        String query_obj = "";
	if ( search_obj != null && search_obj.equals("earth") ) {
	    query_obj = "-(Kwasan OR KwasanHidaObs)";
	}
        if ( search_obj != null && search_obj.equals("sun") ) {
            query_obj = "(Kwasan OR KwasanHidaObs)";
        }
        String query_region = "";
        if ( region != null ) {
            if ( region.length == 1 ) {
                query_region = "(" + region[0] + ")";
            }
            else if ( region.length ==2 ) {
                query_region = "(" + region[0] + " OR " + region[1] + ")";
            }
        }
*/
        
        String query_resourcetype = "(";
        if ( resourceType.size() == 0 ) {
            query_resourcetype = "ResourceType:none";
        }
        else if ( resourceType.size() == 1 ) {
            query_resourcetype = "ResourceType:"+resourceType.get(0);
        }
        else {
            for ( int i=0; i<resourceType.size()-1; i++ ) {
                query_resourcetype += String.format("ResourceType:%s OR ", resourceType.get(i) );
            }
            query_resourcetype += String.format("ResourceType:%s)", resourceType.get(resourceType.size()-1) );
        }





        // Create Query
        if ( query_sub != null && query_sub.length() > 0 ) {
            if ( query == null || query.length() == 0 ) {
                query = query_sub;
            }
            else {
                query = "(" + query + ")" + " AND " + query_sub;
            }
        }

        if ( query_resourcetype != null && query_resourcetype.length() > 0 ) {
            if ( query == null || query.length() == 0 ) {
                query = "AND " + query_resourcetype;
            }
            else {
                query = query + " AND " + query_resourcetype;
            }
        }

        // Output
        System.out.println("query = [" + query + "]");

        // ------------------------------------------- //
        //      << END: ADD UMEMURA, 2012.1.4 >>       //
        // ------------------------------------------- //

        int start = Util.getIntParameter(request, "start");
        int rpp = Util.getIntParameter(request, "rpp");
        int sort = Util.getIntParameter(request, "sort_by");
        String order = request.getParameter("order");
        String sortOrder = (order == null || order.length() == 0 || order.toLowerCase().startsWith("asc")) ?
                         SortOption.ASCENDING : SortOption.DESCENDING;
        
        QueryArgs qArgs = new QueryArgs();
        // can't start earlier than 0 in the results!
        if (start < 0)
        {
            start = 0;
        }
        qArgs.setStart(start);
        
        if (rpp > 0)
        {
            qArgs.setPageSize(rpp);
        }
        qArgs.setSortOrder(sortOrder);
        
        if (sort > 0)
        {
                try
                {
                        qArgs.setSortOption(SortOption.getSortOption(sort));
                }
                catch(Exception e)
                {
                        // invalid sort id - do nothing
                }
        }
        qArgs.setSortOrder(sortOrder);

        // Ensure the query is non-null
        if (query == null)
        {
            query = "";
        }

        // If there is a scope parameter, attempt to dereference it
        // failure will only result in its being ignored
        DSpaceObject container = (scope != null) ? HandleManager.resolveToObject(context, scope) : null;

        // Build log information
        String logInfo = "";

        // get the start of the query results page
        qArgs.setQuery(query);

        // Perform the search
        QueryResults qResults = null;
        if (container == null)
        {
                qResults = DSQuery.doQuery(context, qArgs);
        }
        else if (container instanceof Collection)
        {
            logInfo = "collection_id=" + container.getID() + ",";
            qResults = DSQuery.doQuery(context, qArgs, (Collection)container);
        }
        else if (container instanceof Community)
        {
            logInfo = "community_id=" + container.getID() + ",";
            qResults = DSQuery.doQuery(context, qArgs, (Community)container);
        }
        else
        {
            throw new IllegalStateException("Invalid container for search context");
        }
        
        // now instantiate the results
        DSpaceObject[] results = new DSpaceObject[qResults.getHitHandles().size()];
        for (int i = 0; i < qResults.getHitHandles().size(); i++)
        {
            String myHandle = qResults.getHitHandles().get(i);
            DSpaceObject dso = HandleManager.resolveToObject(context, myHandle);
            if (dso == null)
            {
                throw new SQLException("Query \"" + query
                        + "\" returned unresolvable handle: " + myHandle);
            }
            results[i] = dso;
        }

        // Log
        log.info(LogManager.getHeader(context, "search", logInfo + "query=\"" + query + "\",results=(" + results.length + ")"));

        // format and return results
        Map<String, String> labelMap = getLabels(request);
        Document resultsDoc = OpenSearch.getResultsDoc(format, query, qResults, container, results, labelMap);
        try
        {
            Transformer xf = TransformerFactory.newInstance().newTransformer();
            response.setContentType(OpenSearch.getContentType(format));
            xf.transform(new DOMSource(resultsDoc), new StreamResult(response.getWriter()));
        }
        catch (TransformerException e)
        {
            log.error(e);
            throw new ServletException(e.toString(), e);
        }
    }
    
    private Map<String, String> getLabels(HttpServletRequest request)
    {
        // Get access to the localized resource bundle
        Locale locale = request.getLocale();
        Map<String, String> labelMap = localeLabels.get(locale.toString());
        if (labelMap == null)
        {
                labelMap = getLocaleLabels(locale);
                localeLabels.put(locale.toString(), labelMap);
        }
        return labelMap;
    }
    
    private Map<String, String> getLocaleLabels(Locale locale)
    {
        Map<String, String> labelMap = new HashMap<String, String>();
        ResourceBundle labels = ResourceBundle.getBundle("Messages", locale);

        labelMap.put(SyndicationFeed.MSG_UNTITLED, labels.getString(msgKey + ".notitle"));
        labelMap.put(SyndicationFeed.MSG_LOGO_TITLE, labels.getString(msgKey + ".logo.title"));
        labelMap.put(SyndicationFeed.MSG_FEED_DESCRIPTION, labels.getString(msgKey + ".general-feed.description"));
        labelMap.put(SyndicationFeed.MSG_UITYPE, SyndicationFeed.UITYPE_JSPUI);
        for (String selector : SyndicationFeed.getDescriptionSelectors())
        {
            labelMap.put("metadata." + selector, labels.getString(SyndicationFeed.MSG_METADATA + selector));
        }
        return labelMap;
    }
}
