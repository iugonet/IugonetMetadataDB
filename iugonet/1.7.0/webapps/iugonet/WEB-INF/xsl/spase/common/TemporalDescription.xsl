<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- DEFINE: import -->
  <xsl:import href="./TimeSpan.xsl"/>


  <!-- Template -->
  <xsl:template name="TemporalDescription">

    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>


    <!-- Set Count -->
    <xsl:variable name="count_temporaldescription" select="count(//dublin_core/dcvalue[contains(@qualifier, concat($parent_element, 'TemporalDescription'))])"/>
    <xsl:if test="$count_temporaldescription != 0">
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>TemporalDescription</td>
      </tr>
    </xsl:if>


    <!-- TimeSpan -->
    <xsl:call-template name="TimeSpan">
      <xsl:with-param name="resource_type"><xsl:value-of select="$resource_type"/></xsl:with-param>
      <xsl:with-param name="parent_element">TemporalDescription</xsl:with-param>
      <xsl:with-param name="indent_number"><xsl:value-of select="number($indent_number + 1)"/></xsl:with-param>
    </xsl:call-template>


    <!-- Cadence -->
    <xsl:comment> [Cadence] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'TemporalDescriptionCadence')]">
      <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Cadence</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>

    <!-- Exposure -->
    <xsl:comment> [Exposure] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'TemporalDescriptionExposure')]">
      <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Exposure</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>

