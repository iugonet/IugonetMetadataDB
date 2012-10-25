<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- Template -->
  <xsl:template name="ParameterEntity">


    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>


    <!-- Set Count -->
    <xsl:variable name="count_parameterentity" select="count(//dublin_core/dcvalue[contains(@qualifier, concat($parent_element, 'ParameterEntity'))])"/>
    <xsl:if test="$count_parameterentity != 0">
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>ParameterEntity</td>
      </tr>
    </xsl:if>


    <!-- CoordinateSystemRepresentation -->
    <xsl:comment> [CoordinateSystemRepresentation] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterEntityCoordinateSystemRepresentation')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>CoordinateSystemRepresentation</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- CoordinateSystemName -->
    <xsl:comment> [CoordinateSystemName] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterEntityCoordinateSystemName')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>CoordinateSystemName</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


  </xsl:template>

</xsl:stylesheet>
