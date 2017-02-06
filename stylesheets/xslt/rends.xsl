<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs dc rdf">

    <xsl:output method="html" indent="yes" encoding="UTF-8" />

    <xsl:param name="pagetype">unset</xsl:param>

    <xsl:template match="/" xpath-default-namespace="">

        <html>
            <body>
                <p>Note that there is currently an upper limit of 10,000 documents to show. If there are more than 10,000 results, some documents will not properly show.</p>
                <p><xsl:value-of select="//result[@name='response']/@numFound" /> results were found.</p>

                <div class="rends">

                    <xsl:if test="$pagetype = 'rends'">
                        <xsl:call-template name="rends"/>
                    </xsl:if>

                    <xsl:if test="$pagetype = 'unset'">
                        <xsl:call-template name="rend_fields" />
                    </xsl:if>

                </div>

            </body>
        </html>
    </xsl:template>

    <xsl:template match="div1[@type='html']">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="str[@name='id']">
        <li><!--xsl:value-of select="." /--></li>
    </xsl:template>

    <xsl:template name="rends">
        <xsl:apply-templates select="//text"/>
    </xsl:template>

    <xsl:template name="rend_fields" xpath-default-namespace="">
        <xsl:variable name="field"
            select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/@name"/>

        <p>Rends for: <strong>
                <xsl:value-of select="$field"/>
        </strong></p>

        <ul>

            <xsl:for-each
                select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/int">
                <xsl:variable name="fieldName" select="@name"/>
                <xsl:choose>
                    <xsl:when test="$fieldName = ''">
                        <li><strong>Blank ('')</strong>: <xsl:value-of select="."/></li>
                    </xsl:when>
                    <xsl:when test="not($fieldName)">
                        <li><strong>Missing</strong>: <xsl:value-of select="."/></li>
                    </xsl:when>
                    <xsl:otherwise>
                        <li><strong>
                                <xsl:value-of select="@name"/>
                        </strong>: <xsl:value-of select="."/></li>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each>
        </ul>

        <p>Annotated List</p>

        <ul>

            <xsl:for-each
                select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name=$field]/int">
                <xsl:if test=". != 0">

                    <xsl:variable name="fieldName" select="@name"/>

                    <xsl:choose>
                        <xsl:when test="$fieldName = '' or not($fieldName)">
                            <li><strong>Blank ('')</strong>: <xsl:value-of select="."/></li>
                        </xsl:when>
                        <xsl:otherwise>
                            <li><strong><xsl:value-of select='@name' /></strong>: <xsl:value-of select="." /></li>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <ul>
                        <xsl:choose>
                            <xsl:when test="/response/result[@name='response']/doc/arr[@name=$field]/str[.=$fieldName]">
                                <xsl:for-each select="/response/result[@name='response']/doc/arr[@name=$field]/str[.=$fieldName]">
                                    <li>
                                        <xsl:value-of select="current()/parent::node()/parent::node()/str[@name='id']" />
                                    </li>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>Blank ('')</li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </ul>
                </xsl:if>

            </xsl:for-each>

        </ul>

    </xsl:template>

</xsl:stylesheet>
