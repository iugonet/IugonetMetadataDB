<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display the results of a simple search
  -
  - Attributes to pass in:
  -
  -   community        - pass in if the scope of the search was a community
  -                      or a collection in this community
  -   collection       - pass in if the scope of the search was a collection
  -   community.array  - if the scope of the search was "all of DSpace", pass
  -                      in all the communities in DSpace as an array to
  -                      display in a drop-down box
  -   collection.array - if the scope of a search was a community, pass in an
  -                      array of the collections in the community to put in
  -                      the drop-down box
  -   items            - the results.  An array of Items, most relevant first
  -   communities      - results, Community[]
  -   collections      - results, Collection[]
  -
  -   query            - The original query
  -
  -   admin_button     - If the user is an admin
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.net.URLEncoder"            %>
<%@ page import="org.dspace.content.Community"   %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.Item"        %>
<%@ page import="org.dspace.search.QueryResults" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Set" %>

<%
    String order = (String)request.getAttribute("order");
    String ascSelected = (SortOption.ASCENDING.equalsIgnoreCase(order)   ? "selected=\"selected\"" : "");
    String descSelected = (SortOption.DESCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    SortOption so = (SortOption)request.getAttribute("sortedBy");
    String sortedBy = (so == null) ? null : so.getName();

    // Get the attributes
    Community   community        = (Community   ) request.getAttribute("community" );
    Collection  collection       = (Collection  ) request.getAttribute("collection");
    Community[] communityArray   = (Community[] ) request.getAttribute("community.array");
    Collection[] collectionArray = (Collection[]) request.getAttribute("collection.array");

    Item      [] items       = (Item[]      )request.getAttribute("items");
    Community [] communities = (Community[] )request.getAttribute("communities");
    Collection[] collections = (Collection[])request.getAttribute("collections");

    String query = (String) request.getAttribute("query");

    String query_form = (String) request.getAttribute("query_form");
    String datetime_start = (String) request.getAttribute("ts");
    String datetime_end   = (String) request.getAttribute("te");
    String datetime_zone  = (String) request.getAttribute("tz");
    String nlatitude      = (String) request.getAttribute("nlat");
    String slatitude      = (String) request.getAttribute("slat");
    String elongitude     = (String) request.getAttribute("elon");
    String wlongitude     = (String) request.getAttribute("wlon");
    String catalog        = (String) request.getAttribute("Catalog");
    String displaydata    = (String) request.getAttribute("DisplayData");
    String numericaldata  = (String) request.getAttribute("NumericalData");
    String person         = (String) request.getAttribute("Person");
    String instrument     = (String) request.getAttribute("Instrument");
    String observatory    = (String) request.getAttribute("Observatory");
    String repository     = (String) request.getAttribute("Repository");
    String document       = (String) request.getAttribute("Document");
    String registry       = (String) request.getAttribute("Registry");
    String service        = (String) request.getAttribute("Service");
    String annotation     = (String) request.getAttribute("Annotation");
    String granule        = (String) request.getAttribute("Granule");
    String [] region      = (String[]) request.getAttribute("Region");
    String search_obj     = (String) request.getAttribute("SearchObj");

    QueryResults qResults = (QueryResults)request.getAttribute("queryresults");

    int pageTotal   = ((Integer)request.getAttribute("pagetotal"  )).intValue();
    int pageCurrent = ((Integer)request.getAttribute("pagecurrent")).intValue();
    int pageLast    = ((Integer)request.getAttribute("pagelast"   )).intValue();
    int pageFirst   = ((Integer)request.getAttribute("pagefirst"  )).intValue();
    int rpp         = qResults.getPageSize();
    int etAl        = qResults.getEtAl();

    // retain scope when navigating result sets
    String searchScope = "";
    if (community == null && collection == null) {
	searchScope = "";
    } else if (collection == null) {
	searchScope = "/handle/" + community.getHandle();
    } else {
	searchScope = "/handle/" + collection.getHandle();
    }

    // Admin user or not
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
%>

<dspace:layout titlekey="jsp.search.results.title">
<hr/>
    <%-- <h1>Search Results</h1> --%>

<h1><fmt:message key="jsp.search.results.title"/></h1>

    <%-- Controls for a repeat search --%>
    <div id="allsearch">
    <form action="search" method="get">
        <table class="miscTable" align="center" summary="Table displaying your search results">
            <tr>
                <td class="evenRowEvenCol">
                    <table>
<%--                        <tr>
                            <td> --%>
                                <%-- <strong>Search:</strong>&nbsp;<select name="location"> --%>
<%--                                <label for="tlocation"><strong><fmt:message key="jsp.search.results.searchin"/></strong></label>&nbsp;<select name="location" id="tlocation"> --%>
<%--
    if (community == null && collection == null)
    {
        // Scope of the search was all of DSpace.  The scope control will list
        // "all of DSpace" and the communities.
--%>
                                    <%-- <option selected value="/">All of DSpace</option> --%>
<%--                                    <option selected="selected" value="/"><fmt:message key="jsp.general.genericScope"/></option> --%>
<%--
        for (int i = 0; i < communityArray.length; i++)
        {
--%>
<%--                                    <option value="<%= communityArray[i].getHandle() %>"><%= communityArray[i].getMetadata("name") %></option> --%>
<%--
        }
    }
    else if (collection == null)
    {
        // Scope of the search was within a community.  Scope control will list
        // "all of DSpace", the community, and the collections within the community.
--%>
                                    <%-- <option value="/">All of DSpace</option> --%>
<%--                                    <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                                    <option selected="selected" value="<%= community.getHandle() %>"><%= community.getMetadata("name") %></option> --%>
<%--
        for (int i = 0; i < collectionArray.length; i++)
        {
--%>
<%--                                    <option value="<%= collectionArray[i].getHandle() %>"><%= collectionArray[i].getMetadata("name") %></option> --%>
<%--
        }
    }
    else
    {
        // Scope of the search is a specific collection
--%>
                                    <%-- <option value="/">All of DSpace</option> --%>
<%--                                    <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                                    <option value="<%= community.getHandle() %>"><%= community.getMetadata("name") %></option>
                                    <option selected="selected" value="<%= collection.getHandle() %>"><%= collection.getMetadata("name") %></option> --%>
<%--
    }
--%>
<%--                                </select>
                            </td>
                        </tr> --%>
                        <tr>
                            <td align="center">
<%--                                <fmt:message key="jsp.search.results.searchfor"/>&nbsp; --%>
                                <input size="72" type="text" name="query" value="<%= (query_form==null ? "" : StringEscapeUtils.escapeHtml(query_form)) %>"/>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                            Time from: <input size="20" type="text" name="ts" value="<%= (datetime_start==null ? "" : StringEscapeUtils.escapeHtml(datetime_start)) %>"/> to
                                       <input size="20" type="text" name="te" value="<%= (datetime_end==null ? ""   : StringEscapeUtils.escapeHtml(datetime_end)) %>"/> [UTC]
                                       <br/>
                            </td>
                        </tr>
                        <tr>
                          <td align="center">
<span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"> <font style="background-color:#ccecff">Data Set ( </font></span>
<input type="checkbox" name="NumericalData" value="numericaldata" <%= (numericaldata==""       ? "" : "checked=\"checked\"" ) %> /><span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"><font style="background-color:#ccecff">Numerical</font></span>
<input type="checkbox" name="DisplayData"   value="displaydata" <%= (displaydata==""       ? "" : "checked=\"checked\"" ) %> /><span title="<fmt:message key="jsp.layout.iugonet.DisplayData.Description"/>">  <font style="background-color:#ccecff">Plot &frasl; Movie )</font></span>
<input type="checkbox" name="Granule"       value="granule"       <%= (granule==""       ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Granule.Description"/>">       <font style="background-color:#ccecff">Data File &frasl; Plot</font></span>
<input type="checkbox" name="Instrument"    value="instrument"    <%= (instrument==""    ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Instrument.Description"/>">    <font style="background-color:#ccffcc">Instrument</font></span>
<input type="checkbox" name="Observatory"   value="observatory"   <%= (observatory==""   ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Observatory.Description"/>">   <font style="background-color:#ccffcc">Observatory</font></span><br/>
<input type="submit" value="<fmt:message key="jsp.general.go"/>" />
                          </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
    </div>

    <div id="earthsearch">
    <form action="search" method="get">
	<input type="hidden" name="search_obj" value="earth" />
        <table class="miscTable" align="center" summary="Table displaying your search results">
            <tr>
                <td class="evenRowEvenCol">
                    <table>
<%--                        <tr>
                            <td> --%>
                                <%-- <strong>Search:</strong>&nbsp;<select name="location"> --%>
<%--                                <label for="tlocation"><strong><fmt:message key="jsp.search.results.searchin"/></strong></label>&nbsp;<select name="location" id="tlocation"> --%>
<%--
    if (community == null && collection == null)
    {
        // Scope of the search was all of DSpace.  The scope control will list
        // "all of DSpace" and the communities.
--%>
                                    <%-- <option selected value="/">All of DSpace</option> --%>
<%--                                    <option selected="selected" value="/"><fmt:message key="jsp.general.genericScope"/></option> --%>
<%--
        for (int i = 0; i < communityArray.length; i++)
        {
--%>
<%--                                    <option value="<%= communityArray[i].getHandle() %>"><%= communityArray[i].getMetadata("name") %></option> --%>
<%--
        }
    }
    else if (collection == null)
    {
        // Scope of the search was within a community.  Scope control will list
        // "all of DSpace", the community, and the collections within the community.
--%>
                                    <%-- <option value="/">All of DSpace</option> --%>
<%--                                    <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                                    <option selected="selected" value="<%= community.getHandle() %>"><%= community.getMetadata("name") %></option> --%>
<%--
        for (int i = 0; i < collectionArray.length; i++)
        {
--%>
<%--                                    <option value="<%= collectionArray[i].getHandle() %>"><%= collectionArray[i].getMetadata("name") %></option> --%>
<%--
        }
    }
    else
    {
        // Scope of the search is a specific collection
--%>
                                    <%-- <option value="/">All of DSpace</option> --%>
<%--                                    <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                                    <option value="<%= community.getHandle() %>"><%= community.getMetadata("name") %></option>
                                    <option selected="selected" value="<%= collection.getHandle() %>"><%= collection.getMetadata("name") %></option> --%>
<%--
    }
--%>
<%--                                </select>
                            </td>
                        </tr> --%>
                        <tr>
                            <td align="center">
<%--                                <fmt:message key="jsp.search.results.searchfor"/>&nbsp; --%>
                                <input size="72" type="text" name="query" value="<%= (query_form==null ? "" : StringEscapeUtils.escapeHtml(query_form)) %>"/>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                            Time from: <input size="20" type="text" name="ts" value="<%= (datetime_start==null ? "" : StringEscapeUtils.escapeHtml(datetime_start)) %>"/> to
                                       <input size="20" type="text" name="te" value="<%= (datetime_end==null ? ""   : StringEscapeUtils.escapeHtml(datetime_end)) %>"/> [UTC]
                                       <br/>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                            Spatial Coverage
                            <table>
<!--
                            <tr>
                            <td>Latitude:  Southernmost</td><td><input size="10" type="text" name="slat" value="<%= (slatitude==null ? "" : StringEscapeUtils.escapeHtml(slatitude)) %>"/></td>
                            <td>, Northernmost <input size="10" type="text" name="nlat" value="<%= (nlatitude==null ? "" : StringEscapeUtils.escapeHtml(nlatitude)) %>"/xo></td>
                            </tr>
                            <tr>
                            <td>Longitude: Westernmost</td><td><input size="10" type="text" name="wlon" value="<%= (wlongitude==null ? "" : StringEscapeUtils.escapeHtml(wlongitude)) %>"/></td>
                            <td>, Easternmost <input size="10" type="text" name="elon" value="<%= (elongitude==null ? "" : StringEscapeUtils.escapeHtml(elongitude)) %>"/></td>
                            </tr>
-->
<tr>
<td>Latitude:</td><td>Southernmost</td><td><input size="10" type="text" id="d_slat" name="slat" value="<%= (slatitude==null ? "" : StringEscapeUtils.escapeHtml(slatitude)) %>" /></td><td>, Northernmost</td><td><input size="10" type="text" id="d_nlat" name="nlat" value="<%= (nlatitude==null ? "" : StringEscapeUtils.escapeHtml(nlatitude)) %>" /></td><td>[degree]</td>
</tr>
<tr>
<td>Longitude:</td><td>Westernmost</td><td><input size="10" type="text" id="d_wlon" name="wlon" value="<%= (wlongitude==null ? "" : StringEscapeUtils.escapeHtml(wlongitude)) %>" /></td><td>, Easternmost</td><td><input size="10" type="text" id="d_elon" name="elon" value="<%= (elongitude==null ? "" : StringEscapeUtils.escapeHtml(elongitude)) %>" /></td><td>[degree]</td>
</tr>
                            </table>
                            </td>
                        </tr>
                        <tr>
                          <td align="center">
<span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"> <font style="background-color:#ccecff">Data Set ( </font></span>
<input type="checkbox" name="NumericalData" value="numericaldata" <%= (numericaldata==""       ? "" : "checked=\"checked\"" ) %> /><span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"><font style="background-color:#ccecff">Numerical</font></span>
<input type="checkbox" name="DisplayData"   value="displaydata" <%= (displaydata==""       ? "" : "checked=\"checked\"" ) %> /><span title="<fmt:message key="jsp.layout.iugonet.DisplayData.Description"/>">  <font style="background-color:#ccecff">Plot &frasl; Movie )</font></span>
<input type="checkbox" name="Granule"       value="granule"       <%= (granule==""       ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Granule.Description"/>">       <font style="background-color:#ccecff">Data File &frasl; Plot</font></span>
<input type="checkbox" name="Instrument"    value="instrument"    <%= (instrument==""    ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Instrument.Description"/>">    <font style="background-color:#ccffcc">Instrument</font></span>
<input type="checkbox" name="Observatory"   value="observatory"   <%= (observatory==""   ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Observatory.Description"/>">   <font style="background-color:#ccffcc">Observatory</font></span><br/>
<input type="submit" value="<fmt:message key="jsp.general.go"/>" />
                          </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
    </div>

    <div id="sunsearch">
    <form action="search" method="get">
	<input type="hidden" name="search_obj" value="sun" />
        <table class="miscTable" align="center" summary="Table displaying your search results">
            <tr>
                <td class="evenRowEvenCol">
                    <table>
<%--                        <tr>
                            <td> --%>
                                <%-- <strong>Search:</strong>&nbsp;<select name="location"> --%>
<%--                                <label for="tlocation"><strong><fmt:message key="jsp.search.results.searchin"/></strong></label>&nbsp;<select name="location" id="tlocation"> --%>
<%--
    if (community == null && collection == null)
    {
        // Scope of the search was all of DSpace.  The scope control will list
        // "all of DSpace" and the communities.
--%>
                                    <%-- <option selected value="/">All of DSpace</option> --%>
<%--                                    <option selected="selected" value="/"><fmt:message key="jsp.general.genericScope"/></option> --%>
<%--
        for (int i = 0; i < communityArray.length; i++)
        {
--%>
<%--                                    <option value="<%= communityArray[i].getHandle() %>"><%= communityArray[i].getMetadata("name") %></option> --%>
<%--
        }
    }
    else if (collection == null)
    {
        // Scope of the search was within a community.  Scope control will list
        // "all of DSpace", the community, and the collections within the community.
--%>
                                    <%-- <option value="/">All of DSpace</option> --%>
<%--                                    <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                                    <option selected="selected" value="<%= community.getHandle() %>"><%= community.getMetadata("name") %></option> --%>
<%--
        for (int i = 0; i < collectionArray.length; i++)
        {
--%>
<%--                                    <option value="<%= collectionArray[i].getHandle() %>"><%= collectionArray[i].getMetadata("name") %></option> --%>
<%--
        }
    }
    else
    {
        // Scope of the search is a specific collection
--%>
                                    <%-- <option value="/">All of DSpace</option> --%>
<%--                                    <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                                    <option value="<%= community.getHandle() %>"><%= community.getMetadata("name") %></option>
                                    <option selected="selected" value="<%= collection.getHandle() %>"><%= collection.getMetadata("name") %></option> --%>
<%--
    }
--%>
<%--                                </select>
                            </td>
                        </tr> --%>
                        <tr>
                            <td align="center">
<%--                                <fmt:message key="jsp.search.results.searchfor"/>&nbsp; --%>
                                <input size="72" type="text" name="query" value="<%= (query_form==null ? "" : StringEscapeUtils.escapeHtml(query_form)) %>"/>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                            Time from: <input size="20" type="text" name="ts" value="<%= (datetime_start==null ? "" : StringEscapeUtils.escapeHtml(datetime_start)) %>"/> to
                                       <input size="20" type="text" name="te" value="<%= (datetime_end==null ? ""   : StringEscapeUtils.escapeHtml(datetime_end)) %>"/> [UTC]
                                       <br/>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                            Solar Spatial Coverage
                            <table>
<!--
                            <tr>
                            <td>Latitude:  Southernmost</td><td><input size="10" type="text" name="slat" value="<%= (slatitude==null ? "" : StringEscapeUtils.escapeHtml(slatitude)) %>"/></td>
                            <td>, Northernmost <input size="10" type="text" name="nlat" value="<%= (nlatitude==null ? "" : StringEscapeUtils.escapeHtml(nlatitude)) %>"/xo></td>
                            </tr>
                            <tr>
                            <td>Longitude: Westernmost</td><td><input size="10" type="text" name="wlon" value="<%= (wlongitude==null ? "" : StringEscapeUtils.escapeHtml(wlongitude)) %>"/></td>
                            <td>, Easternmost <input size="10" type="text" name="elon" value="<%= (elongitude==null ? "" : StringEscapeUtils.escapeHtml(elongitude)) %>"/></td>
                            </tr>
-->
<tr>
<td>Region:</td><td colspan="2" align="center"><input type="checkbox" name="region" value="FullDisk" <% if (region!=null){if(region.length==1){if (region[0].equals("FullDisk")){out.print("checked");}}else if(region.length==2){out.print("checked");}}; %> />FullDisk</td>
<td colspan="2" align="center"><input type="checkbox" name="region" value="PartialRegion" <% if (region!=null){if(region.length==1){if (region[0].equals("PartialRegion")){out.print("checked");}}else if(region.length==2){out.print("checked");}};%> />PartialRegion</td>
</tr>
<tr>
<td>Latitude:</td><td>Southernmost</td><td><input size="10" type="text" id="d_slat2" name="slat" value="<%= (slatitude==null ? "" : StringEscapeUtils.escapeHtml(slatitude)) %>"  /></td><td>, Northernmost</td><td><input size="10" type="text" id="d_nlat2" name="nlat" value="<%= (nlatitude==null ? "" : StringEscapeUtils.escapeHtml(nlatitude)) %>" /></td><td>[degree]</td>
</tr>
<tr>
<td>Longitude:</td><td>Westernmost</td><td><input size="10" type="text" id="d_wlon2" name="wlon" value="<%= (wlongitude==null ? "" : StringEscapeUtils.escapeHtml(wlongitude)) %>" /></td><td>, Easternmost</td><td><input size="10" type="text" id="d_elon2" name="elon" value="<%= (elongitude==null ? "" : StringEscapeUtils.escapeHtml(elongitude)) %>" /></td><td>[degree]</td>
</tr>
                            </table>
                            </td>
                        </tr>
                        <tr>
                          <td align="center">
<span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"> <font style="background-color:#ccecff">Data Set ( </font></span>
<input type="checkbox" name="NumericalData" value="numericaldata" <%= (numericaldata==""       ? "" : "checked=\"checked\"" ) %> /><span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"><font style="background-color:#ccecff">Numerical</font></span>
<input type="checkbox" name="DisplayData"   value="displaydata" <%= (displaydata==""       ? "" : "checked=\"checked\"" ) %> /><span title="<fmt:message key="jsp.layout.iugonet.DisplayData.Description"/>">  <font style="background-color:#ccecff">Plot &frasl; Movie )</font></span>
<input type="checkbox" name="Granule"       value="granule"       <%= (granule==""       ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Granule.Description"/>">       <font style="background-color:#ccecff">Data File &frasl; Plot</font></span>
<input type="checkbox" name="Instrument"    value="instrument"    <%= (instrument==""       ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Instrument.Description"/>">    <font style="background-color:#ccffcc">Instrument</font></span>
<input type="checkbox" name="Observatory"   value="observatory"   <%= (observatory==""       ? "" : "checked=\"checked\"" ) %> /> <span title="<fmt:message key="jsp.layout.iugonet.Observatory.Description"/>">   <font style="background-color:#ccffcc">Observatory</font></span><br/>
<input type="submit" value="<fmt:message key="jsp.general.go"/>" />
                          </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
    </div>

<% if( qResults.getErrorMsg()!=null )
{
    String qError = "jsp.search.error." + qResults.getErrorMsg();
 %>
    <p align="center" class="submitFormWarn"><fmt:message key="<%= qError %>"/></p>
<%
}
else if( qResults.getHitCount() == 0 )
{
 %>
    <%-- <p align="center">Search produced no results.</p> --%>
    <p align="center"><fmt:message key="jsp.search.general.noresults"/></p>
<%
}
else
{
%>
    <%-- <p align="center">Results <//%=qResults.getStart()+1%>-<//%=qResults.getStart()+qResults.getHitHandles().size()%> of --%>
	<p align="center"><fmt:message key="jsp.search.results.results">
        <fmt:param><%=qResults.getStart()+1%></fmt:param>
        <fmt:param><%=qResults.getStart()+qResults.getHitHandles().size()%></fmt:param>
        <fmt:param><%=qResults.getHitCount()%></fmt:param>
    </fmt:message></p>

<% } %>
    <%-- Include a component for modifying sort by, order, results per page, and et-al limit --%>
   <div align="center">
   <form method="get" action="<%= request.getContextPath() + searchScope + "/search" %>">
   <table border="0">
       <tr><td>
           <input type="hidden" name="query" value="<%= StringEscapeUtils.escapeHtml(query_form) %>" />
           <input type="hidden" name="ts"    value="<%= StringEscapeUtils.escapeHtml(datetime_start) %>" />
           <input type="hidden" name="te"    value="<%= StringEscapeUtils.escapeHtml(datetime_end) %>" />
           <input type="hidden" name="tz"    value="<%= StringEscapeUtils.escapeHtml(datetime_zone) %>" />
           <input type="hidden" name="nlat"  value="<%= StringEscapeUtils.escapeHtml(nlatitude) %>" />
           <input type="hidden" name="slat"  value="<%= StringEscapeUtils.escapeHtml(slatitude) %>" />
           <input type="hidden" name="elon"  value="<%= StringEscapeUtils.escapeHtml(elongitude) %>" />
           <input type="hidden" name="wlon"  value="<%= StringEscapeUtils.escapeHtml(wlongitude) %>" />
<%
           if ( catalog != "" ) {
%>
               <input type="hidden" name="Catalog"    value="<%= StringEscapeUtils.escapeHtml(catalog) %>" />
<%
           }
%>
<%
           if ( displaydata != "" ) {
%>
               <input type="hidden" name="DisplayData"    value="<%= StringEscapeUtils.escapeHtml(displaydata) %>" />
<%
           }
%>
<%
           if ( numericaldata != "" ) {
%>
               <input type="hidden" name="NumericalData"    value="<%= StringEscapeUtils.escapeHtml(numericaldata) %>" />
<%
           }
%>
<%
           if ( instrument != "" ) {
%>
               <input type="hidden" name="Instrument"    value="<%= StringEscapeUtils.escapeHtml(instrument) %>" />
<%
           }
%>
<%
           if ( observatory != "" ) {
%>
               <input type="hidden" name="Observatory"    value="<%= StringEscapeUtils.escapeHtml(observatory) %>" />
<%
           }
%>
<%
           if ( person != "" ) {
%>
               <input type="hidden" name="Person"    value="<%= StringEscapeUtils.escapeHtml(person) %>" />
<%
           }
%>
<%
           if ( repository != "" ) {
%>
               <input type="hidden" name="Repository"    value="<%= StringEscapeUtils.escapeHtml(repository) %>" />
<%
           }
%>
<%
           if ( document != "" ) {
%>
               <input type="hidden" name="Document"    value="<%= StringEscapeUtils.escapeHtml(document) %>" />
<%
           }
%>
<%
           if ( service != "" ) {
%>
               <input type="hidden" name="Service"    value="<%= StringEscapeUtils.escapeHtml(service) %>" />
<%
           }
%>
<%
           if ( registry != "" ) {
%>
               <input type="hidden" name="Registry"    value="<%= StringEscapeUtils.escapeHtml(registry) %>" />
<%
           }
%>
<%
           if ( annotation != "" ) {
%>
               <input type="hidden" name="Annotation"    value="<%= StringEscapeUtils.escapeHtml(annotation) %>" />
<%
           }
%>
<%
           if ( granule != "" ) {
%>
               <input type="hidden" name="Granule"    value="<%= StringEscapeUtils.escapeHtml(granule) %>" />
<%
           }
%>
           <fmt:message key="search.results.perpage"/>
           <select name="rpp">
<%
               for (int i = 10; i <= 100 ; i += 10)
               {
                   String selected = (i == rpp ? "selected=\"selected\"" : "");
%>
                   <option value="<%= i %>" <%= selected %>><%= i %></option>
<%
               }
%>
           </select>
           &nbsp;|&nbsp;
<%
           Set<SortOption> sortOptions = SortOption.getSortOptions();
           if (sortOptions.size() > 1)
           {
%>
               <fmt:message key="search.results.sort-by"/>
               <select name="sort_by">
                   <option value="0"><fmt:message key="search.sort-by.relevance"/></option>
<%
               for (SortOption sortBy : sortOptions)
               {
                   if (sortBy.isVisible())
                   {
                       String selected = (sortBy.getName().equals(sortedBy) ? "selected=\"selected\"" : "");
                       String mKey = "search.sort-by." + sortBy.getName();
                       %> <option value="<%= sortBy.getNumber() %>" <%= selected %>><fmt:message key="<%= mKey %>"/></option><%
                   }
               }
%>
               </select>
<%
           }
%>
           <fmt:message key="search.results.order"/>
           <select name="order">
               <option value="ASC" <%= ascSelected %>><fmt:message key="search.order.asc" /></option>
               <option value="DESC" <%= descSelected %>><fmt:message key="search.order.desc" /></option>
           </select>
           <%-- add results per page, etc. --%>
           <input type="submit" name="submit_search" value="<fmt:message key="search.update" />" />

<%
    if (admin_button)
    {
        %><input type="submit" name="submit_export_metadata" value="<fmt:message key="jsp.general.metadataexport.button"/>" /><%
    }
%>
           
       </td></tr>
   </table>
   </form>
   </div>

<% if (communities.length > 0 ) { %>
    <%-- <h3>Community Hits:</h3> --%>
    <h3><fmt:message key="jsp.search.results.comhits"/></h3>
    <dspace:communitylist  communities="<%= communities %>" />
<% } %>

<% if (collections.length > 0 ) { %>
    <br/>
    <%-- <h3>Collection hits:</h3> --%>
    <h3><fmt:message key="jsp.search.results.colhits"/></h3>
    <dspace:collectionlist collections="<%= collections %>" />
<% } %>

<% if (items.length > 0) { %>
    <br/>
    <%-- <h3>Item hits:</h3> --%>
    <h3><fmt:message key="jsp.search.results.itemhits"/></h3>
    <dspace:itemlist items="<%= items %>" sortOption="<%= so %>" authorLimit="<%= qResults.getEtAl() %>" />
<% } %>

<p align="center">

<%
    // create the URLs accessing the previous and next search result pages
    String s_obj = "";
    if ( search_obj != null && search_obj.equals("earth")) {
	s_obj = "&amp;search_obj=earth";
    }

    if ( search_obj != null && search_obj.equals("sun")) {
	s_obj = "&amp;search_obj=sun";
    }

    String regionstring = "";
    if (region!=null){
        if (region.length == 2){
            regionstring = "&amp;region=FullDisk&amp;region=PartialRegion";
        }
        else if (region[0].equals("FullDisk")){
            regionstring = "&amp;region=FullDisk";
        } else if (region[0].equals("PartialRegion")){
            regionstring = "&amp;region=PartialRegion";
        } else {
            regionstring = "";
        }
    }

    String prevURL =  request.getContextPath()
                    + searchScope
                    + "/search?query="
                    + URLEncoder.encode(query_form,"UTF-8")
                    + s_obj
                    + regionstring
                    + "&amp;ts=" + URLEncoder.encode(datetime_start,"UTF-8")
                    + "&amp;te=" + URLEncoder.encode(datetime_end,"UTF-8")
                    + "&amp;tz=" + URLEncoder.encode(datetime_zone,"UTF-8")
                    + "&amp;nlat=" + URLEncoder.encode(nlatitude,"UTF-8")
                    + "&amp;slat=" + URLEncoder.encode(slatitude,"UTF-8")
                    + "&amp;elon=" + URLEncoder.encode(elongitude,"UTF-8")
                    + "&amp;wlon=" + URLEncoder.encode(wlongitude,"UTF-8")
                    + "&amp;Catalog=" + URLEncoder.encode(catalog,"UTF-8")
                    + "&amp;DisplayData=" + URLEncoder.encode(displaydata,"UTF-8")
                    + "&amp;NumericalData=" + URLEncoder.encode(numericaldata,"UTF-8")
                    + "&amp;Instrument=" + URLEncoder.encode(instrument,"UTF-8")
                    + "&amp;Observatory=" + URLEncoder.encode(observatory,"UTF-8")
                    + "&amp;Person=" + URLEncoder.encode(person,"UTF-8")
                    + "&amp;Repository=" + URLEncoder.encode(repository,"UTF-8")
                    + "&amp;Document=" + URLEncoder.encode(document,"UTF-8")
                    + "&amp;Service=" + URLEncoder.encode(service,"UTF-8")
                    + "&amp;Registry=" + URLEncoder.encode(registry,"UTF-8")
                    + "&amp;Annotation=" + URLEncoder.encode(annotation,"UTF-8")
                    + "&amp;Granule=" + URLEncoder.encode(granule,"UTF-8")
                    + "&amp;sort_by=" + (so != null ? so.getNumber() : 0)
                    + "&amp;order=" + order
                    + "&amp;rpp=" + rpp
                    + "&amp;etal=" + etAl
                    + "&amp;start=";

    String nextURL = prevURL;

    prevURL = prevURL
            + (pageCurrent-2) * qResults.getPageSize();

    nextURL = nextURL
            + (pageCurrent) * qResults.getPageSize();


if (pageFirst != pageCurrent)
{
    %><a href="<%= prevURL %>"><fmt:message key="jsp.search.general.previous" /></a><%
};


for( int q = pageFirst; q <= pageLast; q++ )
{
    String myLink = "<a href=\""
                    + request.getContextPath()
                    + searchScope
                    + "/search?query="
                    + URLEncoder.encode(query_form,"UTF-8")
                    + s_obj
                    + regionstring
                    + "&amp;ts=" + URLEncoder.encode(datetime_start,"UTF-8")
                    + "&amp;te=" + URLEncoder.encode(datetime_end,"UTF-8")
                    + "&amp;tz=" + URLEncoder.encode(datetime_zone,"UTF-8")
                    + "&amp;nlat=" + URLEncoder.encode(nlatitude,"UTF-8")
                    + "&amp;slat=" + URLEncoder.encode(slatitude,"UTF-8")
                    + "&amp;elon=" + URLEncoder.encode(elongitude,"UTF-8")
                    + "&amp;wlon=" + URLEncoder.encode(wlongitude,"UTF-8")
                    + "&amp;Catalog=" + URLEncoder.encode(catalog,"UTF-8")
                    + "&amp;DisplayData=" + URLEncoder.encode(displaydata,"UTF-8")
                    + "&amp;NumericalData=" + URLEncoder.encode(numericaldata,"UTF-8")
                    + "&amp;Instrument=" + URLEncoder.encode(instrument,"UTF-8")
                    + "&amp;Observatory=" + URLEncoder.encode(observatory,"UTF-8")
                    + "&amp;Person=" + URLEncoder.encode(person,"UTF-8")
                    + "&amp;Repository=" + URLEncoder.encode(repository,"UTF-8")
                    + "&amp;Document=" + URLEncoder.encode(document,"UTF-8")
                    + "&amp;Service=" + URLEncoder.encode(service,"UTF-8")
                    + "&amp;Registry=" + URLEncoder.encode(registry,"UTF-8")
                    + "&amp;Annotation=" + URLEncoder.encode(annotation,"UTF-8")
                    + "&amp;Granule=" + URLEncoder.encode(granule,"UTF-8")
                    + "&amp;sort_by=" + (so != null ? so.getNumber() : 0)
                    + "&amp;order=" + order
                    + "&amp;rpp=" + rpp
                    + "&amp;etal=" + etAl
                    + "&amp;start=";


    if( q == pageCurrent )
    {
        myLink = "" + q;
    }
    else
    {
        myLink = myLink
            + (q-1) * qResults.getPageSize()
            + "\">"
            + q
            + "</a>";
    }
%>

<script type="text/javascript"><!--
      document.getElementById('allsearch').style.display = 'none';
      document.getElementById('earthsearch').style.display = 'none';
      document.getElementById('sunsearch').style.display = 'none';
<%
    String search_r;
    if ( search_obj != null && search_obj.equals("earth")) {
        search_r = "earthsearch";
    } else if ( search_obj != null && search_obj.equals("sun")) {
        search_r = "sunsearch";
    } else {
        search_r = "allsearch";
    }
%>
      document.getElementById('<%=search_r%>').style.display = 'block';

// --></script>

<%= myLink %>

<%
}

if (pageTotal > pageCurrent)
{
    %><a href="<%= nextURL %>"><fmt:message key="jsp.search.general.next" /></a><%
}
%>

</p>

</dspace:layout>

