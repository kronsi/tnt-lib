<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

		<xsl:param name="code39Barcode_url" select="/CONSIGNMENTBATCH/BARCODEURL" />
		<xsl:param name="hostName" select="/CONSIGNMENTBATCH/HOST" />
		<xsl:param name="images_dir" select="/CONSIGNMENTBATCH/IMAGESDIR" />

	<xsl:template match="/">
		<html>
			<head>
				<style><![CDATA[
                .smborder td, .smborder th, .smborder { border: 1px solid black; border-collapse: collapse; }
                .smborder td { padding: 1px 3px; }
				font.data {	color : black; background-color : white; font-family : arial, helvetica "sans-serif"; font-size : 6pt; }
				font.title { color : black; background-color : white; font-weight : bold;	font-family : arial, helvetica "sans-serif"; font-size : 9pt; text-decoration:underline; }
				.senderAddress{ line-height: 2mm; }
				.deliveryAddress{ line-height: 3mm; }
				.table1{ height: 25mm; }
				.table1td1{ width: 56mm; height: 25mm; border-right: 1px solid #000000; }
				.table1td1table{ width: 56mm; height: 25mm; }
				.table1td2{ height: 17mm; border-bottom: 1px solid #000000; }
				.table1td3{ height: 8mm; }
				.table2td1{ width: 64mm; border-right: 1px solid #000000; }
				.table2td1table{ width: 64mm; }
				.table3{ height: 8mm; }
				.table3td1{ width: 84mm; height: 8mm; border-right: 1px solid #000000; }
				.table3td2{ height: 8mm; }
				.table4td1{ width: 67mm; border-right: 1px solid #000000; }
				.table4td2{ width: 31mm; border-right: 1px solid #000000; }
				font.addressHeader { color : black; font-weight : bold; font-family : "arial"; font-size : 6pt; }
				font.addressHeaderCode { color : black; font-weight : bold; font-family : "arial"; font-size : 8pt; letter-spacing: 0.2cm }
				font.barcode { color : black; font-weight : bold; font-family : "arial"; font-size : 8pt; letter-spacing: 0.1cm }
				font.addressHeaderRec { color : black; font-weight : bold; font-family : "arial"; font-size : 6pt; }
				font.addressData { color : black; font-family : "courier new"; font-size : 8pt; }
				font.addressDataRec { color : black; font-weight : bold; font-family : "courier new"; }
				font.addressDataWeight { color : black; font-weight : bold; font-family : "courier new"; font-size : 11pt; }
				font.addressSmallPrint { font-family : "courier new"; font-size : 4pt; }
				font.addressSmallPrintLink { font-family : "courier new"; font-size : 5pt; }
				font.header { color : black; font-weight : bold; font-family : arial, helvetica "sans-serif"; font-size : 8pt;}
				font.invoiceHeader { color : black; background-color : white; font-weight : bold; font-family : arial, helvetica "sans-serif"; font-size : 10pt; }
				font.data { color : black; font-family : arial , "sans-serif"; font-size : 8pt; }
				font.smallprint { color : black; background-color : white; font-family : arial, "sans-serif"; font-size : 6pt; }
				font.smallprintlink { color : black; background-color : white; font-family : arial, "sans-serif"; font-size : 7pt; }
				font.auSmallPrint { color : black; background-color : white; font-family : arial, "sans-serif"; font-size : 7pt; }
				font.auSmallPrintLink { color : black; background-color : white; font-family : arial, "sans-serif"; font-size : 7pt; text-decoration:underline; }
				font.carrierLicence { color : black; font-family : "courier new"; font-size : 7pt; }
				.normalService { font-size: x-large; }
				.premiumService { font-size: xx-large; font-weight: bold; }
				.tntTelephone { font-size: small; }
				.deliveryDepot { font-size: 96px; }
				.data { }
				.dataBold { font-weight: bold; }
				.label { }
				.deliveryPostcode { font-size: xx-large; font-weight: bold; }
				table.outLine { border: 1px solid #656566; border-collapse : collapse; padding : 1px; background-color: #FFFFFF; }
				td.outLineCell { border: 1px solid #656566; }
				font.sm-data { color : black; background-color : white; font-family : arial, helvetica "sans-serif"; font-size : 6pt; }
				font.sm-field { color : black; background-color : white; font-weight : bold; font-family : arial, helvetica "sans-serif"; font-size : 6pt; }
				font.sm-title { color : black; background-color : white; font-weight : bold; font-family : arial, helvetica "sans-serif"; font-size : 9pt; text-decoration:underline; }
				font.serviceCode { color : black; font-weight : bold; font-family : arial; font-size : 18pt; }
				font.operationsFlow { color : black; font-weight : bold; font-family : arial; font-size : 24pt; }
				font.productCode { color : black; font-weight : bold; font-family : arial; font-size : 12pt; }
				font.postProduct { color : black; font-family : arial; font-size : 10pt; }
				font.domestic { color : black; font-weight : bold; font-family : arial; font-size : 16pt; }
					]]>
				</style>
			</head>
			<body>
				<xsl:for-each select="CONSIGNMENTBATCH/CONSIGNMENT">

					<xsl:choose>
						<xsl:when test="@marketType='DOMESTIC'">

							<xsl:choose>
								<xsl:when test="@originCountry='GB'">
									<xsl:call-template name="ukDomesticManifest"/>
								</xsl:when>

								<xsl:otherwise>

									<xsl:call-template name="defaultManifest"/>

								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>

							<xsl:call-template name="internationalManifest"/>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>



	<xsl:template name="ukDomesticManifest">

        <div style="page-break-inside:avoid;">

    		<table width="600" cellpadding="0" cellspacing="0" border="0">
    			<tr valign="top">
    			</tr>
    			<tr>
    				<td colspan="4">
    					<table cellpadding="0" cellspacing="0" border="0" align="center">
    						<tr valign="top">
    						</tr>
    						<tr>
    							<td colspan="4">
    								<table width="100%" cellpadding="0" cellspacing="0" border="0">
    									<tr>
    										<td>
    											<center style="padding-top: 15px;">
    												<font class="dataBold">COLLECTION MANIFEST</font>
    											</center>
    										</td>
    									</tr>
    								</table>
    								<table width="100%">
    									<tr valign="top">
    										<td>
    											<font class="header">Sender Account:</font>&#160;<font class="data"><xsl:value-of select="HEADER/SENDER/ACCOUNT"/></font></td>
    										<td>&#160;</td>
    										<td rowspan="2">
    											<font class="header">Shipment Date:</font>&#160;<font class="data"><xsl:value-of select="HEADER/SHIPMENTDATE"/></font></td>
    									</tr>
    									<tr valign="top">
    										<td valign="top">
    											<font class="header">Sender Name:<br class=""/>&amp; Address</font>
    										</td>
    										<td>
    											<font class="data">
    												<xsl:value-of select="HEADER/SENDER/COMPANYNAME"/>
    												<br class=""/>
    												<xsl:value-of select="HEADER/SENDER/STREETADDRESS1"/>

    												<xsl:if test="HEADER/SENDER/STREETADDRESS2/text()">
    													<br class=""/>
    													<xsl:value-of select="HEADER/SENDER/STREETADDRESS2"/>
    												</xsl:if>

    												<xsl:if test="HEADER/SENDER/STREETADDRESS3/text()">
    													<br class=""/>
    													<xsl:value-of select="HEADER/SENDER/STREETADDRESS3"/>
    												</xsl:if>

    												<br class=""/>
    												<xsl:value-of select="HEADER/SENDER/CITY"/>

    												<xsl:if test="HEADER/SENDER/PROVINCE/text()">
    													<br class=""/>
    													<xsl:value-of select="HEADER/SENDER/PROVINCE"/>
    												</xsl:if>

    												<xsl:if test="HEADER/SENDER/POSTCODE/text()">
    													<br class=""/><xsl:value-of select="HEADER/SENDER/POSTCODE"/>
    												</xsl:if>

    												<br class=""/><xsl:value-of select="HEADER/SENDER/COUNTRY"/>


    											</font>
    										</td>
    									</tr>
    								</table>
    							</td>
    						</tr>
    					</table>
    					<table width="100%" border="1" cellspacing="0" cellpadding="0" class="smborder">
    						<tr valign="top">
    							<td colspan="1" valign="center" align="center">
    								<!-- <br class=""/> -->
    								<img src="{$hostName}/barbecue/barcode?data={CONNUMBER}&amp;type=Code128&amp;height=70" width="160"/>
    								<br class=""/>
    								<font class="header"><xsl:value-of select="CONNUMBER"/></font>
    							</td>
    							<td colspan="2">
    								<font class="header">Special Instructions:</font>
    								<br class=""/>
    								<font class="data">
    									<xsl:if test="DELIVERYINST/text()">
    										<xsl:value-of select="substring(DELIVERYINST,1,25)"/>
    									</xsl:if>


    								</font>
    							</td>
    							<td rowspan="4">
    								<font class="header">Services:</font>
    								<br class=""/>
    								<font class="data"><xsl:value-of select="SERVICE"/></font>
    								<br class=""/>
    								<br class=""/>
    								<font class="header">
    									<xsl:choose>
    										<xsl:when test="PAYMENTIND='R'">RECEIVER</xsl:when>
    										<xsl:otherwise>SENDER</xsl:otherwise>
    									</xsl:choose>&#160;PAYS
    									</font>
    							</td>
    							<td rowspan="4">
    								<font class="header">Ops Verify</font>
    							</td>
    						</tr>
    						<tr valign="top">
    							<td>
    								<font class="header">Sender Contact:</font>
    							</td>
    							<td>
    								<font class="data">
    									  <xsl:value-of select="HEADER/SENDER/CONTACTNAME"/>
    								</font>
    							</td>
    							<td>
    								<font class="header">Tel:</font>&#160;<font class="data">
    									<xsl:if test="HEADER/SENDER/CONTACTDIALCODE/text()">
    										<xsl:value-of select="HEADER/SENDER/CONTACTDIALCODE"/>&#160;
    									</xsl:if>
    									<xsl:if test="HEADER/SENDER/CONTACTTELEPHONE/text()">
    										<xsl:value-of select="HEADER/SENDER/CONTACTTELEPHONE"/>
    									</xsl:if>

    								</font></td>
    						</tr>
    						<tr valign="top">
    							<td colspan="1">
    								<font class="header">Sender Ref:</font>
    							</td>
    							<td colspan="2">
    								<font class="data">
    									<xsl:value-of select="substring(CUSTOMERREF,1, 15)"/>
    								</font>
    							</td>
    						</tr>
    						<tr valign="top">
    							<td>
    								<font class="header">Receiver's VAT No:</font>
    							</td>
    							<td colspan="2">
    								<font class="data">
    									<xsl:value-of select="RECEIVER/VAT"/>&#160;
    								</font>
    							</td>
    						</tr>
    						<tr valign="top">
    							<td>
    								<font class="header" style="display:block;max-width:195px;">Receiver Name &amp; Address<br class=""/>
                						THE SENDER AGREES THAT THE GENERAL CONDITIONS,
                						ACCESSIBLE VIA THE HELP TEXT, ARE ACCEPTABLE
                						AND GOVERN THIS CONTRACT. IF NO SERVICE
                						OR BILLING OPTION IS SELECTED THE FASTEST
                						AVAILABLE SERVICE WILL BE CHARGED TO THE
                						SENDER.</font>
    							</td>
    							<td colspan="2">
    								<font class="data">
    									<xsl:value-of select="RECEIVER/COMPANYNAME"/>
    									<br class=""/><xsl:value-of select="RECEIVER/STREETADDRESS1"/>
    									<xsl:if test="RECEIVER/STREETADDRESS2/text()">
    										<br class=""/><xsl:value-of select="RECEIVER/STREETADDRESS2"/>
    									</xsl:if>
     									<xsl:if test="RECEIVER/STREETADDRESS3/text()">
    										<br class=""/><xsl:value-of select="RECEIVER/STREETADDRESS3"/>
    									</xsl:if>
    									<br class=""/><xsl:value-of select="RECEIVER/CITY"/>
    								 	<xsl:if test="RECEIVER/PROVINCE/text()">
    										<br class=""/><xsl:value-of select="RECEIVER/PROVINCE"/>
    								 	</xsl:if>
    									<xsl:if test="RECEIVER/POSTCODE/text()">
    										<br class=""/><xsl:value-of select="RECEIVER/POSTCODE"/>
    									</xsl:if>
    									<br class=""/><xsl:value-of select="RECEIVER/COUNTRY"/>
    								</font>
    								<br class=""/>
    								<font class="header">Receiver Contact:</font>&#160;<font class="data"><xsl:value-of select="RECEIVER/CONTACTNAME"/></font></td>
    							<td valign="top">
    								<font class="header">Options:</font>
    								<font class="data">
    								<xsl:if test="OPTION1/text()">
    									<br class=""/><xsl:value-of select="OPTION1"/>
    								</xsl:if>
    								<xsl:if test="OPTION2/text()">
    									<br class=""/><xsl:value-of select="OPTION2"/>
    								</xsl:if>
    								<xsl:if test="OPTION3/text()">
    									<br class=""/><xsl:value-of select="OPTION3"/>
    								</xsl:if>
    								<xsl:if test="OPTION4/text()">
    									<br class=""/><xsl:value-of select="OPTION4"/>
    								</xsl:if>
    								<xsl:if test="OPTION5/text()">
    									<br class=""/><xsl:value-of select="OPTION5"/>
    								</xsl:if>
    								</font>



    							</td>
    							<td valign="top">
    								<font class="header">Weight:</font>
    							</td>
    						</tr>
    						<tr>
    							<td valign="top">
    								<font class="header">Items:</font>&#160;<font class="data"><xsl:value-of select="TOTALITEMS"/></font><br class=""/></td>
    							<td valign="top">
    								<font class="header">Weight:</font>
    								<br class=""/>
    								<font class="data">
    									<xsl:value-of select="TOTALWEIGHT"/>&#160;<xsl:value-of select="TOTALWEIGHT/@units"/></font>
    								<br class=""/>
    							</td>
    							<td colspan="2" valign="top" align="center">
    								<font class="header">Dimensions (HxWxD)</font>
    								<br class=""/>

    								<xsl:for-each select="PACKAGE">
    									<font class="data">
    									<xsl:value-of select="HEIGHT"/>	&#160;x&#160;<xsl:value-of select="LENGTH"/>&#160;x&#160;<xsl:value-of select="WIDTH"/></font>
    									<br class=""/>
    								</xsl:for-each>


    							</td>
    							<td valign="top" rowspan="3">
    								<font class="header">Volume</font>
    							</td>
    						</tr>
    						<tr valign="top">
    							<td colspan="4">
    								<font class="header">Insurance Value:</font>&#160;<font class="data"><xsl:value-of select="INSURANCEVALUE"/>&#160;<xsl:value-of select="CURRENCY"/></font></td>
    						</tr>
    						<tr valign="top">
    							<td colspan="4">
    								<font class="header">Goods Description:</font>
    								<br class=""/>
    								<xsl:for-each select="PACKAGE/ARTICLE">
    									<font class="data"><xsl:value-of select="PACKAGECODE"/></font><br class=""/>
    								</xsl:for-each>


    							</td>
    						</tr>
    						<tr valign="top">
    							<td colspan="3">&#160;</td>
    							<td colspan="2">
    								<font class="header">Total Consignment Volume:</font>
    								<font class="data">&#160;<xsl:value-of select="TOTALVOLUME"/>&#160;m</font>
    								<font size="1">
    									<sup>3</sup>
    								</font>
    							</td>
    						</tr>
    					</table>
    				</td>
    			</tr>
    		</table>

        </div>
	</xsl:template>




	<xsl:template name="defaultManifest">

		<xsl:call-template name="internationalManifest"/>
	</xsl:template>



	<xsl:template name="internationalManifest">

        <div style="page-break-inside:avoid; padding: 70px 0 20px;">

    		<table width="600" border="0" cellspacing="1" cellpadding="0">
    			<tr>
    				<td width="80"></td>
    				<td width="120"></td>
    				<td width="150"></td>
    				<td width="120"></td>
    				<td width="130"></td>
    			</tr>

    			<tr>
    				<td colspan="1">
    					<img src="{$hostName}{$images_dir}/logo-small.gif"/>
    				</td>
    				<td align="center" colspan="3">

    				<xsl:choose>
    					<xsl:when test="PAYMENTIND/text() = 'S'">
    						<font class="title">COLLECTION MANIFEST (DETAIL) - OTHERS (SENDER PAYS)-1</font>
    					</xsl:when>
    					<xsl:otherwise>
    						<font class="title">COLLECTION MANIFEST (DETAIL) - OTHERS (RECEIVER PAYS)-1</font>
    					</xsl:otherwise>
    				</xsl:choose>

    				<br/>
    					<font class="data">TNT Express<br/>Shipment Date : <xsl:value-of select="HEADER/SHIPMENTDATE"/><br/>Pickup id :&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</font>
    				</td>
    				<td align="right">
    					<font class="data">&#160;</font>
    				</td>
    			</tr>

    			<tr>
    				<td colspan="1">
    					<font class="data">Sender Account<br/>Sender Name<br/>&amp; Address</font>
    				</td>
    				<td colspan="3">
    					<font class="data">: <xsl:value-of select="HEADER/SENDER/ACCOUNT"/><br/>: <xsl:value-of select="HEADER/SENDER/COMPANYNAME"/><br/>: <xsl:value-of select="HEADER/SENDER/STREETADDRESS1"/>,<xsl:if test="HEADER/SENDER/STREETADDRESS2/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS2"/>,</xsl:if><xsl:if test="HEADER/SENDER/STREETADDRESS3/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS3"/>,</xsl:if><xsl:if test="HEADER/SENDER/CITY/text()"><xsl:value-of select="HEADER/SENDER/CITY"/>,</xsl:if><xsl:if test="HEADER/SENDER/PROVINCE/text()"><xsl:value-of select="HEADER/SENDER/PROVINCE"/>,</xsl:if><xsl:if test="HEADER/SENDER/POSTCODE/text()"><xsl:value-of select="HEADER/SENDER/POSTCODE"/>,</xsl:if><xsl:value-of select="HEADER/SENDER/COUNTRY"/></font>
    				</td>
    				<td colspan="1" align="right">
    					<font class="data">Printed on : <script type="text/javascript">
    							var d = new Date()
    							document.write(d.getDate())
    							document.write("/")
    							document.write(d.getMonth() + 1)
    							document.write("/")
    							document.write(d.getFullYear())</script></font>
    				</td>
    			</tr>

    			<tr>
    				<td colspan="5">
    					<hr width="100%" size="1" noshade="true"/>
    				</td>
    			</tr>

    			<tr>
    				<td colspan="2" align="center">
    			    <img height="60" style="margin-right: 10px">
    			       <xsl:attribute name="src">
    			         <xsl:value-of select="concat($hostName,concat($code39Barcode_url,CONNUMBER))" />
    			       </xsl:attribute>
    			    </img>
    					<br/>
    					<font class="data">*<xsl:value-of select="CONNUMBER"/>*</font>
    				</td>
    				<td valign="top">
    					<font class="data">Sending Depot&#160;&#160;&#160;Receiving Depot<br/></font>
    				</td>
    				<td valign="top" colspan="2">
    					<font class="data">
    						<u>Special Instructions</u>
    						<xsl:if test="DELIVERYINST/text()">
    							<br/>
    							<xsl:value-of select="DELIVERYINST"/>
    						</xsl:if>





    				<xsl:choose>
    					<xsl:when test="PAYMENTIND/text() = 'S'">
    						<br/>SENDER PAYS
    					</xsl:when>
    					<xsl:otherwise>
    						<br/>RECEIVER PAYS
    					</xsl:otherwise>
    				</xsl:choose>
    				</font>

    				</td>
    			</tr>

    			<tr>
    				<td colspan="1">
    					<font class="data">Sender Contact</font>
    				</td>
    				<td colspan="4">
    					<font class="data">: <xsl:value-of select="HEADER/SENDER/CONTACTNAME"/>
    		&#160;&#160;Tel : <xsl:value-of select="HEADER/SENDER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="HEADER/SENDER/CONTACTTELEPHONE"/>
    		&#160;&#160;Sender Ref : <xsl:value-of select="CUSTOMERREF"/>
    		&#160;&#160;Receiver Vat Nr : <xsl:value-of select="RECEIVER/VAT"/>
    		&#160;&#160;Receiver Acc Number : <xsl:value-of select="RECEIVER/ACCOUNT"/></font>
    				</td>
    			</tr>

    			<tr>
    				<td valign="top" colspan="1">
    					<font class="data">Receiver Name<br/>&amp; Address<br/>Receiver Tel<br/>Collection<br/>&amp; Address<br/>Delivery<br/>&amp; Address</font>
    				</td>
    				<td valign="top" colspan="3">
    					<font class="data">: <xsl:value-of select="RECEIVER/COMPANYNAME"/>,<xsl:value-of select="RECEIVER/STREETADDRESS1"/>,<xsl:if test="RECEIVER/STREETADDRESS2/text()"><xsl:value-of select="RECEIVER/STREETADDRESS2"/>,</xsl:if><xsl:if test="RECEIVER/STREETADDRESS3/text()"><xsl:value-of select="RECEIVER/STREETADDRESS3"/></xsl:if>&#160;&#160;&#160;Receiver Contact : <xsl:value-of select="RECEIVER/CONTACTNAME"/><br/>: <xsl:if test="RECEIVER/CITY/text()"><xsl:value-of select="RECEIVER/CITY"/>,</xsl:if><xsl:if test="RECEIVER/PROVINCE/text()"><xsl:value-of select="RECEIVER/PROVINCE"/>,</xsl:if><xsl:if test="RECEIVER/POSTCODE/text()"><xsl:value-of select="RECEIVER/POSTCODE"/>,</xsl:if><xsl:value-of select="RECEIVER/COUNTRY"/><br/>: <xsl:if test="RECEIVER/CONTACTTELEPHONE/text()"><xsl:value-of select="RECEIVER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="RECEIVER/CONTACTTELEPHONE"/></xsl:if><br/>: <xsl:if test="HEADER/COLLECTION/COMPANYNAME/text()"><xsl:value-of select="HEADER/COLLECTION/COMPANYNAME"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/STREETADDRESS1/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS1"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/STREETADDRESS2/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS2"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/STREETADDRESS3/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS3"/></xsl:if><br/>: <xsl:if test="HEADER/COLLECTION/CITY/text()"><xsl:value-of select="HEADER/COLLECTION/CITY"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/PROVINCE/text()"><xsl:value-of select="HEADER/COLLECTION/PROVINCE"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/POSTCODE/text()"><xsl:value-of select="HEADER/COLLECTION/POSTCODE"/>,</xsl:if><xsl:value-of select="HEADER/COLLECTION/COUNTRY"/><br/>: <xsl:if test="DELIVERY/COMPANYNAME/text()"><xsl:value-of select="DELIVERY/COMPANYNAME"/>,</xsl:if><xsl:if test="DELIVERY/STREETADDRESS1/text()"><xsl:value-of select="DELIVERY/STREETADDRESS1"/>,</xsl:if><xsl:if test="DELIVERY/STREETADDRESS2/text()"><xsl:value-of select="DELIVERY/STREETADDRESS2"/>,</xsl:if><xsl:if test="DELIVERY/STREETADDRESS3/text()"><xsl:value-of select="DELIVERY/STREETADDRESS3"/></xsl:if><br/>: <xsl:if test="DELIVERY/CITY/text()"><xsl:value-of select="DELIVERY/CITY"/>,</xsl:if><xsl:if test="DELIVERY/PROVINCE/text()"><xsl:value-of select="DELIVERY/PROVINCE"/>,</xsl:if><xsl:if test="DELIVERY/POSTCODE/text()"><xsl:value-of select="DELIVERY/POSTCODE"/>,</xsl:if><xsl:value-of select="DELIVERY/COUNTRY"/></font>
    				</td>
    				<td valign="top" colspan="1">
    					<font class="data">Serv : <xsl:value-of select="SERVICE"/><br/>Opts : <xsl:value-of select="OPTION1"/><xsl:if test="OPTION2/text()"><br/><xsl:value-of select="OPTION2"/></xsl:if><xsl:if test="OPTION3/text()"><br/><xsl:value-of select="OPTION3"/></xsl:if><xsl:if test="OPTION4/text()"><br/><xsl:value-of select="OPTION4"/></xsl:if><xsl:if test="OPTION5/text()"><br/><xsl:value-of select="OPTION5"/></xsl:if></font>
    				</td>
    			</tr>

    			<tr>
    				<td colspan="1">
    					<font class="data">No Pieces : <xsl:value-of select="TOTALITEMS"/></font>
    				</td>
    				<td colspan="1">
    					<font class="data">Weight : <xsl:value-of select="TOTALWEIGHT"/>&#160;<xsl:value-of select="TOTALWEIGHT/@units"/></font>
    				</td>
    				<td colspan="1">
    					<font class="data">Insurance Value : <xsl:value-of select="INSURANCEVALUE"/>&#160;<xsl:value-of select="INSURANCECURRENCY"/></font>
    				</td>
    				<td colspan="2">
    					<font class="data">Invoice Value : <xsl:value-of select="GOODSVALUE"/>&#160;<xsl:value-of select="CURRENCY"/></font>
    				</td>
    				<td></td>
    			</tr>



    			<tr>
    				<td colspan="2" valign="bottom">
    					<font class="data">Description (including packing and marks)</font>
    				</td>
    				<td colspan="2" align="center" valign="bottom">
    					<font class="data">Dimensions (L x W x H)</font>
    				</td>
    				<td colspan="1" align="center" valign="top">
    					<font class="data">Total Consignment Volume<br/><xsl:value-of select="TOTALVOLUME"/><xsl:value-of select="PACKAGE/VOLUME/@units"/></font>
    				</td>
    			</tr>

    			<xsl:for-each select="PACKAGE/ARTICLE">
    				<tr>
    					<td colspan="2">
    						<font class="data">
    							<xsl:value-of select="INVOICEDESC"/>
    						</font>
    					</td>
    					<td colspan="2" align="center" valign="top">
    						<font class="data">
    							<xsl:value-of select="../LENGTH"/>
    							<xsl:value-of select="../LENGTH/@units"/>&#160;x&#160;<xsl:value-of select="../WIDTH"/><xsl:value-of select="../WIDTH/@units"/>&#160;x&#160;<xsl:value-of select="../HEIGHT"/><xsl:value-of select="../HEIGHT/@units"/></font>
    					</td>
    					<td colspan="1" align="center" valign="top">
    						<font class="data">&#160;</font>
    					</td>
    				</tr>
    			</xsl:for-each>



    			<tr>
    				<td colspan="5">
    					<hr width="100%" size="1" noshade="true"/>
    				</td>
    			</tr>
    		</table>
    		<xsl:choose>
    			<xsl:when test="HEADER/@last[.='false']">
    				<div>
    					<font size="1" color="#5FFFFF">.</font>
    				</div>
    			</xsl:when>
    			<xsl:otherwise>
    			</xsl:otherwise>
    		</xsl:choose>

        </div>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="CombinedManifest" userelativepaths="yes" externalpreview="no" url="..\xml\manifest&#x2D;doc.xml" htmlbaseurl="" outputurl="..\html\newCombinedManifest.html" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->
