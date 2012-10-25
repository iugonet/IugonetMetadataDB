<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- Template -->
  <xsl:template name="Parameter">


    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>


    <!-- Set Count -->
    <xsl:variable name="count_parametername"        select="count(//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterName')])"/>
    <xsl:variable name="count_parameterdescription" select="count(//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterDescription')])"/>


    <!-- case -->
    <xsl:choose>

      <!-- Error Trap -->
      <xsl:when test="$count_parametername = '0'">
      </xsl:when>

      <!-- case.1 -->
      <xsl:when test="$count_parametername = $count_parameterdescription">
        <xsl:comment> count(ParaneterName) == count(ParameterDescription) </xsl:comment>
        <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterName')]">
          <xsl:variable name="position_parametername" select="position()"/>
          <!-- Title -->
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Parameter</td>
          </tr>
          <!-- Name -->
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Name</td>
          </tr>
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
          </tr>
          <!-- Description -->
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Description</td>
          </tr>
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterDescription')][position() = $position_parametername]"/></td>
          </tr>
        </xsl:for-each>
      </xsl:when>

      <!-- case.2 -->
      <xsl:when test="$count_parametername != $count_parameterdescription">
        <xsl:comment> count(ParameterName) != count(ParameterDescription) </xsl:comment>
        <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterName')] | //dublin_core/dcvalue[@qualifier=concat($parent_element, 'ParameterDescription')]">
          <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
          <xsl:variable name="qualifier" select="./@qualifier"/>
          <xsl:choose>
            <!-- ParameterName -->
            <xsl:when test="$qualifier = 'ParameterName'">
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Parameter</td>
              </tr>
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Name</td>
              </tr>
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
              </tr>
            </xsl:when>
            <!-- ParameterDescription -->
            <xsl:when test="$qualifier = 'ParameterDescription'">
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Description</td>
              </tr>
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="."/></td>
              </tr>
            </xsl:when>
            <!-- Error Trap -->
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>

      <!-- Error Trap -->
      <xsl:otherwise>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
