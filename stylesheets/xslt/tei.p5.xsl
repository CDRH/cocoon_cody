<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="2.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs dc rdf">
  <!-- This is here so I can use xs:integer to set param type -KD -->

  <xsl:output method="xhtml" indent="yes" encoding="UTF-8"/>

  <xsl:param name="pagetype">unset</xsl:param>
  <xsl:param name="subCategory">unset</xsl:param>
  <xsl:param name="searchtype">unset</xsl:param>
  <xsl:param name="pageid">unset</xsl:param>
  <xsl:param name="sort">unset</xsl:param>
  <xsl:param name="imageno">unset</xsl:param>
  <xsl:param name="start">0</xsl:param>
  <xsl:param name="rows">50</xsl:param>
  <xsl:param name="q"></xsl:param>
  <xsl:param name="fq">unset</xsl:param>
  
  <!--<xsl:param name="personAttribute">unset</xsl:param>-->

  <xsl:include href="../../config/config.xsl"/>
  <xsl:include href="page_templates.xsl"/>
  <xsl:include href="html_template.xsl"/>
  
  <!-- A cheat to pass through HTML as is, mostly for youtube embed codes and the like -->
  <xsl:template match="div1[@type='html']">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template name="language_choice">
    <xsl:param name="language"></xsl:param>
    <xsl:choose>
      <xsl:when test="$language = 'de'">German</xsl:when>
      <xsl:when test="$language = 'en'">English</xsl:when>
      <xsl:otherwise>Unknown</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- For display of multi lingual texts -->
  <xsl:template match="div1[@xml:lang]">
   
    
    <div class="translation" id="{@xml:lang}">
      <h4>
      <xsl:choose>
        <xsl:when test="@xml:lang != 'en'">
          <xsl:text>Original </xsl:text> 
          <xsl:call-template name="language_choice">
            <xsl:with-param name="language"><xsl:value-of select="@xml:lang"/></xsl:with-param>
          </xsl:call-template>
          <xsl:text> | </xsl:text> 
            <a>
              <xsl:attribute name="href">
                <xsl:text>#en</xsl:text>
              </xsl:attribute>
              <xsl:text>English Translation Available</xsl:text>
            </a>
        </xsl:when>
        <xsl:when test="not(preceding-sibling::div1)">
          <xsl:text>English Translation</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>English Translation | </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:text>#</xsl:text><xsl:value-of select="preceding-sibling::div1[last()]/@xml:lang"/>
            </xsl:attribute>
            <xsl:text>Original </xsl:text>
            <xsl:call-template name="language_choice">
              <xsl:with-param name="language"><xsl:value-of select="preceding-sibling::div1[last()]/@xml:lang"/></xsl:with-param>
            </xsl:call-template>
 
          </a>
        </xsl:otherwise>
      </xsl:choose>
      </h4>
    <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="head">
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'p']"> <!-- Usually when the head is in a p, so can't use headers -->
        <span>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/>
            <xsl:text> para</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="head[1]"><!-- When the first head on the page -->
        <h2>
          <xsl:apply-templates/>
        </h2>
      </xsl:when>
      <xsl:otherwise>
        <h3>
          <xsl:apply-templates/>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="@type='editorial'">
        <!-- Hide -->
      </xsl:when>
      <xsl:when test="parent::*[name() = 'p']"/><!-- ???? -->
      <xsl:when test="ancestor::*[name() = 'person']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="choice">
    <xsl:choose>
      <!-- sic/corr -->
      <xsl:when test="child::*[name() = 'sic']">
        <xsl:if test="pb"> <!-- show page break if in corr -->
          <xsl:apply-templates select="pb"/>
        </xsl:if>
        <xsl:apply-templates select="sic"/>
      </xsl:when>
      <!-- reg/orig -->
      <xsl:when test="child::*[name() = 'orig']">
        <!--<xsl:if test="orig/pb">
          <xsl:apply-templates select="orig/pb"/> 
        </xsl:if>-->                        <!-- This was causing a problem when we switched back to displaying orig -->
        <xsl:apply-templates select="orig"/><!-- Decided to show orig because page breaks are in orig sometimes, i.e. wfc.bks00008.html -->
      </xsl:when>
      <!-- abbr/expan -->
      <xsl:when test="child::*[name() = 'abbr']">
        <xsl:if test="pb"> <!-- if there is a pb in a abbr-->
          <xsl:apply-templates select="pb"/>
        </xsl:if>
        <abbr>
          <xsl:attribute name="title">
            <xsl:apply-templates select="expan"/>
          </xsl:attribute>
          <xsl:apply-templates select="abbr"/>
        </abbr>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="supplied">
    [<xsl:apply-templates/>]
  </xsl:template>

  <xsl:template match="emph | hi[@rend='italic'] | foreign">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="list">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="l">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <xsl:template match="del">
    <xsl:text> </xsl:text>
    <del>
      <xsl:apply-templates/>
    </del>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="p | addrLine | salute | signed | ab | dateline">
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'p'] or ancestor::*[name() = 'dateline']"><!-- avoid nesting p's -->
        <span>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/> <!-- add a class with the name of the element -->
            <xsl:text> para</xsl:text><!-- add style so can ve styled like a paragraph rather than a span -->
          </xsl:attribute>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="closer | date">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
        <xsl:text> p</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="lg">
    <xsl:choose>
      <xsl:when test="child::*[name() = 'lg'] or ancestor::*[name() = 'p']">
        <span>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <!-- same as otherwise, so commented out. Delete if no problems -->
      <!--<xsl:when test="parent::*[name() = 'lg']">
        <p>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </p>
      </xsl:when>-->
      <xsl:otherwise>
        <p>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="div1/bibl">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="quote">
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'p']">
        <q class="blockquote">
          <xsl:apply-templates/>
        </q>
      </xsl:when>
      <xsl:otherwise>
        <blockquote>
          <p>
            <xsl:apply-templates/>
          </p>
        </blockquote>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="q">
    <q>
      <xsl:apply-templates/>
    </q>
  </xsl:template>

  <xsl:template match="unclear">
    <xsl:text> [...] </xsl:text>
  </xsl:template>

  <xsl:template
    match="titlePage | docTitle | titlePart | byline | docAuthor | docImprint | publisher | pubPlace ">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="lb">
    <br/>
  </xsl:template>

  <xsl:template match="fw">
    <!-- Hide -->
  </xsl:template>

  <xsl:template match="div1/bibl/title">
    <xsl:choose>
      <xsl:when test="@level='m'">
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:when test="@level='j'">
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Called via figure template match below -->
  <xsl:template name="figure_formatter">
    <xsl:param name="type"/>
    
    <xsl:choose>
      <!-- handled by "audio and video" below -->
      <xsl:when test="$type = 'audio' or $type = 'video'"><xsl:apply-templates/></xsl:when>
      
      <xsl:when test="ancestor::*[name() = 'person']">
        <xsl:apply-templates/>
      </xsl:when>
      
      <xsl:when test="$type = 'illustration'">
        <span class="figure">
          <span>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$fileroot"/>
                <xsl:text>figures/800/</xsl:text>
                <xsl:value-of select="graphic/@url"/>
                <xsl:text>.jpg</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="rel">
                <xsl:text>prettyPhoto[pp_gal]</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:text>&lt;a href="</xsl:text>
                <xsl:value-of select="$fileroot"/>
                <xsl:text>figures/800/</xsl:text>
                <xsl:value-of select="graphic/@url"/>
                <xsl:text>.jpg</xsl:text>
                <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
              </xsl:attribute>
              <img>
                <xsl:attribute name="src">
                  <xsl:value-of select="$fileroot"/>
                  <xsl:text>figures/250/</xsl:text>
                  <xsl:value-of select="graphic/@url"/>
                  <xsl:text>.jpg</xsl:text>
                </xsl:attribute>
              </img>
            </a>
          </span>
        </span>
      </xsl:when>
      
      <xsl:otherwise>
        <span class="figure">
          <span>
            <xsl:attribute name="class">
              <xsl:value-of select="@n"/>
              <xsl:text> figureDesc</xsl:text>
            </xsl:attribute>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
          </span>
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="figure">
    
    
    <span class="tei_figure">
      <xsl:choose>
        <xsl:when test="//keywords[@n='category']/term[1] = 'Images'">
          <xsl:call-template name="figure_formatter">
            <xsl:with-param name="type">image</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
       
        <xsl:when test="media/@mimeType='audio/mp3'">
          <xsl:call-template name="figure_formatter">
            <xsl:with-param name="type">audio</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="media/@mimeType='video/mp4'">
          <xsl:call-template name="figure_formatter">
            <xsl:with-param name="type">video</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@n='illustration' or not(@n)">
          <xsl:call-template name="figure_formatter">
            <xsl:with-param name="type">illustration</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="figure_formatter">
            <xsl:with-param name="type">other</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <!--[<xsl:apply-templates/>]-->
    </span>
    
  </xsl:template>
  
  <!-- ~~~~~~~ audio and video ~~~~~~~ -->
  
  <xsl:template match="media[@mimeType='audio/mp3']">
    
    <audio controls="controls">
      <source src="{$fileroot}audio/mp3/{@url}" type="audio/mpeg"/>
      <source src="{$fileroot}audio/mp3/{substring-before(@url,'.mp3')}.ogg" type="audio/ogg"/> 
      <embed src="http://www.google.com/reader/ui/3523697345-audio-player.swf" flashvars="audioUrl={$fileroot}audio/mp3/{@url}" type="application/x-shockwave-flash" width="230" height="27" quality="best"/>
    </audio>
    
   
    
  </xsl:template>
  
  <xsl:template match="media[@mimeType='video/mp4']">
    
    <iframe width="560" height="315" src="{@url}" frameborder="0" allowfullscreen="true">&#160;</iframe>
    
    <!--<object width="560" height="315">
      <param name="movie" value="http://www.youtube.com/v/ITek7jSH8Uk?version=3&amp;hl=en_US"></param>
      <param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param>
      <embed src="{@url}" type="application/x-shockwave-flash" width="560" height="315" allowscriptaccess="always" allowfullscreen="true"></embed>
    </object>-->
    
  </xsl:template>
  

  <!--<xsl:template match="figure">
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'person']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="@n = 'illustration'">
        
        <span class="figure">
          <span>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$fileroot"/>
                <xsl:text>figures/800/</xsl:text>
                <xsl:value-of select="graphic/@facs"/>
                <xsl:text>.jpg</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="rel">
                <xsl:text>prettyPhoto[pp_gal]</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:text>&lt;a href="</xsl:text>
                <xsl:value-of select="$fileroot"/>
                <xsl:text>figures/800/</xsl:text>
                <xsl:value-of select="graphic/@facs"/>
                <xsl:text>.jpg</xsl:text>
                <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
              </xsl:attribute>
              <img>
                <xsl:attribute name="src">
                  <xsl:value-of select="$fileroot"/>
                  <xsl:text>figures/250/</xsl:text>
                  <xsl:value-of select="graphic/@facs"/>
                  <xsl:text>.jpg</xsl:text>
                </xsl:attribute>
              </img>
            </a>
          </span>
        </span>
        
      
      </xsl:when>
      <xsl:otherwise>
        <span class="figure">
          <span>
            <xsl:attribute name="class">
              <xsl:value-of select="@n"/>
              <xsl:text> figureDesc</xsl:text>
            </xsl:attribute>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
          </span>
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <xsl:template match="pb">
    <span class="hr">&#160;</span>
    <span class="pageimage">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$fileroot"/>
          <xsl:text>figures/800/</xsl:text>
          <xsl:value-of select="@facs"/>
          <xsl:text>.jpg</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="rel">
          <xsl:text>prettyPhoto[pp_gal]</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>&lt;a href="</xsl:text>
          <xsl:value-of select="$fileroot"/>
          <xsl:text>figures/800/</xsl:text>
          <xsl:value-of select="@facs"/>
          <xsl:text>.jpg</xsl:text>
          <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
        </xsl:attribute>
        <img>
          <xsl:attribute name="src">
            <xsl:value-of select="$fileroot"/>
            <xsl:text>figures/250/</xsl:text>
            <xsl:value-of select="@facs"/>
            <xsl:text>.jpg</xsl:text>
          </xsl:attribute>
        </img>
      </a>
    </span>
  </xsl:template>

  <xsl:template match="back">
    <xsl:choose>
      <xsl:when test="child::note">
        <div class="bibliography">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:when test="not(child::note) and not(string(.))">
        <xsl:if test="/TEI/teiHeader/fileDesc/notesStmt/note != ''">
          <div class="bibliography">
            <p>Note: <xsl:value-of select="/TEI/teiHeader/fileDesc/notesStmt/note"/></p>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:when test="string(.)">
        <div class="bibliography">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise/>
      <!-- Do nothing -->
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ref">
    <xsl:choose>
      <!-- When an offsite link -->
      <xsl:when test="starts-with(@target, 'http')">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- When an internal link to another document. target should point to full path after siteurl -->
      <xsl:when test="contains(@target, 'wfc')">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$siteroot"/>
            <xsl:value-of select="@target"/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="ends-with(@target, 'html')">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- otherwise it is a note, and will link to notes in metadat -->
      <xsl:otherwise>
        <a>
          <xsl:attribute name="name">
            <xsl:value-of select="@target"/>
            <xsl:text>.ref</xsl:text>
          </xsl:attribute>
        </a>
        <a>
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@target"/>
            <xsl:text>.note</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>ref</xsl:text>
          </xsl:attribute> [<xsl:apply-templates/>] </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- handle notes linked from above -->
  <xsl:template match="//back/note">
    <p>
      <a>
        <xsl:attribute name="name">
          <xsl:value-of select="@xml:id"/>
          <xsl:text>.note</xsl:text>
        </xsl:attribute>
        <xsl:text> </xsl:text>
      </a>
      <xsl:apply-templates/>
      <xsl:text> </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="@xml:id"/>
          <xsl:text>.ref</xsl:text>
        </xsl:attribute> [back] </a>
    </p>
  </xsl:template>

  <xsl:template match="table">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="cell">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <!--  <xsl:template match="persName">
    <xsl:choose>
      <xsl:when test="parent::person">
        <span style="background-color:red;"><xsl:apply-templates/></span>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$siteroot"/>
            <xsl:text>life/wfc.person.html#</xsl:text>
            <xsl:value-of select="@xml:id"/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <xsl:template match="persName">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$siteroot"/>
        <xsl:text>life/wfc.person.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:text>Link to </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text> in the personography</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </a>
  </xsl:template>
  
  <xsl:template match="orgName | rs">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$siteroot"/>
        <xsl:text>life/wfc.encyc.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:text>Link to </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text> in the encyclopedia</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </a>
  </xsl:template>
  
  
  <!-- Not sure what this is for? particDesc does not match anything-->
  <!--  <xsl:template match="particDesc">
    <xsl:for-each select="listPerson">
      <!-\-<xsl:value-of select="concat(upper-case(substring(@type, 1, 1)), substring(@type, 2))"/>-\->
      <xsl:for-each select="person">
        <xsl:sort select="persName[@type='lcsh']"></xsl:sort>
        <div class="person">
          <h3><xsl:apply-templates select="persName[@type='lcsh']"></xsl:apply-templates></h3>
          
          <xsl:for-each select="note[@type='photograph']">
            <div class="personImage">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$siteroot"/>
                  <xsl:text>images/view/photographs/</xsl:text>
                  <xsl:value-of select="figure/graphic/@n"/>
                </xsl:attribute>
                <img>
                  <xsl:attribute name="src">
                    <xsl:value-of select="$fileroot"/>
                    <xsl:text>figures/250/</xsl:text>
                    <xsl:value-of select="figure/graphic/@n"/>
                    <xsl:text>.jpg</xsl:text>
                  </xsl:attribute>
                </img>
                <!-\-<xsl:value-of select="figure/graphic/@n"/>-\->
              </a>
            </div>
          </xsl:for-each>
          
        <xsl:for-each select="birth | death | sex | affiliation | occupation | floruit | nationality | education | residence | faith">
          <xsl:if test="string(.)">
            <xsl:param name="personAttribute">unset</xsl:param>
            <xsl:param name="personAttribute"><xsl:value-of select="name()"/></xsl:param>
            
            <p class="personDetails">
              <xsl:choose>
                <xsl:when test="$personAttribute = 'floruit'">
                  Active
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(upper-case(substring($personAttribute, 1, 1)), substring($personAttribute, 2))"/>
                </xsl:otherwise>
              </xsl:choose>    
              <xsl:text>: </xsl:text><xsl:value-of select="."/>
            </p>
          </xsl:if>
          </xsl:for-each>
          
        <xsl:if test="note[not(@*)] or note[@type='bio']">
          <p class="personBio">
            <xsl:apply-templates select="note"/>
          </p>
        </xsl:if>
        </div>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>-->


</xsl:stylesheet>
