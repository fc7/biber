<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:bcf="https://sourceforge.net/projects/biblatex"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs xsl bcf"
                version="1.0">

  <!-- Use strict Doctype otherwise IE7 is too stupid to do tables correctly -->
  <xsl:output method="html" 
              media-type="text/html" 
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              indent="yes"
              encoding="UTF-8"/>

  <xsl:template name="generate-string">
    <xsl:param name="text"/>
    <xsl:param name="count"/>

    <xsl:choose>
      <xsl:when test="string-length($text) = 0 or $count &lt;= 0"/>
      <xsl:otherwise>
	<xsl:value-of select="$text"/>
	<xsl:call-template name="generate-string">
	  <xsl:with-param name="text" select="$text"/>
	  <xsl:with-param name="count" select="$count - 1"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>BibLaTeX control file</title>
        <style type="text/css">
          .sortitem_final {
            color: red;
          }
          .sort_label {
            background-color: #D0D0D0;
          }
          .sort_padding {
            color: #88BBEE;
          }
          .sort_substring {
            color: #FF9933;
          }
          .options_table_value {
            font-family: "Courier New", Courier, monospace;
          }
        </style>
        <script type="text/javascript">
          <![CDATA[
          ]]>
        </script>
      </head>
      <body>
        <h2><tt>BibLaTeX</tt> Control File (format version: <xsl:value-of select="/bcf:controlfile/@version"/>)</h2>
        <!-- OPTIONS -->
        <xsl:for-each select="/bcf:controlfile/bcf:options">
          <div class="options_header">&quot;<xsl:value-of select="./@type"/>&quot; options for <tt><xsl:value-of select="./@component"/></tt></div>
          <table class="options_table">
            <thead>
              <tr><td>Option</td><td>Value</td></tr>
            </thead>
            <tbody>
              <xsl:for-each select="./bcf:option">
                <xsl:choose>
                  <xsl:when test="./@type='singlevalued'">
                    <tr>
                    <td><xsl:value-of select="./bcf:key/text()"/></td>
                    <td class="options_table_value"><xsl:value-of select="./bcf:value/text()"/></td>
                    </tr>
                  </xsl:when>
                  <xsl:when test="./@type='multivalued'">
                    <tr>
                      <td class="options_table_value"><xsl:value-of select="./bcf:key/text()"/></td>
                      <td><xsl:for-each select="./bcf:value">
                        <xsl:sort select="./@order"/>
                        <xsl:value-of select="./text()"/><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </xsl:for-each></td>
                    </tr>
                  </xsl:when>
                </xsl:choose>                
              </xsl:for-each>
            </tbody>
          </table>
        </xsl:for-each>
        <!-- SORTING -->
        <xsl:for-each select="/bcf:controlfile/bcf:sorting">
          <div class="sorting_header">&quot;<xsl:value-of select="./@type"/>&quot; sorting options</div>
          <table class="sorting_table">
            <tbody>
              <tr>
                <xsl:for-each select="./bcf:sort">
                  <xsl:sort select="./@order"/>
                  <td valign="top">
                    <xsl:if test="./@pass = 'label'">
                      <xsl:attribute name="class">sort_label</xsl:attribute>
                    </xsl:if>
                    <xsl:for-each select="./bcf:sortitem">
                      <xsl:sort select="./@order"/>
                      <span>
                        <xsl:if test="./@final = '1'">
                          <xsl:attribute name="class">sortitem_final</xsl:attribute>
                        </xsl:if>
                        <!-- left padding -->
                        <xsl:if test="./@pad_side = 'left'">
                          <span class="sort_padding">
                            <xsl:call-template name='generate-string'>
                              <xsl:with-param name='text'><xsl:value-of select="./@pad_char"/></xsl:with-param>
                              <xsl:with-param name='count' select='./@pad_width'/>
                            </xsl:call-template>
                          </span>
                        </xsl:if>
                        <!-- left substring -->
                        <xsl:if test="./@substring_side = 'left'">
                          <span class="sort_substring">
                            <xsl:call-template name='generate-string'>
                              <xsl:with-param name='text'>&gt;</xsl:with-param>
                              <xsl:with-param name='count' select='./@substring_width'/>
                            </xsl:call-template>
                          </span>
                        </xsl:if>
                        <xsl:value-of select="./text()"/>
                        <!-- right padding -->
                        <xsl:if test="./@pad_side = 'right'">
                          <span class="sort_padding">
                            <xsl:call-template name='generate-string'>
                              <xsl:with-param name='text'><xsl:value-of select="./@pad_char"/></xsl:with-param>
                              <xsl:with-param name='count' select='./@pad_width'/>
                            </xsl:call-template>
                          </span>
                        </xsl:if>
                        <!-- right substring -->
                        <xsl:if test="./@substring_side = 'right'">
                          <span class="sort_substring">
                            <xsl:call-template name='generate-string'>
                              <xsl:with-param name='text'>&lt;</xsl:with-param>
                              <xsl:with-param name='count' select='./@substring_width'/>
                            </xsl:call-template>
                          </span>
                        </xsl:if>
                      </span>
                      <xsl:choose>
                        <xsl:when test="./@sort_direction = 'ascending'">
                          <xsl:text disable-output-escaping="yes">&amp;uarr;</xsl:text>
                        </xsl:when>
                        <xsl:when test="./@sort_direction = 'descending'">
                          <xsl:text disable-output-escaping="yes">&amp;darr;</xsl:text>
                        </xsl:when>
                      </xsl:choose>
                      <br/>
                    </xsl:for-each>
                  </td>
                </xsl:for-each>
              </tr>
            </tbody>
          </table>
        </xsl:for-each>
        <xsl:if test="/bcf:controlfile/bcf:structure">
          <div class="structure_header">Data structure</div>
          <div>Legal entrytypes</div>
          <table class="entrytype_table">
            <tbody>
              <xsl:for-each select="/bcf:controlfile/bcf:structure/bcf:entrytypes/bcf:entrytype">
                <tr>
                  <td><xsl:value-of select="./text()"/></td>
                  <xsl:for-each select="/bcf:controlfile/bcf:structure/bcf:aliases/bcf:alias[@type = 'entrytype']/bcf:realname[./text() = current()/text()]">
                    <td><xsl:value-of select="parent()/bcf:name/text()"/></td>
                  </xsl:for-each>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
