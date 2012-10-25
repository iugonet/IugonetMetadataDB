<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- DEFINE: import -->
  <xsl:import href="./spase/Granule.xsl"/>
  <xsl:import href="./spase/Catalog.xsl"/>
  <xsl:import href="./spase/DisplayData.xsl"/>
  <xsl:import href="./spase/NumericalData.xsl"/>
  <xsl:import href="./spase/Instrument.xsl"/>
  <xsl:import href="./spase/Observatory.xsl"/>
  <xsl:import href="./spase/Repository.xsl"/>
  <xsl:import href="./spase/Person.xsl"/>
  <xsl:import href="./spase/Service.xsl"/>
  <xsl:import href="./spase/Document.xsl"/>
  <xsl:import href="./spase/Service.xsl"/>
  <xsl:import href="./spase/Annotation.xsl"/>


  <!-- Template -->
<!--  <xsl:template match="dublin_core"> -->
  <xsl:template match="/">


    <!-- Parameter -->
    <xsl:variable name="related_flag" select="//dublin_core/relatedflag"/>


    <!-- Contents -->
    <table width="100%" class="itemDisplayTable">

      <!-- Resource Name -->
      <xsl:comment> [Resource Name] </xsl:comment>
      <xsl:variable name="count_resource_name" select="count(//dublin_core/dcvalue[@qualifier='ResourceHeaderResourceName'])"/>
      <!-- Data Exist -->
      <xsl:if test="$count_resource_name != '0'">
        <tr>
          <th class="itemDisplayTitle"><xsl:value-of select="//dublin_core/dcvalue[@qualifier='ResourceHeaderResourceName']"/></th>
        </tr>
      </xsl:if>


      <!-- Resource Type -->
      <xsl:comment> [Resource Type] </xsl:comment>
      <xsl:variable name="resource_type" select="//dublin_core/dcvalue[@element='ResourceType']"/>
      <xsl:variable name="count_resource_type" select="count(//dublin_core/dcvalue[@element='ResourceType'])"/>
      <!-- Data Exist -->
      <xsl:if test="$count_resource_type != '0'">
        <tr>
          <td class="metadataFieldLabel1"><br/>Resource Type</td>
        </tr>
        <xsl:choose>
          <xsl:when test="$resource_type = 'Granule'">
            <tr>
              <td class="metadataFieldValue1">Data File/Plot</td>
            </tr>
          </xsl:when>
          <xsl:when test="$resource_type = 'NumericalData'">
            <tr>
              <td class="metadataFieldValue1">Data Set</td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td class="metadataFieldValue1"><xsl:value-of select="$resource_type"/></td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>


      <!-- Resource -->
      <xsl:choose>

        <!-- Granule -->
        <xsl:when test="$resource_type = 'Granule'">
          <xsl:call-template name="Granule">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Catalog -->
        <xsl:when test="$resource_type = 'Catalog'">
          <xsl:call-template name="Catalog">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- DisplayData -->
        <xsl:when test="$resource_type = 'DisplayData'">
          <xsl:call-template name="DisplayData">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- NumericalData -->
        <xsl:when test="$resource_type = 'NumericalData'">
          <xsl:call-template name="NumericalData">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Instrument -->
        <xsl:when test="$resource_type = 'Instrument'">
          <xsl:call-template name="Instrument">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Observatory -->
        <xsl:when test="$resource_type = 'Observatory'">
          <xsl:call-template name="Observatory">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Person -->
        <xsl:when test="$resource_type = 'Person'">
          <xsl:call-template name="Person">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Repository -->
        <xsl:when test="$resource_type = 'Repository'">
          <xsl:call-template name="Repository">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Service -->
        <xsl:when test="$resource_type = 'Service'">
          <xsl:call-template name="Service">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Document -->
        <xsl:when test="$resource_type = 'Document'">
          <xsl:call-template name="Document">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Service -->
        <xsl:when test="$resource_type = 'Service'">
          <xsl:call-template name="Service">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Annotation -->
        <xsl:when test="$resource_type = 'Annotation'">
          <xsl:call-template name="Annotation">
            <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <!-- Others (Error Trap) -->
        <xsl:otherwise>
        </xsl:otherwise>

      </xsl:choose>


      <!-- Blank -->
      <xsl:comment> BLANK </xsl:comment>
      <tr>
        <td>&#160;</td>
      </tr>


    </table>


  </xsl:template>

</xsl:stylesheet>
