<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:output method="xhtml" indent="yes" encoding="iso-8859-1"/>
    
    <xsl:variable name="rows" select="//str[@name='rows']"/>
    <xsl:variable name="searchTerm" select="//str[@name='q']"/>
    <xsl:variable name="start" select="//str[@name='start']"/>
    <xsl:variable name="numFound" select="//result/@numFound"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
                <title>Early Recognized Treaties with American Indian Nations</title>
                <link rel="stylesheet" type="text/css" href="css/treaties.css"/>
            </head>
            
            <body>
                
                <div id="mainwrapper">
                    
                    <div id="secondwrapper">
                        
                        <div id="projecthead">
                            
                            <div class="mainmenu">
                                
                                <form action="search" method="get" style="margin-top: 0px;">
                                    <input size="20" type="text" name="q"
                                        value="Search these treaties" onfocus="this.select()"/>
                                    <input value="go" type="submit" style="padding: 0px; "/>
                                    <br/>
                                    <!-- edit -->
                                    <a href="searchHelp.html" class="help">Search Help</a>
                                </form>
                                
                            </div>
                            <img src="images/head.gif"/>
                            
                        </div>
                        
                        <div id="content">
                            
                            <xsl:choose>
                                <xsl:when test="contains($searchTerm, '*')">Search does not support wildcard functionality at this time. Please rerun your query without the asterisk (*). You may wish to consult the <a href="http://earlytreaties.unl.edu/searchHelp.html">search help</a> page as well. 
                                    <br/><br/>
                                If you continue to have problems with the search, please <a href="mailto:cdrh@unl.edu">contact us</a> and we will assist you. <br/><br/>
                                
                                Thank you for your patience!</xsl:when>
                                <xsl:otherwise>
                            
                            
                            
                            
                            <h2>Search Results</h2> Your search for <strong>
                                <xsl:value-of select="$searchTerm"/>
                            </strong> returned <strong>
                                <xsl:value-of select="$numFound"/>
                            </strong> results. <br/>
                            <br/><br/>
                            <xsl:for-each select="//doc">
                                
                                <xsl:sort select="str[@name='id']" order="ascending"/>
                                
                                <xsl:variable name="id" select="str[@name='id']"/>
                                
                                <ul>
                                    
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="str[@name='id']"/>
                                            <xsl:text>.html?q=</xsl:text>
                                            <xsl:value-of select="$searchTerm"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="arr[@name='text']/str[14]"/>
                                    </a>
                                    
                                    <br/>
                                    <xsl:for-each
                                        select="following::lst[@name='highlighting']/child::lst[@name=$id]//str">
                                        <xsl:analyze-string regex="[\s]" select="normalize-space(.)">
                                            <xsl:non-matching-substring>
                                                <xsl:choose>
                                                    <xsl:when test="contains(.,'&lt;em&gt;') and contains(.,'&lt;/em&gt;')">
                                                        <b>
                                                            <xsl:value-of select="replace(replace(.,'&lt;em&gt;',''),'&lt;/em&gt;','')"/>
                                                        </b>
                                                        <xsl:text> </xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="."/>
                                                        <xsl:text> </xsl:text>
                                                    </xsl:otherwise> 
                                                </xsl:choose>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <br/>
                                    </xsl:for-each>
                                </ul>
                                
                            </xsl:for-each>
                                
                                </xsl:otherwise>
                            </xsl:choose>
                            <br/>
                        </div>
                        <div id="footer"> University of Nebraska-Lincoln, <a
                            href="http://cdrh.unl.edu">Center for Digital Research in the
                            Humanities</a>
                            <br/>
                            <a href="http://www.unl.edu/">
                                <img src="unl.jpg"/>
                            </a>
                        </div>
                    </div>
                </div>
                <script type="text/javascript"><![CDATA[var gaJsHost = (("https:" == document.location.protocol)
               ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" +
               gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); </script>
            <script type="text/javascript"> try { var pageTracker =
               _gat._getTracker("UA-6940737-1"); pageTracker._trackPageview(); } catch(err)
            {}]]></script>
            </body>
        </html>
        
    </xsl:template>
    
</xsl:stylesheet>
