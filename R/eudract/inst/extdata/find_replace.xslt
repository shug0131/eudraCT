<?xml version="1.0" encoding="UTF-8"?>
  <xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="replace_file_path"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>  
    </xsl:template>
    
    
    <xsl:template match="reportedEvents">
      <xsl:for-each select="document($replace_file_path)//reportedEvents">
        <xsl:copy><xsl:apply-templates select="@*|node()"/> </xsl:copy>
      </xsl:for-each>
    </xsl:template>
   
    
    <xsl:template match="@*|node()">
      <xsl:copy> <xsl:apply-templates select="@*|node()"/> </xsl:copy>
    </xsl:template>
    
    
 </xsl:stylesheet>    