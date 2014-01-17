<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- This stylesheet includes templates for handling all TEI elements used in CHS diplomatic editions. -->
    
    <xsl:template match="tei:add">
        <span class="tei_add">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:bibl">
        <!-- Check for xml:lang -->
        <xsl:element name="span">
            <xsl:attribute name="class">tei_bibl</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:choice">
        <span class="tei_choice">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:cit">
        <!-- Check for xml:lang -->
        <xsl:element name="blockquote">
            <xsl:attribute name="class">tei_cit</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:corr">
        <span class="tei_corr">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:del">
        <span class="tei_del">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:div">
        <!-- Check for xml:lang -->
        <xsl:choose>
            <xsl:when test="@type='book'">
                <div class="div_book">
                    <p class="citation_value">
                        <xsl:value-of select="@n"/>
                    </p>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@type='chapter'">
                <div class="div_book">
                    <p class="citation_value">
                        <xsl:value-of select="@n"/>
                    </p>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@type='section'">
                <div class="div_section">
                    <p class="citation_value">
                        <xsl:value-of select="@n"/>
                    </p>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="div">
                    <xsl:if test="@type">
                        <xsl:attribute name="class">tei_<xsl:value-of select="@type"
                            /></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@n">
                        <p class="tei_n">
                            <xsl:value-of select="@n"/>
                        </p>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:abbr">
        <span class="tei_abbr">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:expan">
        <span class="tei_expan">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:foreign">
        <!-- xml:lang required -->
        <xsl:element name="span">
            <xsl:attribute name="class">tei_foreign</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:gap">
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="@unit = 'line'">
                    <xsl:attribute name="class">tei_gap unit_line</xsl:attribute>
                </xsl:when>
                <xsl:when test="@unit = 'character'">
                    <xsl:attribute name="class">tei_gap unit_char</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">tei_gap</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose> &#160;<xsl:value-of select="@extent"/>&#160; </xsl:element>
    </xsl:template>
    <xsl:template match="tei:head">
        <!-- Check for xml:lang -->
        <xsl:element name="div">
            <xsl:attribute name="class">tei_head</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:l">
        <p class="tei_l">
            <span class="citation_value">
                <!-- @n for citation required -->
                <xsl:value-of select="@n"/>
            </span>
            <xsl:apply-templates/>
        </p>
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
    <xsl:template match="tei:lg">
        <div class="tei_lg">
            <span class="citation_value">
                <!-- @n for citation required -->
                <xsl:value-of select="@n"/>
            </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:note">
        <!-- Check for xml:lang -->
        <xsl:element name="span">
            <xsl:attribute name="class">tei_note</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:num">
        <span class="tei_num">
            <xsl:apply-templates/>
            <xsl:if test="@value">
                <span class="num_value">
                    <xsl:value-of select="@value"/>
                </span>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:q">
        <!-- Check for xml:lang -->
        <xsl:element name="span">
            <xsl:attribute name="class">tei_q</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <br/><span class="tei_pb"><xsl:value-of select="@n"/></span><br/>
    </xsl:template>

    <xsl:template match="tei:lb"><span class="tei_lb"/></xsl:template>
    

    <xsl:template match="tei:quote">
        <!-- Check for xml:lang -->
        <xsl:element name="span">
            <xsl:attribute name="class">tei_quote</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:seg">
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="@type='word'">
                    <xsl:attribute name="class">chs_word</xsl:attribute>
                </xsl:when>
                <xsl:when test="@type='verse'">
                    <xsl:attribute name="class">chs_verse</xsl:attribute>
                    <span class="citation_value">
                        <!-- @n for citation required -->
                        <xsl:value-of select="@n"/>
                    </span>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:attribute name="class">unrecognized_seg</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:sic">
        <xsl:element name="span">
            <xsl:attribute name="class">tei_sic</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:choose>
                <xsl:when test="@reason='lost'">
                    <xsl:attribute name="class">tei_supplied reason_lost</xsl:attribute>
                </xsl:when>
                <xsl:when test="@reason='omitted'">
                    <xsl:attribute name="class">tei_supplied reason_omitted</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">tei_supplied unrecognized_reason</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Toggle comments between the two following lines -->
            <xsl:call-template name="replaceSupplied"/>
            <!-- <xsl:apply-templates/> -->
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:sp">
        <p class="tei_sp">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:speaker">
        <p class="tei_speaker">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:element name="span">
            <xsl:attribute name="class">tei_unclear</xsl:attribute>
            <xsl:call-template name="addDots"/>
            <!-- <xsl:apply-templates/> -->
        </xsl:element>
    </xsl:template>
    <!-- Below is the standard template for "copy verbatim everything not otherwise caught" -->
    <xsl:template match="node()" priority="-1">
        <span class="unrecognized">
            <xsl:apply-templates/>
        </span>
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
                        <xsl:value-of
                            select="concat(substring($myString,1,($currentChar - 1)),'&#160;&#160;',substring($myString, ($currentChar + 1)))"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$myString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- end replacing supplied text with non-breaking spaces -->
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
                                <xsl:value-of
                                    select="concat(substring($myString,1,$currentChar), ' ', substring($myString, ($currentChar+1),(string-length($myString) - ($currentChar))) )"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat(substring($myString,1,$currentChar), '&#803;', substring($myString, ($currentChar+1),(string-length($myString) - ($currentChar))) )"
                                />
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
</xsl:stylesheet>
