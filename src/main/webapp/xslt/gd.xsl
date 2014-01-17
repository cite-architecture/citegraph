<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:cts="http://chs.harvard.edu/xmlns/cts" xmlns:dc="http://purl.org/dc/elements/1.1" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="yes" method="html" encoding="UTF-8"/>
	<xsl:include href="chs_tei_to_html5.xsl"/>
	<xsl:include href="alternates.xsl"/>
	<!-- Framework for main body of document -->
	<xsl:template match="/">
		<!-- can some of the reply contents in xsl variables
			for convenient use in different parts of the output -->
		<xsl:variable name="urnString">
			<xsl:value-of select="//cts:request/cts:urn"/>
		</xsl:variable>
		
		
		<html>
			<head>
				
				<link
						href="css/normalize.css"
				rel="stylesheet"
				title="CSS for CTS"
				type="text/css"/>
				<link
						href="css/app.css"
					rel="stylesheet"
					title="CSS for CTS"
					type="text/css"/>
				
				<link
						href="css/chs_tei.css"
					rel="stylesheet"
					title="CSS for CTS"
					type="text/css"/>
				<link
						href="css/local.css"
					rel="stylesheet"
					title="CSS for CTS"
					type="text/css"/>
				<xsl:choose>
					<xsl:when
						test="/cts:CTSError">
						<title>Error</title>
					</xsl:when>
					<xsl:otherwise>
						<title><xsl:value-of
							select="//cts:reply/cts:description/cts:groupname"/>, <xsl:value-of
								select="//cts:reply/cts:description/cts:title"/> : <xsl:value-of
									select="//cts:reply/cts:description/cts:label"/>
						</title>
					</xsl:otherwise>
				</xsl:choose>
			</head>
			<body>
				
				
				<header>Ancient texts and translations for teaching and research.</header>
				<nav>
					<p>
						<a href="http://www.homermultitext.org/hmt-doc/">Canonical Text Services</a>
						:
						<a href="home">CTS Home</a>
						
					</p>
					
				</nav>
				
				<article>
					<xsl:choose>
						<xsl:when
							test="/cts:CTSError">
							<xsl:apply-templates
								select="cts:CTSError"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when
									test="//cts:request/cts:edition">
									<h1><xsl:value-of
										select="//cts:reply/cts:description/cts:groupname"/>, <em>
											<xsl:value-of
												select="//cts:reply/cts:description/cts:title"/>
										</em>: <xsl:value-of
											select="//cts:request/cts:psg"/>
									</h1>
									<h2>
										<xsl:value-of
											select="//cts:reply/cts:description/cts:label"/>
									</h2>
								</xsl:when>
								<xsl:when
									test="//cts:request/cts:translation">
									<h1>
										<xsl:value-of
											select="//cts:reply/cts:description/cts:groupname"/>, <em>
												<xsl:value-of
													select="//cts:reply/cts:description/cts:description/cts:title"/>
											</em>: <xsl:value-of
												select="//cts:request/cts:psg"/></h1>
									<h2>
										<xsl:value-of
											select="//cts:reply/cts:description/cts:label"/>
									</h2>
								</xsl:when>
								<xsl:when
									test="//cts:reply/cts:description/cts:title">
									<h1>
										<xsl:value-of
											select="//cts:reply/cts:description/cts:groupname"/>, <em>
												<xsl:value-of
													select="//cts:reply/cts:description/cts:title"/>: <xsl:value-of
														select="//cts:request/cts:psg"/>
											</em></h1>
									<h2>
										<xsl:value-of
											select="//cts:reply/cts:description/cts:label"/>
									</h2>
								</xsl:when>
								<xsl:when
									test="//cts:reply/cts:description/cts:groupname">
									<h1>
										<xsl:value-of
											select="//cts:reply/cts:description/cts:groupname"/>
									</h1>
									<h2>
										<xsl:value-of
											select="//cts:reply/cts:description/cts:label"/>
									</h2>
								</xsl:when>
							</xsl:choose>
							<p
								class="urn"> ( = <xsl:value-of
									select="$urnString"/> ) </p>
							<xsl:apply-templates
								select="//cts:reply"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</article>
				<footer>
					<p>This project enjoyed the support of the Andrew Mellon Foundation, the College of the Holy Cross, Furman University, and the Center for Hellenic Studies of Harvard University.</p>
					<p><xsl:value-of
						select="//cts:versionInfo"/></p>
				</footer>
			</body>
		</html>
	</xsl:template>
	<!-- End Framework for main body document -->
	<!-- Match elements of the CTS reply -->
	<xsl:template match="cts:reply">
		<!--<xsl:if test="(@xml:lang = 'grc') or (@xml:lang = 'lat')">
			<div class="chs-alphaios-hint">Because this page has Greek or Latin text on it, it can take advantage of the morphological and lexical tools from the <a href="http://alpheios.net/" target="blank">Apheios Project</a>.</div>
		</xsl:if>-->
		<xsl:element name="div">
			<xsl:attribute name="lang">
				<xsl:value-of select="@xml:lang"/>
			</xsl:attribute>
			<xsl:if test="(//cts:reply/@xml:lang = 'grc') or (//cts:reply/@xml:lang = 'lat')">
				<xsl:attribute name="class">cts-content alpheios-enabled-text</xsl:attribute>
			</xsl:if>		
			
			<!-- This is where we will catch TEI markup -->
			<xsl:apply-templates/>
			<!-- ====================================== -->
			
		</xsl:element>
	</xsl:template>
	<xsl:template match="cts:CTSError">
		<h1>CTS Error</h1>
		<p class="cts:error">
			<xsl:apply-templates select="cts:message"/>
		</p>
		<p>Error code: <xsl:apply-templates select="cts:code"/></p>
		<p>Error code: <xsl:apply-templates select="cts:code"/></p>
		<p>CTS library version: <xsl:apply-templates select="cts:libraryVersion"/>
		</p>
		<p>CTS library date: <xsl:apply-templates select="cts:libraryDate"/>
		</p>
	</xsl:template>
	<xsl:template
		match="cts:contextinfo">
		<xsl:variable
			name="ctxt">
			<xsl:value-of
				select="cts:context"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when
				test="$ctxt > 0"> 
				
				<div
					class="prevnext">
					<span
						class="prv">
						<xsl:choose>
							<xsl:when
								test="//cts:inv">
								<xsl:variable
									name="inv">
									<xsl:value-of
										select="//cts:inv"/>
								</xsl:variable>
								<xsl:variable
									name="prvVar">./images?inv=<xsl:value-of
										select="$inv"/>&amp;request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
											select="cts:contextback"/>&amp;context=<xsl:value-of select="$ctxt"/></xsl:variable>
								<xsl:element
									name="a">
									<xsl:attribute
										name="href">
										<xsl:value-of
											select="$prvVar"/>
									</xsl:attribute> back </xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable
									name="prvVar">./images?request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
										select="cts:contextback"/>&amp;context=<xsl:value-of select="$ctxt"/></xsl:variable>
								<xsl:element
									name="a">
									<xsl:attribute
										name="href">
										<xsl:value-of
											select="$prvVar"/>
									</xsl:attribute> back </xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</span>| <span
						class="nxt">
						<xsl:choose>
							<xsl:when
								test="//cts:inv">
								<xsl:variable
									name="inv">
									<xsl:value-of
										select="//cts:inv"/>
								</xsl:variable>
								<xsl:variable
									name="nxtVar">./images?inv=<xsl:value-of
										select="$inv"/>&amp;request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
											select="cts:contextforward"/>&amp;context=<xsl:value-of select="$ctxt"/></xsl:variable>
								<xsl:element
									name="a">
									<xsl:attribute
										name="href">
										<xsl:value-of
											select="$nxtVar"/>
									</xsl:attribute> forward </xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable
									name="nxtVar">./images?request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
										select="cts:contextforward"/>&amp;context=<xsl:value-of select="$ctxt"/></xsl:variable>
								<xsl:element
									name="a">
									<xsl:attribute
										name="href">
										<xsl:value-of
											select="$nxtVar"/>
									</xsl:attribute> forward </xsl:element>
							</xsl:otherwise>
						</xsl:choose>
						
					</span>
				</div>
				
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template
		match="cts:prevnext">
		<xsl:variable
			name="ctxt">
			<xsl:value-of
				select="//cts:context"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when
				test="$ctxt > 0">
				<!-- Do nothing! -->
			</xsl:when>
			<xsl:otherwise>
				<div
					class="prevnext">
					<span
						class="prv">
						<xsl:if
							test="cts:prev != ''">
							<xsl:choose>
								<xsl:when
									test="//cts:inv">
									<xsl:variable
										name="inv">
										<xsl:value-of
											select="//cts:inv"/>
									</xsl:variable>
									<xsl:variable
										name="prvVar">./images?inv=<xsl:value-of
											select="$inv"/>&amp;request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
												select="cts:prev"/></xsl:variable>
									<xsl:element
										name="a">
										<xsl:attribute
											name="href">
											<xsl:value-of
												select="$prvVar"/>
										</xsl:attribute> prev </xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable
										name="prvVar">./images?request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
											select="cts:prev"/></xsl:variable>
									<xsl:element
										name="a">
										<xsl:attribute
											name="href">
											<xsl:value-of
												select="$prvVar"/>
										</xsl:attribute> prev </xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</span> | <span
						class="nxt">
						<xsl:if
							test="cts:next != ''">
							<xsl:choose>
								<xsl:when
									test="//cts:inv">
									<xsl:variable
										name="inv">
										<xsl:value-of
											select="//cts:inv"/>
									</xsl:variable>
									<xsl:variable
										name="nxtVar">./images?inv=<xsl:value-of
											select="$inv"/>&amp;request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
												select="cts:next"/></xsl:variable>
									<xsl:element
										name="a">
										<xsl:attribute
											name="href">
											<xsl:value-of
												select="$nxtVar"/>
										</xsl:attribute> next </xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable
										name="nxtVar">./images?request=GetPassagePlus&amp;withXSLT=chs-gp&amp;urn=<xsl:value-of
											select="cts:next"/></xsl:variable>
									<xsl:element
										name="a">
										<xsl:attribute
											name="href">
											<xsl:value-of
												select="$nxtVar"/>
										</xsl:attribute> next </xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</span>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Default: replicate unrecognized markup -->
	<xsl:template match="@*|node()" priority="-1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
