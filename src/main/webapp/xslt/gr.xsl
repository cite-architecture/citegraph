<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:citeimg="http://chs.harvard.edu/xmlns/citeimg" exclude-result-prefixes="citeimg"
    version="1.0">
    
    <xsl:template match="/">
        
        <html lang="en">
            <head>
                <meta charset="utf-8" />
                <title>CITE Image · <xsl:value-of select="//citeimg:request/citeimg:urn"/></title>
                <link rel="stylesheet" href="css/normalize.css"></link>
                <link rel="stylesheet" href="css/simple.css"></link>
                
            </head>
            <body>
                
                <header>
                    <h1>CITE Image</h1>
                    <p>Request: <xsl:value-of select="//citeimg:request/citeimg:urn"/></p>
                </header>
                
                <article>
                    
                    <h1>Rights and licensing for <xsl:value-of select="//citeimg:request/citeimg:urn"/></h1>
                    
                    <p><xsl:value-of select="//citeimg:reply/citeimg:rights"/></p>
                    
                    
                </article>
                
                <footer>
                    <p>The Homer Multitext. Casey Dué &amp; Mary Ebbott, editors; Christopher Blackwell &amp; Neel Smith, project architects. The Center for Hellenic Studies 3100 Whitehaven Street, NW. Washington, DC 20008 202-745-4400. All data are copyrighted to their owners and licensed for non-commercial, scholarly use under a Creative Commons Attribution-Noncommercial-Share Alike License. All source-code is licensed under the General Public License. Material on this site is based upon work supported by the National Science Foundation under Grants No. 0916148 &amp; No. 0916421. Any opinions, findings and conclusions or recomendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation (NSF).</p>
                </footer>
                
            </body>
        </html>
        
        
        
    </xsl:template>
    
    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
