<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- Template -->
  <xsl:template name="Person">


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
        <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=PersonID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
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


    <!-- PersonName -->
    <xsl:comment> [PersonName] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='PersonName']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>PersonName</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=PersonName&amp;value=', translate(., ' ', '+'))"/></xsl:attribute><xsl:value-of select="."/></a></td>
      </tr>
    </xsl:for-each>


    <!-- OrganizationName -->
    <xsl:comment> [OrganizationName] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='OrganizationName']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>OrganizationName</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Address -->
    <xsl:comment> [Address] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='Address']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>Address</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Email -->
    <xsl:comment> [Email] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='Email']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>Email</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- PhoneNumber -->
    <xsl:comment> [PhoneNumber] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='Number']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>PhoneNumber</td>
      </tr>
      <tr>
        <td class="metadataFieldValue1"><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- FaxNumber -->
    <xsl:comment> [FaxNumber] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier='FaxNumber']">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td class="metadataFieldLabel1"><hr class="hrMetaDataField"/>FaxNumber</td>
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
