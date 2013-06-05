<%--
  - Home page JSP
  -
  - IUGONET
  -
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>

<%
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">
<hr/>
<p align="center">
<a href="<%= request.getContextPath() %>/index.jsp">
<%
 String p = request.getContextPath();
 ArrayList<String> img = new ArrayList<String>();
 img.add(p+"/iugonet/image/iugonet_search_logo1.png");
 img.add(p+"/iugonet/image/iugonet_search_logo2.png");
 img.add(p+"/iugonet/image/iugonet_search_logo3.png");
 Random rnd = new Random();
 int r = rnd.nextInt( img.size() );
 out.println("<img src=\"" + img.get(r) + "\" alt=\"" + img.get(r) + "\" width=\"294\" height=\"105\" border=\"0\"/>");
%>
</a>
</p>
<br/>

<center>
<!-- tabmenu -->
<div class="search_tabbox">
<ul class="search_tabbox_menu">
<li id="allsearch_li" class="allsearch"><a id="allsearch_a" href="#allsearch" onclick="change_tab('allsearch'); return false;">All <img src="<%= request.getContextPath() %>/iugonet/image/favicon.png" alt="favicon.png" /></a></li>
<li id="tierrasearch_li" class="tierrasearch"><a id="tierrasearch_a" href="#tierrasearch" onclick="change_tab('tierrasearch'); return false;">Earth <img src="<%= request.getContextPath() %>/iugonet/image/earthicon.png" alt="earthicon.png" /></a></li>
<li id="sunsearch_li" class="sunsearch"><a id="sunsearch_a" href="#sunsearch" onclick="change_tab('sunsearch'); return false;">Sun <img src="<%= request.getContextPath() %>/iugonet/image/suntabicon.png" alt="suntabicon.png" /></a></li>
<li id="spatialsearch_li" class="spatialsearch"><a id="spatialsearch_a" href="#spatialsearch" onclick="change_tab('spatialsearch'); return false;">Spatial <img src="<%= request.getContextPath() %>/iugonet/image/wakaba.png" alt="wakaba.png" /></a></li>
</ul>

<!-- tabbox0 -->
<div id="allsearch" class="tabbox0">
<form action="<%= request.getContextPath() %>/search" method="get">
<div style="background-color:#fcfcf0;text-align:left;">

<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_keyword0" name="check_search_keyword" value="search_keyword" checked="checked" onclick="toggle_search_box('search_keyword');" /><a href="#" onclick="Effect.toggle(&#39;search_keyword&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Free Word:</a></div>
<div id="search_keyword0" class="search_box" style="text-align:center;">
<input type="text" name="query" id="d_query0" size="72" maxlength="200" value="Free Word" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='Free Word'}"  onfocus="if(this.value == 'Free Word'){this.style.color='#000000'; this.value = ''}" />

<sub><a href="javascript:helpFreeWord();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub><br/>
<%
 ArrayList<String> qword0 = new ArrayList<String>();
 qword0.add("meteor radar, MF radar, SuperDARN, EISCAT");
 qword0.add("magnetometer, SMART, radio wave, imaging riometer");
 qword0.add("ionosphere, troposphere, magnetosphere, helioshpere");
 Random rnd2 = new Random();
 int r2 = rnd2.nextInt( qword0.size() );
 out.println("<font color=\"#808080\">(e.g. " + qword0.get(r2) + ".....)</font>");
%>
</div>

<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_time0" name="check_search_time" value="search_time" checked="checked" onclick="toggle_search_box('search_time');" /><a href="#" onclick="Effect.toggle(&#39;search_time&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Time:</a></div>
<div id="search_time0" class="search_box" style="text-align:center;">
from <input size="30" type="text" id="d_ts0" name="ts" value="YYYY-MM-DDThh:mm:ssZ" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='YYYY-MM-DDThh:mm:ssZ'}"  onfocus="if(this.value == 'YYYY-MM-DDThh:mm:ssZ'){this.style.color='#000000'; this.value = ''}" /> to <input size="30" type="text" id="d_te0" name="te" value="YYYY-MM-DDThh:mm:ssZ" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='YYYY-MM-DDThh:mm:ssZ'}"  onfocus="if(this.value == 'YYYY-MM-DDThh:mm:ssZ'){this.style.color='#000000'; this.value = ''}" /> [UTC]

<sub><a href="javascript:helpTime();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub>
</div>

<div style="margin:10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_datatype0" name="check_search_datatype" value="search_datatype" checked="checked" onclick="return false;" /><a href="#" onclick="Effect.toggle(&#39;search_datatype&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Data Types:</a></div>
<div id="search_datatype0" class="search_box" style="text-align:center;">
<font style="background-color:#ccecff">Data Set ( </font>
<input type="checkbox" name="NumericalData" value="numericaldata" checked="checked" /><span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"><font style="background-color:#ccecff">Numerical</font></span>  
<input type="checkbox" name="DisplayData"   value="displaydata" checked="checked" /><span title="<fmt:message key="jsp.layout.iugonet.DisplayData.Description"/>">  <font style="background-color:#ccecff">Plot &frasl; Movie )</font></span>
<input type="checkbox" name="Granule"       value="granule"        /><span title="<fmt:message key="jsp.layout.iugonet.Granule.Description"/>">      <font style="background-color:#ececff">Data File &frasl; Plot</font></span>   
<input type="checkbox" name="Instrument"    value="instrument"     /><span title="<fmt:message key="jsp.layout.iugonet.Instrument.Description"/>">   <font style="background-color:#ccffcc">Instrument</font></span> 
<input type="checkbox" name="Observatory"   value="observatory"    /><span title="<fmt:message key="jsp.layout.iugonet.Observatory.Description"/>">  <font style="background-color:#ccffcc">Observatory</font></span>
<span style="margin:0px 10px;"><a href="#" onclick="Effect.toggle('detail_search0', 'blind', {duration: 0.3}); return false;"><img src="<%= request.getContextPath() %>/iugonet/image/open.png" alt="open.png" border="0" /></a></span>
<sub><a href="javascript:helpResourceType();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub>
<div id="detail_search0" style="display:none; background-color:transparent;">
<table style="margin:0px auto;text-align:left;">
<tr>
  <td><input type="checkbox" name="Catalog"   value="catalog" /><span title="<fmt:message key="jsp.layout.iugonet.Catalog.Description"/>">  <font style="background-color:#ccecff">Catalog</font></span></td>
  <td><input type="checkbox" name="Person"   value="person" /><span title="<fmt:message key="jsp.layout.iugonet.Person.Description"/>">  <font style="background-color:#ccffcc">Person</font></span></td>
  <td><input type="checkbox" name="Service"   value="service" /><span title="<fmt:message key="jsp.layout.iugonet.Service.Description"/>">  <font style="background-color:#ffcccc">Service</font></span></td>
</tr>
<tr>
  <td><input type="checkbox" name="Document"   value="document" /><span title="<fmt:message key="jsp.layout.iugonet.Document.Description"/>">  <font style="background-color:#ccecff">Document</font></span></td>
  <td><input type="checkbox" name="Annotation"   value="annotation" /><span title="<fmt:message key="jsp.layout.iugonet.Annotation.Description"/>">  <font style="background-color:#ccecff">Annotation</font></span></td>
  <td><input type="checkbox" name="Repository"   value="repository" /><span title="<fmt:message key="jsp.layout.iugonet.Repository.Description"/>">  <font style="background-color:#ffcccc">Repository</font></span></td>
  <td><input type="checkbox" name="Registry"   value="registry" /><span title="<fmt:message key="jsp.layout.iugonet.Registry.Description"/>">  <font style="background-color:#ffcccc">Registry</font></span></td>
</tr>
</table>
</div>
</div>

<div style="text-align:center;">
<input type="submit" name="submit" value="Search" onclick="preset_search_params();" />
</div>

</div>
</form>
</div>
<!-- end of tabbox0 -->

<!-- tabbox1 -->
<div id="tierrasearch" class="tabbox1">
<form action="<%= request.getContextPath() %>/search" method="get">
<input type="hidden" name="search_obj" value="earth" />
<div style="background-color:#fcfcf0;text-align:left;">

<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_keyword" name="check_search_keyword" value="search_keyword" checked="checked" onclick="toggle_search_box('search_keyword');" /><a href="#" onclick="Effect.toggle(&#39;search_keyword&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Free Word:</a></div>
<div id="search_keyword" class="search_box" style="text-align:center;">
<input type="text" name="query" id="d_query" size="72" maxlength="200" value="Free Word" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='Free Word'}"  onfocus="if(this.value == 'Free Word'){this.style.color='#000000'; this.value = ''}" />

<sub><a href="javascript:helpFreeWord();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub><br/>
<%
 ArrayList<String> qword1 = new ArrayList<String>();
 qword1.add("meteor radar, MF radar, SuperDARN, EISCAT");
 qword1.add("magnetometer, SMART, radio wave, imaging riometer");
 qword1.add("ionosphere, troposphere, magnetosphere, helioshpere");
 out.println("<font color=\"#808080\">(e.g. " + qword1.get(r2) + ".....)</font>");
%>
</div>

<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_time" name="check_search_time" value="search_time" checked="checked" onclick="toggle_search_box('search_time');" /><a href="#" onclick="Effect.toggle(&#39;search_time&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Time:</a></div>
<div id="search_time" class="search_box" style="text-align:center;">
from <input size="30" type="text" id="d_ts" name="ts" value="YYYY-MM-DDThh:mm:ssZ" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='YYYY-MM-DDThh:mm:ssZ'}"  onfocus="if(this.value == 'YYYY-MM-DDThh:mm:ssZ'){this.style.color='#000000'; this.value = ''}" /> to <input size="30" type="text" id="d_te" name="te" value="YYYY-MM-DDThh:mm:ssZ" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='YYYY-MM-DDThh:mm:ssZ'}"  onfocus="if(this.value == 'YYYY-MM-DDThh:mm:ssZ'){this.style.color='#000000'; this.value = ''}" /> [UTC]

<sub><a href="javascript:helpTime();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub>
</div>

<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_place" name="check_search_place" value="search_place" checked="checked" onclick="toggle_search_box('search_place');" /><a href="#" onclick="Effect.toggle(&#39;search_place&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Spatial Coverage/Map:</a></div>
<div id="search_place" class="search_box" style="text-align:center;">
<table style="margin: 0px auto;text-align:left;">
<tr>
<td></td>
<td align="center">North <input size="10" type="text" id="d_nlat" name="nlat" value="e.g. 70" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. 70'}"  onfocus="if(this.value == 'e.g. 70'){this.style.color='#000000'; this.value = ''}" /></td>
<td></td>
<td></td>
</tr>

<tr>
<td>West <input size="10" type="text" id="d_wlon" name="wlon" value="e.g. -260" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. -260'}"  onfocus="if(this.value == 'e.g. -260'){this.style.color='#000000'; this.value = ''}" /></td>

<td align="center">
<img src="<%= request.getContextPath() %>/iugonet/image/earthicon.png" alt="earthicon.png" /> <br />
<script type="text/javascript">
<!--
load_gmaps_spatial_search();
//-->
</script>
</td>

<td>East <input size="10" type="text" id="d_elon" name="elon" value="e.g. 135" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. 135'}"  onfocus="if(this.value == 'e.g. 135'){this.style.color='#000000'; this.value = ''}" /></td>

<td>[degree]</td>
</tr>

<tr>
<td></td>
<td align="center">South <input size="10" type="text" id="d_slat" name="slat" value="e.g. -45" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. -45'}"  onfocus="if(this.value == 'e.g. -45'){this.style.color='#000000'; this.value = ''}" /></td>
<td></td>
<td></td>
</tr>
</table>

</div>

<div style="margin:10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_datatype" name="check_search_datatype" value="search_datatype" checked="checked" onclick="return false;" /><a href="#" onclick="Effect.toggle(&#39;search_datatype&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Data Types:</a></div>
<div id="search_datatype" class="search_box" style="text-align:center;">
<font style="background-color:#ccecff">Data Set ( </font>
<input type="checkbox" name="NumericalData" value="numericaldata" checked="checked" /><span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"><font style="background-color:#ccecff">Numerical</font></span>  
<input type="checkbox" name="DisplayData"   value="displaydata" checked="checked" /><span title="<fmt:message key="jsp.layout.iugonet.DisplayData.Description"/>">  <font style="background-color:#ccecff">Plot &frasl; Movie )</font></span>
<input type="checkbox" name="Granule"       value="granule"        /><span title="<fmt:message key="jsp.layout.iugonet.Granule.Description"/>">      <font style="background-color:#ececff">Data File &frasl; Plot</font></span>   
<input type="checkbox" name="Instrument"    value="instrument"     /><span title="<fmt:message key="jsp.layout.iugonet.Instrument.Description"/>">   <font style="background-color:#ccffcc">Instrument</font></span> 
<input type="checkbox" name="Observatory"   value="observatory"    /><span title="<fmt:message key="jsp.layout.iugonet.Observatory.Description"/>">  <font style="background-color:#ccffcc">Observatory</font></span>
<span style="margin:0px 10px;"><a href="#" onclick="Effect.toggle('detail_search', 'blind', {duration: 0.3}); return false;"><img src="<%= request.getContextPath() %>/iugonet/image/open.png" alt="open.png" border="0" /></a></span>
<sub><a href="javascript:helpResourceType();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub>
<div id="detail_search" style="display:none; background-color:transparent;">
<table style="margin:0px auto;text-align:left;">
<tr>
  <td><input type="checkbox" name="Catalog"   value="catalog" /><span title="<fmt:message key="jsp.layout.iugonet.Catalog.Description"/>">  <font style="background-color:#ccecff">Catalog</font></span></td>
  <td><input type="checkbox" name="Person"   value="person" /><span title="<fmt:message key="jsp.layout.iugonet.Person.Description"/>">  <font style="background-color:#ccffcc">Person</font></span></td>
  <td><input type="checkbox" name="Service"   value="service" /><span title="<fmt:message key="jsp.layout.iugonet.Service.Description"/>">  <font style="background-color:#ffcccc">Service</font></span></td>
</tr>
<tr>
  <td><input type="checkbox" name="Document"   value="document" /><span title="<fmt:message key="jsp.layout.iugonet.Document.Description"/>">  <font style="background-color:#ccecff">Document</font></span></td>
  <td><input type="checkbox" name="Annotation"   value="annotation" /><span title="<fmt:message key="jsp.layout.iugonet.Annotation.Description"/>">  <font style="background-color:#ccecff">Annotation</font></span></td>
  <td><input type="checkbox" name="Repository"   value="repository" /><span title="<fmt:message key="jsp.layout.iugonet.Repository.Description"/>">  <font style="background-color:#ffcccc">Repository</font></span></td>
  <td><input type="checkbox" name="Registry"   value="registry" /><span title="<fmt:message key="jsp.layout.iugonet.Registry.Description"/>">  <font style="background-color:#ffcccc">Registry</font></span></td>
</tr>
</table>
</div>
</div>

<div style="text-align:center;">
<input type="submit" name="submit" value="Search" onclick="preset_search_params();" />
</div>

</div>
</form>
</div>
<!-- end of tabbox1 -->

<!-- tabbox2 -->
<div id="sunsearch" class="tabbox2">
<form action="<%= request.getContextPath() %>/search" method="get">
<input type="hidden" name="search_obj" value="sun" />
<div style="background-color:#fcfcf0;text-align:left;">
<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_keyword2" name="check_search_keyword2" value="search_keyword2" checked="checked" onclick="toggle_search_box('search_keyword2');" /><a href="#" onclick="Effect.toggle(&#39;search_keyword2&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Free Word:</a></div>
<div id="search_keyword2" class="search_box" style="text-align:center;">
<input type="text" name="query" id="d_query2" size="72" maxlength="200" value="Free Word" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='Free Word'}"  onfocus="if(this.value == 'Free Word'){this.style.color='#000000'; this.value = ''}" />
<sub><a href="javascript:helpFreeWord();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub><br/>
<%
 ArrayList<String> qword2 = new ArrayList<String>();
 qword2.add("Halpha Chromosphere Moreton wave...");
 qword2.add("SMART Filament Flare...");
 qword2.add("Sun Prominence");
 out.println("<font color=\"#808080\">(e.g. " + qword2.get(r2) + ".....)</font>");
%>
</div>

<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_time2" name="check_search_time2" value="search_time2" checked="checked" onclick="toggle_search_box('search_time2');" /><a href="#" onclick="Effect.toggle(&#39;search_time2&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Time:</a></div>
<div id="search_time2" class="search_box" style="text-align:center;">
from <input size="30" type="text" id="d_ts2" name="ts" value="YYYY-MM-DDThh:mm:ssZ" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='YYYY-MM-DDThh:mm:ssZ'}"  onfocus="if(this.value == 'YYYY-MM-DDThh:mm:ssZ'){this.style.color='#000000'; this.value = ''}" /> to <input size="30" type="text" id="d_te2" name="te" value="YYYY-MM-DDThh:mm:ssZ" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='YYYY-MM-DDThh:mm:ssZ'}"  onfocus="if(this.value == 'YYYY-MM-DDThh:mm:ssZ'){this.style.color='#000000'; this.value = ''}" /> [UTC]

<sub><a href="javascript:helpTime();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub>
</div>

<div style="margin: 10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_place2" name="check_search_place2" value="search_place2" checked="checked" onclick="toggle_search_box('search_place2');" /><a href="#" onclick="Effect.toggle(&#39;search_place2&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Solar Spatial Coverage:</a></div>
<div id="search_place2" class="search_box" style="text-align:center;">

<table style="margin: 0px auto;text-align:left;">

<tr>
<td>Region:</td>
<td><input type="checkbox" name="region" value="FullDisk" />FullDisk</td>
<td><input type="checkbox" name="region" value="PartialRegion" />PartialRegion</td>
<td><sub><a href="javascript:helpSpatialCoverage();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub></td>
</tr>

<tr>
<td></td>
<td align="center">North <input size="10" type="text" id="d_nlat2" name="nlat" value="e.g. 70" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. 70'}"  onfocus="if(this.value == 'e.g. 70'){this.style.color='#000000'; this.value = ''}" /></td>
<td></td>
<td></td>
</tr>

<tr>
<td>East <input size="10" type="text" id="d_elon2" name="elon" value="e.g. 135" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. 135'}"  onfocus="if(this.value == 'e.g. 135'){this.style.color='#000000'; this.value = ''}" /></td>
<td align="center"><img src="<%= request.getContextPath() %>/iugonet/image/sunicon.png" alt="sunicon.png" /></td>
<td>West <input size="10" type="text" id="d_wlon2" name="wlon" value="e.g. -260" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. -260'}"  onfocus="if(this.value == 'e.g. -260'){this.style.color='#000000'; this.value = ''}" /></td>
<td>[degree]</td>
</tr>

<tr>
<td></td>
<td align="center">South <input size="10" type="text" id="d_slat2" name="slat" value="e.g. -45" style="color: #999999;" onblur="if(this.value==''){this.style.color='#999999'; this.value='e.g. -45'}"  onfocus="if(this.value == 'e.g. -45'){this.style.color='#000000'; this.value = ''}" /></td>
<td></td>
<td></td>
</tr>

</table>
</div>

<div style="margin:10px 10px 0px 10px;"><input type="checkbox" class="check_search_box" id="d_check_search_datatype2" name="check_search_datatype2" value="search_datatype2" checked="checked" onclick="return false;" /><a href="#" onclick="Effect.toggle(&#39;search_datatype2&#39;, &#39;blind&#39;, {duration: 0.3}); return false;">Data Types:</a></div>
<div id="search_datatype2" class="search_box" style="text-align:center;">
<font style="background-color:#ccecff">Data Set ( </font>
<input type="checkbox" name="NumericalData" value="numericaldata" checked="checked" /><span title="<fmt:message key="jsp.layout.iugonet.NumericalData.Description"/>"><font style="background-color:#ccecff">Numerical</font></span>  
<input type="checkbox" name="DisplayData"   value="displaydata" checked="checked" /><span title="<fmt:message key="jsp.layout.iugonet.DisplayData.Description"/>">  <font style="background-color:#ccecff">Plot &frasl; Movie )</font></span>
<input type="checkbox" name="Granule"       value="granule"        /><span title="<fmt:message key="jsp.layout.iugonet.Granule.Description"/>">      <font style="background-color:#ececff">Data File &frasl; Plot</font></span>   
<input type="checkbox" name="Instrument"    value="instrument"     /><span title="<fmt:message key="jsp.layout.iugonet.Instrument.Description"/>">   <font style="background-color:#ccffcc">Instrument</font></span> 
<input type="checkbox" name="Observatory"   value="observatory"    /><span title="<fmt:message key="jsp.layout.iugonet.Observatory.Description"/>">  <font style="background-color:#ccffcc">Observatory</font></span>
<span style="margin:0px 10px;"><a href="#" onclick="Effect.toggle('detail_search2', 'blind', {duration: 0.3}); return false;"><img src="<%= request.getContextPath() %>/iugonet/image/open.png" alt="open.png" border="0" /></a></span>
<sub><a href="javascript:helpResourceType();"><img src="<%= request.getContextPath() %>/iugonet/image/question.png" alt="question.png"/></a></sub>
<div id="detail_search2" style="display:none; background-color:transparent;">
<table style="margin:0px auto;text-align:left;">
<tr>
  <td><input type="checkbox" name="Catalog"   value="catalog" /><span title="<fmt:message key="jsp.layout.iugonet.Catalog.Description"/>">  <font style="background-color:#ccecff">Catalog</font></span></td>
  <td><input type="checkbox" name="Person"   value="person" /><span title="<fmt:message key="jsp.layout.iugonet.Person.Description"/>">  <font style="background-color:#ccffcc">Person</font></span></td>
  <td><input type="checkbox" name="Service"   value="service" /><span title="<fmt:message key="jsp.layout.iugonet.Service.Description"/>">  <font style="background-color:#ffcccc">Service</font></span></td>
</tr>
<tr>
  <td><input type="checkbox" name="Document"   value="document" /><span title="<fmt:message key="jsp.layout.iugonet.Document.Description"/>">  <font style="background-color:#ccecff">Document</font></span></td>
  <td><input type="checkbox" name="Annotation"   value="annotation" /><span title="<fmt:message key="jsp.layout.iugonet.Annotation.Description"/>">  <font style="background-color:#ccecff">Annotation</font></span></td>
  <td><input type="checkbox" name="Repository"   value="repository" /><span title="<fmt:message key="jsp.layout.iugonet.Repository.Description"/>">  <font style="background-color:#ffcccc">Repository</font></span></td>
  <td><input type="checkbox" name="Registry"   value="registry" /><span title="<fmt:message key="jsp.layout.iugonet.Registry.Description"/>">  <font style="background-color:#ffcccc">Registry</font></span></td>
</tr>
</table>
</div>
</div>

<div style="text-align:center;">
<input type="submit" name="submit" value="Search" onclick="preset_search_params_sun();" />
</div>

</div>
</form>
</div> <!-- end of tabbox2 -->

<!-- tabbox3 -->
<div id="spatialsearch" class="tabbox3">
<div style="background-color:#fcfcf0;text-align:left;margin-top: 10px;">
<img src="<%= request.getContextPath() %>/iugonet/image/spatial.png" alt="spatial.png" usemap="#iugonet" />
<map name="iugonet">
  <area shape="rect" coords="226,36,315,66" href="http://search.iugonet.org/iugonet/search?query=solar+telescope&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Solar telescope" target="_blank"/>
  <area shape="rect" coords="413,37,504,67" href="http://search.iugonet.org/iugonet/search?query=solar+telescope&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Solar telescope" target="_blank"/>
  <area shape="rect" coords="55,64,113,81" href="http://search.iugonet.org/iugonet/search?query=heliosphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Heliosphere" target="_blank"/>
  <area shape="rect" coords="40,138,112,155" href="http://search.iugonet.org/iugonet/search?query=magnetosphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Magnetosphere" target="_blank"/>
  <area shape="rect" coords="46,178,113,193" href="http://search.iugonet.org/iugonet/search?query=plasmasphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule" alt="Plasmasphere" target="_blank"/>
  <area shape="rect" coords="59,203,112,217" href="http://search.iugonet.org/iugonet/search?query=ionosphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule" alt="Ionosphere" target="_blank"/>
  <area shape="rect" coords="46,235,112,251" href="http://search.iugonet.org/iugonet/search?query=thermosphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule" alt="Thermosphere" target="_blank"/>
  <area shape="rect" coords="54,260,112,275" href="http://search.iugonet.org/iugonet/search?query=mesosphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule" alt="Mesosphere" target="_blank"/>
  <area shape="rect" coords="52,284,113,299" href="http://search.iugonet.org/iugonet/search?query=stratosphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule" target="_blank"/>
  <area shape="rect" coords="53,310,112,325" href="http://search.iugonet.org/iugonet/search?query=troposphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule" alt="Troposphere" target="_blank"/>
  <area shape="rect" coords="7,76,37,167" href="http://search.iugonet.org/iugonet/search?query=masnetosphere+||+plasmasphere+||+ionosphere+||+heliosphere&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule&Instrument=instrument&Observatory=observatory" alt="Ionized atmosphere" target="_blank"/>
  <area shape="rect" coords="6,217,35,310" href="http://search.iugonet.org/iugonet/search?query=thermosphere+||+mesosphere+||+stratosphere+||+troposphere+&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata&Granule=granule&Instrument=instrument&Observatory=observatory" alt="Neutral atmosphere" target="_blank"/>
  <area shape="rect" coords="124,371,194,388" href="http://search.iugonet.org/iugonet/search?query=&ts=&te=&slat=-90&nlat=-66&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Antartica" target="_blank"/>
  <area shape="rect" coords="226,370,319,398" href="http://search.iugonet.org/iugonet/search?query=&ts=&te=&slat=-66&nlat=-30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" target="_blank"/>
  <area shape="rect" coords="342,370,399,391" href="http://search.iugonet.org/iugonet/search?query=&ts=&te=&slat=-30&nlat=30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Equator" target="_blank"/>
  <area shape="rect" coords="423,373,516,389" href="http://search.iugonet.org/iugonet/search?query=&ts=&te=&slat=30&nlat=66&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Northern mid-latitudes" target="_blank"/>  
  <area shape="rect" coords="551,371,594,387" href="http://search.iugonet.org/iugonet/search?query=&ts=&te=&slat=66&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="" target="_blank"/>
  <area shape="rect" coords="286,345,375,357" href="http://search.iugonet.org/iugonet/search?query=magnetometer&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Magnetometer" target="_blank"/>
  <area shape="rect" coords="379,344,473,357" href="http://search.iugonet.org/iugonet/search?query=geomagnetic+index&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Geomagneticindex" target="_blank"/>
  <area shape="rect" coords="477,343,586,358" href="http://search.iugonet.org/iugonet/search?query=ionosphere+conductivity&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Ionospheric conductivity" target="_blank"/> 
  <area shape="rect" coords="120,337,598,363" href="http://search.iugonet.org/iugonet/search?query=WDC&ts=&te=&slat=e.g.+-45&nlat=e.g.+70&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="WDC" target="_blank"/>
  <area shape="rect" coords="135,140,176,152" href="http://search.iugonet.org/iugonet/search?query=SD+rador+&ts=&te=&slat=-90&nlat=-66&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="SD radar" target="_blank"/>
  <area shape="rect" coords="130,161,178,173" href="http://search.iugonet.org/iugonet/search?query=radio&ts=&te=&slat=-90&nlat=-66&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Radio" target="_blank"/>
  <area shape="rect" coords="137,183,170,197" href="http://search.iugonet.org/iugonet/search?query=imager&ts=&te=&slat=-90&nlat=-66&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Imager" target="_blank"/>
  <area shape="rect" coords="121,207,187,220" href="http://search.iugonet.org/iugonet/search?query=magnetometer&ts=&te=&slat=-90&nlat=-66&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Magnetometer" target="_blank"/>
  <area shape="rect" coords="126,236,181,263" href="MF || meteor" alt="MF/Meteor" target="_blank"/>
  <area shape="rect" coords="121,129,188,273" href="http://search.iugonet.org/iugonet/search?query=SD+||+radio+||++Imager+||+MF+||+meteor+||+rador&ts=&te=&slat=-90&nlat=-66&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="SD rador, imager, radio, magnetometer, and MF/meteor rador" target="_blank"/>
  <area shape="rect" coords="420,86,468,98" href="http://search.iugonet.org/iugonet/search?check_search_keyword=search_keyword&query=solar+radio&check_search_time=search_time&ts=&te=&check_search_place=search_place&slat=&nlat=&wlon=&elon=&check_search_datatype=search_datatype&NumericalData=numericaldata&DisplayData=displaydata&submit=Search" alt="Solar radio" target="_blank"/>
  <area shape="rect" coords="418,72,469,191" href="http://search.iugonet.org/iugonet/search?query=radio+||+heliosphere+||+magnetosphere+||+plasmasphere&ts=&te=&slat=45&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Radio observations at mid-latitudes in the northern hemisphere " target="_blank"/>
  <area shape="rect" coords="225,149,302,160" href="http://search.iugonet.org/iugonet/search?query=MAGDAS+||+CPMN&ts=&te=&slat=-75&nlat=75&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="MAGDAS, CPMN" target="_blank"/>
  <area shape="rect" coords="230,165,296,177" href="http://search.iugonet.org/iugonet/search?query=magnetometer&ts=&te=&slat=-75&nlat=75&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Magnetometer" target="_blank"/>
  <area shape="rect" coords="206,179,321,190" href="http://search.iugonet.org/iugonet/search?query=Ionosphere+FM+CW&ts=&te=&slat=-75&nlat=75&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Ionospheric FM-CW data" target="_blank"/>
  <area shape="poly" coords="193,144,192,245,248,245,250,212,304,211,303,245,314,245,314,190,399,189,388,213,432,212,432,195,480,194,480,146,471,145,470,191,417,192,416,145,203,145" href="http://search.iugonet.org/iugonet/search?query=Magdas+||+CPMN+||+magnetopmeter+||+Ionosphere+FM+CW&ts=&te=&slat=-75&nlat=75&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="" target="_blank"/>
  <area shape="rect" coords="259,220,292,232" href="http://search.iugonet.org/iugonet/search?query=Imager&ts=&te=&slat=-60&nlat=-30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Imager at southern mid-latitudes" target="_blank"/>
  <area shape="rect" coords="255,240,296,264" href="http://search.iugonet.org/iugonet/search?query=magnetometer&ts=&te=&slat=-60&nlat=-30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Magnetmeter at southern mid-latitudes" target="_blank"/>
  <area shape="rect" coords="251,214,302,273" href="http://search.iugonet.org/iugonet/search?query=Imager+||+magnetometer&ts=&te=&slat=-60&nlat=-30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Imager and magnetometer at southern mid-latitudes" target="_blank"/>
  <area shape="rect" coords="394,220,428,232" href="http://search.iugonet.org/iugonet/search?query=imager&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Imager at northern mid-latitudes" target="_blank"/>
  <area shape="rect" coords="390,240,430,264" href="http://search.iugonet.org/iugonet/search?query=magnetometer&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="magmnetometer at northern mid-latitudes" target="_blank"/>
  <area shape="rect" coords="388,214,432,272" href="http://search.iugonet.org/iugonet/search?query=imager+||+magnetometer&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Imager and magnetometer at northern mid-latitudes" target="_blank"/>
  <area shape="rect" coords="489,85,538,97" href="http://search.iugonet.org/iugonet/search?query=radio&ts=&te=&slat=45&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Radio observations at higher latitudes in the northern hemisphere" target="_blank"/>
  <area shape="rect" coords="488,126,530,138" href="http://search.iugonet.org/iugonet/search?query=SD+radar&ts=&te=&slat=45&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="SD radar at higher latitudes in the northern hemisphere" target="_blank"/>
  <area shape="rect" coords="489,151,522,138" href="http://search.iugonet.org/iugonet/search?query=imager&ts=&te=&slat=45&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Imager at higher latitudes in the northern hemisphere" target="_blank"/>
<area shape="poly" coords="483,93,483,253,500,274,535,275,535,124,600,124, 600, 93" href="http://search.iugonet.org/iugonet/search?query=radio+||+SD+||+radar+||+imager&ts=&te=&slat=45&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Radio observations, SD radar, and imager" target="_blank"/>
  <area shape="rect" coords="552,133,590,145" href="http://search.iugonet.org/iugonet/search?query=IS+radar&ts=&te=&slat=66&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="IS radar" target="_blank"/>
  <area shape="rect" coords="546,157,594,168" href="http://search.iugonet.org/iugonet/search?query=radio&ts=&te=&slat=45&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Arctic radio observation" target="_blank"/>
  <area shape="rect" coords="552,180,587,193" href="http://search.iugonet.org/iugonet/search?query=imager&ts=&te=&slat=45&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Arctic imager" target="_blank"/>
  <area shape="rect" coords="535,201,602,212" href="http://search.iugonet.org/iugonet/search?query=magnetometer&ts=&te=&slat=66&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Arctic megnetometer" target="_blank"/>
  <area shape="rect" coords="543,229,594,242" href="http://search.iugonet.org/iugonet/search?query=MF+||+meteor+||+radar+&ts=&te=&slat=66&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Arctic Mf/Meteor radar" target="_blank"/>
  <area shape="rect" coords="536,123,603,268" href="http://search.iugonet.org/iugonet/search?query=IS+||+radio+||++imager+||+magnetometer+||+MF+||+meteor+||+radar+&ts=&te=&slat=66&nlat=90&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="IS rador, imager, magnetometer, MF/meteor radar at Arctic" target="_blank"/>
  <area shape="poly" coords="326,195,323,215,338,233,363,234,377,216,373,194" href="http://search.iugonet.org/iugonet/search?query=equatorial+atmosphere+radar&ts=&te=&slat=-45&nlat=30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Equatorial Atmosphere Radar" target="_blank"/>
  <area shape="poly" coords="326,244,337,268,365,270,378,246" href="http://search.iugonet.org/iugonet/search?query=MF+||+meteor+||++radar&ts=&te=&slat=-45&nlat=30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="MF/Meteor radar on equator" target="_blank"/>
  <area shape="poly" coords="324,279,318,298,339,319,365,318,385,300,376,278" href="http://search.iugonet.org/iugonet/search?query=boundary+layer+radar&ts=&te=&slat=-45&nlat=30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="" target="_blank"/>
  <area shape="rect" coords="315,191,386,322" href="http://search.iugonet.org/iugonet/search?query=atmospheric+radar+||+MF+||+meteor+||+bondary+layer+radar&ts=&te=&slat=-45&nlat=30&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Atmospheric rador, MF/Meteor radar, and boundary layer radar onequator" target="_blank"/>
   <area shape="rect" coords="445,202,477,227" href="http://search.iugonet.org/iugonet/search?query=ionosonde&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata"  alt="Ionosonde at mid-latitudes" target="_blank"/>
  <area shape="rect" coords="438,238,482,249" href="http://search.iugonet.org/iugonet/search?query=MU+radar&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="MU radar at mid-latitudes" target="_blank"/>
  <area shape="rect" coords="446,260,475,269" href="http://search.iugonet.org/iugonet/search?query=lidar&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Lidar at mid-latitudes" target="_blank"/>  
  <area shape="recy" coords="435,281,489,319" href="http://search.iugonet.org/iugonet/search?query=Lower+troposphere+radar&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Lower troposphere radar at mid-latitudes" target="_blank"/>
  <area shape="poly" coords="434,197,434,322,491,323,490,273,481,264,480,196" href="http://search.iugonet.org/iugonet/search?query=Ionosonde+||+MU+||+laidar+||+lower+troposphere+radar&ts=&te=&slat=30&nlat=60&wlon=&elon=&NumericalData=numericaldata&DisplayData=displaydata" alt="Ionosonde, MU, laidar, and low troposphere radar" target="_blank"/>
</map>
</div>
</div> <!-- end of tabbox3 -->
</div> <!-- end of tabmenu -->
<script type="text/javascript"><!--
change_tab('allsearch');
// --></script>

</center>
    <dspace:sidebar>
    <%
    if(feedEnabled)
    {
	%>
	    <center>
	    <h4><fmt:message key="jsp.home.feeds"/></h4>
	<%
	    	String[] fmts = feedData.substring(feedData.indexOf(':')+1).split(",");
	    	String icon = null;
	    	int width = 0;
	    	for (int j = 0; j < fmts.length; j++)
	    	{
	    		if ("rss_1.0".equals(fmts[j]))
	    		{
	    		   icon = "rss1.gif";
	    		   width = 80;
	    		}
	    		else if ("rss_2.0".equals(fmts[j]))
	    		{
	    		   icon = "rss2.gif";
	    		   width = 80;
	    		}
	    		else
	    	    {
	    	       icon = "rss.gif";
	    	       width = 36;
	    	    }
	%>
	    <a href="<%= request.getContextPath() %>/feed/<%= fmts[j] %>/site">
            <img src="<%= request.getContextPath() %>/image/<%= icon %>"
                 alt="RSS Feed" width="<%= width %>" height="15" vspace="3" border="0" />
            </a><br />
	<%
	    	}
	%>
            <%
               String fname = application.getRealPath("iugonet/update.out");
               File f = new File( fname );
               if ( f.exists() ) {
                  Date date = new Date( f.lastModified() );
            %>
               <dspace:popup page="/iugonet/update.out"><%= " Latest Update " + date.toString() %></dspace:popup>
            <%
               }
            %>
            <%
               String flname = application.getRealPath("iugonet/update_list.html");
               File fl = new File( flname );
               if ( fl.exists() ) {
            %>
               <br />
               <dspace:popup page="/iugonet/update_list.html"><span style="text-align: right;">more...</span></dspace:popup>
            <%
               }
            %>
            <h4></h4>

            <a href="http://validator.w3.org/check?uri=referer">
            <img src="<%= request.getContextPath() %>/image/valid-xhtml10.png" alt="Valid XHTML 1.0!" height="31" width="88" />
            </a>

	    </center>
	<%
	    }
	%>
    </dspace:sidebar>
</dspace:layout>
