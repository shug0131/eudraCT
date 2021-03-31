<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>



  <xsl:key name="group_id" match="GROUP/title" use="."/>
  <xsl:key name="term" match="SERIOUS | NON_SERIOUS" use="concat(term, eutctId, name())"/>


  <xsl:template match="/">
      <tns:result partialUpload="true" 	xmlns:tns="http://clinicaltrials.gov/rrs"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        	>
<outcomeMeasures/>


    <reportedEvents>
      <allCauseMortComment>all-cause mortality</allCauseMortComment>
      <assessmentType>Non-Systematic Assessment</assessmentType>
      <frequencyReportingThreshold>0.0</frequencyReportingThreshold>



      <frequentAdverseEvents>
        <xsl:for-each select="TABLE/NON_SERIOUS[ count(.| key('term', concat(term, eutctId, name()))[1])=1]" >
          <frequentEvent>
            <xsl:call-template name="event"/>
          </frequentEvent>
        </xsl:for-each>
      </frequentAdverseEvents>

      <interventionGroups>
        <xsl:apply-templates select="TABLE/GROUP"/>
      </interventionGroups>

      <notes/>

      <seriousAdverseEvents>
        <xsl:for-each select="TABLE/SERIOUS[ count(.| key('term', concat(term, eutctId, name()))[1])=1]" >
          <seriousEvent>
            <xsl:call-template name="event"/>
          </seriousEvent>
        </xsl:for-each>
      </seriousAdverseEvents>

      <sourceVocabulary>MedDRA 22.0</sourceVocabulary>
      <timeFrame>Timeframe for AE</timeFrame>
    </reportedEvents>
  </tns:result>
  </xsl:template>


  <xsl:template name="event">
    <adverseEventStats>
      <xsl:for-each select="key('term', concat(term, eutctId, name()))">
        <xsl:call-template name="value"/>
      </xsl:for-each>
    </adverseEventStats>
    <assessmentType>Non-Systematic Assessment</assessmentType>
    <notes> <xsl:value-of select ="term"/> </notes>
    <xsl:variable name="localEutctId" select="eutctId" />
    <organSystemName>
      <xsl:value-of select="document($soc_xml_file_path)/soc_table/soc[eutctId=$localEutctId]/soc_term"/>
    </organSystemName>
    <sourceVocabulary>MedDRA 22.0</sourceVocabulary>
    <term> <xsl:value-of select ="term"/> </term>
  </xsl:template>


  <xsl:template name="value">
    <eventStats>
      <reportingGroupId>
        <xsl:value-of select="generate-id( key('group_id',  ./groupTitle) )"/>
      </reportingGroupId>
      <numEvents>
        <xsl:value-of select="occurrences"/>
      </numEvents>
      <numSubjectsAffected>
        <xsl:value-of select="subjectsAffected"/>
      </numSubjectsAffected>
      <numSubjects>
        <xsl:value-of select="key('group_id',./groupTitle)/../subjectsExposed"/>
      </numSubjects>
    </eventStats>
  </xsl:template>




  <xsl:template match="GROUP">
    <interventionGroup  id="{generate-id(title)}">
      <description>
          <xsl:value-of select="title"/>
      </description>
      <numDeaths>
        <xsl:value-of select="deathsAllCauses"/>
      </numDeaths>
      <numSubjectsFrequentEvents>
        <xsl:value-of select="subjectsAffectedByNonSeriousAdverseEvents"/>
      </numSubjectsFrequentEvents>
      <numSubjectsSeriousEvents>
        <xsl:value-of select="subjectsAffectedBySeriousAdverseEvents"/>
      </numSubjectsSeriousEvents>
      <partAtRiskAllCauseMort>
        <xsl:value-of select="subjectsExposed"/>
      </partAtRiskAllCauseMort>
      <partAtRiskFrequentEvents><xsl:value-of select="subjectsExposed"/></partAtRiskFrequentEvents>
      <partAtRiskSeriousEvents><xsl:value-of select="subjectsExposed"/></partAtRiskSeriousEvents>
      <title>
        <xsl:value-of select="title"/>
      </title>

    </interventionGroup>


  </xsl:template>


</xsl:stylesheet>
