<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE -->
  <xsl:import href="./Checksum.xsl"/>
  <xsl:import href="./DataExtent.xsl"/>


  <!-- Template -->
  <xsl:template name="Source">


    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>


    <!-- Set Count -->
    <xsl:variable name="count_source" select="count(//dublin_core/dcvalue[contains(@qualifier, concat($parent_element, 'Source'))])"/>
    <xsl:if test="$count_source != 0">
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Source</td>
      </tr>
    </xsl:if>


    <!-- SourceType -->
    <xsl:comment> [SourceType] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'SourceSourceType')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>SourceType</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- URL -->
    <xsl:comment> [URL] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'SourceURL')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>URL</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><a><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a></td>
      </tr>
    </xsl:for-each>


    <!-- MirrorURL -->
    <xsl:comment> [MirrorURL] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'MirrorURL')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>MirrorURL</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Checksum -->
    <xsl:call-template name="Checksum">
      <xsl:with-param name="resource_type"><xsl:value-of select="$resource_type"/></xsl:with-param>
      <xsl:with-param name="parent_element">Source</xsl:with-param>
      <xsl:with-param name="indent_number"><xsl:value-of select="number($indent_number)"/></xsl:with-param>
    </xsl:call-template>


    <!-- DataExtent -->
    <xsl:call-template name="DataExtent">
      <xsl:with-param name="resource_type"><xsl:value-of select="$resource_type"/></xsl:with-param>
      <xsl:with-param name="parent_element">Source</xsl:with-param>
      <xsl:with-param name="indent_number"><xsl:value-of select="number($indent_number)"/></xsl:with-param>
    </xsl:call-template>


  </xsl:template>

</xsl:stylesheet>
