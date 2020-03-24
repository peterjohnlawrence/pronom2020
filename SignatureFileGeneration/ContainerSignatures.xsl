<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <!-- The input JSON file -->
    <xsl:param name="ContainerSignature" select="'url to json file'"/>
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="data">
        <!--      Used to output raw trabnsformation to make it easier to navigate tree -->
        <!--                <xsl:copy-of select="json-to-xml(.)"/>-->
        <ContainerSignatures>
            <xsl:apply-templates select="json-to-xml(.)"/>
        </ContainerSignatures>
    </xsl:template>

    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

        <xsl:apply-templates select="array[@key = 'value']/map"/>

    </xsl:template>
    <xsl:template match="array[@key = 'value']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <ContainerSignature>
            <xsl:attribute name="Id">
                <xsl:value-of select="number[@key = 'containerSignature_ID']"/>
            </xsl:attribute>
            <xsl:attribute name="ContainerType">
                <xsl:value-of select="string[@key = 'ContainerType']"/>
            </xsl:attribute>
            <Description>
                <xsl:value-of select="string[@key = 'comment']"/>
            </Description>
            <Files>
                <xsl:apply-templates select="array[@key = 'containerSignature_ContainerFile']/map">
                    <xsl:with-param name="Id" select="number[@key = 'containerSignature_ID']"/>
                </xsl:apply-templates>
            </Files>
        </ContainerSignature>
    </xsl:template>
    <xsl:template match="array[@key = 'containerSignature_ContainerFile']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="Id"/>
        <File>
            <Path>
                <xsl:value-of select="string[@key = 'filePath']"/>
            </Path>
            <xsl:apply-templates select="array[@key = 'containerFile_ByteSequence']/map">
                <xsl:with-param name="Id" select="$Id"/>
            </xsl:apply-templates>
        </File>
    </xsl:template>
    <xsl:template match="array[@key = 'containerFile_ByteSequence']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="Id"/>
        <BinarySignatures>
            <InternalSignatureCollection>
                <InternalSignature>
                    <xsl:attribute name="Id">
                        <xsl:value-of select="$Id"/>
                        <!--<xsl:value-of select="string[@key = '@odata.id']"/>-->
                    </xsl:attribute>
                    <ByteSequence Reference="BOFoffset">
                        <xsl:attribute name="Reference">
                            <xsl:value-of
                                select="map[@key = 'byteSequence_ByteSequencePosition']/string[@key = 'label']"
                            />
                        </xsl:attribute>
                        <SubSequence Position="1">
                            <!--                            <xsl:attribute name="byteSequenceIndirectOffsetLength">
                                <xsl:value-of select="number[@key = 'byteSequenceIndirectOffsetLength']"/>
                            </xsl:attribute> 
                            <xsl:attribute name="byteSequenceIndirectOffsetLength">
                                <xsl:value-of select="number[@key = 'byteSequenceIndirectOffsetLocation']"/>
                            </xsl:attribute> -->
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
                    <xsl:apply-templates select="string[@key = 'comment']"/>
                </InternalSignature>
            </InternalSignatureCollection>
        </BinarySignatures>
    </xsl:template>
</xsl:stylesheet>
