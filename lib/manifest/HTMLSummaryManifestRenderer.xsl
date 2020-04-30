<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="hostName" select="/CONSIGNMENTBATCH/HOST" />

  <xsl:output method="html" version="4.0" />

  <xsl:variable name="resourcesDir"></xsl:variable>
  <xsl:variable name="cons-per-page" select="10" />
  <xsl:variable name="total-no-pages" select="string(ceiling(count(/CONSIGNMENTBATCH/CONSIGNMENT) div $cons-per-page))" />
  <xsl:variable name="empty-row">
    <tr>
      <td>&#160;</td><td>&#160;</td><td>&#160;</td><td>&#160;</td><td>&#160;</td><td>&#160;</td><td>&#160;</td><td>&#160;</td>
    </tr>
  </xsl:variable>
  <xsl:variable name="column-dimensions">
    <tr>
      <td width="72"></td>
      <td width="40"></td>
      <td width="48"></td>
      <td width="48"></td>
      <td width="96"></td>
      <td width="96"></td>
      <td width="96"></td>
      <td width="104"></td>
    </tr>
  </xsl:variable>

  <xsl:template match="/">

    <html>
      <head>
        <title>TNT Manifests</title>
        <style>
          td{
   			padding: 0px;
		  }

		  tr{
			line-height: 12px;
		  }
          font.data {
            color : black;
            background-color : white;
            font-family : arial, helvetica, "sans-serif";
            font-size : 6pt;
          }

          font.field {
            color : black;
            background-color : white;
            font-weight : bold;
            font-family : arial, helvetica, "sans-serif";
            font-size : 6pt;
          }

          font.title {
            color : black;
            background-color : white;
            font-weight : bold;
            font-family : arial, helvetica, "sans-serif";
            font-size : 9pt;
            text-decoration:underline;
          }

          @page {orientation:portrait;}

          div.print {
            position: relative;
            top: 10px;
            visibility: visible;
          }

          div.browser {
            position: absolute;
            top: 10px;
            visibility: visible;
          }

        </style>

        <script type="text/javascript">

          function prePrint() {
              document.getElementById('print').style.visibility = 'visible';
              document.getElementById('summary').style.visibility = 'hidden';
          }

          function postPrint() {
              document.getElementById('print').style.visibility = 'hidden';
              document.getElementById('summary').style.visibility = 'visible';
          }

        </script>

      </head>

      <body onBeforePrint="prePrint();" onAfterPrint="postPrint();">

        <xsl:comment>
          Essentially two seperate HTML pages will be created, one for normal browser display, and one
          to be printed out, with the header and footer, and a maximum of $cons-per-page on each page.
          Two seperate DIV elements will be created, one or other will be shown, depending upon
          whether or not the manifest is being printed.
        </xsl:comment>

        <xsl:apply-templates select="CONSIGNMENTBATCH" mode="print" />
      </body>
    </html>

  </xsl:template>

  <xsl:template match="CONSIGNMENTBATCH" mode="print">

    <xsl:comment>
      This is the root template for creating the print view.
      The individual pages use the CONSIGNMENTBATCH template in page mode/
    </xsl:comment>

    <xsl:element name="div">
      <xsl:attribute name="id">print</xsl:attribute>
      <xsl:attribute name="class">print</xsl:attribute>

      <xsl:apply-templates select="." mode="page" />

    </xsl:element>

  </xsl:template>

  <xsl:template match="CONSIGNMENTBATCH" mode="page">

    <xsl:param name="page-no" select="number(1)" />

    <xsl:comment>
      Divide the number of CONSIGNMENT elements by 10, to display the number per page
    </xsl:comment>

    <xsl:element name="div">
      <xsl:choose>
        <xsl:when test="$page-no = $total-no-pages">
          <xsl:attribute name="style">page-break-after: avoid</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="style">page-break-after: always</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <table cellpadding="2" cellspacing="3" border="0" width="600">
        <xsl:apply-templates select="HEADER">
          <xsl:with-param name="page-no" select="$page-no" />
        </xsl:apply-templates>

		<xsl:apply-templates select="CONSIGNMENT[1]/HEADER">
          <xsl:with-param name="page-no" select="$page-no" />
        </xsl:apply-templates>


       <xsl:apply-templates select="CONSIGNMENT[((position() - 1) &lt; ($cons-per-page * number($page-no))) and (position() &gt; ($cons-per-page * (number($page-no) - 1 )))]"/>

        <tr>
          <td colspan="8"><hr width="100%" noshade="true" /></td>
        </tr>

        <xsl:if test="$total-no-pages = $page-no">
          <xsl:call-template name="totals-and-sign-off" />
        </xsl:if>

        <xsl:call-template name="footer" />

      </table>

    </xsl:element>

    <xsl:if test="$page-no &lt; $total-no-pages">
      <xsl:apply-templates select="." mode="page">
        <xsl:with-param name="page-no" select="string(number($page-no) + 1)" />
      </xsl:apply-templates>
    </xsl:if>

  </xsl:template>

  <xsl:template match="CONSIGNMENTBATCH" mode="browser">

    <xsl:comment>
      This template will go through all of the consignments in one go as there is no need for individual pages
    </xsl:comment>

    <xsl:element name="div">
      <xsl:attribute name="id">summary</xsl:attribute>
      <xsl:attribute name="class">browser</xsl:attribute>

      <table cellpadding="2" cellspacing="3" border="0" width="600">
        <xsl:apply-templates select="HEADER">
          <xsl:with-param name="page-no" select="string('1')" />
        </xsl:apply-templates>

		 <xsl:apply-templates select="CONSIGNMENT[1]/HEADER">
          <xsl:with-param name="page-no" select="string('1')" />
        </xsl:apply-templates>

        <xsl:apply-templates select="CONSIGNMENT" />

        <tr>
          <td colspan="8"><hr width="100%" noshade="true" /></td>
        </tr>

        <xsl:call-template name="totals-and-sign-off" />

        <xsl:call-template name="footer" />

      </table>

    </xsl:element>

  </xsl:template>

  <xsl:template match="HEADER">

    <xsl:param name="page-no" />

    <xsl:copy-of select="$column-dimensions"/>
    <tr>
      <td colspan="6" align="center">
        <font class="title">COLLECTION MANIFEST (SUMMARY)<br /></font>
      </td>
      <td colspan="2">
      	<xsl:comment>
        <img src="{$resourcesDir}images/logo-small.gif" align="right"/>
        </xsl:comment>
        <img src="https://express.tnt.com/expresswebservices-website/rendering/images/logo-small.gif" align="right"/>
      </td>
    </tr>

    <tr>
      <td colspan="2"><font class="field">Sender Account</font></td>
      <td colspan="5"><font class="data">: <xsl:value-of select="SENDER/ACCOUNT"/></font></td>
      <td align="right"><font class="field">Page</font><font class="data">: <xsl:value-of select="$page-no" /> of <xsl:value-of select="$total-no-pages"/></font></td>
    </tr>
    <tr>
      <td colspan="2"><font class="field">Sender Name</font></td>
      <td colspan="6"><font class="data">: <xsl:value-of select="SENDER/COMPANYNAME"/></font></td>
    </tr>
    <tr>
      <td colspan="2"><font class="field">&amp; Address</font></td>
      <td colspan="5"><font class="data">: <xsl:value-of select="SENDER/STREETADDRESS1" />, <xsl:value-of select="SENDER/STREETADDRESS2" />, <xsl:if test="SENDER/STREETADDRESS3/text()"><xsl:value-of select="SENDER/STREETADDRESS3"/>, </xsl:if>
      <xsl:if test="SENDER/CITY/text()"><xsl:value-of select="SENDER/CITY"/>, </xsl:if>
      <xsl:value-of select="SENDER/PROVINCE"/>, <xsl:if test="SENDER/POSTCODE/text()"><xsl:value-of select="SENDER/POSTCODE"/>, </xsl:if>
      <xsl:value-of select="SENDER/COUNTRY"/>.</font></td>

      <td align="right"><font class="field">Date</font><font class="data">: <xsl:value-of select="SHIPMENTDATE"/></font></td>
    </tr>
    <tr>
      <td colspan="2"><font class="field">Group code</font></td>
      <td colspan="6"><font class="data">: <xsl:value-of select="/CONSIGNMENTBATCH/GROUPCODE"/></font></td>
    </tr>

    <tr>
      <td colspan="8"><hr width="100%" noshade="true" /></td>
    </tr>
    <tr>
      <td valign="bottom"><font class="field">Con Nr.</font></td>
      <td align="right" valign="bottom"><font class="field">No. of<br class="" />Pieces</font></td>

      <xsl:comment>
        The units are hard coded within ExpressConnect, therefore just read the units attribute
        from the first consignments total weight element
      </xsl:comment>

      <td align="right" valign="bottom"><font class="field">Weight<br class="" />(<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT[position() = 1]/TOTALWEIGHT/@units"/>)</font></td>
      <td valign="bottom"><font class="field">Shipper Ref.</font></td>
      <td valign="bottom"><font class="field">Receiver</font></td>
      <td valign="bottom"><font class="field">City</font></td>
      <td valign="bottom"><font class="field">Destination</font></td>
      <td valign="bottom"><font class="field">Service</font></td>
    </tr>

  </xsl:template>

  <xsl:template match="CONSIGNMENT">
    <tr>
      <td>
        <div style="">
            <xsl:choose>
                <xsl:when test="@marketType='DOMESTIC'">
                    <img src="{$hostName}/barbecue/barcode?data={CONNUMBER}&amp;type=Code128&amp;height=55&amp;width=2" width="200"/>
                </xsl:when>
                <xsl:otherwise>
                    <img src="{$hostName}/barbecue/barcode?data={CONNUMBER}&amp;type=Code39&amp;height=100&amp;width=2" width="200"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <center><font class="data"><xsl:value-of select="CONNUMBER"/></font></center>
      </td>
      <td align="right"><font class="data"><xsl:value-of select="TOTALITEMS" /></font></td>
      <td align="right"><font class="data"><xsl:value-of select="TOTALWEIGHT" /></font></td>
      <td><font class="data"><xsl:value-of select="CUSTOMERREF" /></font></td>
      <td><font class="data"><xsl:value-of select="RECEIVER/COMPANYNAME" /></font></td>
      <td><font class="data"><xsl:if test="RECEIVER/CITY/text()"><xsl:value-of select="RECEIVER/CITY" /></xsl:if></font></td>
      <td><font class="data"><xsl:value-of select="RECEIVER/COUNTRY" /></font></td>
      <td><font class="data"><xsl:value-of select="SERVICE"/></font></td>
    </tr>
    <!--    <xsl:copy-of select="$empty-row" /> -->
  </xsl:template>

  <xsl:template name="footer">

    <tr>
      <td colspan="4"></td>
      <td colspan="2">
        <font class="field">Print Date</font>
        <font class="data">:
          <script type="text/javascript">
            var d = new Date()
            document.write(d.getDate())
            document.write("/")
            document.write(d.getMonth() + 1)
            document.write("/")
            document.write(d.getFullYear())
          </script>
        </font>
      </td>
      <td colspan="2"><font class="field">Print Time</font>
        <font class="data">:
          <script type="text/javascript">
            var d = new Date()
            document.write(d.getHours())
            document.write(":")
            document.write(d.getMinutes())
          </script>
        </font>
</td>
    </tr>
    <tr>
      <td colspan="8">&#160;</td>
    </tr>
    <tr>
      <td colspan="8">
		<table width="100%" border="0" cellpadding="2" cellspacing="2">
			      <tr>
				      <td valign="top"><input type="checkbox"/></td>
				      <td><font class="data">The consignments(s) has been loaded by TNT or a designated agent of TNT and a check of the number and condition of the consignment(s) has been undertaken by TNT.</font></td>
			      </tr>
		</table>

      </td>
    </tr>
    <tr>
      <td colspan="8"><hr width="100%" noshade="true" /></td>
    </tr>
    <tr>
      <td colspan="8">
        <font class="data">
          TNT'S LIABILITY FOR LOSS, DAMAGE AND DELAY IS LIMITED BY THE CMR CONVENTION OR THE WARSAW CONVENTION, WHICHEVER IS APPLICABLE.  THE SENDER AGREES THAT THE GENERAL CONDITIONS, ACCESSIBLE VIA THE TNT HELP, ARE ACCEPTABLE AND GOVERN THIS CONTRACT. IF NO SERVICE OR BILLING OPTION IS SELECTED THEN THE FASTEST AVAILABLE SERVICE WILL BE CHARGED TO THE SENDER.
        </font>
      </td>
    </tr>

  </xsl:template>

  <xsl:template name="totals-and-sign-off">

    <xsl:variable name="totals-row">
      <tr>
        <xsl:comment>
          TODO: Need to add as we go along the number of consignments, number of pieces, and total weight
        </xsl:comment>

        <td>
            <font class="data">Grand Totals :</font>
        </td>
        <td align="right">
            <font class="data"><xsl:value-of select="count(/CONSIGNMENTBATCH/CONSIGNMENT)" /></font>
            <font class="data" style="margin-left: 10px;"><xsl:value-of select="sum(/CONSIGNMENTBATCH/CONSIGNMENT/TOTALITEMS)" /></font>
        </td>
        <td align="right"><font class="data"><xsl:value-of select="format-number(sum(/CONSIGNMENTBATCH/CONSIGNMENT/TOTALWEIGHT), '#.000')" /></font></td>
        <td colspan="5"></td>
      </tr>

      <tr>
        <td colspan="8"><hr width="100%" noshade="true" /></td>
      </tr>
    </xsl:variable>

    <xsl:copy-of select="$totals-row" />

    <xsl:copy-of select="$empty-row" />

    <tr>
      <td colspan="5"><font class="field">Sender's Signature ______________________________________________________ </font></td>
      <td colspan="3"><font class="field">Date ____/____/____</font></td>
    </tr>
    <xsl:copy-of select="$empty-row" />
    <tr>
      <td colspan="5"><font class="field">Received by TNT ______________________________________________________ </font></td>
      <td colspan="3"><font class="field">Date ____/____/____  Time ___:___ hrs</font></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
