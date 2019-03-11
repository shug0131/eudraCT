<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:key name="term" match="event" use="./term" />

<xsl:for-each select="event[ count(.| key('term', ./term)[1])=1]" >
	<xsl:variable name="first_event" select="."/>
	<xsl:variable name="term_group", select="$first_event/term")
	<term> 
		<term_label> <xsl:value-of  select="$term_group"/> </term_label>
		<xsl:for-each select="key('term', $term_group)">
			<group><xsl:value-of select="./group"/></group>
			<occurences><xsl:value-of select="./occurences"/></occurences>
		<xsl:for-each>
	</term>
<xsl:for-each>
</xsl:stylesheet>