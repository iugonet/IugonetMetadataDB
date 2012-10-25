<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- DEFINE: import -->
  <xsl:import href="./AccessURL.xsl"/>
  <xsl:import href="./DataExtent.xsl"/>


  <!-- Template -->
  <xsl:template name="AccessInformation">


    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>


    <!-- Set Count -->
    <xsl:variable name="count_accessinformation" select="count(//dublin_core/dcvalue[contains(@qualifier, concat($parent_element, 'AccessInformation'))])"/>
    <xsl:if test="$count_accessinformation != 0">
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>AccessInformation</td>
      </tr>
    </xsl:if>


    <!-- RepositoryID -->
    <xsl:comment> [RepositoryID] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'AccessInformationRepositoryID')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>RepositoryID</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=', $resource_type, 'RepositoryID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
      </tr>
    </xsl:for-each>


    <!-- AccessURL -->
    <xsl:call-template name="AccessURL">
      <xsl:with-param name="resource_type"><xsl:value-of select="$resource_type"/></xsl:with-param>
      <xsl:with-param name="parent_element">AccessInformation</xsl:with-param>
      <xsl:with-param name="indent_number"><xsl:value-of select="number($indent_number + 1)"/></xsl:with-param>
    </xsl:call-template>


    <!-- Availability -->
    <xsl:comment> [Availability] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'AccessInformationAvailability')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Availability</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- AccessRights -->
    <xsl:comment> [AccessRights] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'AccessInformationAccessRights')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>AccessRights</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Description -->
    <xsl:comment> [Description] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'AccessInformationDescription')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Description</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Format -->
    <xsl:comment> [Format] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'AccessInformationFormat')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Format</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- Encoding -->
    <xsl:comment> [Encoding] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'AccessInformationEncoding')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Encoding</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


    <!-- DataExtent -->
    <xsl:call-template name="DataExtent">
      <xsl:with-param name="resource_type"><xsl:value-of select="$resource_type"/></xsl:with-param>
      <xsl:with-param name="parent_element">AccessInformation</xsl:with-param>
      <xsl:with-param name="indent_number"><xsl:value-of select="number($indent_number + 1)"/></xsl:with-param>
    </xsl:call-template>


    <!-- Acknowledgement -->
    <xsl:comment> [Acknowledgement] </xsl:comment>
    <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'AccessInformationAcknowledgement')]">
    <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Acknowledgement</td>
      </tr>
      <tr>
        <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
      </tr>
    </xsl:for-each>


  </xsl:template>

</xsl:stylesheet>
