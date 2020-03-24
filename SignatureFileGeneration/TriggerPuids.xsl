<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.nationalarchives.gov.uk/formatRegistry/" version="3.0">
    <!-- The input JSON file -->
    <xsl:param name="ContainerType" select="'url to json file'"/>
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="data">
        <!--      <xsl:copy-of select="json-to-xml(.)"/>-->
        <TriggerPuids>
            <xsl:apply-templates select="json-to-xml(.)"/>
        </TriggerPuids>
    </xsl:template>

    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:apply-templates select="array[@key = 'value']/map"/>
    </xsl:template>

    <xsl:template match="array[@key = 'value']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:apply-templates select="array[@key = 'containerType_FileFormat']/map">
            <xsl:with-param name="ContainerType" select="string[@key = 'label']"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="array[@key = 'containerType_FileFormat']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="ContainerType"/>
        <TriggerPuid>
            <xsl:attribute name="ContainerType">
                <xsl:value-of select="$ContainerType"/>
            </xsl:attribute>
            <xsl:attribute name="Puid">
                <xsl:value-of select="string[@key = 'puid']"/>
            </xsl:attribute>
        </TriggerPuid>
    </xsl:template>
</xsl:stylesheet>
