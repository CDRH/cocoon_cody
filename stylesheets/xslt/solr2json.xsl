<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output method="xhtml" indent="yes" encoding="UTF-8"/>

    <xsl:include href="config.xsl"/>

    <xsl:param name="category"/>

    <xsl:template match="/">

            <xsl:text>var </xsl:text>
            <xsl:value-of select="$category"/>
            <xsl:text> = [</xsl:text>
            <xsl:for-each select="/response/result/doc">
                
                <xsl:if test="./*/text()">
                    <xsl:if test="position() != 1">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    
                    <xsl:text>{</xsl:text>
                    <xsl:for-each select="./*">
                        <xsl:if test="position() != 1">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        
                        <xsl:text>"</xsl:text>
                        <xsl:value-of select='replace(@name,"""","\\""")'/>
                        <xsl:text>": "</xsl:text>
                        <xsl:value-of select="encode-for-uri(./text())"/>
                        <xsl:text>"</xsl:text>
                    </xsl:for-each>

                    <xsl:text>}</xsl:text>
                </xsl:if>

            </xsl:for-each>

            <xsl:text>];</xsl:text>
    </xsl:template>

</xsl:stylesheet>
