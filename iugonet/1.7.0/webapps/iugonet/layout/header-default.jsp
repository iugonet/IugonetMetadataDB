<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - HTML header for main home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="java.util.StringTokenizer" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String)request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List)request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String)request.getAttribute("dspace.layout.head");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace "+dsVersion;
%>
<%
// if get item, replace title string to resource name
Item item = (Item) request.getAttribute("item");
if(item!=null){
  String handle = item.getHandle();
  if(handle!=null){
    DCValue[] value_t = item.getMetadata("iugonet", Item.ANY, "ResourceHeaderResourceName", Item.ANY);
    if(value_t.length == 1){
      title = value_t[0].value;
    }
  }
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title><%= siteName %>: <%= title %></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Generator" content="<%= generator %>" />
        <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css" type="text/css" />
        <link rel="stylesheet" href="<%= request.getContextPath() %>/print.css" media="print" type="text/css" />
        <link rel="stylesheet" href="<%= request.getContextPath() %>/lightbox.css" type="text/css" />
        <link rel="shortcut icon" href="<%= request.getContextPath() %>/favicon.ico" type="image/x-icon"/>
<%
    if (!"NONE".equals(feedRef))
    {
        for (int i = 0; i < parts.size(); i+= 3)
        {
%>
        <link rel="alternate" type="application/<%= (String)parts.get(i) %>" title="<%= (String)parts.get(i+1) %>" href="<%= request.getContextPath() %>/feed/<%= (String)parts.get(i+2) %>/<%= feedRef %>"/>
<%
        }
    }
    
    if (osLink)
    {
%>
        <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath() %>/<%= osCtx %>description.xml" title="<%= osName %>"/>
<%
    }

    if (extraHeadData != null)
        { %>
<%= extraHeadData %>
<%
        }
%>
        
    <script type="text/javascript" src="<%= request.getContextPath() %>/utils.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/prototype.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/scriptaculous.js?load=effects,builder"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/controls.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/scriptaculous/lightbox.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/choice-support.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/helpFreeWord.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/helpTime.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/helpSpatialCoverage.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/helpResourceType.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/gmaps.js"> </script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/searchbox.js"> </script>

<script type="text/javascript"><!--
   function change_tab(tabname) {
      document.getElementById('allsearch').style.display = 'none';
      document.getElementById('allsearch_a').style.color = '#336699';
      document.getElementById('allsearch_a').style.fontWeight = 'normal';
      document.getElementById('allsearch_li').style.margin = '0px';
      document.getElementById('tierrasearch').style.display = 'none';
      document.getElementById('tierrasearch_a').style.color = '#336699';
      document.getElementById('tierrasearch_a').style.fontWeight = 'normal';
      document.getElementById('tierrasearch_li').style.margin = '0px';
      document.getElementById('sunsearch').style.display = 'none';
      document.getElementById('sunsearch_a').style.color = '#336699';
      document.getElementById('sunsearch_a').style.fontWeight = 'normal';
      document.getElementById('sunsearch_li').style.margin = '0px';
      document.getElementById('spatialsearch').style.display = 'none';
      document.getElementById('spatialsearch_a').style.color = '#336699';
      document.getElementById('spatialsearch_a').style.fontWeight = 'normal';
      document.getElementById('spatialsearch_li').style.margin = '0px';
      if(tabname) {
	 tabbar = tabname + "_li";
	 tablink = tabname + "_a";
         document.getElementById(tabbar).style.margin = '1px 0px -1px 0px'
         document.getElementById(tabname).style.display = 'block';
         document.getElementById(tablink).style.color = 'black';
         document.getElementById(tablink).style.fontWeight = 'bold';
      }
   }
// --></script>

    </head>

    <%-- HACK: leftmargin, topmargin: for non-CSS compliant Microsoft IE browser --%>
    <%-- HACK: marginwidth, marginheight: for non-CSS compliant Netscape browser --%>
    <body>

        <%-- Localization --%>
<%--  <c:if test="${param.locale != null}">--%>
<%--   <fmt:setLocale value="${param.locale}" scope="session" /> --%>
<%-- </c:if> --%>
<%--        <fmt:setBundle basename="Messages" scope="session"/> --%>

        <%-- Page contents --%>

        <%-- HACK: width, border, cellspacing, cellpadding: for non-CSS compliant Netscape, Mozilla browsers --%>
        <table class="centralPane" width="99%" border="0" cellpadding="3" cellspacing="1">

            <%-- HACK: valign: for non-CSS compliant Netscape browser --%>
            <tr valign="top">

            <%-- Navigation bar --%>
<%
    if (!navbar.equals("off"))
    {
%>
            <td class="navigationBar">
                <dspace:include page="<%= navbar %>" />
            </td>
<%
    }
%>
            <%-- Page Content --%>

            <%-- HACK: width specified here for non-CSS compliant Netscape 4.x --%>
            <%-- HACK: Width shouldn't really be 100%, but omitting this means --%>
            <%--       navigation bar gets far too wide on certain pages --%>
            <td class="pageContents" width="100%">

                <%-- Location bar --%>
<%
    if (locbar)
    {
%>
                <dspace:include page="/layout/location-bar.jsp" />
<%
    }
%>
