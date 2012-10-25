<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE: import -->
  <xsl:import href="./Contact.xsl"/>
  <xsl:import href="./InformationURL.xsl"/>


  <!-- Template -->
  <xsl:template name="ResourceHeader">


    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>
    <xsl:param name="related_flag"/>


    <!-- ResourceName -->
    <xsl:comment> [ResourceName] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderResourceName')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>ResourceName</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Description -->
    <xsl:comment> [Description] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderDescription')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Description</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Acknowledgement -->
    <xsl:comment> [Acknowledgement] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderAcknowledgement')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Acknowledgement</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- AlternateName -->
    <xsl:comment> [AlternateName] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderAlternateName')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>AlternateName</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ReleaseDate -->
    <xsl:comment> [ReleaseDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderReleaseDate')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>ReleaseDate</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- ExpirationDate -->
    <xsl:comment> [ExpirationDate] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderExpirationDate')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>ExpirationDate</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Contact -->
    <xsl:call-template name="Contact">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type"><xsl:value-of select="$resource_type"/></xsl:with-param>
      <xsl:with-param name="parent_element">ResourceHeader</xsl:with-param>
      <xsl:with-param name="indent_number"><xsl:value-of select="number($indent_number)"/></xsl:with-param>
    </xsl:call-template>


    <!-- InformationURL -->
    <xsl:call-template name="InformationURL">
      <xsl:with-param name="related_flag"><xsl:value-of select="$related_flag"/></xsl:with-param>
      <xsl:with-param name="resource_type"><xsl:value-of select="$resource_type"/></xsl:with-param>
      <xsl:with-param name="parent_element">ResourceHeader</xsl:with-param>
      <xsl:with-param name="indent_number"><xsl:value-of select="number($indent_number)"/></xsl:with-param>
    </xsl:call-template>


    <!-- Association -->
    <xsl:comment> [Association] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderAssociation')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Association</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- PriorID -->
    <xsl:comment> [PriorID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ResourceHeaderPriorID')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>PriorID</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


  </xsl:template>

</xsl:stylesheet>
