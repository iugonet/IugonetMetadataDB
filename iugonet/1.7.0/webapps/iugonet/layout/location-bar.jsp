<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Location bar component
  -
  - This component displays the "breadcrumb" style navigation aid at the top
  - of most screens.
  -
  - Uses request attributes set in org.dspace.app.webui.jsptag.Layout, and
  - hence must only be used as part of the execution of that tag.  Plus,
  - dspace.layout.locbar should be verified to be true before this is included.
  -
  -  dspace.layout.parenttitles - List of titles of parent pages
  -  dspace.layout.parentlinks  - List of URLs of parent pages, empty string
  -                               for non-links
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>
  
<%@ page import="java.util.List" %>

<p class="locationBar">
<span style="padding: 5px; background-color: #222222; color: #ffffff; display:block; ">
<%
    List parentTitles = (List) request.getAttribute("dspace.layout.parenttitles");
    List parentLinks = (List) request.getAttribute("dspace.layout.parentlinks");

    for (int i = 0; i < parentTitles.size(); i++)
    {
        String s = (String) parentTitles.get(i);
        String u = (String) parentLinks.get(i);

        // New line for each breadcrumb (no <br> needed for first)
//        if (i > 0)
//        {
//            out.print("<br/>");
//        }

        if (u.equals(""))
        {
%>
<%= s %>&nbsp;&gt;
<%
        }
        else
        {
%>
<a style="color: #ffffff;" href="<%= request.getContextPath() %><%= u %>"><%= s %></a>&nbsp;&gt;
<%
        }
}
%>
</span>

<!-- AddThis Button BEGIN -->
<span class="addthis_toolbox addthis_default_style " style="margin-top:10pt; height: 20px; display:block; ">
<a class="addthis_button_facebook"></a>
<a class="addthis_button_google"></a>
<a class="addthis_button_twitter"></a>
<a class="addthis_button_evernote"></a>
<a class="addthis_button_compact"></a>
<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=xa-4d33864050c07839"></script>
<!-- AddThis Button END -->
</span>
</p>
<div class="questionnaire">
<MARQUEE SCROLLDELAY="500" SCROLLAMOUNT="120" WIDTH="120"><span style="color:#ff0000;">Questionnaire</span></MARQUEE><a target="_blank" href="/iugonet/feedback/form.jsp">easy feedback</a> or <a target="_blank" href="https://spreadsheets.google.com/spreadsheet/viewform?hl=en_US&amp;formkey=dF9sV0pNalRPQkx0MUlPQjAxU1cybFE6MQ">detail survey</a>
</div>
