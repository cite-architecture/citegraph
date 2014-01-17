<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dsegraph="http://www.homermultitext.org/xmlns/dsegraph" version="1.0">
    <xsl:import href="header.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="html"/>
    
    <!-- Variables for CSS Classes and HTML IDs -->
    <xsl:variable name="canvasId">canvas</xsl:variable>
    <xsl:variable name="rectClass">cite_rect</xsl:variable>
    <xsl:variable name="rectIdBase">cite_rect_</xsl:variable>
    <xsl:variable name="objClass">cite_obj</xsl:variable>
    <xsl:variable name="objIdBase">cite_obj_</xsl:variable>
    <xsl:variable name="seqClass">cite_sequence</xsl:variable>
    <xsl:variable name="pairClass">cite_pair</xsl:variable>
    <xsl:variable name="roiLabelClass">cite_label</xsl:variable>
    
    <!-- Variables for URLs of services, images, etc. -->
    <xsl:variable name="imgURL">http://beta.hpcc.uh.edu/tomcat/hmt/images</xsl:variable>
    <xsl:variable name="ictURL">http://beta.hpcc.uh.edu/tomcat/hmt/ict/html</xsl:variable>
    <xsl:variable name="imageThumbURL"><xsl:value-of select="$imgURL"
        />?request=GetBinaryImage&amp;w=600&amp;urn=</xsl:variable>
    <xsl:variable name="imageGIPUrl"><xsl:value-of select="$imgURL"
        />?request=GetImagePlus&amp;urn=</xsl:variable>
    
    <!-- Variables from source XML -->
    <xsl:variable name="imageURN">
        <xsl:value-of select="//dsegraph:request/dsegraph:urn"/>
    </xsl:variable>
   
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="utf-8"/>
                <title>CITE Index</title>
                <link href="css/steely.css" rel="stylesheet"/>
                <link href="css/graph.css" rel="stylesheet"/>
                <link href="css/visinv.css" rel="stylesheet"/>
                <script src="js/jquery-1.9.1.js"/>
                <script>
							var img_source = "<xsl:value-of select="$imageThumbURL"/><xsl:value-of select="$imageURN"/>";
							var canvasId = "<xsl:value-of select="$canvasId"/>";
							var mapArray = new Array();
							var groupArray = new Array();
							var rectClass = "<xsl:value-of select="$rectClass"/>";
                            var rectIdBase = "<xsl:value-of select="$rectClass"/>";
                            var objectClass = "<xsl:value-of select="$objClass"/>";
                            var objectIdBase = "<xsl:value-of select="$objIdBase"/>";
                            var seqClass = "<xsl:value-of select="$seqClass"/>";
                            var pairClass = "<xsl:value-of select="$pairClass"/>";
							
				</script>
                <script src="js/visinv.js" type="text/javascript"/>
            </head>
            <body>
                <div id="rightDiv">
                    <div id="texts">
                        <xsl:apply-templates
                            select="//dsegraph:reply/dsegraph:graph/dsegraph:sequence"/>
                    </div>
                    <div id="objects">
                        <xsl:apply-templates select="//dsegraph:reply/dsegraph:graph/dsegraph:node"
                            />
                    </div>
                   
                </div>
                <div id="leftDiv">
                    <p>Relationships for <code><xsl:value-of
                        select="//dsegraph:request/dsegraph:urn"/></code></p>
                    <xsl:call-template name="makeCanvas"/>
                    
                </div>
                <xsl:call-template name="citekit-sources"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="makeCanvas">
        <xsl:element name="canvas">
            <xsl:attribute name="id">
                <xsl:value-of select="$canvasId"/>
            </xsl:attribute>
            <xsl:attribute name="width">800</xsl:attribute>
            <xsl:attribute name="height">1000</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="dsegraph:sequence">
      <xsl:variable name="thisSeqId"><xsl:value-of select="generate-id(.)"/></xsl:variable>
        <div class="toggler">
        <xsl:element name="a">
            <xsl:attribute name="id">toggle_<xsl:value-of select="$thisSeqId"/></xsl:attribute>
            <xsl:attribute name="onclick">toggleThis("<xsl:value-of select="$thisSeqId"/>")</xsl:attribute>
            Show/Hide
        </xsl:element>
        
      <xsl:element name="div">
          <xsl:attribute name="class">
              <xsl:value-of select="$seqClass"/>
              
          </xsl:attribute>
          <xsl:attribute name="id"><xsl:value-of select="$thisSeqId"/></xsl:attribute>
          <p><strong><xsl:value-of select="@urn"/></strong></p>
          <xsl:apply-templates select="dsegraph:node" mode="visinv-text">
              <xsl:with-param name="seqId"><xsl:value-of select="$thisSeqId"/></xsl:with-param>
          </xsl:apply-templates>
      </xsl:element>
        </div>
    </xsl:template>
    
    <xsl:template match="dsegraph:node" mode="visinv-obj">
        
    </xsl:template>
    
    <xsl:template match="dsegraph:node" mode="visinv-text">
        <!-- The following variable will associate the object with the bounding rectangle -->
        <xsl:variable name="thisId"><xsl:value-of select="generate-id()"/></xsl:variable>
        
        <!-- Test that this is an "illustrates" relationship, and that the subject has an ROI -->
        <xsl:if
                test="(current()/@v = 'http://www.homermultitext.org/cite/rdf/illustrates') and (contains(current()/@s,'@'))">
                <!-- The Div of type "pair" holds an object and its ROI -->
                <xsl:element name="div">
                    <xsl:attribute name="id"><xsl:value-of select="$thisId"/></xsl:attribute>
                        <xsl:attribute name="class"><xsl:value-of select="$pairClass"/></xsl:attribute>
                    <xsl:element name="div"> <!-- The ROI rectangle -->
                        <xsl:attribute name="class"><xsl:value-of select="$rectClass"/></xsl:attribute>
                        <xsl:attribute name="id"><xsl:value-of select="$rectIdBase"/><xsl:value-of select="$thisId"/></xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class"><xsl:value-of select="$roiLabelClass"/></xsl:attribute>
                            <xsl:value-of select="@s"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="div"> <!-- The object illustrated by the ROI -->
                        <xsl:attribute name="class"><xsl:value-of select="$objClass"/></xsl:attribute>
                        <xsl:attribute name="id"><xsl:value-of select="$objIdBase"/><xsl:value-of select="$thisId"/></xsl:attribute>
                        <xsl:value-of select="."/>
                       
                    </xsl:element>
                </xsl:element>
         </xsl:if>
    </xsl:template>
    
    <xsl:template match="dsegraph:node" mode="show">
        <div>
        
        </div>
    </xsl:template>
    
    
    
    <xsl:template name="citekit-sources">
        <div id="citekit-additional-sources">
            <p class="citekit-additional-source cite-cts" id="svc-graph-cts"
                >http://beta.hpcc.uh.edu/tomcat/hmt/texts?request=GetPassagePlus&amp;urn=</p>
            <p class="citekit-additional-source cite-img" id="svc-graph-img"
                >http://beta.hpcc.uh.edu/tomcat/hmt/images?request=GetImagePlus&amp;urn=</p>
            <p class="citekit-additional-source cite-coll" id="svc-graph-coll"/>
        </div>
    </xsl:template>
    
    
    
</xsl:stylesheet>
