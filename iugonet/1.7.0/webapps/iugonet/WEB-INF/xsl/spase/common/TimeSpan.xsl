<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- Template -->
  <xsl:template name="TimeSpan">


    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>


    <!-- Parent Element -->
    <xsl:variable name="count_timespan" select="count(//dublin_core/dcvalue[contains(@qualifier, concat($parent_element, 'TimeSpan'))])"/>
    <xsl:if test="$count_timespan != 0">
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>TimeSpan</td>
      </tr>
    </xsl:if>


    <!-- StartDate -->
    <xsl:comment> [StartDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'TimeSpanStartDate')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>StartDate</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- StopDate -->
    <xsl:comment> [StopDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'TimeSpanStopDate')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>StopDate</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- StopDateEntity -->
    <xsl:comment> [StopDateEntity] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'TimeSpanStopDateEntity')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>StopDateEntity</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- RelativeStopDate -->
    <xsl:comment> [RelativeStopDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'TimeSpanRelativeStopDate')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>RelativeStopDate</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Note -->
    <xsl:comment> [Note] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'TimeSpanNote')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Note</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


  </xsl:template>

</xsl:stylesheet>
