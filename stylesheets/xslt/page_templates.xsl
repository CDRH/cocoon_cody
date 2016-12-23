<?xml version="1.0"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    exclude-result-prefixes="dc rdf"
    version="2.0">
    
    <xsl:template name="mainContent">
        
        <!-- variables, for testing. -->
        <!--<ul>
            <li>pagetype: <xsl:value-of select="$pagetype"/></li>
            <li>subCategory: <xsl:value-of select="$subCategory"/></li>
            <li>searchtype: <xsl:value-of select="$searchtype"/></li>
            <li>pageid: <xsl:value-of select="$pageid"/></li>
            <li>sort: <xsl:value-of select="$sort"/></li>
            <li>imageno: <xsl:value-of select="$imageno"/></li>
            <li>start: <xsl:value-of select="$start"/></li>
            <li>rows: <xsl:value-of select="$rows"/></li>
            <li>q: <xsl:value-of select="$q"/></li>
            <li>fq: <xsl:value-of select="$fq"/></li>

        </ul>-->

        
        <!-- =====================================================================================
        Main // About // Search // Support // Ephemera // Scholarship // Community // Events // Links 
        // Sharing // Staff // Topics
        ===================================================================================== -->
        <xsl:if test="$pagetype = 'home' or 
            $pagetype = 'about' or 
            $pagetype = 'support' or 
            $pagetype = 'search' or 
            $pagetype = 'ephemera' or 
            $pagetype = 'scholarship' or 
            $pagetype = 'community' or 
            $pagetype = 'events' or 
            $pagetype = 'links' or 
            $pagetype = 'sharing' or 
            $pagetype = 'staff' or 
            $pagetype = 'topics'">
            <xsl:apply-templates select="//text"/>
        </xsl:if>   
        
        <!-- =====================================================================================
         Texts // Multimedia // Memorabilia
        ===================================================================================== -->
        <xsl:if test="$pagetype = 'texts' or
            $pagetype = 'multimedia' or 
            $pagetype = 'memorabilia'">
            <xsl:call-template name="metadataTop"/>
            <xsl:apply-templates select="//text"/>
            <xsl:call-template name="metadataBottom"/>
        </xsl:if>
        
        <!-- =====================================================================================
        Images Page
        ===================================================================================== -->
        <xsl:if test="$pagetype = 'images'">
            <xsl:for-each select="/" xpath-default-namespace="">
            <xsl:copy-of select="document('../../xml/wfc.000.images.xml')/TEI/text/body/div1"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0"/>
        </xsl:for-each>
        </xsl:if>
        
        <!-- =====================================================================================
        imagesGallery Page
        ===================================================================================== -->
        
        <xsl:if test="$pagetype = 'imagesGallery'">
            
            <xsl:variable name="solrsearchurl">
                <xsl:call-template name="solrURL">
                    <xsl:with-param name="rowstart"><xsl:value-of select="$start"/></xsl:with-param>
                    <xsl:with-param name="rowend">12</xsl:with-param>
                    <xsl:with-param name="searchfields">id,titleMain,category,subCategory,itemCategory,date,imageID</xsl:with-param>
                    <xsl:with-param name="facet">false</xsl:with-param>
                    <xsl:with-param name="facetfield"><!--{!ex=dt}subtype--></xsl:with-param>
                    <xsl:with-param name="other">
                        <xsl:text>&amp;fq=category:Images</xsl:text>
                        
                        <xsl:text>&amp;fq=subCategory:&quot;</xsl:text>
                        <xsl:value-of select="replace(lower-case($subCategory), '_', '%20')"/>
                        <xsl:text>&quot;</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="q">*:*</xsl:with-param>
                    <xsl:with-param name="sort">dateSort</xsl:with-param><!-- assumed +asc, will need to add another variable if we want +desc -->
                    <xsl:with-param name="sortSecondary">titleMain</xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">
                <!-- Karin here is another one -->
                <xsl:variable name="numFound" select="//result/@numFound"/>


                <h2><xsl:call-template name="title_case"><xsl:with-param name="string" select="$subCategory"/></xsl:call-template></h2>
                
                <p class="searchResultText"><xsl:value-of select="$numFound"/> <xsl:text> item</xsl:text>
                    <xsl:if test="$numFound > 1"><xsl:text>s</xsl:text></xsl:if>
                    <!-- This choose adds the search phrase to the search results -->
                </p>
                
                <!-- For testing -KMD -->
                <!--<p><xsl:value-of select="$solrsearchurl"></xsl:value-of></p>-->
                
                <xsl:call-template name="paginationLinks">
                    <xsl:with-param name="baseLinkURL">
                        <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
                        <xsl:choose>
                            <xsl:when test="$subCategory='postcards'"><xsl:value-of select="concat($siteroot,'memorabilia/', $subCategory, '/index.html?')"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="concat($siteroot,'images/', $subCategory, '/index.html?')"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="numFound" select="$numFound"/>
                    <xsl:with-param name="start" select="$start"/>
                    <xsl:with-param name="rows" select="$rows"/>
                </xsl:call-template>
                
                <xsl:for-each select="//doc">
                    <div class="imageResult">

                        <a>
                            
                            <xsl:attribute name="href">
                                <xsl:value-of select="$siteroot"/>
                                <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
                                <xsl:choose>
                                    <xsl:when test="$subCategory = 'postcards'">
                                        <xsl:text>memorabilia/view/</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>images/view/</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="$subCategory"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="str[@name='id']"/>
                            </xsl:attribute>
                            <img>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$fileroot"/>
                                    <xsl:text>figures/250/</xsl:text>
                                    <xsl:value-of select="str[@name='id']"/>
                                    <xsl:text>.jpg</xsl:text>
                                </xsl:attribute>
                            </img>
                        </a>
                        
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$siteroot"/>
                                <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
                                <xsl:choose>
                                    <xsl:when test="$subCategory = 'postcards'">
                                        <xsl:text>memorabilia/view/</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>images/view/</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="$subCategory"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="str[@name='id']"/>
                            </xsl:attribute>
                            <h3>
                                <xsl:value-of select="str[@name='titleMain']"/><xsl:if test="str[@name='date'] != ''"> - <xsl:value-of select="str[@name='date']"/></xsl:if>
                            </h3>
                        </a>
                    </div>
                    
                </xsl:for-each>
                
                <xsl:call-template name="paginationLinks">
                    <xsl:with-param name="baseLinkURL">
                        <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
                        <xsl:choose>
                            <xsl:when test="$subCategory='postcards'"><xsl:value-of select="concat($siteroot,'memorabilia/', $subCategory, '/index.html?')"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="concat($siteroot,'images/', $subCategory, '/index.html?')"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="numFound" select="$numFound"/>
                    <xsl:with-param name="start" select="$start"/>
                    <xsl:with-param name="rows" select="$rows"/>
                </xsl:call-template>
                
                <input id="var_numFound" type="hidden" value="{$numFound}"/>
                <input id="var_start" type="hidden" value="{$start}"/>
                <input id="var_rows" type="hidden" value="{$rows}"/>
            </xsl:for-each> 
        </xsl:if>
    
        
        <!-- =====================================================================================
        imagesView Page
        ===================================================================================== -->
        <xsl:if test="$pagetype = 'imagesView'">

            <xsl:for-each select="/" xpath-default-namespace="">
                <xsl:for-each select="//rdf:Description[dc:identifier=$imageno]">
                <h2>Image: <xsl:value-of select="dc:title"/></h2>
                
                <!-- Not currently live -->
                <!-- <div class="pagination">&#160;</div> -->
                
                <img>
                    <xsl:attribute name="src">
                        <xsl:value-of select="$fileroot"/>
                        <xsl:text>figures/800/</xsl:text>
                        <xsl:value-of select="$imageno"/>
                        <xsl:text>.jpg</xsl:text>
                    </xsl:attribute>
                </img>
                <div class="bibliography">
                    <xsl:if test="dc:title[.!='']">
                        <p> Title: <xsl:value-of select="dc:title"/>
                        </p>
                    </xsl:if>
                    
                    <xsl:if test="dc:creator[.!='']">
                        <p> Creator: 
                            <span class="subjectLink">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$siteroot"/>
                                        <xsl:text>search/people.html?q=author:"</xsl:text>
                                        <xsl:value-of select="encode-for-uri(dc:creator)"/>
                                        <xsl:text>"</xsl:text>
                                    </xsl:attribute>
                                    <xsl:value-of select="dc:creator"/>
                                </a>
                            </span>
                        </p>
                    </xsl:if>
                    
                    <xsl:if test="dc:subject[.!='']">
                        <p>
                            <xsl:text>Keyword</xsl:text>
                            <xsl:if test="count(dc:subject) &gt;= 2">
                                <xsl:text>s</xsl:text>
                            </xsl:if>
                            <xsl:text>: </xsl:text>
                            
                            <xsl:for-each select="dc:subject">
                                <xsl:if test=". != ''">
                                    <span class="subjectLink">
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$siteroot"/>
                                                <xsl:text>search/result.html?q=keywords:"</xsl:text>
                                                <xsl:value-of select="."/>
                                                <xsl:text>"</xsl:text>
                                            </xsl:attribute>
                                            <xsl:value-of select="."/>
                                        </a>
                                    </span>
                                </xsl:if>
                            </xsl:for-each>
                        </p>
                    </xsl:if>
                    <xsl:if test="dc:description[.!='']">
                        <p> Description: <xsl:value-of select="dc:description"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="dc:publisher[.!='']">
                        <p> Publisher: <xsl:value-of select="dc:publisher"/>
                        </p>
                    </xsl:if>
                    
                    <xsl:if test="dc:contributor[.!='']">
                        <p> Contributor: <xsl:value-of select="dc:contributor"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="dc:date[.!='']">
                        <p> Date: <xsl:value-of select="dc:date"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="dc:type[1][.!='']">
                        <p> Type: <xsl:value-of select="dc:type[1]"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="dc:format[1][.!='']">
                        <p> Format: <xsl:value-of select="dc:format[1]"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="dc:identifier[1][.!='']">
                        <p> ID: <xsl:value-of select="dc:identifier[1]"/>
                        </p>
                    </xsl:if>
                    <!-- old rule was dc:relation[1][.!=''] but some things do not start with multimedia. Should ask Laura about this -->
                    <xsl:if test="dc:relation[1][starts-with(.,'multimedia')]">
                        <p> <xsl:text>Commentary: Audio commentary available. (</xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$siteroot"/>
                                    <xsl:value-of select="dc:relation[1][starts-with(.,'multimedia')]"/>
                                    <xsl:text>.html</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <!--<xsl:value-of select="substring-after(dc:relation[1],'/')"/>-->
                                <xsl:text>Open commentary in new window</xsl:text>
                            </a><xsl:text>)</xsl:text>
                        </p>
                        
                        <!-- a way to include the audio inline. May need to be disabled if it is too server intensive -->
                        <!--<p><xsl:for-each select="document('../../xml/wfc.aud.69.236.13.xml')">
                            <xsl:copy-of select="//tei:div1"/>
                        </xsl:for-each></p>-->
                        
                    </xsl:if>
  
                    <xsl:if test="dc:source[.!='']">
                        <p> Source: <xsl:choose>
                            <xsl:when test="dc:rights">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="dc:rights"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="dc:source"/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="dc:source"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        </p>
                    </xsl:if>
                    
                </div>
                    
                   
                
            </xsl:for-each>
            </xsl:for-each>

        </xsl:if>
        
        <!-- =====================================================================================
        Life Page
        ===================================================================================== -->
        <xsl:if test="$pagetype = 'life'">
            <xsl:choose>
                <xsl:when test="$subCategory = 'Personography'">
                    
                    <h2>Personography</h2>
                    
                    <ul class="life_item">
                        <xsl:for-each select="//person">
                            <xsl:sort select="@xml:id"/>
                            <li>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="title">
                                        <xsl:value-of select="persName[@type='display']"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="persName[@type='display']"/>
                                </a>
                            </li>
                            
                        </xsl:for-each>
                    </ul>
                    
                    <xsl:for-each select="//person">
                        <xsl:sort select="@xml:id"/>
                        <div>
                            <xsl:attribute name="class">
                                <xsl:text>life_item</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                            <h3>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$siteroot"/>
                                        <!-- Got rid of the people specific search for now, until we have more of the people fields filled out -->
                                        <!--<xsl:text>search/people.html?q=people:"</xsl:text>-->
                                        <xsl:text>search/people.html?q=</xsl:text>
                                        <xsl:value-of select="encode-for-uri(persName[@type='display'])"/>
                                        <!--<xsl:text>"</xsl:text>--><!-- Needed for people result -->
                                        <xsl:text>&amp;fq=-subCategory:"Personography"</xsl:text> <!-- To exclude link back to personography, won't be needed when limited to people: -->
                                    </xsl:attribute>
                                    <xsl:value-of select="persName[@type='display']"/>
                                </a>  
                            </h3>
                            <p><xsl:apply-templates select="note"/></p>
                        </div>
                    </xsl:for-each>
                    
                </xsl:when>
                <xsl:when test="$subCategory = 'Encyclopedia'">
                    <h2>Encyclopedia</h2>
                    
                    <ul class="life_item">
                        <xsl:for-each select="//div2">
                            <xsl:sort select="@xml:id"/>
                            <li>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="head"/>
                                </a>
                            </li>
                            
                        </xsl:for-each>
                    </ul>
                    
                    <xsl:for-each select="//div2">
                        <xsl:sort select="@xml:id"/>
                        <div class="life_item">
                            <h3>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$siteroot"/>
                                    <xsl:text>search/encyc.html?q=</xsl:text>
                                    <xsl:value-of select="encode-for-uri(head)"/>
                                    <xsl:text>&amp;fq=-subCategory:"Encyclopedia"</xsl:text> <!-- To exclude link back to encyclopedia, won't be needed when limited -->
                                </xsl:attribute>
                                <xsl:value-of select="head"/>
                                </a>
                            </h3>
                            
                            <p><xsl:apply-templates select="p"/></p>
                        </div>
                    </xsl:for-each> 
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="//text"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <!-- =====================================================================================
        SearchResults and category listing
        Controls Texts, Topics, Scholarship, Multimedia, Memorabilia
        ===================================================================================== -->
        <xsl:if test="$pagetype = 'category' or $pagetype = 'searchresults'">
            

            
            <xsl:variable name="solrQuery">
                <xsl:choose>
                    <!-- not sure if this is used anymore, q defaults to blank now -kmd -->
                    <xsl:when test="$q = 'unset'">
                        <xsl:text>subCategory:"</xsl:text>
                        <xsl:value-of select="concat(upper-case(substring($subCategory, 1, 1)), substring($subCategory, 2))"/>
                        <xsl:text>"</xsl:text>
                    </xsl:when>
                    <xsl:when test="$searchtype = 'people'">
                        <xsl:text>(people:"</xsl:text>
                        <xsl:value-of select="$q"/>
                        <xsl:text>")</xsl:text>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="$q"/></xsl:otherwise>
                </xsl:choose>
                
            </xsl:variable>
            
            <xsl:variable name="solrsearchurl">
                <xsl:call-template name="solrURL">
                    <xsl:with-param name="rowstart"><xsl:value-of select="$start"/></xsl:with-param>
                    <xsl:with-param name="rowend"><xsl:value-of select="$rows"/></xsl:with-param>
                    <xsl:with-param name="searchfields">id,titleMain,category,subCategory,itemCategory,date,imageID,dateSort</xsl:with-param>
                    <xsl:with-param name="facet">false</xsl:with-param>
                    <xsl:with-param name="facetfield"><!--{!ex=dt}subtype--></xsl:with-param>
                    <xsl:with-param name="other">
                        <xsl:if test="$pagetype = 'searchresults' and $searchtype = 'unset'"><!-- Only need to include hits for search results -->
                            <xsl:text>&amp;hl=on</xsl:text>
                            <xsl:text>&amp;hl.fl=text</xsl:text>
                            <xsl:text>&amp;hl.usePhraseHighlighter=true</xsl:text>
                            <xsl:text>&amp;hl.highlighMultiTerm=true</xsl:text>
                            <xsl:text>&amp;hl.snippets=4</xsl:text>
                        </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="q"><xsl:value-of select="$solrQuery"/></xsl:with-param>
                    <xsl:with-param name="sort">
                        <xsl:choose>
                            <xsl:when test="$sort = 'date' or $pagetype = 'category'"><xsl:text>dateSort</xsl:text></xsl:when>
                            <xsl:when test="$sort = 'unset' or $sort = 'relevance'"></xsl:when> <!-- Leave blank for relevance -->
                            <xsl:when test="$sort = 'title'"><xsl:text>titleMain</xsl:text></xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                        </xsl:with-param>
                    <xsl:with-param name="sortDirection"> <!-- Currently only being used to reverse sort the scholarship/papers section -->
                        <xsl:choose>
                            <xsl:when test="substring-before(substring-after($q, '&quot;'), '&quot;') = 'Papers'"><xsl:text>desc</xsl:text></xsl:when>
                            <xsl:otherwise><xsl:text>asc</xsl:text></xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="sortSecondary">
                        <xsl:text>titleMain</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <!-- Search url, for testing -->
            <!--<xsl:value-of select="$solrsearchurl"></xsl:value-of>-->
            
            
            <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">
                
                <xsl:variable name="searchTerm" select="substring(//str[@name='q'],2,string-length(//str[@name='q'])-2)"/>
		<!-- Karin, numFound is being compared below to a number, possibly this needs to be made into an integer or number here? -->
                <xsl:variable name="numFound" select="//result/@numFound"/>
                
                <!-- This choose adds the subcategory name to non searchresults -->
                <xsl:choose>
                    <xsl:when test="$pagetype = 'category'">
                        <h2><xsl:value-of select="substring-before(substring-after($q, '&quot;'), '&quot;')"/></h2>
                    </xsl:when>
                    <xsl:otherwise>
                        <h2>Search Results</h2>
                    </xsl:otherwise>
                </xsl:choose>
                
                <p class="searchResultText"><xsl:value-of select="$numFound"/> <xsl:text> item</xsl:text>
			<!-- Karin, this is one of the spots I have found where this happens -->
                    <xsl:if test="$numFound > 1"><xsl:text>s</xsl:text></xsl:if>
                    
                    <!-- This choose adds the search phrase to the search results -->
                    <xsl:choose>
                        <xsl:when test="$pagetype = 'category'">
                            <!-- nothing -->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> found for search term </xsl:text> <strong><xsl:value-of select="$q"/></strong>
                        </xsl:otherwise>
                    </xsl:choose>
                    </p>
                
                <!-- Sorting options, only on search pages -->
                <xsl:choose>
                    <xsl:when test="not(starts-with($q, 'subCategory')) and not(starts-with($q, 'topic'))"><!-- May be a better way to do this, stops sort from showing up on all but search pages -->
                        <p class="searchSort">
                            <xsl:text>Sort by: </xsl:text>
                            <xsl:choose>
                                <xsl:when test="$sort = 'unset' or $sort = 'relevance'">Relevance</xsl:when>
                                <xsl:otherwise>
                                    <a href="{$siteroot}search/result.html?q={$q}&amp;sort=relevance">Relevance</a>
                                </xsl:otherwise>
                            </xsl:choose> | 
                            <xsl:choose>
                                <xsl:when test="$sort = 'date'">Date</xsl:when>
                                <xsl:otherwise>
                                    <a href="{$siteroot}search/result.html?q={$q}&amp;sort=date">Date</a>
                                </xsl:otherwise>
                            </xsl:choose> | 
                            <xsl:choose>
                                <xsl:when test="$sort = 'title'">Title</xsl:when>
                                <xsl:otherwise>
                                    <a href="{$siteroot}search/result.html?q={$q}&amp;sort=title">Title</a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </p> 
                    </xsl:when>
                    <xsl:otherwise></xsl:otherwise>
                </xsl:choose>
                
                
                <!-- I don't think this is needed now that the URL's are being handled by the XSL -KD-->
                <!--<input id="var_numFound" type="hidden" value="{$numFound}"/>
                <input id="var_start" type="hidden" value="{$start}"/>
                <input id="var_rows" type="hidden" value="{$rows}"/>-->
                
                <xsl:call-template name="paginationLinks">
                    <!--<xsl:with-param name="baseLinkURL" select="concat($siteroot, 'category/result.html?')">-->
                    <xsl:with-param name="baseLinkURL">
                            <xsl:value-of select="$siteroot"/>
                        <!-- Added a choose to determine between category search results and regular search results. -->
                        <xsl:choose>
                            <xsl:when test="$pagetype = 'category'"><xsl:text>category</xsl:text></xsl:when>
                            <xsl:otherwise><xsl:text>search</xsl:text></xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>/result.html?</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="searchTerm" select="$searchTerm"/>
                    <xsl:with-param name="numFound" select="$numFound"/>
                    <xsl:with-param name="start" select="$start"/>
                    <xsl:with-param name="rows" select="$rows"/>
                    <xsl:with-param name="sort" select="$sort"/>
                </xsl:call-template>
                    
                <xsl:for-each select="//doc">
                    <xsl:variable name="id" select="str[@name='id']"/>
                    <xsl:variable name="titleMain" select="str[@name='titleMain']"/>
                    <xsl:variable name="date" select="str[@name='date']"/>
                    <xsl:variable name="category" select="str[@name='category']"/>
                    <xsl:variable name="subCategory" select="str[@name='subCategory']"/>
                    <xsl:variable name="imageID" select="str[@name='imageID']"/>
                    
                    <xsl:variable name="resultURL">
                        <xsl:choose>
                            <xsl:when test="$category = 'Images'">
                                <xsl:value-of select="$siteroot"/>
                                <xsl:text>images/view/</xsl:text>
                                <xsl:value-of select="$subCategory"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="$imageID"/>
                            </xsl:when>
                            <!-- Personography results need a different link structure -->
                            <xsl:when test="$subCategory = 'Personography'">
                                <xsl:value-of select="$siteroot"/>
                                <xsl:text>life/wfc.person.html#</xsl:text>
                                <xsl:value-of select="$id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$siteroot"/>
                                <xsl:value-of select="lower-case($category)"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="$id"/>
                                <xsl:text>.html</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:variable>
                    
                    <div class="searchResult">
                        <xsl:call-template name="searchImageLink">
                            <xsl:with-param name="imageID" select="$imageID"/>
                            <xsl:with-param name="category" select="$category"/>
                            <xsl:with-param name="subCategory" select="$subCategory"/>
                            <xsl:with-param name="resultURL" select="$resultURL"/>
                        </xsl:call-template>
                        
                        <p class="meta">
                            <span class="date">
                                <xsl:value-of select="$date"/>
                            </span>
                            <span class="section">
                                <xsl:value-of select="$category"/>
                            </span>
                            <span class="subsection">
                                <xsl:value-of select="$subCategory"/>
                            </span>
                        </p>
                        <h3>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$resultURL"/>
                                </xsl:attribute>
                                <xsl:value-of select="$titleMain"/>
                            </a>
                        </h3>
                        <xsl:for-each select="//lst[@name='highlighting']/lst[@name=$id]/arr/str">
                            <p class="result">
                                <xsl:text>"...</xsl:text>
                                <xsl:call-template name="unescapeEm">
                                    <xsl:with-param name="val"><xsl:value-of select="."/></xsl:with-param>
                                </xsl:call-template>
                                <xsl:text>..."</xsl:text>
                            </p>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
                
                <xsl:call-template name="paginationLinks">
                    <!--<xsl:with-param name="baseLinkURL" select="concat($siteroot, 'category/result.html?')">-->
                    <xsl:with-param name="baseLinkURL">
                        <xsl:value-of select="$siteroot"/>
                        <!-- Added a choose to determine between category search results and regular search results. -->
                        <xsl:choose>
                            <xsl:when test="$pagetype = 'category'"><xsl:text>category</xsl:text></xsl:when>
                            <xsl:otherwise><xsl:text>search</xsl:text></xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>/result.html?</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="searchTerm" select="$searchTerm"/>
                    <xsl:with-param name="numFound" select="$numFound"/>
                    <xsl:with-param name="start" select="$start"/>
                    <xsl:with-param name="rows" select="$rows"/>
                    <xsl:with-param name="sort" select="$sort"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>   
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Pagination Code
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
    <xsl:template name="title_case">
        <xsl:param name="string"></xsl:param>
        
        <xsl:for-each select="tokenize(lower-case(replace($string, '_', ' ')), ' ')">
            <xsl:value-of select="concat(upper-case(substring(., 1, 1)), substring(., 2))"/>
            <xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
        </xsl:for-each>
        
    </xsl:template>
     
  
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Pagination Code
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

  <xsl:template name="paginationLinks">
    <xsl:param name="baseLinkURL"/>
    <xsl:param name="searchTerm"/>
    <xsl:param name="numFound"/>
    <xsl:param name="start"/> <!-- defaults to 0, unless changed in cocoon sitemap -->
    <xsl:param name="rows"/> <!-- defaults to 10, unless changed in cocoon sitemap -->
    <xsl:param name="sort"/>

    <xsl:variable name="prev-link">
      <xsl:choose>
        <xsl:when test="$start &lt;= 0">
          <xsl:text>Previous</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$baseLinkURL"/>
              <xsl:if test="$q">
                <xsl:text>q=</xsl:text>
                <xsl:value-of select="$q"/>
                <xsl:text>&#38;</xsl:text>
              </xsl:if>
              <xsl:text>start=</xsl:text>
              <xsl:value-of select="$start - $rows"/>
              <xsl:text>&#38;rows=</xsl:text>
              <xsl:value-of select="$rows"/>
                <xsl:if test="$sort != 'unset'">
                    <xsl:text>&amp;sort=</xsl:text>
                    <xsl:value-of select="$sort"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:text>Previous</xsl:text>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="next-link">
      <xsl:choose>
        <xsl:when test="$start + $rows &gt;= $numFound">
          <xsl:text>Next</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$baseLinkURL"/>
              <xsl:if test="$q">
                <xsl:text>q=</xsl:text>
                <xsl:value-of select="$q"/>
                <xsl:text>&#38;</xsl:text>
              </xsl:if>
              <xsl:text>start=</xsl:text>
              <xsl:value-of select="$start + $rows"/>
              <xsl:text>&#38;rows=</xsl:text>
              <xsl:value-of select="$rows"/>
                <xsl:if test="$sort != 'unset'">
                    <xsl:text>&amp;sort=</xsl:text>
                    <xsl:value-of select="$sort"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:text>Next</xsl:text>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Pagination HTML -->
    <div class="pagination"><xsl:copy-of select="$prev-link"/> | Go to page <form class="jumpForm">
        <input type="text" name="paginationJump" value="{$start div $rows + 1}"
          class="paginationJump"/>
        <input type="submit" value="Go" class="paginationJumpBtn submit"/>
      </form> of <xsl:value-of select="ceiling($numFound div $rows)"/> | <xsl:copy-of
        select="$next-link"/>
    </div><div class="paginationline">&#160;</div>
    <!-- /end Pagination HTML -->
  </xsl:template>

    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        searchImageLink Code
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
  <xsl:template name="searchImageLink">
    <xsl:param name="imageID"/>
    <xsl:param name="category"/>
    <xsl:param name="subCategory"/>
    <xsl:param name="resultURL"/>

    <xsl:choose>

      <!-- when icon-$subCategory appears for the imageID, we need to use a slightly modified URL -->
      <!-- this would occur when there is no suitable image of the object, or the image is of low quality, etc. -->
      <xsl:when test="contains($imageID, 'icon-')">
        <div class="image">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$resultURL"/>
            </xsl:attribute>
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$fileroot" />
                <xsl:text>images/</xsl:text>
                <xsl:value-of select="$imageID"/>
                <xsl:text>.jpg</xsl:text>
              </xsl:attribute>
            </img>
          </a>
        </div>
      </xsl:when>

      <!-- when a proper imageID exists in the results -->
      <xsl:otherwise>
        <div class="image">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$resultURL"/>
            </xsl:attribute>
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$fileroot" />
                <xsl:text>figures/searchresults/</xsl:text>
                <xsl:value-of select="$imageID"/>
                <xsl:text>.jpg</xsl:text>
              </xsl:attribute>
            </img>
          </a>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Metadata Code
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --> 
    <xsl:template name="metadataTop">
        <xsl:if test="$pageid = 'unset'"><!-- nothing --></xsl:if>
        <xsl:if test="$pageid != 'unset'">
            <div class="bibliography" id="topBibl">
                <xsl:choose>
                    <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='m'][1])">
                        <p> Title: <xsl:value-of
                            select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='m']" separator=" | "/>
                        </p>
                    </xsl:when>
                    <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='a'][1])">
                        <p> Title: <xsl:value-of
                            select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='a']" separator=" | "/>
                        </p>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j'][1])">
                    <p> Periodical: <xsl:value-of
                        select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j']" separator=" | "/>
                    </p>
                </xsl:if>
                
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/date[1])">
                    <p> Date: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date"/>
                    </p>
                </xsl:if>
                
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/author[1])">
                    <p>Author: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/author">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                    </p>
                </xsl:if>
                
                <span class="morelink">
                    <a href="#bottomBibl">More metadata</a>
                </span>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="metadataBottom">
        <xsl:if test="$pageid = 'unset'"><!-- nothing --></xsl:if>
        <xsl:if test="$pageid != 'unset'">
            
            <div class="bibliography" id="bottomBibl">
                <!-- Title rules -->
                <xsl:choose>
                    <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='m'][1])">
                        <p> Title: <xsl:value-of
                            select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='m']" separator=" | "/>
                        </p>
                    </xsl:when>
                    <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='a'][1])">
                        <p> Title: <xsl:value-of
                            select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='a']" separator=" | "/>
                        </p>
                    </xsl:when>
                </xsl:choose>
                
                <!-- Journal/Periodical rules -->
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j'][1])">
                    <p> Periodical: <xsl:value-of
                        select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j']" separator=" | "/>
                    </p>
                </xsl:if>
                
                <!-- Publisher riles -->
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher[1])">
                    <p>Publisher: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher">
                        <xsl:value-of select="."/><xsl:text> </xsl:text>
                    </xsl:for-each>
                    </p>
                </xsl:if>
                
                <!-- Repository rules -->
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository[1])">
                    <p>Source: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository">
                        <xsl:value-of select="."/>
                        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/idno)">
                            <xsl:text>, </xsl:text>
                            <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/idno">
                                <xsl:value-of select="."/>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                    </p>
                </xsl:if>
                
                
                <!-- Date -->
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/date)">
                    <p> Date: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date"/></p>
                </xsl:if>
                
                <!-- Author -->
                <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/author[1])">
                    <p>Author: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/author">
                        <span class="subjectLink">
                            <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$siteroot"/>
                                <xsl:text>search/people.html?q=author:"</xsl:text>
                                <!-- This code is to choose the @n value for the name if there is one -->
                                <xsl:choose>
                                    <xsl:when test="@n and @n != ''">
                                        <xsl:value-of select="encode-for-uri(@n)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="encode-for-uri(.)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>"</xsl:text>
                            </xsl:attribute>
                                <!-- This code is to choose the @n value for the name if there is one -->
                                <xsl:choose>
                                    <xsl:when test="@n and @n != ''">
                                        <xsl:value-of select="@n"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </a>    
                        </span>
                    </xsl:for-each>
                    </p>
                </xsl:if>
                

                <!-- Related and Identical Documents -->
				<xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/relatedItem">
					<p> Also appeared as:
						<p>&#160;&#160;Title: 
							<xsl:if test="bibl/title[@type='main']/text()">
								<xsl:value-of select="bibl/title[@type='main']"/>
								<xsl:text> | </xsl:text>
							</xsl:if>
							<xsl:if test="bibl/title[@type='sub']/text()">
								<xsl:value-of select="bibl/title[@type='sub']"/>
							</xsl:if>
						</p>
						<xsl:if test="bibl/title[@level='j']/text()">
							<p>&#160;&#160;Periodical:
								<xsl:value-of select="bibl/title[@level='j']"/>
							</p>
						</xsl:if>
						<xsl:if test="bibl/date/text()">
							<p>&#160;&#160;Date:
								<xsl:value-of select="bibl/date"/>
							</p>
						</xsl:if>
					</p>
				</xsl:for-each>


                <!-- Topics -->
                <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n='topic']/term[1])">
                    <p>
                        <xsl:text>Topic</xsl:text>
                        <xsl:if
                            test="count(/TEI/teiHeader/profileDesc/textClass/keywords[@n='topic']/term) &gt;= 2">
                            <xsl:text>s</xsl:text>
                        </xsl:if>
                        <xsl:text>:</xsl:text>
                        
                        
                        <xsl:for-each select="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n='topic']/term[1])">
                            <xsl:if test="string(.)">
                                <span class="subjectLink">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$siteroot"/>
                                            <xsl:text>search/result.html?q=topic:"</xsl:text>
                                            <xsl:value-of select="."/>
                                            <xsl:text>"</xsl:text>
                                        </xsl:attribute>
                                        <xsl:value-of select="."/>
                                    </a>
                                </span>
                            </xsl:if>
                        </xsl:for-each>
                        
                    </p>
                </xsl:if>
                
                <!-- Keywords -->
                <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n='keywords']/term[1])">
                    <p>
                        <xsl:text>Keyword</xsl:text>
                        <xsl:if
                            test="count(/TEI/teiHeader/profileDesc/textClass/keywords[@n='keywords']/term) &gt;= 2">
                            <xsl:text>s</xsl:text>
                        </xsl:if>
                        <xsl:text>:</xsl:text>
                        
                        <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='keywords']/term">
                            <xsl:if test="string(.)">
                                <span class="subjectLink">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$siteroot"/>
                                            <xsl:text>search/result.html?q=keywords:"</xsl:text>
                                            <xsl:value-of select="."/>
                                            <xsl:text>"</xsl:text>
                                        </xsl:attribute>
                                        
                                        <xsl:value-of select="."/>
                                    </a>
                                </span>
                            </xsl:if>
                        </xsl:for-each>
                    </p>
                </xsl:if>
                
                <!-- People -->
                <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term[1])">
                    <p>
                        <xsl:text>People: </xsl:text>
                        
                        <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term">
                            <xsl:if test="string(.)">
                                <span class="subjectLink">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$siteroot"/>
                                            <xsl:text>search/result.html?q=people:"</xsl:text>
                                            <xsl:value-of select="."/>
                                            <xsl:text>"</xsl:text>
                                        </xsl:attribute>
                                        
                                        <xsl:value-of select="."/>
                                    </a>
                                </span>
                            </xsl:if>
                        </xsl:for-each>
                    </p>
                </xsl:if>
                
                <!-- Places -->
                <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n='places']/term[1])">
                    <p>
                        <xsl:text>Place</xsl:text>
                        <xsl:if
                            test="count(/TEI/teiHeader/profileDesc/textClass/keywords[@n='places']/term) &gt;= 2">
                            <xsl:text>s</xsl:text>
                        </xsl:if>
                        <xsl:text>: </xsl:text>
                        
                        <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='places']/term">
                            <xsl:if test="string(.)">
                                <xsl:if test=". != ''">
                                    <xsl:variable name="place"><xsl:value-of select="." /></xsl:variable>
                                    <span class="subjectLink">
                                        <a href="{$siteroot}search/result.html?q=places:&quot;{$place}&quot;">
                                            <xsl:value-of select="."/>
                                            <xsl:text> </xsl:text>
                                        </a>
                                    </span>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </p>
                </xsl:if>
                
                <!-- resp Statements -->
                <xsl:if test="//respStmt">
                   
                    <xsl:for-each select="//respStmt">
                        <p>
                        <xsl:value-of select="resp"/><xsl:text>: </xsl:text>
                        <xsl:value-of select="name" separator="; "></xsl:value-of>
                        </p>
                    </xsl:for-each>
                    
                </xsl:if>
                
                
                <!-- Sponsor rules -->
                <xsl:if test="string(/TEI/teiHeader/fileDesc/titleStmt/sponsor[1])">
                    <p>Sponsor: <xsl:for-each select="/TEI/teiHeader/fileDesc/titleStmt/sponsor">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                    </p>
                </xsl:if>


                <!-- Editorial statement and Conditions of use -->
                
                <p><a href="{$siteroot}about/#editorial_statement">Editorial Statement</a> | <a href="{$siteroot}about/#conditions">Conditions of Use</a></p>
                
                <p>TEI encoded XML: 
                    <a class="subjectLink">
                        <xsl:attribute name="href">
                            <xsl:text>wfc.</xsl:text>
                            <xsl:value-of select="$pageid"/>
                            <xsl:text>.xml</xsl:text>
                        </xsl:attribute> View <xsl:text>wfc.</xsl:text><xsl:value-of select="$pageid"/>
                        <xsl:text>.xml</xsl:text>
                    </a></p>
                
                <span class="morelink">
                    <a href="#topBibl">Back to top</a>
                </span>
            </div>
            
            
            
        </xsl:if>
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        SOLR Code
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->    
<xsl:template name="solrURL">
        <!-- Any site wide defaults should be set here. Any blanks will go to solr defaults -->
        <xsl:param name="rowstart">0</xsl:param>
        <xsl:param name="rowend">20</xsl:param>
        <xsl:param name="searchfields">id,title</xsl:param>
        <xsl:param name="facet"></xsl:param>
        <xsl:param name="facetfield"></xsl:param>
        <xsl:param name="other"></xsl:param>
        <xsl:param name="q"></xsl:param>
        <xsl:param name="sort"></xsl:param>
        <xsl:param name="sortDirection">asc</xsl:param> <!-- Ascending as usual by default -->
        <xsl:param name="sortSecondary"></xsl:param>
        
        <xsl:value-of select="$searchroot"/>
        
        <!-- Add sort if not set to default -->
        <xsl:choose>
            <xsl:when test="$sort = ''">
                <!-- do nothing to leave as default sort -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sort"/>
                <xsl:text>+</xsl:text>
                <xsl:value-of select="$sortDirection"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- Add secondary sort if necessary -->
        <xsl:choose>
            <xsl:when test="$sortSecondary = ''">
                <!-- do nothing to leave as default sort -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="$sortSecondary"/>
                <xsl:text>+asc</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- tag filters that directly constrain doctype http://wiki.apache.org/solr/SimpleFacetParameters 
             This variable is set globally, and passed through a URL
             need to research this more, not sure what project I used it for or what I was accomplishing
             Oh, might have used it for CWW keywords -Karin -->
        <!--<xsl:choose>
            <xsl:when test="$searchtype = 'all' or $searchtype = '' or $searchtype = 'keyword'">
                <!-\- do nothing to leave as default display -\->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;fq={!tag=dt}subtype:</xsl:text>
                <xsl:value-of select="$searchtype"/>
            </xsl:otherwise>
        </xsl:choose>-->
        
        <!-- Start and rows -->
        <xsl:if test="$rowstart != ''">
            <xsl:text>&amp;start=</xsl:text>
            <xsl:value-of select="$rowstart"/>
        </xsl:if>
        <xsl:if test="$rowend != ''">
            <xsl:text>&amp;rows=</xsl:text>
            <xsl:value-of select="$rowend"/>
        </xsl:if>
        
        <!-- Which fields to return -->
        <xsl:if test="$searchfields != ''">
            <xsl:text>&amp;fl=</xsl:text>
            <xsl:value-of select="$searchfields"/>
        </xsl:if>
    
    <!-- Which fields to return -->
    <xsl:if test="$fq != '' and $fq != 'unset'">
        <xsl:text>&amp;fq=</xsl:text>
        <xsl:value-of select="$fq"/>
    </xsl:if>
        
        <!-- faceting options -->
        <xsl:if test="$facet = 'true'">
            <xsl:text>&amp;facet=</xsl:text>
            <xsl:value-of select="$facet"/>
            <xsl:text>&amp;facet.field=</xsl:text>
            <xsl:value-of select="$facetfield"/>
        </xsl:if>
        
        <!-- anything else, passed through the "other" variable -->
        <xsl:if test="$other != ''">
            <xsl:value-of select="$other"/>
        </xsl:if>
        
        <!-- query -->
        <xsl:choose>
            <xsl:when test="$q = ''">
                <xsl:text>&amp;q=%28*:*%29</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;q=%28</xsl:text>
                <xsl:value-of select="encode-for-uri($q)"/>
                <xsl:text>%29</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template> 
    
    
    <xsl:template name="unescapeEm"> 
        <xsl:param name="val" select="''"/> 
        <xsl:variable name="preEm" select="substring-before($val, '&lt;')"/> 
        <xsl:choose> 
            <xsl:when test="$preEm or starts-with($val, '&lt;')"> 
                <xsl:variable name="insideEm" select="substring-before($val, 
                    '&lt;/')"/> 
                <xsl:value-of select="$preEm"/><em><xsl:value-of 
                    select="substring($insideEm, string-length($preEm)+5)"/></em> 
                <xsl:variable name="leftover" select="substring($val, 
                    string-length($insideEm) + 6)"/> 
                <xsl:if test="$leftover"> 
                    <xsl:call-template name="unescapeEm"> 
                        <xsl:with-param name="val" select="$leftover"/> 
                    </xsl:call-template> 
                </xsl:if> 
            </xsl:when> 
            <xsl:otherwise> 
                <xsl:value-of select="$val"/> 
            </xsl:otherwise> 
        </xsl:choose> 
    </xsl:template>  
    
    
    
    
    
    
</xsl:stylesheet>
