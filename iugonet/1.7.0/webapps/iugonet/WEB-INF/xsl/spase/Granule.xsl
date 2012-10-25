<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE -->
  <xsl:import href="./common/Source.xsl"/>
  <xsl:import href="./common/SpatialCoverage.xsl"/>


  <!-- Template -->
  <xsl:template name="Granule">


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


    <!-- ReleaseDate -->
    <xsl:comment> [ReleaseDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ReleaseDate']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ReleaseDate</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ExpirationDate -->
    <xsl:comment> [ExpirationDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ExpirationDate']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ExpirationDate</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ParentID -->
    <xsl:comment> [ParentID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ParentID']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ParentID</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('#', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
      </tr>
    </xsl:for-each>


    <!-- PriorID -->
    <xsl:comment> [PriorID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='PriorID']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>PriorID</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- StartDate -->
    <xsl:comment> [StartDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='StartDate']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>StartDate</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- StopDate -->
    <xsl:comment> [StopDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='StopDate']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>StopDate</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Source -->
    <xsl:call-template name="Source">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Granule</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- SpatialCoverage -->
    <xsl:call-template name="SpatialCoverage">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Granule</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


  </xsl:template>

</xsl:stylesheet>
