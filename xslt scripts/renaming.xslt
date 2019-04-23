<?xml version="1.0" encoding="utf-8"?>
<!--
	Author: Simon Bond
	File: rename.xslt
	Date: 4APR2019
	Purpose: To rename xml tags when SAS has terminated the variable names
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>
  <xsl:key name="rename" match="rename" use="old"/>		
<xsl:template match="/">
<table>
<xsl:apply-templates select="//GROUP | //SERIOUS | //NON_SERIOUS"/>		
</table>
</xsl:template>

<xsl:template match="*" name="myelement">
<xsl:variable name="tagname" >
<xsl:choose>
<xsl:when test="count(key('rename', name(.)))=1">
<xsl:value-of select="key('rename', name(.))/new"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="name(.)"/>	
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:element name="{$tagname}">
<xsl:if test="count(child::*)=0"> 
	<xsl:value-of select="."/>
</xsl:if>
<xsl:apply-templates select="*"/>
</xsl:element>
</xsl:template>

</xsl:stylesheet>
