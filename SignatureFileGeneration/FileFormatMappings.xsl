<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <!-- The input JSON file -->
    <xsl:param name="FileFormatMappings" select="'url to json file'"/>
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="data">
        <!--      Used to output raw trabnsformation to make it easier to navigate tree -->
        <!--                        <xsl:copy-of select="json-to-xml(.)"/>-->
        <FileFormatMappings>
            <xsl:apply-templates select="json-to-xml(.)"/>
        </FileFormatMappings>
    </xsl:template>

    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:apply-templates select="array[@key = 'value']/map"/>
    </xsl:template>

    <xsl:template match="array[@key = 'value']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:comment>
          <xsl:value-of select="string[@key = 'comment']"/>          
        </xsl:comment>
        <FileFormatMapping signatureId="35000" Puid="fmt/1213">
            <xsl:attribute name="signatureId">
                <xsl:value-of select="number[@key = 'containerSignature_ID']"/>
            </xsl:attribute>
            <xsl:attribute name="Puid">
                <xsl:value-of
                    select="array[@key = 'containerSignature_FileFormat']/map/string[@key = 'puid']"
                />
            </xsl:attribute>
        </FileFormatMapping>
    </xsl:template>
</xsl:stylesheet>
