<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE -->
  <xsl:import href="./common/ResourceHeader.xsl"/>
  <xsl:import href="./common/AccessInformation.xsl"/>


  <!-- Template -->
  <xsl:template name="Document">


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
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Resource Header -->
    <xsl:call-template name="ResourceHeader">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Document</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- Access Information -->
    <xsl:call-template name="AccessInformation">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Document</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- Keyword -->
    <xsl:comment> [Keyword] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='Keyword']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>Keyword</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- DocumentType -->
    <xsl:comment> [DocumentType] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='DocumentType']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>DocumentType</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- InputResourceID -->
    <xsl:comment> [InputResourceID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='InputResourceID']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>InputResourceID</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


  </xsl:template>

</xsl:stylesheet>
