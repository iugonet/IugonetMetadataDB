<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


  <!-- Template -->
  <xsl:template name="Contact">


    <!-- Parameter -->
    <xsl:param name="resource_type"/>
    <xsl:param name="parent_element"/>
    <xsl:param name="indent_number"/>
    <xsl:param name="related_flag"/>


    <!-- PersonID and Role -->
    <xsl:comment> [PersonID] and [Role] </xsl:comment>
    <xsl:variable name="count_personid" select="count(//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ContactPersonID')])"/>
    <xsl:variable name="count_role"     select="count(//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ContactRole')])"/>
    <xsl:choose>
      <!-- Error Trap -->
      <xsl:when test="$count_personid = '0'">
      </xsl:when>
      <!-- Error Trap -->
      <xsl:when test="$count_role = '0'">
      </xsl:when>
      <!-- case.1 -->
      <xsl:when test="$count_personid = $count_role">
        <xsl:comment> count(PersonID) == count(Role) </xsl:comment>
        <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ContactPersonID')]">
          <xsl:variable name="position_personid" select="position()"/>
          <!-- Title -->
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Contact</td>
          </tr>
          <!-- PersonID -->
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>PersonID</td>
          </tr>
          <tr>
            <xsl:choose>
              <xsl:when test="$related_flag = '1'">
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=', $resource_type, 'PersonID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
              </xsl:when>
              <xsl:otherwise>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><a><xsl:attribute name="href"><xsl:value-of select="concat('#', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <!-- Role -->
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Role</td>
          </tr>
          <tr>
            <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><xsl:value-of select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ContactRole')][position() = $position_personid]"/></td>
          </tr>
        </xsl:for-each>
      </xsl:when>
      <!-- case.2 -->
      <xsl:when test="$count_personid != $count_role">
        <xsl:comment> count(PersonID) != count(Role) </xsl:comment>
        <xsl:for-each select="//dublin_core/dcvalue[@qualifier=concat($parent_element, 'ContactPersonID')] | //dublin_core/dcvalue[@qualifier=concat($parent_element, 'ContactRole')]">
          <xsl:sort select="./@metadata_value_id" data-type="number" order="ascending"/>
          <xsl:variable name="qualifier" select="./@qualifier"/>
          <xsl:choose>
            <!-- PersonID -->
            <xsl:when test="$qualifier = concat($parent_element, 'ContactPersonID')">
              <!-- Title -->
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number))"/></xsl:attribute><hr class="hrMetaDataField"/>Contact</td>
              </tr>
              <!-- PersonID -->
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>PersonID</td>
              </tr>
              <tr>
                <xsl:choose>
                  <xsl:when test="$related_flag = '1'">
                    <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><a><xsl:attribute name="href"><xsl:value-of select="concat('/iugonet/browse?type=', $resource_type, 'PersonID&amp;value=', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldValue', number($indent_number + 1))"/></xsl:attribute><a><xsl:attribute name="href"><xsl:value-of select="concat('#', .)"/></xsl:attribute><xsl:value-of select="."/></a></td>
                  </xsl:otherwise>
                </xsl:choose>
              </tr>
            </xsl:when>
            <!-- Role -->
            <xsl:when test="$qualifier = concat($parent_element, 'ContactRole')">
              <tr>
                <td><xsl:attribute name="class"><xsl:value-of select="concat('metadataFieldLabel', number($indent_number + 1))"/></xsl:attribute><hr class="hrMetaDataField"/>Role</td>
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
