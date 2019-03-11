<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<TABLE>
<xsl:apply-templates select="dta/data/o" />
</TABLE>
</xsl:template>

<xsl:template match="o">
<group>
	<xsl:apply-templates select="v"/>
</group>
</xsl:template>


<xsl:key name="label" match="vlabel" use="@varname"/>

<xsl:template match="v">

<xsl:variable name="var">
	<xsl:for-each select="key('label',@varname)">
		<xsl:if test=".='' "> <xsl:value-of select="@varname" /> </xsl:if>
		<xsl:if test="not(.='')"> <xsl:value-of select="."/></xsl:if>
	</xsl:for-each>
</xsl:variable>


<xsl:element name="{$var}">
       	<xsl:value-of select="."/> 
</xsl:element>
</xsl:template>
</xsl:stylesheet>