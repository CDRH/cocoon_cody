<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:vra="http://www.vraweb.org/vracore4.htm"
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
    <xsl:if
      test="
        $pagetype = 'home' or
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
      <xsl:apply-templates select="//text"></xsl:apply-templates>
    </xsl:if>

    <!-- =====================================================================================
         Texts // Multimedia // Memorabilia
        ===================================================================================== -->
    <xsl:if test="
        $pagetype = 'texts' or
        $pagetype = 'multimedia' or
        $pagetype = 'memorabilia'">
      <xsl:call-template name="metadataTop"></xsl:call-template>
      <xsl:apply-templates select="//text"></xsl:apply-templates>
      <xsl:call-template name="metadataBottom"></xsl:call-template>
    </xsl:if>

    <!-- =====================================================================================
        Images Page
        ===================================================================================== -->
    <xsl:if test="$pagetype = 'images'">
      <xsl:for-each select="/" xpath-default-namespace="">
        <xsl:copy-of select="document('../../structure/wfc.000.images.xml')/TEI/text/body/div1" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
        ></xsl:copy-of>
      </xsl:for-each>
    </xsl:if>

    <!-- =====================================================================================
        imagesGallery Page
        ===================================================================================== -->

    <xsl:if test="$pagetype = 'imagesGallery'">

      <xsl:variable name="solrsearchurl">
        <xsl:call-template name="solrURL">
          <xsl:with-param name="rowstart">
            <xsl:value-of select="$start"></xsl:value-of>
          </xsl:with-param>
          <xsl:with-param name="rowend">12</xsl:with-param>
          <xsl:with-param name="searchfields">id,title,category,subCategory,itemCategory_s,date,dateDisplay,dateSort_s,image_id</xsl:with-param>
          <xsl:with-param name="facet">false</xsl:with-param>
          <xsl:with-param name="facetfield"><!--{!ex=dt}subtype--></xsl:with-param>
          <xsl:with-param name="other">
            <xsl:text>&amp;fq=category:Images</xsl:text>

            <xsl:text>&amp;fq=subCategory:&quot;</xsl:text>
            <xsl:value-of select="lower-case($subCategory)"></xsl:value-of>
            <xsl:text>&quot;</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="q">*:*</xsl:with-param>
          <xsl:with-param name="sort">dateSort_s</xsl:with-param>
          <!-- assumed +asc, will need to add another variable if we want +desc -->
          <xsl:with-param name="sortSecondary">title</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>

      <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">

        <xsl:variable name="numFound" select="//result/@numFound"></xsl:variable>


        <h2>
          <xsl:call-template name="title_case">
            <xsl:with-param name="string" select="$subCategory"></xsl:with-param>
          </xsl:call-template>
        </h2>

        <p class="searchResultText">
          <xsl:value-of select="$numFound"></xsl:value-of>
          <xsl:text> item</xsl:text>
          <xsl:if test="$numFound > 1">
            <xsl:text>s</xsl:text>
          </xsl:if>
          <!-- This choose adds the search phrase to the search results -->
        </p>

        <!-- For testing -KMD -->
        <!--<p><xsl:value-of select="$solrsearchurl"></xsl:value-of></p>-->

        <xsl:call-template name="paginationLinks">
          <xsl:with-param name="baseLinkURL">
            <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
            <xsl:choose>
              <xsl:when test="$subCategory = 'postcards'">
                <xsl:value-of select="concat($siteroot, 'memorabilia/', $subCategory, '/index.html?')"></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($siteroot, 'images/', $subCategory, '/index.html?')"></xsl:value-of>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="numFound" select="$numFound"></xsl:with-param>
          <xsl:with-param name="start" select="$start"></xsl:with-param>
          <xsl:with-param name="rows" select="$rows"></xsl:with-param>
        </xsl:call-template>

        <xsl:for-each select="//doc">
          <div class="imageResult">

            <a>

              <xsl:attribute name="href">
                <xsl:value-of select="$siteroot"></xsl:value-of>
                <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
                <xsl:choose>
                  <xsl:when test="$subCategory = 'postcards'">
                    <xsl:text>memorabilia/view/</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>images/view/</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="$subCategory"></xsl:value-of>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="str[@name = 'id']"></xsl:value-of>
              </xsl:attribute>
              <img>
                <xsl:attribute name="src">
                  <xsl:value-of select="$fileroot"></xsl:value-of>
                  <xsl:text>figures/250/</xsl:text>
                  
                  <xsl:value-of select="str[@name = 'image_id']"/>
                  
                  <xsl:text>.jpg</xsl:text>
                </xsl:attribute>
                
              </img>
            </a>
            <!--[[<xsl:value-of select="str[@name = 'image_id']"/>]]-->
           

            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$siteroot"></xsl:value-of>
                <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
                <xsl:choose>
                  <xsl:when test="$subCategory = 'postcards'">
                    <xsl:text>memorabilia/view/</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>images/view/</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="$subCategory"></xsl:value-of>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="str[@name = 'id']"></xsl:value-of>
              </xsl:attribute>
              <h3>
                <xsl:value-of select="str[@name = 'title']"></xsl:value-of>
                <xsl:if test="str[@name = 'dateDisplay'] != ''"> - <xsl:value-of select="str[@name = 'dateDisplay']"></xsl:value-of></xsl:if>
              </h3>
            </a>
          </div>

        </xsl:for-each>

        <xsl:call-template name="paginationLinks">
          <xsl:with-param name="baseLinkURL">
            <!-- added choice for when image type content exists in the metadata section (i.e. postcards) -->
            <xsl:choose>
              <xsl:when test="$subCategory = 'postcards'">
                <xsl:value-of select="concat($siteroot, 'memorabilia/', $subCategory, '/index.html?')"></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($siteroot, 'images/', $subCategory, '/index.html?')"></xsl:value-of>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="numFound" select="$numFound"></xsl:with-param>
          <xsl:with-param name="start" select="$start"></xsl:with-param>
          <xsl:with-param name="rows" select="$rows"></xsl:with-param>
        </xsl:call-template>

        <input id="var_numFound" type="hidden" value="{$numFound}"></input>
        <input id="var_start" type="hidden" value="{$start}"></input>
        <input id="var_rows" type="hidden" value="{$rows}"></input>
      </xsl:for-each>
    </xsl:if>


    <!-- =====================================================================================
        imagesView Page
        ===================================================================================== -->
    <xsl:if test="$pagetype = 'imagesView'">

      <xsl:for-each select="/" xpath-default-namespace="http://www.vraweb.org/vracore4.htm">
        
          <h2>Image: <xsl:value-of select="/vra/work[1]/titleSet/title"></xsl:value-of></h2>
        <xsl:variable name="image_id" select="/vra/work[1]/@id"/>

          <div class="image_view">
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$fileroot"></xsl:value-of>
              <xsl:text>figures/800/</xsl:text>
       
              <xsl:value-of select="$image_id"/>
              
              
              <xsl:text>.jpg</xsl:text>
            </xsl:attribute>
          </img>
          </div>
        
        <xsl:if test="/vra/work/descriptionSet/normalize-space(description)[. != '']">
          <p><xsl:apply-templates select="/vra/work/descriptionSet/description"/>
          </p>
        </xsl:if>
        
          <div class="bibliography">
            <xsl:if test="/vra/work[1]/titleSet[1]/title[1][. != '']">
              <p> Title: <xsl:value-of select="/vra/work[1]/titleSet/title"></xsl:value-of>
              </p>
            </xsl:if>
            
            
            <!-- I don't love the way I am doing this but it works so leaving for now -->
            <xsl:variable name="creator_check">
                <xsl:for-each select="//work/agentSet/agent">
                  <xsl:choose>
                    <xsl:when test="role='publisher'"></xsl:when>
                    <xsl:when test="role='contributor'"></xsl:when>
                    <xsl:when test="role!=''">creator</xsl:when>
                    <xsl:when test="role='' and name != ''">creator</xsl:when>
                  </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            
           <!-- Creator -->
              <xsl:if test="contains($creator_check,'creator')">
              
                <p><xsl:text>Creator: </xsl:text>
                  
                  <xsl:for-each select="/vra/work/agentSet/agent">
                    <xsl:if test="role != 'publisher' and role != 'contributor' and normalize-space(.) != ''">
                      <!-- <p>Creator:--> <span class="subjectLink">
                        <a>
                          <xsl:attribute name="href">
                            <xsl:value-of select="$siteroot"></xsl:value-of>
                            <xsl:text>search/result.html?q=creator:"</xsl:text>
                            <xsl:value-of select="encode-for-uri(name)"></xsl:value-of>
                            <xsl:text>"</xsl:text>
                          </xsl:attribute>
                          <xsl:value-of select="name"></xsl:value-of>
                        </a>
                      </span><!--</p>-->
                    </xsl:if>
                  </xsl:for-each>
                </p>
                
              </xsl:if>
          
            
            <!-- Creator -->
        
            
            

            <xsl:if test="/vra/work[1]/subjectSet/subject[1]/term[1][. != '']">
              <p>
                <xsl:text>Keyword</xsl:text>
                <xsl:if test="count(/vra/work[1]/subjectSet/subject) &gt;= 2">
                  <xsl:text>s</xsl:text>
                </xsl:if>
                <xsl:text>: </xsl:text>

                <xsl:for-each select="/vra/work/subjectSet/subject/term">
                  <xsl:if test=". != ''">
                    <span class="subjectLink">
                      <a>
                        <xsl:attribute name="href">
                          <xsl:value-of select="$siteroot"></xsl:value-of>
                          <xsl:text>search/result.html?q=keywords:"</xsl:text>
                          <xsl:value-of select="."></xsl:value-of>
                          <xsl:text>"</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="."></xsl:value-of>
                      </a>
                    </span>
                  </xsl:if>
                </xsl:for-each>
              </p>
            </xsl:if>
            
            

            
            <xsl:for-each select="/vra/work/agentSet/agent">
              <xsl:if test="role = 'publisher'">
                <p>Publisher: <xsl:value-of select="name"/></p>
              </xsl:if>
            </xsl:for-each>
   
            
            <xsl:for-each select="/vra/work/agentSet/agent">
              <xsl:if test="role = 'contributor'">
                <p>Contributor: <xsl:value-of select="name"/></p>
              </xsl:if>
            </xsl:for-each>
            
            <xsl:if test="/vra/work[1]/dateSet[1]/normalize-space(display[1])[. != '']">
              <p> Date: <xsl:value-of select="/vra/work/dateSet/display"></xsl:value-of>
              </p>
            </xsl:if>
            <xsl:if test="/vra/work/materialSet/normalize-space(display[1])[. != '']">
              <p> Type: <xsl:value-of select="/vra/work[1]/materialSet/display"/>
              </p>
            </xsl:if>
            <xsl:if test="/vra/work/measurementsSet/normalize-space(display[1])[. != '']">
              <p> Format: <xsl:value-of select="/vra/work/measurementsSet/display"/>
              </p>
            </xsl:if>
            <p> ID: <xsl:value-of select="/vra/work/@id"/>
              </p>
           
            <xsl:if test="/vra/work[1]/relationSet/display[. != '']">
              <p>
                <xsl:text>Commentary: </xsl:text>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"></xsl:value-of>
                    <xsl:value-of select="/vra/work/relationSet/relation/@href"></xsl:value-of>
                    <xsl:text>.html</xsl:text>
                  </xsl:attribute>
                  <!--<xsl:attribute name="target">_blank</xsl:attribute>-->
                  <xsl:value-of select="/vra/work/relationSet/display"/>
                </a>
              </p>

              <!-- a way to include the audio inline. May need to be disabled if it is too server intensive -->
              <!--<p><xsl:for-each select="document('../../xml/wfc.aud.69.236.13.xml')">
                            <xsl:copy-of select="//tei:div1"/>
                        </xsl:for-each></p>-->

            </xsl:if>
            
            <!--<sourceSet>
              <display>multimedia/wfc.aud.69.238.2</display>
              <source>
                <name type="electronic" href="http://americanhistory.si.edu">multimedia/wfc.aud.69.238.2</name>
              </source>
            </sourceSet>-->

            <xsl:if test="/vra/work[1]/sourceSet[1]/display[1][. != '']">
              <p> Source: <xsl:choose>
                <xsl:when test="/vra/work[1]/sourceSet/source/name/@href and /vra/work[1]/sourceSet/source/name/@href != ''">
                    <a>
                      <xsl:attribute name="href">
                        <xsl:value-of select="/vra/work[1]/sourceSet/source/name/@href"></xsl:value-of>
                      </xsl:attribute>
                      <xsl:value-of select="/vra/work[1]/sourceSet/display"></xsl:value-of>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="/vra/work[1]/sourceSet/display"></xsl:value-of>
                  </xsl:otherwise>
                </xsl:choose>
              </p>
            </xsl:if>
            
            <xsl:if test="/vra/work[1]/rightsSet/rights/rightsHolder[. != '']">
              <p>Rights: <xsl:value-of select="/vra/work[1]/rightsSet/rights/rightsHolder"/></p>
            </xsl:if>

          </div>


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
              <xsl:sort select="@xml:id"></xsl:sort>
              <li>
                <a>
                  <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="@xml:id"></xsl:value-of>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:value-of select="persName[@type = 'display']"></xsl:value-of>
                  </xsl:attribute>
                  <xsl:value-of select="persName[@type = 'display']"></xsl:value-of>
                </a>
              </li>

            </xsl:for-each>
          </ul>

          <xsl:for-each select="//person">
            <xsl:sort select="@xml:id"></xsl:sort>
            <div>
              <xsl:attribute name="class">
                <xsl:text>life_item</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"></xsl:value-of>
              </xsl:attribute>
              <h3>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"></xsl:value-of>
                    <!-- Got rid of the people specific search for now, until we have more of the people fields filled out -->
                    <!--<xsl:text>search/people.html?q=people:"</xsl:text>-->
                    <xsl:text>search/people.html?q=</xsl:text>
                    <xsl:value-of select="encode-for-uri(persName[@type = 'display'])"></xsl:value-of>
                    <!--<xsl:text>"</xsl:text>-->
                    <!-- Needed for people result -->
                    <xsl:text>&amp;fq=-subCategory:"Personography"</xsl:text>
                    <!-- To exclude link back to personography, won't be needed when limited to people: -->
                  </xsl:attribute>
                  <xsl:value-of select="persName[@type = 'display']"></xsl:value-of>
                </a>
              </h3>
              <p>
                <xsl:apply-templates select="note"></xsl:apply-templates>
              </p>
            </div>
          </xsl:for-each>

        </xsl:when>
        <xsl:when test="$subCategory = 'Encyclopedia'">
          <h2>Encyclopedia</h2>

          <ul class="life_item">
            <xsl:for-each select="//div2">
              <xsl:sort select="@xml:id"></xsl:sort>
              <li>
                <a>
                  <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="@xml:id"></xsl:value-of>
                  </xsl:attribute>
                  <xsl:value-of select="head"></xsl:value-of>
                </a>
              </li>

            </xsl:for-each>
          </ul>

          <xsl:for-each select="//div2">
            <xsl:sort select="@xml:id"></xsl:sort>
            <div class="life_item">
              <h3>
                <xsl:attribute name="id">
                  <xsl:value-of select="@xml:id"></xsl:value-of>
                </xsl:attribute>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"></xsl:value-of>
                    <xsl:text>search/encyc.html?q=</xsl:text>
                    <xsl:value-of select="encode-for-uri(head)"></xsl:value-of>
                    <xsl:text>&amp;fq=-subCategory:"Encyclopedia"</xsl:text>
                    <!-- To exclude link back to encyclopedia, won't be needed when limited -->
                  </xsl:attribute>
                  <xsl:value-of select="head"></xsl:value-of>
                </a>
              </h3>

              <p>
                <xsl:apply-templates select="p"></xsl:apply-templates>
              </p>
            </div>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="//text"></xsl:apply-templates>
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
            <xsl:value-of select="concat(upper-case(substring($subCategory, 1, 1)), substring($subCategory, 2))"></xsl:value-of>
            <xsl:text>"</xsl:text>
          </xsl:when>
          <xsl:when test="$searchtype = 'people'">
            <xsl:text>(people:"</xsl:text>
            <xsl:value-of select="$q"></xsl:value-of>
            <xsl:text>")</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$q"></xsl:value-of>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:variable>

      <xsl:variable name="solrsearchurl">
        <xsl:call-template name="solrURL">
          <xsl:with-param name="rowstart">
            <xsl:value-of select="$start"></xsl:value-of>
          </xsl:with-param>
          <xsl:with-param name="rowend">
            <xsl:value-of select="$rows"></xsl:value-of>
          </xsl:with-param>
          <xsl:with-param name="searchfields">id,title,category,subCategory,itemCategory_s,date,dateDisplay,image_id,dateSort_s</xsl:with-param>
          <xsl:with-param name="facet">false</xsl:with-param>
          <xsl:with-param name="facetfield"><!--{!ex=dt}subtype--></xsl:with-param>
          <xsl:with-param name="other">
            <xsl:if test="$pagetype = 'searchresults' and $searchtype = 'unset'">
              <!-- Only need to include hits for search results -->
              <xsl:text>&amp;hl=on</xsl:text>
              <xsl:text>&amp;hl.fl=text</xsl:text>
              <xsl:text>&amp;hl.usePhraseHighlighter=true</xsl:text>
              <xsl:text>&amp;hl.highlighMultiTerm=true</xsl:text>
              <xsl:text>&amp;hl.snippets=4</xsl:text>
            </xsl:if>
          </xsl:with-param>
          <xsl:with-param name="q">
            <xsl:value-of select="$solrQuery"></xsl:value-of>
          </xsl:with-param>
          <xsl:with-param name="sort">
            <xsl:choose>
              <xsl:when test="$sort = 'date' or $pagetype = 'category'">
                <xsl:text>dateSort_s</xsl:text>
              </xsl:when>
              <xsl:when test="$sort = 'unset' or $sort = 'relevance'"></xsl:when>
              <!-- Leave blank for relevance -->
              <xsl:when test="$sort = 'title'">
                <xsl:text>title</xsl:text>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="sortDirection">
            <!-- Currently only being used to reverse sort the scholarship/papers section -->
            <xsl:choose>
              <xsl:when test="substring-before(substring-after($q, '&quot;'), '&quot;') = 'Papers'">
                <xsl:text>desc</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>asc</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="sortSecondary">
            <xsl:text>title</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>

      <!-- Search url, for testing -->
      <!--<xsl:value-of select="$solrsearchurl"></xsl:value-of>-->


      <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">

        <xsl:variable name="searchTerm" select="substring(//str[@name = 'q'], 2, string-length(//str[@name = 'q']) - 2)"></xsl:variable>
        <xsl:variable name="numFound" select="//result/@numFound"></xsl:variable>

        <!-- This choose adds the subcategory name to non searchresults -->
        <xsl:choose>
          <xsl:when test="$pagetype = 'category'">
            <h2>
              <xsl:value-of select="substring-before(substring-after($q, '&quot;'), '&quot;')"></xsl:value-of>
            </h2>
          </xsl:when>
          <xsl:otherwise>
            <h2>Search Results</h2>
          </xsl:otherwise>
        </xsl:choose>

        <p class="searchResultText">
          <xsl:value-of select="$numFound"></xsl:value-of>
          <xsl:text> item</xsl:text>
          <xsl:if test="$numFound > 1">
            <xsl:text>s</xsl:text>
          </xsl:if>

          <!-- This choose adds the search phrase to the search results -->
          <xsl:choose>
            <xsl:when test="$pagetype = 'category'">
              <!-- nothing -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> found for search term </xsl:text>
              <strong>
                <xsl:value-of select="$q"></xsl:value-of>
              </strong>
            </xsl:otherwise>
          </xsl:choose>
        </p>

        <!-- Sorting options, only on search pages -->
        <xsl:choose>
          <xsl:when test="not(starts-with($q, 'subCategory')) and not(starts-with($q, 'topic'))">
            <!-- May be a better way to do this, stops sort from showing up on all but search pages -->
            <p class="searchSort">
              <xsl:text>Sort by: </xsl:text>
              <xsl:choose>
                <xsl:when test="$sort = 'unset' or $sort = 'relevance'">Relevance</xsl:when>
                <xsl:otherwise>
                  <a href="{$siteroot}search/result.html?q={$q}&amp;sort=relevance">Relevance</a>
                </xsl:otherwise>
              </xsl:choose> | <xsl:choose>
                <xsl:when test="$sort = 'date'">Date</xsl:when>
                <xsl:otherwise>
                  <a href="{$siteroot}search/result.html?q={$q}&amp;sort=dateSort_s">Date</a>
                </xsl:otherwise>
              </xsl:choose> | <xsl:choose>
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
            <xsl:value-of select="$siteroot"></xsl:value-of>
            <!-- Added a choose to determine between category search results and regular search results. -->
            <xsl:choose>
              <xsl:when test="$pagetype = 'category'">
                <xsl:text>category</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>search</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>/result.html?</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="searchTerm" select="$searchTerm"></xsl:with-param>
          <xsl:with-param name="numFound" select="$numFound"></xsl:with-param>
          <xsl:with-param name="start" select="$start"></xsl:with-param>
          <xsl:with-param name="rows" select="$rows"></xsl:with-param>
          <xsl:with-param name="sort" select="$sort"></xsl:with-param>
        </xsl:call-template>

        <xsl:for-each select="//doc">
          <xsl:variable name="id" select="str[@name = 'id']"></xsl:variable>
          <xsl:variable name="titleMain" select="str[@name = 'title']"></xsl:variable>
          <xsl:variable name="date" select="str[@name = 'dateDisplay']"></xsl:variable>
          <xsl:variable name="category" select="str[@name = 'category']"></xsl:variable>
          <xsl:variable name="subCategory" select="str[@name = 'subCategory']"></xsl:variable>
          <xsl:variable name="imageID" select="str[@name = 'image_id']"></xsl:variable>

          <xsl:variable name="resultURL">
            <xsl:choose>
              <xsl:when test="$category = 'Images'">
                <xsl:value-of select="$siteroot"></xsl:value-of>
                <xsl:text>images/view/</xsl:text>
                <xsl:value-of select="$subCategory"></xsl:value-of>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$imageID"></xsl:value-of>
              </xsl:when>
              <!-- Personography results need a different link structure -->
              <xsl:when test="$subCategory = 'Personography'">
                <xsl:value-of select="$siteroot"></xsl:value-of>
                <xsl:text>life/wfc.person.html#</xsl:text>
                <xsl:value-of select="$id"></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$siteroot"></xsl:value-of>
                <xsl:value-of select="lower-case($category)"></xsl:value-of>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$id"></xsl:value-of>
                <xsl:text>.html</xsl:text>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:variable>

          <div class="searchResult">
            <xsl:call-template name="searchImageLink">
              <xsl:with-param name="imageID" select="$imageID"></xsl:with-param>
              <xsl:with-param name="category" select="$category"></xsl:with-param>
              <xsl:with-param name="subCategory" select="$subCategory"></xsl:with-param>
              <xsl:with-param name="resultURL" select="$resultURL"></xsl:with-param>
            </xsl:call-template>

            <p class="meta">
              <span class="date">
                <xsl:value-of select="$date"></xsl:value-of>
              </span>
              <span class="section">
                <xsl:value-of select="$category"></xsl:value-of>
              </span>
              <span class="subsection">
                <xsl:call-template name="title_case">
                  <xsl:with-param name="string">
                    <xsl:value-of select="replace($subCategory, '_', ' ')"></xsl:value-of>
                  </xsl:with-param>
                </xsl:call-template>
              </span>
            </p>
            <h3>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$resultURL"></xsl:value-of>
                </xsl:attribute>
                <xsl:value-of select="$titleMain"></xsl:value-of>
              </a>
            </h3>
            <xsl:for-each select="//lst[@name = 'highlighting']/lst[@name = $id]/arr/str">
              <p class="result">
                <xsl:text>"...</xsl:text>
                <xsl:call-template name="unescapeEm">
                  <xsl:with-param name="val">
                    <xsl:value-of select="."></xsl:value-of>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:text>..."</xsl:text>
              </p>
            </xsl:for-each>
          </div>
        </xsl:for-each>

        <xsl:call-template name="paginationLinks">
          <!--<xsl:with-param name="baseLinkURL" select="concat($siteroot, 'category/result.html?')">-->
          <xsl:with-param name="baseLinkURL">
            <xsl:value-of select="$siteroot"></xsl:value-of>
            <!-- Added a choose to determine between category search results and regular search results. -->
            <xsl:choose>
              <xsl:when test="$pagetype = 'category'">
                <xsl:text>category</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>search</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>/result.html?</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="searchTerm" select="$searchTerm"></xsl:with-param>
          <xsl:with-param name="numFound" select="$numFound"></xsl:with-param>
          <xsl:with-param name="start" select="$start"></xsl:with-param>
          <xsl:with-param name="rows" select="$rows"></xsl:with-param>
          <xsl:with-param name="sort" select="$sort"></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Title Case
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

  <xsl:template name="title_case">
    <xsl:param name="string"></xsl:param>

    <xsl:for-each select="tokenize(lower-case(replace($string, '_', ' ')), ' ')">
      <xsl:value-of select="concat(upper-case(substring(., 1, 1)), substring(., 2))"></xsl:value-of>
      <xsl:if test="position() != last()">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>


  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Pagination Code
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

  <xsl:template name="paginationLinks">
    <xsl:param name="baseLinkURL"></xsl:param>
    <xsl:param name="searchTerm"></xsl:param>
    <xsl:param name="numFound"></xsl:param>
    <xsl:param name="start_pagination" as="xs:integer">
      <xsl:value-of select="$start"></xsl:value-of>
    </xsl:param>
    <!-- defaults to 0, unless changed in cocoon sitemap -->
    <xsl:param name="rows_pagination" as="xs:integer">
      <xsl:value-of select="$rows"></xsl:value-of>
    </xsl:param>
    <!-- defaults to 10, unless changed in cocoon sitemap -->
    <xsl:param name="sort"></xsl:param>

    <xsl:variable name="prev-link">
      <xsl:choose>
        <xsl:when test="$start_pagination &lt;= 0">
          <xsl:text>Previous</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$baseLinkURL"></xsl:value-of>
              <xsl:if test="$q">
                <xsl:text>q=</xsl:text>
                <xsl:value-of select="replace($q, '&amp;', '%26')"/>
                <xsl:text>&#38;</xsl:text>
              </xsl:if>
              <xsl:text>start=</xsl:text>
              <xsl:value-of select="$start_pagination - $rows_pagination"></xsl:value-of>
              <xsl:text>&#38;rows=</xsl:text>
              <xsl:value-of select="$rows_pagination"></xsl:value-of>
              <xsl:if test="$sort != 'unset'">
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sort"></xsl:value-of>
              </xsl:if>
            </xsl:attribute>
            <xsl:text>Previous</xsl:text>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="next-link">
      <xsl:choose>
        <xsl:when test="$start_pagination + $rows_pagination &gt;= $numFound">
          <xsl:text>Next</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$baseLinkURL"></xsl:value-of>
              <xsl:if test="$q">
                <xsl:text>q=</xsl:text>
                <xsl:value-of select="replace($q, '&amp;', '%26')"/>
                <xsl:text>&#38;</xsl:text>
              </xsl:if>
              <xsl:text>start=</xsl:text>
              <xsl:value-of select="$start_pagination + $rows_pagination"></xsl:value-of>
              <xsl:text>&#38;rows=</xsl:text>
              <xsl:value-of select="$rows_pagination"></xsl:value-of>
              <xsl:if test="$sort != 'unset'">
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sort"></xsl:value-of>
              </xsl:if>
            </xsl:attribute>
            <xsl:text>Next</xsl:text>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Pagination HTML -->
    <div class="pagination"><xsl:copy-of select="$prev-link"></xsl:copy-of> | <!-- Commented this out because it is broken -kmd --><!--Go to page <form class="jumpForm">
        <input type="text" name="paginationJump" value="{format-number($start_pagination div $rows_pagination + 1, '0')}" class="paginationJump"></input>
        <input type="submit" value="Go" class="paginationJumpBtn submit"></input>
      </form> of <xsl:value-of select="ceiling($numFound div $rows_pagination)"></xsl:value-of> |--> <xsl:copy-of select="$next-link"></xsl:copy-of>
    </div>
    <div class="paginationline">&#160;</div>
    <!-- /end Pagination HTML -->
  </xsl:template>

  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        searchImageLink Code
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

  <xsl:template name="searchImageLink">
    <xsl:param name="imageID"></xsl:param>
    <xsl:param name="category"></xsl:param>
    <xsl:param name="subCategory"></xsl:param>
    <xsl:param name="resultURL"></xsl:param>

    <xsl:choose>

      <!-- when icon-$subCategory appears for the imageID, we need to use a slightly modified URL -->
      <!-- this would occur when there is no suitable image of the object, or the image is of low quality, etc. -->
      <xsl:when test="contains($imageID, 'icon-')">
        <div class="image">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$resultURL"></xsl:value-of>
            </xsl:attribute>
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$fileroot"></xsl:value-of>
                <xsl:text>images/</xsl:text>
                <xsl:value-of select="$imageID"></xsl:value-of>
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
              <xsl:value-of select="$resultURL"></xsl:value-of>
            </xsl:attribute>
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$fileroot"></xsl:value-of>
                <xsl:text>figures/searchresults/</xsl:text>
                <xsl:value-of select="$imageID"></xsl:value-of>
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
          <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'm'][1])">
            <p> Title: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'm']" separator=" | "></xsl:value-of>
            </p>
          </xsl:when>
          <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'a'][1])">
            <p> Title: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'a']" separator=" | "></xsl:value-of>
            </p>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'j'][1])">
          <p> Periodical: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'j']" separator=" | "></xsl:value-of>
          </p>
        </xsl:if>

        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/date[1])">
          <p> Date: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date"></xsl:value-of>
          </p>
        </xsl:if>

        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/author[1])">
          <p>Author: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/author">
              <xsl:value-of select="."></xsl:value-of>
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
          <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'm'][1])">
            <p> Title: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'm']" separator=" | "></xsl:value-of>
            </p>
          </xsl:when>
          <xsl:when test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'a'][1])">
            <p> Title: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'a']" separator=" | "></xsl:value-of>
            </p>
          </xsl:when>
        </xsl:choose>

        <!-- Journal/Periodical rules -->
        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'j'][1])">
          <p> Periodical: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level = 'j']" separator=" | "></xsl:value-of>
          </p>
        </xsl:if>

        <!-- Publisher riles -->
        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher[1])">
          <p>Publisher: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher">
              <xsl:value-of select="."></xsl:value-of><xsl:text> </xsl:text>
            </xsl:for-each>
          </p>
        </xsl:if>

        <!-- Repository rules -->
        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository[1])">
          <p>Source: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository">
              <xsl:value-of select="."></xsl:value-of>
              <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/idno)">
                <xsl:text>, </xsl:text>
                <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/idno">
                  <xsl:value-of select="."></xsl:value-of>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
          </p>
        </xsl:if>


        <!-- Sponsor rules --> <!-- This now appears down below, delete later -kmd -->
        <!--<xsl:if test="string(/TEI/teiHeader/fileDesc/titleStmt/sponsor[1])">
          <p>Sponsor: <xsl:for-each select="/TEI/teiHeader/fileDesc/titleStmt/sponsor">
              <xsl:value-of select="."></xsl:value-of>
            </xsl:for-each>
          </p>
        </xsl:if>-->


        <!-- Date -->
        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/date)">
          <p> Date: <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date"></xsl:value-of></p>
        </xsl:if>

        <!-- Author -->
        <xsl:if test="string(/TEI/teiHeader/fileDesc/sourceDesc/bibl/author[1])">
          <p>Author: <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/author">
              <span class="subjectLink">
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$siteroot"></xsl:value-of>
                    <xsl:text>search/people.html?q=creator:"</xsl:text>
                    <!-- This code is to choose the @n value for the name if there is one -->
                    <xsl:choose>
                      <xsl:when test="@n and @n != ''">
                        <xsl:value-of select="encode-for-uri(@n)"></xsl:value-of>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="encode-for-uri(.)"></xsl:value-of>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>"</xsl:text>
                  </xsl:attribute>
                  <!-- This code is to choose the @n value for the name if there is one -->
                  <xsl:choose>
                    <xsl:when test="@n and @n != ''">
                      <xsl:value-of select="@n"></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="."></xsl:value-of>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </span>
            </xsl:for-each>
          </p>
        </xsl:if>

        <!-- Related and Identical Documents -->
        <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/relatedItem">
          <p> Also appeared as: <p>&#160;&#160;Title: <xsl:if test="bibl/title[@type = 'main']/text()">
                <xsl:value-of select="bibl/title[@type = 'main']"></xsl:value-of>
                <xsl:text> | </xsl:text>
              </xsl:if>
              <xsl:if test="bibl/title[@type = 'sub']/text()">
                <xsl:value-of select="bibl/title[@type = 'sub']"></xsl:value-of>
              </xsl:if>
            </p>
            <xsl:if test="bibl/title[@level = 'j']/text()">
              <p>&#160;&#160;Periodical: <xsl:value-of select="bibl/title[@level = 'j']"></xsl:value-of>
              </p>
            </xsl:if>
            <xsl:if test="bibl/date/text()">
              <p>&#160;&#160;Date: <xsl:value-of select="bibl/date"></xsl:value-of>
              </p>
            </xsl:if>
          </p>
        </xsl:for-each>

        <!-- Topics -->
        <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'topic']/term[1])">
          <p>
            <xsl:text>Topic</xsl:text>
            <xsl:if test="count(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'topic']/term) &gt;= 2">
              <xsl:text>s</xsl:text>
            </xsl:if>
            <xsl:text>:</xsl:text>
            <xsl:for-each select="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'topic']/term[1])">
              <xsl:if test="string(.)">
                <span class="subjectLink">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$siteroot"></xsl:value-of>
                      <xsl:text>search/result.html?q=topic:"</xsl:text>
                      <xsl:value-of select="."></xsl:value-of>
                      <xsl:text>"</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="."></xsl:value-of>
                  </a>
                </span>
              </xsl:if>
            </xsl:for-each>

          </p>
        </xsl:if>

        <!-- Keywords -->
        <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'keywords']/term[1])">
          <p>
            <xsl:text>Keyword</xsl:text>
            <xsl:if test="count(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'keywords']/term) &gt;= 2">
              <xsl:text>s</xsl:text>
            </xsl:if>
            <xsl:text>:</xsl:text>

            <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'keywords']/term">
              <xsl:if test="string(.)">
                <span class="subjectLink">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$siteroot"></xsl:value-of>
                      <xsl:text>search/result.html?q=keywords:"</xsl:text>
                      <xsl:value-of select="."></xsl:value-of>
                      <xsl:text>"</xsl:text>
                    </xsl:attribute>

                    <xsl:value-of select="."></xsl:value-of>
                  </a>
                </span>
              </xsl:if>
            </xsl:for-each>
          </p>
        </xsl:if>

        <!-- People -->
        <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'people']/term[1])">
          <p>
            <xsl:text>People: </xsl:text>

            <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'people']/term">
              <xsl:if test="string(.)">
                <span class="subjectLink">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$siteroot"></xsl:value-of>
                      <xsl:text>search/result.html?q=people:"</xsl:text>
                      <xsl:value-of select="."></xsl:value-of>
                      <xsl:text>"</xsl:text>
                    </xsl:attribute>

                    <xsl:value-of select="."></xsl:value-of>
                  </a>
                </span>
              </xsl:if>
            </xsl:for-each>
          </p>
        </xsl:if>

        <!-- Places -->
        <xsl:if test="string(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'places']/term[1])">
          <p>
            <xsl:text>Place</xsl:text>
            <xsl:if test="count(/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'places']/term) &gt;= 2">
              <xsl:text>s</xsl:text>
            </xsl:if>
            <xsl:text>: </xsl:text>

            <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n = 'places']/term">
              <xsl:if test="string(.)">
                <xsl:if test=". != ''">
                  <xsl:variable name="place">
                    <xsl:value-of select="."></xsl:value-of>
                  </xsl:variable>
                  <span class="subjectLink">
                    <a href="{$siteroot}search/result.html?q=places:&quot;{$place}&quot;">
                      <xsl:value-of select="."></xsl:value-of>
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
              <xsl:value-of select="resp"></xsl:value-of>
              <xsl:text>: </xsl:text>
              <xsl:value-of select="name" separator="; "></xsl:value-of>
            </p>
          </xsl:for-each>

        </xsl:if>

        <!-- Sponsor rules -->
        <xsl:if test="string(/TEI/teiHeader/fileDesc/titleStmt/sponsor[1])">
          <p>Sponsor: <xsl:for-each select="/TEI/teiHeader/fileDesc/titleStmt/sponsor">
              <xsl:value-of select="."></xsl:value-of>
            </xsl:for-each>
          </p>
        </xsl:if>

        <!-- Editorial statement and Conditions of use -->

        <p><a href="{$siteroot}about/#editorial_statement">Editorial Statement</a> | <a href="{$siteroot}about/#conditions">Conditions of Use</a></p>

        <p>TEI encoded XML: <a class="subjectLink">
            <xsl:attribute name="href">
              <xsl:text>wfc.</xsl:text>
              <xsl:value-of select="$pageid"></xsl:value-of>
              <xsl:text>.xml</xsl:text>
            </xsl:attribute> View <xsl:text>wfc.</xsl:text><xsl:value-of select="$pageid"></xsl:value-of>
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
    <xsl:param name="sortDirection">asc</xsl:param>
    <!-- Ascending as usual by default -->
    <xsl:param name="sortSecondary"></xsl:param>

    <xsl:value-of select="$searchroot"></xsl:value-of>

    <!-- Add sort if not set to default -->
    <xsl:choose>
      <xsl:when test="$sort = ''">
        <!-- do nothing to leave as default sort -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&amp;sort=</xsl:text>
        <xsl:value-of select="$sort"></xsl:value-of>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$sortDirection"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>

    <!-- Add secondary sort if necessary -->
    <xsl:choose>
      <xsl:when test="$sortSecondary = ''">
        <!-- do nothing to leave as default sort -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="$sortSecondary"></xsl:value-of>
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
      <xsl:value-of select="$rowstart"></xsl:value-of>
    </xsl:if>
    <xsl:if test="$rowend != ''">
      <xsl:text>&amp;rows=</xsl:text>
      <xsl:value-of select="$rowend"></xsl:value-of>
    </xsl:if>

    <!-- Which fields to return -->
    <xsl:if test="$searchfields != ''">
      <xsl:text>&amp;fl=</xsl:text>
      <xsl:value-of select="$searchfields"></xsl:value-of>
    </xsl:if>

    <!-- Which fields to return -->
    <xsl:if test="$fq != '' and $fq != 'unset'">
      <xsl:text>&amp;fq=</xsl:text>
      <xsl:value-of select="$fq"></xsl:value-of>
    </xsl:if>

    <!-- faceting options -->
    <xsl:if test="$facet = 'true'">
      <xsl:text>&amp;facet=</xsl:text>
      <xsl:value-of select="$facet"></xsl:value-of>
      <xsl:text>&amp;facet.field=</xsl:text>
      <xsl:value-of select="$facetfield"></xsl:value-of>
    </xsl:if>

    <!-- anything else, passed through the "other" variable -->
    <xsl:if test="$other != ''">
      <xsl:value-of select="$other"></xsl:value-of>
    </xsl:if>

    <!-- query -->
    <xsl:choose>
      <xsl:when test="$q = ''">
        <xsl:text>&amp;q=%28*:*%29</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&amp;q=%28</xsl:text>
        <xsl:value-of select="encode-for-uri($q)"></xsl:value-of>
        <xsl:text>%29</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template name="unescapeEm">
    <xsl:param name="val" select="''"></xsl:param>
    <xsl:variable name="preEm" select="substring-before($val, '&lt;')"></xsl:variable>
    <xsl:choose>
      <xsl:when test="$preEm or starts-with($val, '&lt;')">
        <xsl:variable name="insideEm" select="
            substring-before($val,
            '&lt;/')"></xsl:variable>
        <xsl:value-of select="$preEm"></xsl:value-of>
        <em>
          <xsl:value-of select="substring($insideEm, string-length($preEm) + 5)"></xsl:value-of>
        </em>
        <xsl:variable name="leftover" select="
            substring($val,
            string-length($insideEm) + 6)"></xsl:variable>
        <xsl:if test="$leftover">
          <xsl:call-template name="unescapeEm">
            <xsl:with-param name="val" select="$leftover"></xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$val"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>






</xsl:stylesheet>
