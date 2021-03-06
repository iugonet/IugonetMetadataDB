<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE -->
  <xsl:import href="./common/ResourceHeader.xsl"/>


  <!-- Template -->
  <xsl:template name="Instrument">


    <!-- Parameter -->
    <xsl:param name="related_flag"/>


    <!-- ResourceID -->
    <xsl:comment> [ResourceID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@element='ResourceID']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ResourceID</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=InstrumentID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
      </tr>
    </xsl:for-each>


    <!-- Resource Header -->
    <xsl:call-template name="ResourceHeader">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Instrument</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- InstrumentType -->
    <xsl:comment> [InstrumentType] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='InstrumentType']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>InstrumentType</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ObservatoryID -->
    <xsl:comment> [ObservatoryID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ObservatoryID']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ObservatoryID</td>
      </tr>
      <tr>
        <xsl:choose>
          <xsl:when test="$related_flag = '1'">
            <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=InstrumentObservatoryID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
          </xsl:when>
          <xsl:otherwise>
            <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('#', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </xsl:for-each>


    <!-- InvestigationName -->
    <xsl:comment> [InvestigationName] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='InvestigationName']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>InvestigationName</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Caveats -->
    <xsl:comment> [Caveats] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='Caveats']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>Caveats</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Extension -->
    <xsl:comment> [Extension] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='Extension']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>Extension</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


  </xsl:template>

</xsl:stylesheet>
