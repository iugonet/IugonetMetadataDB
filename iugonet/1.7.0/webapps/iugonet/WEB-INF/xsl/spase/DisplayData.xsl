<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE: import -->
  <xsl:import href="./common/ResourceHeader.xsl"/>
  <xsl:import href="./common/AccessInformation.xsl"/>
  <xsl:import href="./common/TemporalDescription.xsl"/>
  <xsl:import href="./common/SpatialCoverage.xsl"/>
  <xsl:import href="./common/Parameter.xsl"/>


  <!-- Template -->
  <xsl:template name="DisplayData">


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
        <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=DisplayDataID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
      </tr>
    </xsl:for-each>


    <!-- Resource Header -->
    <xsl:call-template name="ResourceHeader">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">DisplayData</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- Access Information -->
    <xsl:call-template name="AccessInformation">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">DisplayData</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


    <!-- Processing Level -->
    <xsl:comment> [Processing Level] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ProcessingLevel']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ProcessingLevel</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ProviderResourceName -->
    <xsl:comment> [ProviderResourceName] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ProviderResourceName']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ProviderResourceName</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ProviderProcessingLevel -->
    <xsl:comment> [ProviderProcessingLevel] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@element='ProviderProcessingLevel']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ProviderProcessingLevel</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ProviderVersion -->
    <xsl:comment> [ProviderVersion] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ProviderVersion']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ProviderVersion</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- InstrumentID -->
    <xsl:comment> [InstrumentID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='InstrumentID']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>InstrumentID</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- MeasurementType -->
    <xsl:comment> [MeasurementType] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='MeasurementType']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>MeasurementType</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- TemporalDescription -->
    <xsl:call-template name="TemporalDescription">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">DisplayData</xsl:with-param>
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


    <!-- SpectralRange -->
    <xsl:comment> [SpectralRange] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='SpectralRange']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>SpectralRange</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- DisplayCadence -->
    <xsl:comment> [DisplayCadence] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='DisplayCadence']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>DisplayCadence</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ObserverdRegion -->
    <xsl:comment> [ObserverdRegion] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ObserverdRegion']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ObserverdRegion</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ObserverdRegion -->
    <xsl:comment> [ObserverdRegion] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='ObserverdRegion']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>ObserverdRegion</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- SpatialCoverage -->
    <xsl:call-template name="SpatialCoverage">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">DisplayData</xsl:with-param>
      <xsl:with-param name="parent_element"></xsl:with-param>
      <xsl:with-param name="indent_number">1</xsl:with-param>
    </xsl:call-template>


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


    <!-- Parameter -->
    <xsl:call-template name="Parameter">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type">DisplayData</xsl:with-param>
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
