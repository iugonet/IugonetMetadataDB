<%--
    << !! CAUTION !! >>
    This script 'full_nobody.jsp' has been newly added by N.UMEMURA, on 20120404.
    (DSpace's original package doesn't have this script.)
    This script is required to display the relational metadata on the same screen.
    Technical document is in the wiki page, please see that.
    Contact: N.UMEMURA@STEL umemura@stelab.nagoya-u.ac.jp

--%>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>

<%
    // First, get the browse info object
    BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");
    BrowseIndex bix = bi.getBrowseIndex();
%>

<%-- output the results using the browselist tag --%>
<%
    if (bix.isMetadataIndex())
    {
%>
    <dspace:browselist browseInfo="<%= bi %>" emphcolumn="<%= bix.getMetadata() %>" />
<%
    }
    else if (request.getAttribute("browseWithdrawn") != null)
    {
%>
    <dspace:browselist browseInfo="<%= bi %>" emphcolumn="<%= bix.getSortOption().getMetadata() %>" linkToEdit="true" disableCrossLinks="true" />
<%
    }
    else
    {
%>
     <dspace:browselist browseInfo="<%= bi %>" emphcolumn="<%= bix.getSortOption().getMetadata() %>" />
<%
    }
%>
