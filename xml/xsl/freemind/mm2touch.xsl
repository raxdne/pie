<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
  <xsl:variable name="str_class" select="'default'"/>
<xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="file|pie">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="map">
    <xsl:element name="html">
      <xsl:element name="head">
      <xsl:element name="title">
        <xsl:value-of select="node/@TEXT"/>
      </xsl:element>
        <!-- -->
        <link href="http://fonts.googleapis.com/css?family=Roboto:100,400,700" rel="stylesheet" type="text/css"/>
        <!-- -->
        <xsl:element name="style">
          <xsl:attribute name="type">text/css</xsl:attribute>
          <xsl:text>
body {
  color:#ffffff;
  background-color:#111111;
  margin: 5px 5px 5px 5px;
  clear:both;
  font-size:14px;
  font-weight:400;
  line-height:1.5em;
  padding-bottom:.3em;
  padding-top:15px;
  font-family:Roboto, Arial, sans-serif;
}

div.default {
  margin: 5px 5px 5px 15px;
}
div.done {
  color:#FFFF66;
}
div.focus {
  color:#FFFF66;
  font-size:150%;
}

a.focus {
  color:#FFFF66;
  font-size:150%;
}
a.done {
  color:#FFFF66;
  font-size:100%;
}
</xsl:text>
        </xsl:element>
        <xsl:element name="script">
          <xsl:attribute name="type">text/javascript</xsl:attribute>
          <xsl:text>
function SwitchDisplayChilds(_this,strId) {

    // replace symbol at end of line
    var strDisplay = _this.lastChild.nodeValue;
    if (_this.getAttribute('class') == 'focus') {
        _this.setAttribute('class','done');
        _this.lastChild.nodeValue = strDisplay.replace(/ +\u25b2/,' \u25bc'); // ' \u2304'
    } 
    else {
        _this.setAttribute('class','focus');
        _this.lastChild.nodeValue = strDisplay.replace(/ +\u25bc/,' \u25b2'); // ' \u2303' ' \u25b2'
    }

    // switch display status of all childs
    var nodeTags = document.getElementById(strId).childNodes;
    for (i=0; i &lt; nodeTags.length; i++) {
	if (nodeTags[i].style.display=='none') {
	    nodeTags[i].style.display = 'block';
	}
	else {
	    nodeTags[i].style.display = 'none';
	}
    }
}
</xsl:text>
        </xsl:element>
      </xsl:element>
    <!-- -->
    <xsl:element name="body">
        <xsl:choose>
          <xsl:when test="not(node/@TEXT) or node/@TEXT=''">
            <xsl:apply-templates select="node/node"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="node"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="node">
    <xsl:element name="div">
      <xsl:choose>
        <xsl:when test="starts-with(@TEXT,'&lt;html&gt;')">
          <!-- node with HTML tags -->
          <xsl:element name="img">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
            <xsl:attribute name="src">
              <xsl:value-of select="substring-before(substring-after(@TEXT, '&lt;html&gt;&lt;img src=&quot;'),'&quot;&gt;')"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
        <xsl:when test="@LINK">
          <!-- node with a link -->
          <xsl:element name="div">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="@LINK"/>
              </xsl:attribute>
              <xsl:value-of select="@TEXT"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="child::node">
          <!-- node with childs -->
          <xsl:variable name="str_id" select="generate-id(.)"/>
          <xsl:element name="div">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="onclick">
                <xsl:value-of select="concat('javascript:','SwitchDisplayChilds(this,&quot;',$str_id,'&quot;)')"/>
              </xsl:attribute>
              <xsl:value-of select="concat(@TEXT,' ','&#x25bc;')"/>
            </xsl:element>
            <xsl:element name="div">
              <xsl:attribute name="id">
                <xsl:value-of select="$str_id"/>
              </xsl:attribute>
          <xsl:element name="div">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
                <xsl:if test="count(ancestor::*) &gt; 1">
                  <xsl:attribute name="style">
                    <xsl:value-of select="'display:none'"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- node without childs -->
          <xsl:element name="div">
              <xsl:attribute name="class">
                <xsl:value-of select="$str_class"/>
              </xsl:attribute>
              <xsl:attribute name="onclick">
                <xsl:value-of select="concat('javascript:','this.setAttribute(&quot;class&quot;,&quot;done&quot;)')"/>
              </xsl:attribute>
            <xsl:value-of select="@TEXT"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
