<?xml version="1.0"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:choose>
            <!--<xsl:when test="$pagetype = 'popup'">
                <html class="popup">
                  <head>
                    <title>Personography</title>
                    <link rel="stylesheet" href="{$siteroot}stylesheets/css/reset.css"/>
                    <link rel="stylesheet" href="{$siteroot}stylesheets/css/style.css"/>
                  </head>
                    <body>
                        <xsl:call-template name="popup"/>
                    </body>
                </html>
            </xsl:when>-->
         
          <xsl:when test="$pagetype = 'error'">
            <html class="error">
              <head>
                <title>Error Page</title>
                <link rel="stylesheet" href="{$siteroot}stylesheets/css/style.css"/>
              </head>
              <body>
                <div class="error">
                  <h1>Something went wrong</h1>
                  <p>Sorry, the page you were looking for can't be found. Please try the <a href="{$siteroot}">home page</a> to find what you are looking for.</p>
                </div>
              </body>
            </html>
          </xsl:when>
            <xsl:otherwise>


    <html lang="en" class="no-js {$pagetype}">
      <head>
        <meta charset="utf-8"/>
        <!--<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />-->

        <!-- www.phpied.com/conditional-comments-block-downloads/ -->
        <!--[if IE]><![endif]-->

        <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame 
            Remove this if you use the .htaccess -->
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

        <title>William F. Cody Archive: Documenting the life and times of Buffalo Bill</title>
        
        <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
        <link rel="apple-touch-icon-precomposed" href="/apple-touch-icon.png"/>
          

        <!-- JQuery -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"> &#160; </script>
        
        <!-- JQuery UI CSS -->
        <link rel="stylesheet"
        href="{$siteroot}plugins/jquery-ui-1.8.14.custom/css/custom-theme/jquery-ui-1.8.14.custom.css"/>
        
        <!-- Pretty Photo Image Viewer -->
        <link rel="stylesheet" href="{$siteroot}js/prettyPhoto_compressed_3.1.3/css/prettyPhoto.css" type="text/css" media="screen" charset="utf-8" />
        <script src="{$siteroot}js/prettyPhoto_compressed_3.1.3/js/jquery.prettyPhoto.js"> &#160; </script>
        <script src="{$siteroot}js/script.js"> &#160; </script>

        <!-- CSS : implied media="all" -->
        <link rel="stylesheet" href="{$siteroot}stylesheets/css/reset.css"/>
        <link rel="stylesheet" href="{$siteroot}stylesheets/css/style.css"/>

        <script src="{$siteroot}plugins/jquery-ui-1.8.14.custom/js/jquery-ui-1.8.14.custom.min.js"> &#160; </script>
        
        <!--<script src="{$siteroot}js/plugins.js?v=1"> &#160; </script>-->
<xsl:if test="$pagetype = 'search'">
        <script src="{$siteroot}js/solr/people.json"> &#160; </script>
        <script src="{$siteroot}js/solr/places.json"> &#160; </script>
        <script src="{$siteroot}js/solr/author.json"> &#160; </script>
        <script src="{$siteroot}js/solr/year.json"> &#160; </script>
        <!--<script src="{$siteroot}js/script.js?v=1"> &#160; </script>-->
</xsl:if>

        <script type="text/javascript">
            
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-26037096-1']);
            _gaq.push(['_trackPageview']);
            
            (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
          
        </script>
        
        

      </head>

      <body>



        <div id="container">
          <div id="header">
            <h1>
              <a href="{$siteroot}"><span>The William F. Cody Archive:</span> Documenting the life and times of Buffalo Bill</a>
            </h1>
            <div id="nav">

              <ul class="nav_second">

                <li class="one">
                  <a href="{$siteroot}life/">
                    <strong>Life</strong>
                    <span>Biographies, Chronology, Encyclopedia, Personography</span>
                  </a>
                </li>

                <li class="two">
                  <a href="{$siteroot}topics/">
                    <strong>Topics</strong>
                    <span>Buffalo Bill Himself, Lakota Performers, Wild West in Britain, Congress of Rough Riders…</span>
                  </a>
                </li>

                <li class="three">
                  <a href="{$siteroot}scholarship/">
                    <strong>Scholarship</strong>
                    <span>Digital Research, Digital Scholarship, Monographs, Editions, Presentations, and Historiography</span>
                  </a>
                </li>


                <li class="four">
                  <a href="{$siteroot}community/">
                    <strong>Community</strong>
                    <span>Events, Links, Sharing</span>
                  </a>
                </li>


                <li class="five">
                  <a href="{$siteroot}texts/">
                    <strong>Texts</strong>
                    <span>Books, Correspondence, Newspapers, Periodicals, Records <!--Dime
                      Novels--></span>
                  </a>
                </li>
                <li class="six">
                  <a href="{$siteroot}images/">
                    <strong>Images</strong>
                    <span>Cabinet Cards, Illustrations, Photographs, Postcards, Posters, Visual Art</span>
                  </a>
                </li>

                <li class="seven">
                  <a href="{$siteroot}memorabilia/">
                    <strong>Memorabilia</strong>
                    <span>Programs, Postcards, Scrapbooks<!--, Route Books, Scrapbooks--></span>
                  </a>
                </li>


                <li class="eight">
                  <a href="{$siteroot}multimedia/">
                    <strong>Multimedia</strong>
                    <span>Audio, Video</span>
                  </a>
                </li>


              </ul>
              <ul class="nav_first">
                <li class="nav_search">
                  <a href="{$siteroot}search/">
                    <strong>Search</strong>
                  </a>
                </li>
                <li class="nav_about">
                  <a href="{$siteroot}about/">
                    <strong>About</strong>
                  </a>
                </li>
                <li class="nav_support">
                  <a href="{$siteroot}support/">
                    <strong>Support the Archive</strong>
                  </a>
                </li>
              </ul>




            </div>
          </div>

          <a href="{$siteroot}">
            <div id="logo">
              <span/>
            </div>
          </a>

          <div id="main">

<!--<xsl:value-of select="$pagetype"></xsl:value-of>--> <!-- zzz test remove later -kd  -->
            <!--<xsl:value-of select="$searchtype"></xsl:value-of>--> <!-- zzz test remove later -kd  -->
    <xsl:call-template name="mainContent"/> 


          </div>

          <div id="footer">

            <div class="logos">
              <p class="bbhc_logo">
                <a href="http://centerofthewest.org/">
                  <img src="{$siteroot}images/BB_Center_Logo.png"/>
                </a>
              </p>
              <p class="unl_logo">
                <a href="http://www.unl.edu/">
                  <img src="{$siteroot}images/front_logo_unl.gif"/>
                </a>
              </p>
            </div>

            <div class="support_footer">
              <p>Funding and support provided by the National Endowment for the Humanities, the
                Institute of Museum and Library Services, the Wyoming Community Foundation, Wyoming
                State Parks &amp; Cultural Resources, the Dellenback Family Foundation, Adrienne
                &amp; John Mars, and Naoma Tate &amp; the Family of Hal Tate.</p>
            </div>


            <span class="photo_credit">Banner image: Buffalo Bill Center of the West, Cody, Wyoming,
              U.S.A.; Original Buffalo Bill Museum Collection, P.69.118</span>

            <div class="footer_inner">

              <ul class="nav_first2">
                <li>
                  <a href="{$siteroot}search/">Search</a>
                </li>
                <li>
                  <a href="{$siteroot}about/">About</a>
                </li>
                <li>
                  <a href="{$siteroot}support/">Support the Archive</a>
                </li>
              </ul>

              <ul class="nav_second2">


                <li class="one">
                  <a href="{$siteroot}life/">
                    <strong>Life</strong>
                  </a>
                </li>

                <li class="two">
                  <a href="{$siteroot}topics/">
                    <strong>Topics</strong>
                  </a>
                </li>

                <li class="three">
                  <a href="{$siteroot}scholarship/">
                    <strong>Scholarship</strong>
                  </a>
                </li>


                <li class="four">
                  <a href="{$siteroot}community/">
                    <strong>Community</strong>
                  </a>
                </li>


                <li class="five">
                  <a href="{$siteroot}texts/">
                    <strong>Texts</strong>
                  </a>
                </li>
                <li class="six">
                  <a href="{$siteroot}images/">
                    <strong>Images</strong>
                  </a>
                </li>

                <li class="seven">
                  <a href="{$siteroot}memorabilia/">
                    <strong>Memorabilia</strong>
                  </a>
                </li>


                <li class="eight">
                  <a href="{$siteroot}multimedia/">
                    <strong>Multimedia</strong>
                  </a>
                </li>

              </ul>

<p class="copyright">The William F. Cody Archive, Buffalo Bill Center of the West and University of Nebraska-Lincoln. Published under a <a href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons License</a>.</p>

              <!-- <img src="images/unl_logo.gif"/> -->

            </div>



          </div>
          <!--! end of footer -->


        </div>
        <!--! end of #container -->



        <xsl:if test="unparsed-text-available(concat($siteroot,'js/',$pagetype,'.js'))">

          <script type="text/javascript" src="{concat($siteroot,'js/',$pagetype,'.js')}"><xsl:text>&#160;</xsl:text></script>
        </xsl:if>
      </body>
    </html>
                
            </xsl:otherwise>
        </xsl:choose>
        

  </xsl:template>
    
</xsl:stylesheet>
