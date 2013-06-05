<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE -->
  <xsl:import href="./common/ResourceHeader.xsl"/>
  <xsl:import href="./common/TimeSpan.xsl"/>
  <xsl:import href="./common/ObservationExtent.xsl"/>


  <!-- Template -->
  <xsl:template name="Annotation">


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
        <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=AnnotationID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
      </tr>
    </xsl:for-each>


    <!-- Resource Header -->
    <xsl:call-template name="ResourceHeader">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Annotation</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- ImageURL -->
    <xsl:comment> [ImageURL] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ImageURL']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ImageURL</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- AnnotationType -->
    <xsl:comment> [AnnotationType] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='AnnotationType']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>AnnotationType</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- PhenomenonType -->
    <xsl:comment> [PhenomenonType] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='PhenomenonType']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>PhenomenonType</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ClassificationMethod -->
    <xsl:comment> [ClassificationMethod] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ClassificationMethod']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ClassificationMethod</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ConfidenceRating -->
    <xsl:comment> [ConfidenceRating] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ConfidenceRating']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ConfidenceRating</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- TimeSpan -->
    <xsl:call-template name="TimeSpan">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Annotation</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- ObservationExtent -->
    <xsl:call-template name="ObservationExtent">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">Annotation</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


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
