<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:output method="text" indent="yes" encoding="UTF-8"/>
    
    <xsl:param name="category">unset</xsl:param> <!-- for json files -->

    <xsl:include href="config.xsl"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="solrjsonurl">
            <xsl:value-of select="$searchroot"/>
            <!--http://jetson.unl.edu/solr/cody/select/?version=2.2&amp;indent=onpeople&amp;facet.missing=off&amp;facet=true&amp;facet.sort=lex&amp;facet.method=enum&amp;facet.mincount=1-->
            <xsl:text>&amp;q=(*:*)&amp;rows=0&amp;fl=id&amp;facet.field=</xsl:text>
            <xsl:value-of select="$category"/>
            <xsl:text>&amp;facet.missing=off&amp;facet=true&amp;facet.sort=lex&amp;facet.method=enum&amp;facet.mincount=1&amp;facet.limit=-1</xsl:text>
        </xsl:variable>
        
        
        <xsl:for-each select="document($solrjsonurl)" xpath-default-namespace="">
            
           <!-- <xsl:text>//</xsl:text><xsl:value-of select="$solrjsonurl"/>-->
            
        
        <xsl:variable name="field" select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/@name" />
        
        <xsl:value-of select="$field" />
        <xsl:text> = [</xsl:text>
        <xsl:for-each select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/int">
            <xsl:if test="not(@name = '')">
            
                <xsl:text>&quot;</xsl:text>
                <xsl:value-of select='replace(replace(@name,"""","\\"""), "&#301;", "i")' />
                <xsl:text>&quot;</xsl:text>
                <xsl:if test="not(position() = last())">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
