<%--
  - home.jsp
  -
  - Version: $Revision: 3705 $
  -
  - Date: $Date: 2009-04-11 10:02:24 -0700 (Sat, 11 Apr 2009) $
  -
  - Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  - Institute of Technology.  All rights reserved.
  -
  - Redistribution and use in source and binary forms, with or without
  - modification, are permitted provided that the following conditions are
  - met:
  -
  - - Redistributions of source code must retain the above copyright
  - notice, this list of conditions and the following disclaimer.
  -
  - - Redistributions in binary form must reproduce the above copyright
  - notice, this list of conditions and the following disclaimer in the
  - documentation and/or other materials provided with the distribution.
  -
  - - Neither the name of the Hewlett-Packard Company nor the name of the
  - Massachusetts Institute of Technology nor the names of their
  - contributors may be used to endorse or promote products derived from
  - this software without specific prior written permission.
  -
  - THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  - ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  - LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  - A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  - HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  - INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  - BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  - OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  - ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  - TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  - USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  - DAMAGE.
  --%>

<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
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
    Community[] communities = (Community[]) request.getAttribute("communities");

    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    String topNews = ConfigurationManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));
    String sideNews = ConfigurationManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html"));

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">
<P><A href="http://www.iugonet.org/" target="_self">Web</A> <A href="index.jsp">Range Search</A> <A href="index1.jsp">Simple Search</A> <A href="index2.jsp">Advanced Search</A> <B>Help</B></P>
<HR>
<P>ヘルプ</P>
<UL>
  <LI>検索対象
  <UL>
    <LI>現在，設定している検索対象
    <UL>
      <LI><A href="http://iugonet1.stelab.nagoya-u.ac.jp/iugonet/iugonet/spase2dspace.txt">spase2dspace.txt</A>
    </UL>
    <LI>検索対象フィールドの指定
    <UL>
      <LI>デフォルトでは，全要素のデータが検索対象
      <LI>日付時間の範囲検索は，iugonet.Granule.StartDateとiugonet.Granule.StopDateだけ．
      <LI>フィールドを指定して検索することもできる．ここで，フィールドとは複数の要素を集めたもの．
      <UL>
        <LI>フィールド名とワードの間にコロンを入れる．
        <LI>例．NumericalData:velocity
      </UL>
      <LI>現在設定されているフィールドは，
      <UL>
        <LI>
        <TABLE border="1">
          <TBODY>
            <TR>
              <TD align="center">フィールド名</TD>
              <TD align="center">対象要素&nbsp;</TD>
            </TR>
            <TR>
              <TD>&nbsp;NumericalData </TD>
              <TD> iugonet.NumericalData.*&nbsp;</TD>
            </TR>
            <TR>
              <TD>&nbsp;Instrument </TD>
              <TD>&nbsp;iugonet.Instrument.* </TD>
            </TR>
            <TR>
              <TD>&nbsp;Observatory </TD>
              <TD>&nbsp;iugonet.Observatory.* </TD>
            </TR>
            <TR>
              <TD>&nbsp;Person </TD>
              <TD>&nbsp;iugonet.Person.* </TD>
            </TR>
            <TR>
              <TD>&nbsp;Granule </TD>
              <TD>&nbsp;iugonet.Granule.* </TD>
            </TR>
            <TR>
              <TD>&nbsp;Person-PersonName </TD>
              <TD>&nbsp;iugonet.Person.PersonName </TD>
            </TR>
            <TR>
              <TD>&nbsp;Person-OrganizationName </TD>
              <TD>&nbsp;iugonet.Person.OrganizationName </TD>
            </TR>
            <TR>
              <TD>&nbsp;NumericalData-Parameter </TD>
              <TD>&nbsp;iugonet.NumericalData.ParameterName,<BR>
              iugonet.NumericalData.ParameterDescription </TD>
            </TR>
            <TR>
              <TD>&nbsp;Granule-StartDate </TD>
              <TD>&nbsp;iugonet.Granule.StartDate</TD>
            </TR>
            <TR>
              <TD>&nbsp;Granule-StopDate </TD>
              <TD>&nbsp;iugonet.Granule.StopDate </TD>
            </TR>
            <TR>
              <TD>&nbsp;Granule-Date </TD>
              <TD>&nbsp;iugonet.Granule.StartDate,<BR>
              iugonet.Granule.StopDate </TD>
            </TR>
            <TR>
              <TD>&nbsp;PersonID</TD>
              <TD>&nbsp;iugonet.Person.ResourceID,<BR>
              iugonet.NumericalData.ResourceHeaderContactPersonID</TD>
            </TR>
            <TR>
              <TD> filename</TD>
              <TD>&nbsp;iugonet.filename</TD>
            </TR>
            <TR>
              <TD>&nbsp;ResourceType</TD>
              <TD>&nbsp;iugonet.ResourceType</TD>
            </TR>
          </TBODY>
        </TABLE>
      </UL>
    </UL>
  </UL>
  <LI>ワード検索
  <UL>
    <LI>大文字，小文字
    <UL>
      <LI>大文字小文字の区別はない．
      <LI>区別したい場合，どうするか知らない．
    </UL>
    <LI>複数ワード
    <UL>
      <LI>スペース区切りによる複数ワード検索の場合，AND検索になる．
      <LI>OR検索をしたい場合は ORを明記する．
      <UL>
        <LI>例．RISH OR WDC
      </UL>
      <LI>ワード検索と時間範囲検索の関係もAND検索である．
      <LI>今後，ANDやORは，選択できるようにしたほうがよい？
    </UL>
    <LI>ワイルドカード
    <UL>
      <LI>DSpaceでは，単語で完全にマッチしないとヒットしない．
      <UL>
        <LI>インポートされているデータが，NumericalDataの場合，numerical，あるいは，dataではヒットしない．numericaldataでヒットする．
        <LI>インポートされているデータが，Numerical Dataの場合(スペースで区切られている場合)，numerical，あるいは，dataでヒットする．
        <LI>文字列は，英語の区切り文字(スペース，コンマ，ピリオドなど)で，分割されている．
      </UL>
      <LI>１文字補完は，? を使う．
      <LI>複数文字補完は，* を使う．
      <LI>前方補完は使えない(先頭に補完文字は使えない)．
      <LI>中間補完，後方補完は可能．
    </UL>
  </UL>
  <LI>日付時間の範囲検索
  <UL>
    <LI>現在，日付時間の範囲検索の対象は，iugonet.Granule.StartDateとiugonet.Granule.StopDateだけである．そのため，日付時間検索をするとGranuleデータしかヒットしない．
    <LI>存在しない日付や時間を入力した場合
    <UL>
      <LI>現在，動作不明．対応していない．
      <LI>今後決める．エラーになるようにするか? なにも入力されてないことにするか? 内部で修正をするか(たとえば，12月32日を入力した場合は，1月1日に自動に変換するなど)?
    </UL>
    <LI>fromとtoの両方を入力しなければならない．
    <UL>
      <LI>現在，片方入力の場合，無視される．
      <LI>今後決める．片方の入力の場合，自動的に補完するか(たとえば，fromがない場合，0000-01-01など)?
    </UL>
    <LI>日付時間フォーマット
    <UL>
      <LI>現在，サポートしている日付時間フォーマット
      <UL>
        <LI>yyyy-MM-dd'T'HH:mm:ss'Z'
        <LI>yyyy-MM-dd'T'HH:mm:ss
        <LI>yyyy-MM-dd'T'HH:mm
        <LI>yyyy-MM-dd'T'HH
        <LI>yyyy-MM-dd
        <LI>yyyy-MM
        <LI>yyyy
      </UL>
      <LI>例
      <UL>
        <LI>2000-01-10T00:00:00Z
        <LI>2000-01-10T00:00:00
        <LI>2000-01-10
        <LI>2000-1-10
      </UL>
      <LI>月日のゼロはなくてもよい．2000-01-10は，2000-1-10でも同じ．
      <LI>時間を入力していない(日付だけの)場合，時間は，00:00:00(UTC)に設定される．UTC,JSTのオプションは無視される．
      <LI>その他のフォーマットは，希望があれば対応可能
    </UL>
  </UL>
</UL>
<BR>
<CENTER>
<A href="http://www.iugonet.org/">About IUGONET</A>
<BR>
©2010
</CENTER>
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
	    <a href="<%= request.getContextPath() %>/feed/<%= fmts[j] %>/site"><img src="<%= request.getContextPath() %>/image/<%= icon %>" alt="RSS Feed" width="<%= width %>" height="15" vspace="3" border="0" /></a>
	<%
	    	}
	%>
            <h4>Search/Retrieve URL Service</h4>
            <a href="http://iugonet1.stelab.nagoya-u.ac.jp/SRW/">
<img src="iugonet/image/oclc_srwu.gif" alt="OCLC SRW/U" width="80" height="15" vspace="3" border="0" /></a>
	    </center>
	<%
	    }
	%>
    </dspace:sidebar>
</dspace:layout>
