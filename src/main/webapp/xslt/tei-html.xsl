<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:cts="http://chs.harvard.edu/xmlns/cts" xmlns:dc="http://purl.org/dc/elements/1.1" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ********************************************************** -->
	<!-- Include support for a handful of TEI namespaced elements   -->
	<!-- ********************************************************** -->
	<!-- poetry line -->
	<xsl:template match="tei:l">
		<p class="line">
			<span class="lineNumber">
				<xsl:value-of select="@n"/>
				<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
			</span>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<!-- fragments and columns for papyrus work -->
	<xsl:template match="tei:div[@type='frag']">
		<div class="fragment">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="tei:div[@type='col']">
		<div class="column">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- quotations -->
	<xsl:template match="tei:q">“<xsl:apply-templates/>”</xsl:template>
	<!-- "speech" and "speaker" (used for Platonic dialogues -->
	<xsl:template match="tei:speech">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="tei:speaker">
		<span class="speaker"><xsl:apply-templates/> — </span>
	</xsl:template>
	<!-- Div's of type "book" and "line-groups", both resolving to "Book" elements in xhtml, with the enumeration on the @n attribute -->
	<xsl:template match="tei:div[@type='book']">
		<div class="book">
			<span class="bookNumber">Book <xsl:value-of select="@n"/></span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="tei:lg">
		<div class="book">
			<span class="bookNumber">Book <xsl:value-of select="@n"/></span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- Editorial status: "unclear". Begin group of templates for adding under-dots through recursion -->
	<xsl:template match="tei:unclear">
		<span class="unclearText">
			<xsl:call-template name="addDots"/>
			<!-- <xsl:apply-templates/> -->
		</span>
	</xsl:template>
	<!-- A bit of recursion to add under-dots to unclear letters -->
	<xsl:template name="addDots">
		<xsl:variable name="currentChar">1</xsl:variable>
		<xsl:variable name="stringLength">
			<xsl:value-of select="string-length(text())"/>
		</xsl:variable>
		<xsl:variable name="myString">
			<xsl:value-of select="normalize-space(text())"/>
		</xsl:variable>
		<xsl:call-template name="addDotsRecurse">
			<xsl:with-param name="currentChar">
				<xsl:value-of select="$currentChar"/>
			</xsl:with-param>
			<xsl:with-param name="stringLength">
				<xsl:value-of select="$stringLength"/>
			</xsl:with-param>
			<xsl:with-param name="myString">
				<xsl:value-of select="$myString"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="addDotsRecurse">
		<xsl:param name="currentChar"/>
		<xsl:param name="myString"/>
		<xsl:param name="stringLength"/>
		<xsl:choose>
			<xsl:when test="$currentChar &lt;= string-length($myString)">
				<xsl:call-template name="addDotsRecurse">
					<xsl:with-param name="currentChar">
						<xsl:value-of select="$currentChar + 2"/>
					</xsl:with-param>
					<xsl:with-param name="stringLength">
						<xsl:value-of select="$stringLength + 1"/>
					</xsl:with-param>
					<!-- a bit of complexity here to put dots under all letters except spaces -->
					<xsl:with-param name="myString">
						<xsl:choose>
							<xsl:when test="substring($myString,$currentChar,1) = ' '">
								<xsl:value-of select="concat(substring($myString,1,$currentChar), ' ', substring($myString, ($currentChar+1),(string-length($myString) - ($currentChar))) )"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="concat(substring($myString,1,$currentChar), '&#803;', substring($myString, ($currentChar+1),(string-length($myString) - ($currentChar))) )"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$myString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- end under-dot recursion for "unclear" text -->
	<!-- Editorial status: "supplied" -->
	<!-- By default, wraps supplied text in angle-brackets -->
	<!-- Optionally, hide supplied text, replacing each character with non-breaking spaces, through recursion -->
	<xsl:template match="tei:supplied">
		<!-- Toggle between the two lines below depending on whether you want to show supplied text or not -->
		<!--<span class="suppliedText">&lt;<xsl:apply-templates/>&gt;</span>-->
		<span class="suppliedText"><xsl:call-template name="replaceSupplied"/></span>
	</xsl:template>
	<!-- begin replacing supplied text with non-breaking spaces -->
	<xsl:template name="replaceSupplied">
		<xsl:variable name="currentChar">1</xsl:variable>
		<xsl:variable name="stringLength">
			<xsl:value-of select="string-length(text())"/>
		</xsl:variable>
		<xsl:variable name="myString">
			<xsl:value-of select="normalize-space(text())"/>
		</xsl:variable>
		<xsl:call-template name="replaceSuppliedRecurse">
			<xsl:with-param name="currentChar">
				<xsl:value-of select="$currentChar"/>
			</xsl:with-param>
			<xsl:with-param name="stringLength">
				<xsl:value-of select="$stringLength"/>
			</xsl:with-param>
			<xsl:with-param name="myString">
				<xsl:value-of select="$myString"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="replaceSuppliedRecurse">
		<xsl:param name="currentChar"/>
		<xsl:param name="myString"/>
		<xsl:param name="stringLength"/>
		<xsl:choose>
			<xsl:when test="$currentChar &lt;= string-length($myString)">
				<xsl:call-template name="replaceSuppliedRecurse">
					<xsl:with-param name="currentChar">
						<xsl:value-of select="$currentChar + 2"/>
					</xsl:with-param>
					<xsl:with-param name="stringLength">
						<xsl:value-of select="$stringLength"/>
					</xsl:with-param>
					<xsl:with-param name="myString">
						<xsl:value-of select="concat(substring($myString,1,($currentChar - 1)),'&#160;&#160;',substring($myString, ($currentChar + 1)))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$myString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- end replacing supplied text with non-breaking spaces -->
	<xsl:template match="tei:add[@place='supralinear']">
		<span class="supralinearText">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:title">
		<span class="title">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:note">
		<!-- <span class="note">
			<xsl:apply-templates/>
		</span> -->
	</xsl:template>
	<xsl:template match="tei:add">
		<span class="addedText">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:choice">
		<span class="choice">(<xsl:apply-templates select="tei:sic"/><xsl:apply-templates select="tei:orig"/>
			<xsl:apply-templates select="tei:corr"/>)</span>
	</xsl:template>
	<xsl:template match="tei:sic">
		<span class="sic"><xsl:apply-templates/>[sic]</span>
		<!-- <xsl:if test="current()/following-sibling::tei:corr">/</xsl:if> -->
	</xsl:template>
	<xsl:template match="tei:orig">
		<span class="orig"><xsl:apply-templates/></span>
		<!-- <xsl:if test="current()/following-sibling::tei:corr">/</xsl:if> -->
	</xsl:template>
	<xsl:template match="tei:corr">
		<span class="corr">&#160;&#160;/&#160;&#160;<xsl:apply-templates/></span>
		<!-- <xsl:if test="current()/following-sibling::tei:sic">/</xsl:if> -->
	</xsl:template>
	<xsl:template match="tei:del">
		<span class="del">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:list">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<xsl:template match="tei:item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>
	<xsl:template match="tei:title">
		<span class="primaryTitle">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:head">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>
</xsl:stylesheet>
