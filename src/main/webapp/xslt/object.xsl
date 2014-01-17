<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dsegraph='http://www.homermultitext.org/xmlns/dsegraph' version="1.0">

<xsl:import href="header.xsl"/>

<xsl:output encoding="UTF-8" indent="no" method="html"/>
<xsl:variable name="thisURL">@indices@</xsl:variable>
<xsl:variable name="ictURL">@ict@</xsl:variable>
<xsl:variable name="imgURL">@images@</xsl:variable>
<xsl:variable name="thumbSize">300</xsl:variable>

<xsl:template match="/">
		<html lang="en">
				<head>
						<meta charset="utf-8"/>
						<title>CITE Index</title>

						<link href="css/graph.css" rel="stylesheet"></link>
						<link href="css/steely.css" rel="stylesheet"></link>

									</head>
				<body>
						<h1>Relationships for <code><xsl:value-of select="//dsegraph:request/dsegraph:urn"/></code></h1>
								<div id="objects">
												<xsl:apply-templates select="//dsegraph:reply/dsegraph:graph/dsegraph:node" mode="img"/>
												<xsl:apply-templates select="//dsegraph:reply/dsegraph:graph/dsegraph:node" mode="show"/>
								</div>	

								<div id="texts">
								<xsl:apply-templates select="//dsegraph:reply/dsegraph:graph/dsegraph:sequence"/>
								</div>	

				</body>
		</html>
</xsl:template>


<xsl:template match="dsegraph:sequence">
		<h3>Text</h3>
		<div>
				<p><xsl:value-of select="@urn"/></p>
				<xsl:element name="blockquote">
						<xsl:attribute name="class">cite-cts svc-graph-cts</xsl:attribute>
						<xsl:attribute name="cite"><xsl:value-of select="@urn"/></xsl:attribute>
						<xsl:value-of select="@urn"/>
				</xsl:element>
				<ul>
				<xsl:apply-templates select="dsegraph:node" mode="list"/>
				</ul>
		</div>
</xsl:template>


<xsl:template match="dsegraph:node" mode="list">
		<!-- insert stuff for checking types here -->
		<li><xsl:value-of select="@type"/> :
				<xsl:if test="@type != 'data'">
				<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$thisURL"/>?urn=<xsl:value-of select="."/></xsl:attribute>
						find relations
				</xsl:element>
				</xsl:if>
				<xsl:element name="blockquote">
						<xsl:attribute name="class"></xsl:attribute>
						<xsl:attribute name="cite"><xsl:value-of select="."/></xsl:attribute>
						<xsl:value-of select="."/>
				</xsl:element>
		</li>
</xsl:template>

<xsl:template match="dsegraph:node" mode="img">
		<!-- insert stuff for checking types here -->
		<xsl:if test="contains(@v,'illust')">
		<h3><xsl:value-of select="@type"/></h3>
		<div>
				<xsl:element name="p">
						<xsl:value-of select="@v"/>
				</xsl:element>
				<xsl:element name="blockquote">
						<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$imgURL"/>?urn=<xsl:value-of select="."/>&amp;request=GetIIPMooViewer</xsl:attribute>
					<xsl:element name="img">
						<xsl:attribute name="src"><xsl:value-of select="$imgURL"/>?urn=<xsl:value-of select="."/>&amp;w=<xsl:value-of select="$thumbSize"/>&amp;request=GetBinaryImage</xsl:attribute>
						<xsl:attribute name="alt"><xsl:value-of select="."/></xsl:attribute>
					</xsl:element>
					</xsl:element>
					<br/>
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$ictURL"/>?urn=<xsl:value-of select="."/></xsl:attribute>
						Cite &amp; Quote Image
					</xsl:element>
				</xsl:element>
				<xsl:element name="blockquote">
						<xsl:attribute name="class"></xsl:attribute>
						<xsl:attribute name="cite"><xsl:value-of select="."/></xsl:attribute>
						<xsl:value-of select="."/>
				</xsl:element>
				<xsl:if test="@type != 'data'">
				<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$thisURL"/>?urn=<xsl:value-of select="."/></xsl:attribute>
						find relations
				</xsl:element>
				</xsl:if>
		</div>
		</xsl:if>
</xsl:template>

<xsl:template match="dsegraph:node" mode="show">
		<!-- insert stuff for checking types here -->
		<h3><xsl:value-of select="@type"/></h3>
		<div>
				<xsl:element name="p">
						<xsl:if test="(current()/@v = 'http://www.homermultitext.org/hmt/rdf/illustrates') and (contains(current()/@s,'@'))">
								<xsl:attribute name="id">
									<xsl:value-of select="$objectIdBase"/>
									<xsl:value-of select="position() - 1"/>
								</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@v"/>
				</xsl:element>
				<xsl:element name="blockquote">
						<xsl:attribute name="class"></xsl:attribute>
						<xsl:attribute name="cite"><xsl:value-of select="."/></xsl:attribute>
						<xsl:value-of select="."/>
				</xsl:element>
				<xsl:if test="@type != 'data'">
				<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="$thisURL"/>?urn=<xsl:value-of select="."/></xsl:attribute>
						find relations
				</xsl:element>
				</xsl:if>
		</div>
</xsl:template>

</xsl:stylesheet>
