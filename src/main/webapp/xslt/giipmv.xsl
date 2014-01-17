<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:citeimg="http://chs.harvard.edu/xmlns/citeimg" exclude-result-prefixes="citeimg"
    version="1.0">
    
   
    <xsl:template match="/">
        <html>
            
            <head>
                <title><xsl:apply-templates select="//citeimg:id"></xsl:apply-templates>: zoomable image</title>
                
                <link rel="stylesheet" type="text/css" media="all" href="aias/iip-cite.css" />
                
                <script type="text/javascript" src="aias/mootools-1.2-core.js"></script>
                
                <script type="text/javascript" src="aias/mootools-1.2-more.js"></script>
                
                <script type="text/javascript" src="aias/iipmooviewer-cite.js"></script>
                
                
                
                <script type="text/javascript">
                    var server = "<xsl:value-of select="//citeimg:serverUrl/@val"/>";
                    var image = "<xsl:value-of select="//citeimg:imgPath/@val"/>";
                    var credit = "<xsl:value-of select="//citeimg:label"/>";
                    var roi = "<xsl:value-of select="//citeimg:reply/citeimg:roi/@val"/>";
                    var imgId = "<xsl:apply-templates select="//citeimg:id"/>";
                    var imgUrn = "<xsl:apply-templates select="//citeimg:urn"/>";
	                // left, top, width, height
                    // Create our viewer object - note: must assign this to the 'iip' variable
                    iip = new IIP( "targetframe", {
                    image: image,
                    imgId : imgId,
                    imgUrn : imgUrn,
                    server: server,
                    credit: credit, 
                    controls: false,
                    zoom: 1,
                    render: 'spiral',
                    citeROI: roi,
                    showNavButtons: true
                    });
                    
                </script>
                
            </head>
            
            <body>
                <p>URL base: <xsl:value-of select="//citeimg:serverUrl/@val"/></p>  
                <p>Image path: <xsl:value-of select="//citeimg:imgPath/@val"/></p>
                <p>Label: <xsl:apply-templates select="//citeimg:label"></xsl:apply-templates></p>
                <p>RoI: <xsl:apply-templates select="//citeimg:roi/@val"></xsl:apply-templates></p>
                
                <div style="width:99%;height:99%;margin-left:auto;margin-right:auto" id="targetframe"></div>
                
            </body>
        </html>
    </xsl:template>
   
</xsl:stylesheet>
