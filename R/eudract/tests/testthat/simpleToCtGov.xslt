<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>



  <xsl:key name="group_id" match="GROUP/title" use="."/>
  <xsl:key name="term" match="SERIOUS | NON_SERIOUS" use="concat(term, eutctId, name())"/>


  <xsl:template match="/">
    <aev:adverseEvents xmlns:aev="http://eudract.ema.europa.eu/schema/clinical_trial_result/adverse_events" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <description>AE additional description</description>
      <nonSeriousEventFrequencyThreshold>0.0</nonSeriousEventFrequencyThreshold>
      <timeFrame>Timeframe for AE</timeFrame>
      <assessmentMethod>
        <value>ADV_EVT_ASSESS_TYPE.non_systematic</value>
      </assessmentMethod>
      <dictionary>
        <otherName xsi:nil="true"/>
        <version>19.0</version>
        <name>
          <value>ADV_EVT_DICTIONARY_NAME.meddra</value>
        </name>
      </dictionary>


      <reportingGroups>
        <xsl:apply-templates select="TABLE/GROUP"/>
      </reportingGroups>

      <nonSeriousAdverseEvents>
        <xsl:for-each select="TABLE/NON_SERIOUS[ count(.| key('term', concat(term, eutctId, name()))[1])=1]" >
          <nonSeriousAdverseEvent>
            <xsl:call-template name="event"/>
          </nonSeriousAdverseEvent>
        </xsl:for-each>
      </nonSeriousAdverseEvents>

      <seriousAdverseEvents>
        <xsl:for-each select="TABLE/SERIOUS[ count(.| key('term', concat(term, eutctId, name()))[1])=1]" >
          <seriousAdverseEvent>
            <xsl:call-template name="event"/>
          </seriousAdverseEvent>
        </xsl:for-each>
      </seriousAdverseEvents>

    </aev:adverseEvents>
  </xsl:template>


  <xsl:template name="event">
    <description>
      <xsl:value-of select ="term"/>
    </description>
    <term>
      <xsl:value-of select ="term"/>
    </term>
    <organSystem>
      <eutctId>
        <xsl:value-of select ="eutctId"/>
      </eutctId>
      <xsl:variable name="localEutctId" select="eutctId" />
      <soc>
        <xsl:value-of select="document('soc.xml')/soc_table/soc[eutctId=$localEutctId]/soc_term"/>
      </soc>

      <xsl:choose>
        <xsl:when test="eutctId = 100000167503">
          <version>3</version>
        </xsl:when>
        <xsl:otherwise>
           <version>22</version>
        </xsl:otherwise>
      </xsl:choose>
    </organSystem>
    <assessmentMethod>
      <value>ADV_EVT_ASSESS_TYPE.non_systematic</value>
    </assessmentMethod>
    <dictionaryOverridden>false</dictionaryOverridden>
    <values>
      <xsl:for-each select="key('term', concat(term, eutctId, name()))">
        <xsl:call-template name="value"/>
      </xsl:for-each>
    </values>

  </xsl:template>


  <xsl:template name="value">
    <value>
      <xsl:attribute name="reportingGroupId">
        <xsl:value-of select="generate-id( key('group_id',  ./groupTitle) )"/>
      </xsl:attribute>
      <occurrences>
        <xsl:value-of select="occurrences"/>
      </occurrences>
      <subjectsAffected>
        <xsl:value-of select="subjectsAffected"/>
      </subjectsAffected>
      <subjectsExposed>
        <xsl:value-of select="key('group_id',./groupTitle)/../subjectsExposed"/>
      </subjectsExposed>
      <xsl:apply-templates select="."/>
    </value>
  </xsl:template>

  <xsl:template match="SERIOUS">
    <occurrencesCausallyRelatedToTreatment>
      <xsl:value-of select="occurrencesCausallyRelatedToTreatment"/>
    </occurrencesCausallyRelatedToTreatment>
    <fatalities>
      <deaths>
        <xsl:value-of select="deaths"/>
      </deaths>
      <deathsCausallyRelatedToTreatment>
        <xsl:value-of select="deathsCausallyRelatedToTreatment"/>
      </deathsCausallyRelatedToTreatment>
    </fatalities>
  </xsl:template>

  <xsl:template match="NON_SERIOUS"/>


  <xsl:template match="GROUP">
    <reportingGroup  id="{generate-id(title)}">
      <title>
        <xsl:value-of select="title"/>
      </title>
      <description xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
      <subjectsAffectedByNonSeriousAdverseEvents>
        <xsl:value-of select="subjectsAffectedByNonSeriousAdverseEvents"/>
      </subjectsAffectedByNonSeriousAdverseEvents>
      <subjectsAffectedBySeriousAdverseEvents>
        <xsl:value-of select="subjectsAffectedBySeriousAdverseEvents"/>
      </subjectsAffectedBySeriousAdverseEvents>
      <subjectsExposed>
        <xsl:value-of select="subjectsExposed"/>
      </subjectsExposed>
      <deathsAllCauses>
        <xsl:value-of select="deathsAllCauses"/>
      </deathsAllCauses>
      <deathsResultingFromAdverseEvents>
        <xsl:value-of select="deathsResultingFromAdverseEvents"/>
      </deathsResultingFromAdverseEvents>
    </reportingGroup>

  </xsl:template>


</xsl:stylesheet>
