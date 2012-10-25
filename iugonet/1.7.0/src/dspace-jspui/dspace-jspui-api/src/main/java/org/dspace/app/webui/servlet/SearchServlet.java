/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.*;
import java.text.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.app.bulkedit.MetadataExport;
import org.dspace.app.bulkedit.DSpaceCSV;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.Item;
import org.dspace.content.ItemIterator;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.handle.HandleManager;
import org.dspace.search.DSQuery;
import org.dspace.search.QueryArgs;
import org.dspace.search.QueryResults;
import org.dspace.sort.SortOption;

/**
 * Servlet for handling a simple search.
 * <p>
 * All metadata is search for the value contained in the "query" parameter. If
 * the "location" parameter is present, the user's location is switched to that
 * location using a redirect. Otherwise, the user's current location is used to
 * constrain the query; i.e., if the user is "in" a collection, only results
 * from the collection will be returned.
 * <p>
 * The value of the "location" parameter should be ALL (which means no
 * location), a the ID of a community (e.g. "123"), or a community ID, then a
 * slash, then a collection ID, e.g. "123/456".
 * 
 * @author Robert Tansley
 * @version $Id: SimpleSearchServlet.java,v 1.17 2004/12/15 15:21:10 jimdowning
 *          Exp $
 */
public class SearchServlet extends DSpaceServlet
{
/*
    static {
        System.loadLibrary("Geopack_2005");
    }
*/
    /** log4j category */
    private static Logger log = Logger.getLogger(SearchServlet.class);

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // Get the query
        String query = request.getParameter("query");
        int start = UIUtil.getIntParameter(request, "start");
        String advanced = request.getParameter("advanced");
        String fromAdvanced = request.getParameter("from_advanced");
        int sortBy = UIUtil.getIntParameter(request, "sort_by");
        String order = request.getParameter("order");
        int rpp = UIUtil.getIntParameter(request, "rpp");
        String advancedQuery = "";

	String search_obj  = request.getParameter("search_obj");
        String query_form     = request.getParameter("query");
        String datetime_start = request.getParameter("ts");
        String datetime_end   = request.getParameter("te");
        String datetime_zone  = request.getParameter("tz");
        String [] region      = request.getParameterValues("region");
        String nlatitude      = request.getParameter("nlat");
        String slatitude      = request.getParameter("slat");
        String elongitude     = request.getParameter("elon");
        String wlongitude     = request.getParameter("wlon");
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

	/* Check parameter for Sun and preprocess */
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

        System.out.println("resourcetype: ");
        System.out.println( query_resourcetype );
        System.out.println("end resourcetype");

        if ( datetime_zone != null &&
             ( datetime_zone.equals("UTC") || datetime_zone.equals("JST") ) ) {
        }
        else {
            datetime_zone = "UTC";
        }
        String[] datetimeformat = { "yyyy-MM-dd'T'HH:mm:ss'Z'",
                                    "yyyy-MM-dd'T'HH:mm:ss",
                                    "yyyy-MM-dd'T'HH:mm",
                                    "yyyy-MM-dd'T'HH",
                                    "yyyy-MM-dd",
                                    "yyyy-MM",
                                    "yyyy" };
        String datetimeformat_search = "yyyyMMddHHmmss";
        String query_datetime = "";
        String query_datetime_g = "";
        Date date_start = null;
        Date date_end   = null;
        Date date_now = new Date();
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
        else {
            datetime_start = "";
            datetime_end   = "";
            date_start = null;
            date_end   = null;
        }

        System.out.println("datetime: ");
        System.out.println( query_datetime_g );
        System.out.println("end datetime");

        String query_latitude   = "";
        String latitude_format = "(SpatialCoverageLatitude:[%s TO %s] OR (SpatialCoverageSouthernmostLatitude:[00000000 TO %s] AND SpatialCoverageNorthernmostLatitude:[%s 18000000]))";
        if ( nlatitude != null && nlatitude.length() > 0 &&
             slatitude != null && slatitude.length() > 0 ) {
	    nlatitude = nlatitude.replaceAll("N", "+");nlatitude = nlatitude.replaceAll("S", "-");
	    slatitude = slatitude.replaceAll("N", "+");slatitude = slatitude.replaceAll("S", "-");
            try {
                float nlatf = Float.parseFloat( nlatitude );
                float slatf = Float.parseFloat( slatitude );
                if ( nlatf > 90.0f ) {
                    nlatf = 90.0f;
                    nlatitude = "90.0";
                }
                if ( slatf > 90.0f ) {
                    slatf = 90.0f;
                    slatitude = "90.0";
                }
                if ( nlatf < -90.0f ) {
                    nlatf = -90.0f;
                    nlatitude = "-90.0";
                }
                if ( slatf < -90.0f ) {
                    slatf = -90.0f;
                    slatitude = "-90.0";
                }
                if ( slatf > nlatf ) {
                    float tmp = nlatf;
                    nlatf = slatf;
                    slatf = tmp;
                    String stmp = nlatitude;
                    nlatitude = slatitude;
                    slatitude = stmp;
                }

                nlatf = nlatf + 90.0f;
                slatf = slatf + 90.0f;
                float v = 100000.0f;
                int nlati = (int)(nlatf*v);
                int slati = (int)(slatf*v);

                String nlats = String.format("%08d",nlati );
                String slats = String.format("%08d",slati );

                query_latitude = String.format(latitude_format,slats,nlats,slats,nlats);
            }
            catch ( NumberFormatException e ) {
            }
        }
        else {
            nlatitude = "";
            slatitude = "";
        }
        String query_longitude = "";
        String longitude_format1 = "(SpatialCoverageLongitude1:[%s TO %s] OR (SpatialCoverageWesternmostLongitude1:[00000000 TO %s] AND SpatialCoverageEasternmostLongitude1:[%s TO 36000000]))";
        String longitude_format2 = "(SpatialCoverageLongitude2:[%s TO %s] OR (SpatialCoverageWesternmostLongitude2:[00000000 TO %s] AND SpatialCoverageEasternmostLongitude2:[%s TO 36000000]))";

        if ( elongitude != null && elongitude.length() > 0 &&
             wlongitude != null && wlongitude.length() > 0 ) {
	    elongitude = elongitude.replaceAll("E", "+");elongitude = elongitude.replaceAll("W", "-");
	    wlongitude = wlongitude.replaceAll("E", "+");wlongitude = wlongitude.replaceAll("W", "-");
            try {
                float elonf = Float.parseFloat( elongitude );
                float wlonf = Float.parseFloat( wlongitude );

                if ( elonf > 360.0f ) {
                    elonf = 360.0f;
                    elongitude = "360.0";
                }
                if ( wlonf > 360.0f ) {
                    wlonf = 360.0f;
                    wlongitude = "360.0";
                }
                if ( elonf < -360.0f ) {
                    elonf = -360.0f;
                    elongitude = "-360.0";
                }
                if ( wlonf < -360.0f ) {
                    wlonf = -360.0f;
                    wlongitude = "-360.0";
                }
                if ( wlonf > elonf ) {
                    float tmp = wlonf;
                    wlonf = elonf;
                    elonf = tmp;
                    String stmp = wlongitude;
                    wlongitude = elongitude;
                    elongitude = stmp;
                }

                if ( elonf >= 0.0f && wlonf >= 0.0f ) {
                    float v = 100000.0f;
                    int eloni = (int)(elonf*v);
                    int wloni = (int)(wlonf*v);
                    String elons = String.format("%08d",eloni);
                    String wlons = String.format("%08d",wloni);
                    String query_lon1 = String.format(longitude_format1,wlons,elons,wlons,elons);
                    String query_lon2 = String.format(longitude_format2,wlons,elons,wlons,elons);
                    query_longitude = query_lon1 + " OR " + query_lon2;
                    query_longitude = "(" + query_longitude + ")";
                }
                else if ( elonf < 0.0f && wlonf < 0.0f ) {
                    elonf = elonf + 360.0f;
                    wlonf = wlonf + 360.0f;
                    float v = 100000.0f;
                    int eloni = (int)(elonf*v);
                    int wloni = (int)(wlonf*v);
                    String elons = String.format("%08d",eloni);
                    String wlons = String.format("%08d",wloni);
                    String query_lon1 = String.format(longitude_format1,wlons,elons,wlons,elons);
                    String query_lon2 = String.format(longitude_format2,wlons,elons,wlons,elons);
                    query_longitude = query_lon1 + " OR " + query_lon2;
                    query_longitude = "(" + query_longitude + ")";
                }
                else {
                    float v = 100000.0f;
                    int eloni, wloni;
                    String elons, wlons;
                    String query_lon1, query_lon2;
                    wlonf = wlonf + 360.0f;
                    eloni = (int)(360.0f*v);
                    wloni = (int)(wlonf*v);
                    elons = String.format("%08d",eloni);
                    wlons = String.format("%08d",wloni);
                    query_lon1 = String.format(longitude_format1,wlons,elons,wlons,elons);
                    query_lon2 = String.format(longitude_format2,wlons,elons,wlons,elons);
                    String query_longitude1 = query_lon1 + " OR " + query_lon2;
                    query_longitude1 = "(" + query_longitude1 + ")";

                    eloni = (int)(elonf*v);
                    wloni = (int)(0.0f*v);
                    elons = String.format("%08d",eloni);
                    wlons = String.format("%08d",wloni);
                    query_lon1 = String.format(longitude_format1,wlons,elons,wlons,elons);
                    query_lon2 = String.format(longitude_format2,wlons,elons,wlons,elons);
                    String query_longitude2 = query_lon1 + " OR " + query_lon2;
                    query_longitude2 = "(" + query_longitude2 + ")";

                    query_longitude = "(" + query_longitude1 + " OR " + query_longitude2 + ")";
                }
            }
            catch ( NumberFormatException e ) {
            }
        }
        else {
            elongitude = "";
            wlongitude = "";
        }
        String query_latlon = "";
        if ( query_latitude  != null && query_latitude.length() > 0 &&
             query_longitude != null && query_longitude.length() > 0 ) {
            query_latlon = query_latitude + " AND " + query_longitude;
            query_latlon = "(" + query_latlon + ")";
        }
        else if ( query_latitude != null && query_latitude.length() > 0 ) {
            query_latlon = query_latitude;
        }
        else if ( query_longitude != null && query_longitude.length() > 0 ) {
            query_latlon = query_longitude;
        }
        String query_sub = "";
        if ( query_datetime_g != null && query_datetime_g.length() > 0 &&
             query_latlon != null && query_latlon.length() > 0 ) {
            query_sub = "(" + query_datetime_g + " AND " + query_latlon + ")";
        }
        else if ( query_datetime_g != null && query_datetime_g.length() > 0 ) {
            query_sub = query_datetime_g;
        }
        else if ( query_latlon != null && query_latlon.length() > 0 ) {
            query_sub = query_latlon;
        }

	if ( query_region != null && query_region.length() > 0 && 
	     query != null && query.length() > 0 ) {
	    query = "((" + query + ") AND " + query_region + ")";
	}
	else if ( query != null && query.length() > 0 ) {
	    query = "(" + query + ")";
	}
	else if ( query_region != null && query_region.length() > 0 ) {
	    query = query_region;
	}

        if ( query_sub != null && query_sub.length() > 0 ) {
            if ( query == null || query.length() == 0 ) {
                query = query_sub;
            }
            else {
                query = query + " AND " + query_sub;
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
	if (query_obj != null && query_obj.length() > 0 ) {
            if ( query == null || query.length() == 0 ) {
                query = "AND " + query_obj;
            }
            else {
                query = query + " AND " + query_obj;
            }
	}
        System.out.println("query: " + query );

        // can't start earlier than 0 in the results!
        if (start < 0)
        {
            start = 0;
        }

        int collCount = 0;
        int commCount = 0;
        int itemCount = 0;

        Item[] resultsItems;
        Collection[] resultsCollections;
        Community[] resultsCommunities;

        QueryResults qResults = null;
        QueryArgs qArgs = new QueryArgs();
        SortOption sortOption = null;

        if (request.getParameter("etal") != null)
        {
            qArgs.setEtAl(UIUtil.getIntParameter(request, "etal"));
        }

        try
        {
            if (sortBy > 0)
            {
                sortOption = SortOption.getSortOption(sortBy);
                qArgs.setSortOption(sortOption);
            }

            if (SortOption.ASCENDING.equalsIgnoreCase(order))
            {
                qArgs.setSortOrder(SortOption.ASCENDING);
            }
            else
            {
                qArgs.setSortOrder(SortOption.DESCENDING);
            }
        }
        catch (Exception e)
        {
        }

        // Override the page setting if exporting metadata
        if ("submit_export_metadata".equals(UIUtil.getSubmitButton(request, "submit")))
        {
            qArgs.setPageSize(Integer.MAX_VALUE);
        }
        else if (rpp > 0)
        {
            qArgs.setPageSize(rpp);
        }
        
        // if the "advanced" flag is set, build the query string from the
        // multiple query fields
        if (advanced != null)
        {
            query = qArgs.buildQuery(request);
            advancedQuery = qArgs.buildHTTPQuery(request);
        }

        // Ensure the query is non-null
        if (query == null)
        {
            query = "";
        }

        // Get the location parameter, if any
        String location = request.getParameter("location");

        // If there is a location parameter, we should redirect to
        // do the search with the correct location.
        if ((location != null) && !location.equals(""))
        {
            String url = "";

            if (!location.equals("/"))
            {
                // Location is a Handle
                url = "/handle/" + location;
            }

            // Encode the query
            query = URLEncoder.encode(query, Constants.DEFAULT_ENCODING);

            query_form     = URLEncoder.encode(query_form,     Constants.DEFAULT_ENCODING);
            datetime_start = URLEncoder.encode(datetime_start, Constants.DEFAULT_ENCODING);
            datetime_end   = URLEncoder.encode(datetime_end,   Constants.DEFAULT_ENCODING);
            datetime_zone  = URLEncoder.encode(datetime_zone,  Constants.DEFAULT_ENCODING);
            nlatitude      = URLEncoder.encode(nlatitude,      Constants.DEFAULT_ENCODING);
            slatitude      = URLEncoder.encode(slatitude,      Constants.DEFAULT_ENCODING);
            elongitude     = URLEncoder.encode(elongitude,     Constants.DEFAULT_ENCODING);
            wlongitude     = URLEncoder.encode(wlongitude,     Constants.DEFAULT_ENCODING);
            catalog        = URLEncoder.encode(catalog,        Constants.DEFAULT_ENCODING);
            displaydata    = URLEncoder.encode(displaydata,    Constants.DEFAULT_ENCODING);
            numericaldata  = URLEncoder.encode(numericaldata,  Constants.DEFAULT_ENCODING);
            person         = URLEncoder.encode(person,         Constants.DEFAULT_ENCODING);
            instrument     = URLEncoder.encode(instrument,     Constants.DEFAULT_ENCODING);
            observatory    = URLEncoder.encode(observatory,    Constants.DEFAULT_ENCODING);
            repository     = URLEncoder.encode(repository,     Constants.DEFAULT_ENCODING);
            document       = URLEncoder.encode(document,       Constants.DEFAULT_ENCODING);
            registry       = URLEncoder.encode(registry,       Constants.DEFAULT_ENCODING);
            service        = URLEncoder.encode(service,        Constants.DEFAULT_ENCODING);
            annotation     = URLEncoder.encode(annotation,     Constants.DEFAULT_ENCODING);
            granule        = URLEncoder.encode(granule,        Constants.DEFAULT_ENCODING);



            if (advancedQuery.length() > 0)
            {
                query = query + "&from_advanced=true&" + advancedQuery;
            }

            // Do the redirect
            response.sendRedirect(response.encodeRedirectURL(request
                    .getContextPath()
                    + url + "/search?query=" + query_form +
                            "&ts="            + datetime_start +
                            "&te="            + datetime_end   +
                            "&tz="            + datetime_zone  +
                            "&nlat="          + nlatitude  +
                            "&slat="          + slatitude  +
                            "&elon="          + elongitude  +
                            "&wlon="          + wlongitude  +
                            "&Catalog="       + catalog +
                            "&DisplayData="   + displaydata +
                            "&NumericalData=" + numericaldata +
                            "&Person="        + person +
                            "&Instrument="    + instrument +
                            "&Observatory="   + observatory +
                            "&Repository="    + repository +
                            "&Document="      + document +
                            "&Registry="      + registry +
                            "&Service="       + service +
                            "&Annotation="    + annotation +
                            "&Granule="       + granule ));
            return;
        }

        // Build log information
        String logInfo = "";

        // Get our location
        Community community = UIUtil.getCommunityLocation(request);
        Collection collection = UIUtil.getCollectionLocation(request);

        // get the start of the query results page
        //        List resultObjects = null;
        qArgs.setQuery(query);
        qArgs.setStart(start);

        // Perform the search
        if (collection != null)
        {
            logInfo = "collection_id=" + collection.getID() + ",";

            // Values for drop-down box
            request.setAttribute("community", community);
            request.setAttribute("collection", collection);

            qResults = DSQuery.doQuery(context, qArgs, collection);
        }
        else if (community != null)
        {
            logInfo = "community_id=" + community.getID() + ",";

            request.setAttribute("community", community);

            // Get the collections within the community for the dropdown box
            request
                    .setAttribute("collection.array", community
                            .getCollections());

            qResults = DSQuery.doQuery(context, qArgs, community);
        }
        else
        {
            // Get all communities for dropdown box
            Community[] communities = Community.findAll(context);
            request.setAttribute("community.array", communities);

            qResults = DSQuery.doQuery(context, qArgs);
        }

        // now instantiate the results and put them in their buckets
        for (int i = 0; i < qResults.getHitTypes().size(); i++)
        {
            Integer myType = qResults.getHitTypes().get(i);

            // add the handle to the appropriate lists
            switch (myType.intValue())
            {
            case Constants.ITEM:
                itemCount++;
                break;

            case Constants.COLLECTION:
                collCount++;
                break;

            case Constants.COMMUNITY:
                commCount++;
                break;
            }
        }

        // Make objects from the handles - make arrays, fill them out
        resultsCommunities = new Community[commCount];
        resultsCollections = new Collection[collCount];
        resultsItems = new Item[itemCount];

        collCount = 0;
        commCount = 0;
        itemCount = 0;

        for (int i = 0; i < qResults.getHitTypes().size(); i++)
        {
            Integer myId    = qResults.getHitIds().get(i);
            String myHandle = qResults.getHitHandles().get(i);
            Integer myType  = qResults.getHitTypes().get(i);

            // add the handle to the appropriate lists
            switch (myType.intValue())
            {
            case Constants.ITEM:
                if (myId != null)
                {
                    resultsItems[itemCount] = Item.find(context, myId);
                }
                else
                {
                    resultsItems[itemCount] = (Item)HandleManager.resolveToObject(context, myHandle);
                }

                if (resultsItems[itemCount] == null)
                {
                    throw new SQLException("Query \"" + query
                            + "\" returned unresolvable item");
                }
                itemCount++;
                break;

            case Constants.COLLECTION:
                if (myId != null)
                {
                    resultsCollections[collCount] = Collection.find(context, myId);
                }
                else
                {
                    resultsCollections[collCount] = (Collection)HandleManager.resolveToObject(context, myHandle);
                }

                if (resultsCollections[collCount] == null)
                {
                    throw new SQLException("Query \"" + query
                            + "\" returned unresolvable collection");
                }

                collCount++;
                break;

            case Constants.COMMUNITY:
                if (myId != null)
                {
                    resultsCommunities[commCount] = Community.find(context, myId);
                }
                else
                {
                    resultsCommunities[commCount] = (Community)HandleManager.resolveToObject(context, myHandle);
                }

                if (resultsCommunities[commCount] == null)
                {
                    throw new SQLException("Query \"" + query
                            + "\" returned unresolvable community");
                }

                commCount++;
                break;
            }
        }

        // Log
        log.info(LogManager.getHeader(context, "search", logInfo + "query=\""
                + query + "\",results=(" + resultsCommunities.length + ","
                + resultsCollections.length + "," + resultsItems.length + ")"));

        // Pass in some page qualities
        // total number of pages
        int pageTotal = 1 + ((qResults.getHitCount() - 1) / qResults
                .getPageSize());

        // current page being displayed
        int pageCurrent = 1 + (qResults.getStart() / qResults.getPageSize());

        // pageLast = min(pageCurrent+9,pageTotal)
        int pageLast = ((pageCurrent + 9) > pageTotal) ? pageTotal
                : (pageCurrent + 9);

        // pageFirst = max(1,pageCurrent-9)
        int pageFirst = ((pageCurrent - 9) > 1) ? (pageCurrent - 9) : 1;

        // Pass the results to the display JSP
        request.setAttribute("items", resultsItems);
        request.setAttribute("communities", resultsCommunities);
        request.setAttribute("collections", resultsCollections);

        request.setAttribute("pagetotal", Integer.valueOf(pageTotal));
        request.setAttribute("pagecurrent", Integer.valueOf(pageCurrent));
        request.setAttribute("pagelast", Integer.valueOf(pageLast));
        request.setAttribute("pagefirst", Integer.valueOf(pageFirst));

        request.setAttribute("queryresults", qResults);

        // And the original query string
        request.setAttribute("query", query);

        request.setAttribute("query_form", query_form);
        request.setAttribute("ts", datetime_start);
        request.setAttribute("te", datetime_end);
        request.setAttribute("tz", datetime_zone);
        request.setAttribute("nlat", nlatitude);
        request.setAttribute("slat", slatitude);
        request.setAttribute("elon", elongitude);
        request.setAttribute("wlon", wlongitude);
        request.setAttribute("Catalog",       catalog);
        request.setAttribute("DisplayData",   displaydata);
        request.setAttribute("NumericalData", numericaldata);
        request.setAttribute("Person",        person);
        request.setAttribute("Instrument",    instrument);
        request.setAttribute("Observatory",   observatory);
        request.setAttribute("Repository",    repository);
        request.setAttribute("Document",      document);
        request.setAttribute("Registry",      registry);
        request.setAttribute("Service",       service);
        request.setAttribute("Annotation",    annotation);
        request.setAttribute("Granule",       granule);
        request.setAttribute("Region",        region);
	request.setAttribute("SearchObj",     search_obj);

        request.setAttribute("order",  qArgs.getSortOrder());
        request.setAttribute("sortedBy", sortOption);

        if (AuthorizeManager.isAdmin(context))
        {
            // Set a variable to create admin buttons
            request.setAttribute("admin_button", Boolean.TRUE);
        }
        
        if ((fromAdvanced != null) && (qResults.getHitCount() == 0))
        {
            // send back to advanced form if no results
            Community[] communities = Community.findAll(context);
            request.setAttribute("communities", communities);
            request.setAttribute("no_results", "yes");

            Map<String, String> queryHash = qArgs.buildQueryMap(request);

            if (queryHash != null)
            {
                for (Map.Entry<String, String> entry : queryHash.entrySet())
                {
                    request.setAttribute(entry.getKey(), entry.getValue());
                }
            }

            JSPManager.showJSP(request, response, "/search/advanced.jsp");
        }
        else if ("submit_export_metadata".equals(UIUtil.getSubmitButton(request, "submit")))
        {
            exportMetadata(context, response, resultsItems);
        }
        else
        {
            JSPManager.showJSP(request, response, "/search/results.jsp");
        }
    }

    /**
     * Export the search results as a csv file
     *
     * @param context The DSpace context
     * @param response The request object
     * @param items The result items
     * @throws IOException
     * @throws ServletException
     */
    protected void exportMetadata(Context context, HttpServletResponse response, Item[] items)
            throws IOException, ServletException
    {
        // Log the attempt
        log.info(LogManager.getHeader(context, "metadataexport", "exporting_search"));

        // Export a search view
        List<Integer> iids = new ArrayList<Integer>();
        for (Item item : items)
        {
            iids.add(item.getID());
        }
        ItemIterator ii = new ItemIterator(context, iids);
        MetadataExport exporter = new MetadataExport(context, ii, false);

        // Perform the export
        DSpaceCSV csv = exporter.export();

        // Return the csv file
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=search-results.csv");
        PrintWriter out = response.getWriter();
        out.write(csv.toString());
        out.flush();
        out.close();
        log.info(LogManager.getHeader(context, "metadataexport", "exported_file:search-results.csv"));
        return;
    }
}
