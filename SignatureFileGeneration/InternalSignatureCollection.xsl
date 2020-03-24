<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <!-- The input JSON file -->
    <xsl:param name="InternalSignatureCollection" select="'url to json file'"/>
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="data">
        <!--      Used to output raw trabnsformation to make it easier to navigate tree -->
        <!-- <xsl:copy-of select="json-to-xml(.)"/>-->
        <InternalSignatureCollection>
            <xsl:apply-templates select="json-to-xml(.)"/>
        </InternalSignatureCollection>
    </xsl:template>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:apply-templates select="array[@key = 'value']/map"/>
    </xsl:template>
    <xsl:template match="array[@key = 'value']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <InternalSignature Specificity="Specific">
            <xsl:attribute name="ID">
                <xsl:value-of select="number[@key = 'internal_signatures_ID']"/>
            </xsl:attribute>
            <xsl:apply-templates select="array[@key = 'internalSignature_ByteSequence']/map"/>

        </InternalSignature>
    </xsl:template>
    <xsl:template match="array[@key = 'internalSignature_ByteSequence']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <ByteSequence Reference="BOFoffset">
            <xsl:attribute name="Reference">
                <xsl:value-of
                    select="map[@key = 'byteSequence_ByteSequencePosition']/string[@key = 'label']"
                />
            </xsl:attribute>
            <SubSequence MinFragLength="0" Position="1">
                <xsl:attribute name="MinFragLength">
                    <xsl:value-of select="string[@key = 'internal_signatures_ID']"/>
                </xsl:attribute>
                <xsl:attribute name="SubSeqMaxOffset">
                    <xsl:value-of select="number[@key = 'byteSequenceMaxOffset']"/>
                </xsl:attribute>
                <xsl:attribute name="SubSeqMinOffset">
                    <xsl:value-of select="number[@key = 'byteSequenceOffset']"/>
                </xsl:attribute>
                <Sequence>
                    <xsl:value-of select="string[@key = 'byteSequenceValue']"/>
                </Sequence>

            </SubSequence>
        </ByteSequence>
    </xsl:template>

</xsl:stylesheet>
