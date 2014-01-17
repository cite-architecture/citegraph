<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:cts="http://chs.harvard.edu/xmlns/cts3" xmlns:dc="http://purl.org/dc/elements/1.1" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="tei:unclear">
        <span class="tei_unclear">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="@reason='lost'"><xsl:attribute name="class">tei_supplied reason_lost</xsl:attribute></xsl:when>
                <xsl:otherwise><xsl:attribute name="class">tei_supplied unrecognized_reason</xsl:attribute></xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
