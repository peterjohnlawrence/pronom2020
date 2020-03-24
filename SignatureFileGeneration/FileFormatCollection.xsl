<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <!-- The input JSON file -->
    <xsl:param name="FileFormatCollection" select="'url to json file'"/>
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="data">
        <!--      Used to output raw trabnsformation to make it easier to navigate tree -->
        <!--<xsl:copy-of select="json-to-xml(.)"/>-->
        <FileFormatCollection>
            <xsl:apply-templates select="json-to-xml(.)"/>
        </FileFormatCollection>
    </xsl:template>

    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:apply-templates select="array[@key = 'value']/map"/>
    </xsl:template>

    <xsl:template match="array[@key = 'value']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <FileFormat>
            <xsl:attribute name="ID">
                <xsl:value-of select="number[@key = 'file_formats_ID']"/>
            </xsl:attribute>
            <xsl:attribute name="Name">
                <xsl:value-of select="string[@key = 'label']"/>
            </xsl:attribute>
            <xsl:attribute name="PUID">
                <xsl:value-of select="string[@key = 'puid']"/>
            </xsl:attribute>
            <xsl:attribute name="Version">
                <xsl:value-of select="string[@key = 'version']"/>
            </xsl:attribute>
            <xsl:apply-templates select="array[@key = 'fileFormat_FormatIdentifier']/map"/>
            <xsl:apply-templates select="array[@key = 'fileFormat_InternalSignature']/map"/>
            <xsl:apply-templates select="array[@key = 'fileFormat_ExternalSignature']/map"/>
            <xsl:apply-templates select="array[@key = 'hasPriorityOver']/map"/>
        </FileFormat>
    </xsl:template>
    <xsl:template match="array[@key = 'fileFormat_FormatIdentifier']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:variable name="type"
            select="map[@key = 'formatIdentifier_FormatRegistry']/string[@key = 'label']"/>
        <xsl:choose>
            <xsl:when test="$type = 'Internet Media Type'">
                <xsl:attribute name="MIMEType">
                    <xsl:value-of select="string[@key = 'label']"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$type = 'Uniform type identifier'">
                <xsl:attribute name="UTIType">
                    <xsl:value-of select="string[@key = 'label']"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$type = 'Library of Congress File Format Description'">
                <xsl:attribute name="LoCType">
                    <xsl:value-of select="string[@key = 'label']"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="array[@key = 'fileFormat_InternalSignature']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <InternalSignatureID>
            <xsl:value-of select="number[@key = 'internal_signatures_ID']"/>
        </InternalSignatureID>
    </xsl:template>
    <xsl:template match="array[@key = 'fileFormat_ExternalSignature']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <Extension>
            <xsl:value-of select="string[@key = 'extension']"/>
        </Extension>
    </xsl:template>
    <xsl:template match="array[@key = 'hasPriorityOver']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <HasPriorityOverFileFormatID>
            <xsl:value-of select="number[@key = 'file_formats_ID']"/>
        </HasPriorityOverFileFormatID>
    </xsl:template>
</xsl:stylesheet>
