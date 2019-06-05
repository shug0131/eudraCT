<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>


<xsl:template match="/statsfiles">
  <TABLE>
    <xsl:apply-templates select="file"/>
  </TABLE>
</xsl:template>


<xsl:template match="file">
  <xsl:variable name="filename">
    <xsl:value-of select="."/>
  </xsl:variable>
  <xsl:apply-templates select="document($filename)/dta">
    <xsl:with-param name="tagparam" select="@tag"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="dta">
 <xsl:param name="tagparam"/>
  <xsl:apply-templates select="data/o">
    <xsl:with-param name="tagparam" select="$tagparam"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="o">
  <xsl:param name="tagparam"/>
     <xsl:element name="{$tagparam}">
       <xsl:apply-templates select="v"/>
     </xsl:element>
</xsl:template>


<xsl:template match="v">

  <xsl:variable name="nodevar">
    <xsl:value-of select="@varname"/>
  </xsl:variable>

  <xsl:variable name="var">
    <xsl:choose>
        <xsl:when test="not(ancestor::dta/variable_labels/vlabel[@varname= $nodevar]='')">
            <xsl:value-of select="ancestor::dta/variable_labels/vlabel[@varname= $nodevar]"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="@varname"/>
        </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   <xsl:element name="{$var}">
       	<xsl:value-of select="."/>
   </xsl:element>
</xsl:template>


</xsl:stylesheet>
