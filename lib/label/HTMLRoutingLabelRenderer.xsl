<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="ItalianDomesticHtml">

    <div id="boxIT">

      <!--Logo-->
      <div id="logoIT">
        <img src='label/logo_orig.jpg' alt='logo' id="tntLogo" />
      </div>

      <!--Market & Transport Type-->
      <div id="marketAndTransportTypeIT">
        <xsl:value-of select="../consignmentLabelData/marketDisplay"/>
        <xsl:text> / </xsl:text>
        <xsl:value-of select="../consignmentLabelData/transportDisplay"/>
      </div>

      <!--Hazardous-->
      <div id="hazardousIT">
          <xsl:for-each select="../consignmentLabelData/option">
              <xsl:if test="@id='HZ'">
                 <xsl:text>HAZARDOUS</xsl:text>
              </xsl:if>
          </xsl:for-each>
      </div>

      <!--X-RAY-->
      <xsl:if test="string-length(../consignmentLabelData/xrayDisplay)>0">
        <div id="xrayIT">
          <xsl:value-of select="../consignmentLabelData/xrayDisplay"/>
        </div>
      </xsl:if>

      <!--Free Circulation Display-->
      <xsl:choose>
        <xsl:when test="string-length(../consignmentLabelData/freeCirculationDisplay)>0">
          <div id="freeCirculationIndicatorIT" style="background-color: #000000;color: #FFFFFF;">
            <xsl:value-of select="../consignmentLabelData/freeCirculationDisplay"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div id="freeCirculationIndicatorIT" style="background-color: #000000;color: #000000;">
          <xsl:text> </xsl:text>
          </div>
        </xsl:otherwise>
      </xsl:choose>

      <!--Sort Split Indicator-->
      <xsl:choose>
        <xsl:when test="string-length(../consignmentLabelData/sortSplitText)>0">
            <div id="sortSplitIndicatorIT">
                <xsl:value-of select="../consignmentLabelData/sortSplitText" />
            </div>
        </xsl:when>
        <xsl:otherwise>
            <div id="sortSplitIndicatorIT">
                <xsl:text> </xsl:text>
            </div>
        </xsl:otherwise>
      </xsl:choose>

      <!--Consignment Number-->
      <div id="conNumberIT">
        <div id="conNumberHeaderIT">L.V.</div>
        <div id="conNumberDetailIT"><xsl:value-of select="../consignmentLabelData/consignmentNumber"/></div>
      </div>

      <!--Service-->
      <div id="serviceIT">
        <div id="serviceHeaderIT">Servizio</div>
        <xsl:choose>
            <xsl:when test="string-length(../consignmentLabelData/product)>15">
                <span id="serviceDetailIT" style="font-size: 15px;">
                    <xsl:value-of select="../consignmentLabelData/product" />
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="serviceDetailIT" style="font-size: 20px;">
                    <xsl:value-of select="../consignmentLabelData/product" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
      </div>

      <!--Options-->
      <div id="optionIT">
        <span id="optionHeaderIT">Opzione</span>
        <br />
        <xsl:variable name="numberOptions" select="count(../consignmentLabelData/option)" />
            <xsl:choose>
                <!--If there are multiple options then display option id only-->
                <xsl:when test="$numberOptions >1">
                  <xsl:for-each select="../consignmentLabelData/option">
                    <span id="optionDetailIT">
                        <xsl:value-of select="@id" />
                        <xsl:text>  </xsl:text>
                    </span>
                  </xsl:for-each>
                </xsl:when>
                <!--If there is only one option then display the option description-->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="string-length(../consignmentLabelData/option)>0">
                          <span id="optionDetailIT">
                            <xsl:value-of select="../consignmentLabelData/option" />
                          </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span id="optionDetailIT">
                                <xsl:text> </xsl:text>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
      </div>

      <!--Pieces-->
      <div id="pieceIT">
        <span id="pieceHeaderIT">
            Collo
            <br />
        </span>

        <span id="pieceDetailIT"><xsl:value-of select="pieceNumber"/> of <xsl:value-of select="../consignmentLabelData/totalNumberOfPieces"/></span>
      </div>

      <!--Weight-->
      <div id="weightIT">
        <span id="weightHeaderIT">
            Paso
            <br />
        </span>
        <xsl:choose>
            <xsl:when test="weightDisplay/@renderInstructions='highlighted'">
                <span id="weightDetailHighlightedIT">
                    <xsl:value-of select="weightDisplay" />
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="weightDetailIT">
                    <xsl:value-of select="weightDisplay" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </div>

      <!--Customer Info & Account Number-->
      <div id="contactInfoIT">
          <span id="contactInfoHeaderIT">Mitt: </span>
          <span id="contactInfoDetailIT"><xsl:value-of select="../consignmentLabelData/contact/name" disable-output-escaping="yes" /></span>
      </div>
      <div id="referenceIT">
          <span id="referenceHeaderIT">Rif.Cli.: </span>
          <span id="referenceDetailIT"><xsl:value-of select="pieceReference" disable-output-escaping="yes" /></span>
      </div>
      <div id="accountNumberIT">
          <span id="accountNumberHeaderIT">Codica Cliente Mittente</span>
          <span id="accountNumberDetailIT"><xsl:value-of select="../consignmentLabelData/account/accountNumber" /></span>
      </div>

      <!--Origin Depot & Pickup Date-->
      <div id="originDepotIT">
        <span id="originDepotHeaderIT">Filiali Partenza</span>
        <br />
        <span id="originDepotDetailIT"><xsl:value-of select="../consignmentLabelData/originDepot/depotCode" /></span>
      </div>
      <div id="pickupDateIT">
        <span id="pickupDateHeaderIT">Data Partenza</span>
        <br />
        <span id="pickupDateDetailIT">
          <xsl:call-template name="FormatDateItalianDomestic">
                    <xsl:with-param name="DateTime" select="../consignmentLabelData/collectionDate"/>
            </xsl:call-template>
        </span>
      </div>


      <!--Origin Address & Delivery Address-->
      <div id="originAddressIT">
          <span id="originAddressHeaderIT"></span>
          <div id="originAddressDetailIT">
          </div>
      </div>
      <div id="deliveryAddressIT" style="clear:left">
          <span id="deliveryAddressHeaderIT">Indirizzo di consegna</span>
          <br />
          <div id="deliveryAddressDetailIT">
          <xsl:value-of select="../consignmentLabelData/delivery/name" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/addressLine1" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/addressLine2" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/town" disable-output-escaping="yes"/><xsl:text>  </xsl:text>
          <xsl:value-of select="../consignmentLabelData/delivery/postcode"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/country"/>
          </div>
      </div>

      <!-- Route Details-->
      <div id="routingIT">
        <span id="routingHeaderIT">Instradamento</span>
        <div id="routingDetailIT">

             <!-- Check if route includes any transit depots-->
             <xsl:if test="count(../consignmentLabelData/transitDepots/*)=0">
                 <xsl:text> </xsl:text>
             </xsl:if>

            <xsl:for-each select="../consignmentLabelData/transitDepots/*">

                <xsl:if test="name(self::node()[position()])='transitDepot'">
                    <xsl:value-of select="depotCode" />
                    <br />
                </xsl:if>

                <xsl:if test="name(self::node()[position()])='actionDepot'">
                    <xsl:value-of select="depotCode" />
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="actionDayOfWeek" />
                    <br />
                </xsl:if>

                <xsl:if test="name(self::node()[position()])='sortDepot'">
                    <xsl:value-of select="depotCode" />
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="sortCellIndicator" />
                    <br />
                </xsl:if>

            </xsl:for-each>
        </div>
      </div>


      <!--Sort Details-->
      <div id="sortIT">
          <span id="sortDetailIT">
            <xsl:value-of select="../consignmentLabelData/transitDepots/sortDepot/depotCode" />
            <xsl:text> </xsl:text>
          </span>
      </div>

      <!--Microzona code-->
      <div id="microzonaHeaderIT">
        Microzona
      </div>
      <div id="microzonaIT">
        <span id="microzonaDetailIT">
          <xsl:value-of select="../consignmentLabelData/microzone"/>
        </span>
      </div>

      <!-- Bulk Shipment flag -->
      <div id="bulkShipmentHeaderIT">
      </div>
      <div id="bulkShipmentIT">
        <xsl:if test="../consignmentLabelData/bulkShipment/@renderInstructions='yes'">
           <span id="bulkShipmentDetailIT">
            P
           </span>
        </xsl:if>
      </div>

      <!--Destination Depot-->
      <div id="destinationDepotHeaderIT">
          Filiali
          <br />
          Arrivo
      </div>
      <div id="destinationDepotDetailIT">
        <xsl:choose>
          <xsl:when test="../consignmentLabelData/destinationDepot/dueDayOfWeek/@renderInstructions='highlighted'">
            <xsl:value-of select="../consignmentLabelData/destinationDepot/depotCode"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="../consignmentLabelData/destinationDepot/dueDayOfMonth"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="../consignmentLabelData/destinationDepot/depotCode"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="../consignmentLabelData/destinationDepot/dueDayOfMonth"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>

      <!--Barcode-->
      <div id="barcodeIT" name="barcodeIT">
        <img>
           <xsl:attribute name="src">
             <xsl:value-of select="concat($barcode_url,barcode)" />
           </xsl:attribute>
        </img>
      </div>
      <div id="barcodeLabelIT">
         <xsl:value-of select="barcode" />
      </div>
    </div>
    <br style="page-break-before:always"/>

    </xsl:template>

    <xsl:template name="FormatDateItalianDomestic">
        <!-- expected date format 2008 06 16 -->
        <xsl:param name="DateTime" />
        <!-- new date format 20 June 2007 -->
        <xsl:variable name="year">
            <xsl:value-of select="substring-before($DateTime,'-')" />
        </xsl:variable>
        <xsl:variable name="mo-temp">
            <xsl:value-of select="substring-after($DateTime,'-')" />
        </xsl:variable>
        <xsl:variable name="mo">
            <xsl:value-of select="substring-before($mo-temp,'-')" />
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:value-of select="substring-after($mo-temp,'-')" />
        </xsl:variable>

        <xsl:value-of select="$day" />
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="$mo = '1' or $mo = '01'">Jan</xsl:when>
            <xsl:when test="$mo = '2' or $mo = '02'">Feb</xsl:when>
            <xsl:when test="$mo = '3' or $mo = '03'">Mar</xsl:when>
            <xsl:when test="$mo = '4' or $mo = '04'">Apr</xsl:when>
            <xsl:when test="$mo = '5' or $mo = '05'">May</xsl:when>
            <xsl:when test="$mo = '6' or $mo = '06'">Jun</xsl:when>
            <xsl:when test="$mo = '7' or $mo = '07'">Jul</xsl:when>
            <xsl:when test="$mo = '8' or $mo = '08'">Aug</xsl:when>
            <xsl:when test="$mo = '9' or $mo = '09'">Sep</xsl:when>
            <xsl:when test="$mo = '10'">Oct</xsl:when>
            <xsl:when test="$mo = '11'">Nov</xsl:when>
            <xsl:when test="$mo = '12'">Dec</xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$year" />
    </xsl:template>

    

    <xsl:template name="FrenchDomesticHtml">

    <div id="boxFR">

      <!--Logo-->
      <div id="logoFR">
        <img src='https://express.tnt.com/expresswebservices-website/rendering/images/logo_orig.jpg' alt='logo' id="tntLogo" />
      </div>

        <!--Contact Details-->
        <div id="contactDetailsFR">
          <table id="contactDetailsTableFR">
            <tr>
              <td>Service Client </td>
              <td>: +33(0)825 033 033</td>
            </tr>
            <tr>
              <td>Fax </td>
              <td>: +33(0)825 031 021</td>
            </tr>
            <tr>
              <td>Web </td>
              <td>: www.tnt.fr</td>
            </tr>
          </table>
        </div>

        <!--Legal Comments-->
        <div id="legalCommentsFR">
          <xsl:value-of select="../consignmentLabelData/legalComments"/>
        </div>

      <!--Consignment Number-->
      <div id="conNumberFR">
        <div id="conNumberDetailFR"><xsl:value-of select="../consignmentLabelData/consignmentNumber"/></div>
      </div>

      <!--Service-->
      <div id="serviceFR">
        <xsl:choose>
            <xsl:when test="string-length(../consignmentLabelData/product)>15">
                <span id="serviceDetailFR" style="font-size: 17px;">
                    <xsl:value-of select="../consignmentLabelData/product" />
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="serviceDetailFR" style="font-size: 20px;">
                    <xsl:value-of select="../consignmentLabelData/product" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
      </div>

      <!--Pieces-->
      <div id="pieceFR">
        <span id="pieceDetailFR"><xsl:value-of select="pieceNumber"/> sur <xsl:value-of select="../consignmentLabelData/totalNumberOfPieces"/></span>
      </div>

      <!--Weight-->
      <div id="weightFR">
        <xsl:choose>
            <xsl:when test="weightDisplay/@renderInstructions='highlighted'">
                <span id="weightDetailHighlightedFR">
                    <xsl:value-of select="weightDisplay" />
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="weightDetailFR">
                    <xsl:value-of select="weightDisplay" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </div>

      <!--Options-->
      <div id="optionFR">
        <xsl:variable name="numberOptions" select="count(../consignmentLabelData/option)" />
            <xsl:choose>
                <!--If there are multiple options then display option id only-->
                <xsl:when test="$numberOptions > 1">
                  <xsl:for-each select="../consignmentLabelData/option">
                    <span id="optionDetailFR">
                        <xsl:value-of select="@id" />
                        <xsl:text>  </xsl:text>
                    </span>
                  </xsl:for-each>
                </xsl:when>
                <!--If there is only one option then display the option description-->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="string-length(../consignmentLabelData/option)>0">
                          <span id="optionDetailFR">
                            <xsl:value-of select="../consignmentLabelData/option" />
                          </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span id="optionDetailFR">
                                <xsl:text> </xsl:text>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
      </div>

      <!-- Customer Reference Barcode -->
      <div id="customerReferenceBarcodeFR" name="customerReferenceBarcodeFR">
          <img width="240px" height="13px">
              <xsl:if test="string-length(barcodeForCustomer) > 0">
    			  <xsl:attribute name="src">
    			      <xsl:value-of select="concat($code128Bbarcode_url,barcodeForCustomer)" />
                  </xsl:attribute>
              </xsl:if>
          </img>
      </div>

      <!--Customer Reference & Account Number-->
      <div id="customerReferenceFR">
          <span id="customerReferenceHeaderFR">Ref: </span>
          <span id="customerReferenceDetailFR"><xsl:value-of select="pieceReference" disable-output-escaping="yes" /></span>
      </div>
      <div id="accountNumberFR">
          <span id="accountNumberHeaderFR">Cpt: </span>
          <span id="accountNumberDetailFR"><xsl:value-of select="../consignmentLabelData/account/accountNumber" /></span>
      </div>

      <!-- Delivery Depot -->
      <div id="deliveryDepotFR">
        <xsl:if test="string-length(../consignmentLabelData/delivery/postcode) >= 2">
            <xsl:value-of select="substring(../consignmentLabelData/delivery/postcode,1,2)"/>
        </xsl:if>
      </div>

      <!--Origin Address & Delivery Address-->
      <div id="originAddressLabelFR">Exp:</div>
      <div id="originAddressFR" style="clear:left">
          <div id="originAddressDetailFR">
    	      <xsl:value-of select="../consignmentLabelData/sender/name" disable-output-escaping="yes"/><br />
    	      <xsl:value-of select="../consignmentLabelData/sender/addressLine1" disable-output-escaping="yes"/><br />
    	      <xsl:if test="string-length(../consignmentLabelData/sender/addressLine2) > 0">
    	          <xsl:value-of select="../consignmentLabelData/sender/addressLine2" disable-output-escaping="yes"/><br />
    	      </xsl:if>
    	      <xsl:value-of select="../consignmentLabelData/sender/postcode"/><xsl:text>  </xsl:text>
    	      <xsl:value-of select="../consignmentLabelData/sender/town" disable-output-escaping="yes"/><br />
    	      <xsl:value-of select="../consignmentLabelData/sender/country"/>
          </div>
      </div>
      <div id="deliveryAddressLabelFR">Dest:</div>
      <div id="deliveryAddressFR" style="clear:left">
          <!--span id="deliveryAddressHeaderFR">Dest:</span-->
          <div id="deliveryAddressDetailFR">
          <xsl:value-of select="../consignmentLabelData/delivery/name" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/addressLine1" disable-output-escaping="yes"/><br />
          <xsl:if test="string-length(../consignmentLabelData/delivery/addressLine2) > 0">
            <xsl:value-of select="../consignmentLabelData/delivery/addressLine2" disable-output-escaping="yes"/><br />
          </xsl:if>
          <xsl:value-of select="../consignmentLabelData/delivery/postcode"/><xsl:text>  </xsl:text>
          <xsl:value-of select="../consignmentLabelData/delivery/town" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/country"/>
          </div>
      </div>

      <!--Special Instructions-->
      <div id="specialInstructionsFR">
        <xsl:if test="string-length(../consignmentLabelData/specialInstructions) > 0">
            <xsl:value-of select="substring(../consignmentLabelData/specialInstructions,1,65)" />
        </xsl:if>
      </div>

      <!-- Contact Name -->
      <div id="contactNameFR">
          <span id="contactNameHeaderFR">Nom du Contact: </span>
          <span id="contactNameDetailFR">
              <xsl:if test="string-length(../consignmentLabelData/contact) > 0">
    		      <xsl:value-of select="../consignmentLabelData/contact/name" />
    		  </xsl:if>
          </span>
      </div>

      <!-- Contact Phone -->
      <div id="contactPhoneFR">
          <span id="contactPhoneHeaderFR">Tel: </span>
          <span id="contactPhoneDetailFR">
              <xsl:if test="string-length(../consignmentLabelData/contact) > 0">
                  <xsl:value-of select="../consignmentLabelData/contact/telephoneNumber" />
              </xsl:if>
          </span>
      </div>

      <!--Postcode/Cluster code-->
      <div id="postcodeHeaderFR">Code Postal /
          <br />
          Code Satellite
      </div>
      <div id="postcodeFR">
          <span id="postcodeDetailFR"><xsl:value-of select="../consignmentLabelData/delivery/postcode"/></span>
      </div>

      <!--Pickup Date-->
      <div id="pickupDateFR">
        <span id="pickupDateHeaderFR">Date Ramassage: </span>
        <span id="pickupDateDetailFR">
          <xsl:call-template name="FormatDateFrenchDomestic">
                    <xsl:with-param name="DateTime" select="../consignmentLabelData/collectionDate"/>
            </xsl:call-template>
        </span>
      </div>

      <!--CashAmount-->
      <div id="cashAmountFR">
    	  <xsl:for-each select="../consignmentLabelData/option">
    	      <xsl:if test="@id='CO' or @id='RP'">
    	         <xsl:value-of select="../cashAmount"/>
    	      </xsl:if>
    	  </xsl:for-each>
      </div>

      <!--Barcode-->
      <div id="barcodeFR" name="barcodeFR">
        <img>
           <xsl:attribute name="src">
             <xsl:value-of select="concat($int2of5barcode_url,barcode)" />
           </xsl:attribute>
        </img>
      </div>
      <div id="barcodeLabelFR">
         <xsl:value-of select="barcode" />
      </div>
    </div>
    <br style="page-break-before:always"/>

    </xsl:template>

    <xsl:template name="FormatDateFrenchDomestic">
        <!-- expected date format 2008 06 16 -->
        <xsl:param name="DateTime" />
        <!-- new date format 20 June 2007 -->
        <xsl:variable name="year">
            <xsl:value-of select="substring-before($DateTime,'-')" />
        </xsl:variable>
        <xsl:variable name="mo-temp">
            <xsl:value-of select="substring-after($DateTime,'-')" />
        </xsl:variable>
        <xsl:variable name="mo">
            <xsl:value-of select="substring-before($mo-temp,'-')" />
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:value-of select="substring-after($mo-temp,'-')" />
        </xsl:variable>

        <xsl:value-of select="$day" />
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="$mo = '1' or $mo = '01'">01</xsl:when>
            <xsl:when test="$mo = '2' or $mo = '02'">02</xsl:when>
            <xsl:when test="$mo = '3' or $mo = '03'">03</xsl:when>
            <xsl:when test="$mo = '4' or $mo = '04'">04</xsl:when>
            <xsl:when test="$mo = '5' or $mo = '05'">05</xsl:when>
            <xsl:when test="$mo = '6' or $mo = '06'">06</xsl:when>
            <xsl:when test="$mo = '7' or $mo = '07'">07</xsl:when>
            <xsl:when test="$mo = '8' or $mo = '08'">08</xsl:when>
            <xsl:when test="$mo = '9' or $mo = '09'">09</xsl:when>
            <xsl:when test="$mo = '10'">10</xsl:when>
            <xsl:when test="$mo = '11'">11</xsl:when>
            <xsl:when test="$mo = '12'">12</xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$year" />
    </xsl:template>


    <xsl:template name="RestOfWorldHtml">

    <div id="box">

      <!--Logo-->
      <div id="logo">
        <img src='label/logo_orig.jpg' alt='logo' id="tntLogo" />
      </div>

      <!--Market & Transport Type-->
      <div id="marketAndTransportType">
        <xsl:value-of select="../consignmentLabelData/marketDisplay"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="../consignmentLabelData/transportDisplay"/>
      </div>

      <!--Hazardous-->
      <div id="hazardous">
          <xsl:for-each select="../consignmentLabelData/option">
              <xsl:if test="@id='HZ'">
                 <xsl:text>HAZARDOUS</xsl:text>
              </xsl:if>
          </xsl:for-each>
      </div>

      <!--X-RAY-->
      <xsl:if test="string-length(../consignmentLabelData/xrayDisplay)>0">
        <div id="xray">
          <xsl:value-of select="../consignmentLabelData/xrayDisplay"/>
        </div>
      </xsl:if>

      <!--Free Circulation Display-->
      <xsl:choose>
        <xsl:when test="string-length(../consignmentLabelData/freeCirculationDisplay)>0">
          <div id="freeCirculationIndicator" style="background-color: #000000;color: #FFFFFF;">
            <xsl:value-of select="../consignmentLabelData/freeCirculationDisplay"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div id="freeCirculationIndicator" style="background-color: #000000;color: #000000;">
          <xsl:text> </xsl:text>
          </div>
        </xsl:otherwise>
      </xsl:choose>

      <!--Sort Split Indicator-->
      <xsl:choose>
        <xsl:when test="string-length(../consignmentLabelData/sortSplitText)>0">
            <div id="sortSplitIndicator">
                <xsl:value-of select="../consignmentLabelData/sortSplitText" />
            </div>
        </xsl:when>
        <xsl:otherwise>
            <div id="sortSplitIndicator">
                <xsl:text> </xsl:text>
            </div>
        </xsl:otherwise>
      </xsl:choose>

      <!--Consignment Number-->
      <div id="conNumber">
        <div id="conNumberHeader">Con No.</div>
        <div id="conNumberDetail"><xsl:value-of select="../consignmentLabelData/consignmentNumber"/></div>
      </div>

      <!--Service-->
      <div id="service">
        <div id="serviceHeader">Service</div>
        <xsl:choose>
            <xsl:when test="string-length(../consignmentLabelData/product)>15">
                <span id="serviceDetail" style="font-size: 17px;">
                    <xsl:value-of select="../consignmentLabelData/product" />
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="serviceDetail" style="font-size: 20px;">
                    <xsl:value-of select="../consignmentLabelData/product" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
      </div>

      <!--Pieces-->
      <div id="piece">
        <span id="pieceHeader">
            Piece
            <br />
        </span>

        <span id="pieceDetail"><xsl:value-of select="pieceNumber"/> of <xsl:value-of select="../consignmentLabelData/totalNumberOfPieces"/></span>
      </div>

      <!--Weight-->
      <div id="weight">
        <span id="weightHeader">
            Weight
            <br />
        </span>
        <xsl:choose>
            <xsl:when test="weightDisplay/@renderInstructions='highlighted'">
                <span id="weightDetailHighlighted">
                    <xsl:value-of select="weightDisplay" />
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="weightDetail">
                    <xsl:value-of select="weightDisplay" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </div>

      <!--Options-->
      <div id="option">
        <span id="optionHeader">Option</span>
        <br />
        <xsl:variable name="numberOptions" select="count(../consignmentLabelData/option)" />
            <xsl:choose>
                <!--If there are multiple options then display option id only-->
                <xsl:when test="$numberOptions >1">
                  <xsl:for-each select="../consignmentLabelData/option">
                    <span id="optionDetail">
                        <xsl:value-of select="@id" />
                        <xsl:text>  </xsl:text>
                    </span>
                  </xsl:for-each>
                </xsl:when>
                <!--If there is only one option then display the option description-->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="string-length(../consignmentLabelData/option)>0">
                          <span id="optionDetail">
                            <xsl:value-of select="../consignmentLabelData/option" />
                          </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span id="optionDetail">
                                <xsl:text> </xsl:text>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
      </div>

      <!--Customer Reference & Account Number-->
      <div id="customerReference">
          <div id="customerReferenceHeader">Customer Reference</div>
          <div id="customerReferenceDetail"><xsl:value-of select="pieceReference" disable-output-escaping="yes" /></div>
      </div>
      <div id="accountNumber">
          <span id="accountNumberHeader">S/R Account No</span>
          <span id="accountNumberDetail"><xsl:value-of select="../consignmentLabelData/account/accountNumber" /></span>
      </div>

      <!--Origin Depot & Pickup Date-->
      <div id="originDepot">
        <span id="originDepotHeader">Origin</span>
        <span id="originDepotDetail"><xsl:value-of select="../consignmentLabelData/originDepot/depotCode" /></span>
      </div>
      <div id="pickupDate">
        <span id="pickupDateHeader">Pickup Date</span>
        <br />
        <span id="pickupDateDetail">
          <xsl:call-template name="FormatDate">
                    <xsl:with-param name="DateTime" select="../consignmentLabelData/collectionDate"/>
            </xsl:call-template>
        </span>
      </div>


      <!--Origin Address & Delivery Address-->
      <div id="originAddress">
          <span id="originAddressHeader">Sender Address</span>
          <br />
          <div id="originAddressDetail">
          <xsl:value-of select="../consignmentLabelData/sender/name" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/sender/addressLine1" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/sender/addressLine2" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/sender/town" disable-output-escaping="yes"/><xsl:text>  </xsl:text>
          <xsl:value-of select="../consignmentLabelData/sender/postcode"/><br />
          <xsl:value-of select="../consignmentLabelData/sender/country"/>
          </div>
      </div>
      <div id="deliveryAddress" style="clear:left">
          <span id="deliveryAddressHeader">Delivery Address</span>
          <br />
          <div id="deliveryAddressDetail">
          <xsl:value-of select="../consignmentLabelData/delivery/name" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/addressLine1" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/addressLine2" disable-output-escaping="yes"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/town" disable-output-escaping="yes"/><xsl:text>  </xsl:text>
          <xsl:value-of select="../consignmentLabelData/delivery/postcode"/><br />
          <xsl:value-of select="../consignmentLabelData/delivery/country"/>
          </div>
      </div>

      <!-- Route Details-->
      <div id="routing">
        <span id="routingHeader">Routing</span>
        <div id="routingDetail">

             <!-- Check if route includes any transit depots-->
             <xsl:if test="count(../consignmentLabelData/transitDepots/*)=0">
                 <xsl:text> </xsl:text>
             </xsl:if>

            <xsl:for-each select="../consignmentLabelData/transitDepots/*">

                <xsl:if test="name(self::node()[position()])='transitDepot'">
                    <xsl:value-of select="depotCode" />
                    <br />
                </xsl:if>

                <xsl:if test="name(self::node()[position()])='actionDepot'">
                    <xsl:value-of select="depotCode" />
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="actionDayOfWeek" />
                    <br />
                </xsl:if>

                <xsl:if test="name(self::node()[position()])='sortDepot'">
                    <xsl:value-of select="depotCode" />
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="sortCellIndicator" />
                    <br />
                </xsl:if>

            </xsl:for-each>
        </div>
      </div>


      <!--Sort Details-->
      <div id="sort">
          <span id="sortHeader">Sort</span>
          <span id="sortDetail">
            <xsl:value-of select="../consignmentLabelData/transitDepots/sortDepot/depotCode" />
            <xsl:text> </xsl:text>
          </span>
      </div>

      <!--Postcode/Cluster code-->
      <div id="postcodeHeader">Postcode /
          <br />
          Cluster Code
      </div>
      <div id="postcode">
        <xsl:choose>
        <!--If the length of the Cluster code is greater than 3 then the post code is being displayed
        instead, so different rendering applies-->
          <xsl:when test="string-length(../consignmentLabelData/clusterCode)>3">
            <span id="postcodeDetail"><xsl:value-of select="../consignmentLabelData/delivery/postcode"/></span>
          </xsl:when>
          <xsl:otherwise>
            <span id="clustercodeDetail"><xsl:value-of select="../consignmentLabelData/clusterCode"/></span>
          </xsl:otherwise>
        </xsl:choose>
      </div>

      <!--Destination Depot-->
      <div id="destinationDepotHeader">
          Dest
          <br />
          Depot
      </div>
      <div id="destinationDepotDetail">
        <xsl:choose>
          <xsl:when test="../consignmentLabelData/destinationDepot/dueDayOfWeek/@renderInstructions='highlighted'">
            <xsl:value-of select="../consignmentLabelData/destinationDepot/depotCode"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="../consignmentLabelData/destinationDepot/dueDayOfMonth"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="../consignmentLabelData/destinationDepot/depotCode"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="../consignmentLabelData/destinationDepot/dueDayOfMonth"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>

      <!--Barcode-->
      <xsl:variable name="barcode_url" select='"https://express.tnt.com/barbecue/barcode?type=Code128C&amp;height=140&amp;width=2&amp;data="' />
      <div id="barcode" name="barcode">
        <img>
           <xsl:attribute name="src">
             <xsl:value-of select="concat($barcode_url,barcode)" />
           </xsl:attribute>
        </img>
      </div>
      <div id="barcodeLabel">
         <xsl:value-of select="barcode" />
      </div>
    </div>
    <br style="page-break-before:always"/>

    </xsl:template>

    <xsl:template name="FormatDate">
        <!-- expected date format 2008 06 16 -->
        <xsl:param name="DateTime" />
        <!-- new date format 20 June 2007 -->
        <xsl:variable name="year">
            <xsl:value-of select="substring-before($DateTime,'-')" />
        </xsl:variable>
        <xsl:variable name="mo-temp">
            <xsl:value-of select="substring-after($DateTime,'-')" />
        </xsl:variable>
        <xsl:variable name="mo">
            <xsl:value-of select="substring-before($mo-temp,'-')" />
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:value-of select="substring-after($mo-temp,'-')" />
        </xsl:variable>

        <xsl:value-of select="$day" />
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="$mo = '1' or $mo = '01'">Jan</xsl:when>
            <xsl:when test="$mo = '2' or $mo = '02'">Feb</xsl:when>
            <xsl:when test="$mo = '3' or $mo = '03'">Mar</xsl:when>
            <xsl:when test="$mo = '4' or $mo = '04'">Apr</xsl:when>
            <xsl:when test="$mo = '5' or $mo = '05'">May</xsl:when>
            <xsl:when test="$mo = '6' or $mo = '06'">Jun</xsl:when>
            <xsl:when test="$mo = '7' or $mo = '07'">Jul</xsl:when>
            <xsl:when test="$mo = '8' or $mo = '08'">Aug</xsl:when>
            <xsl:when test="$mo = '9' or $mo = '09'">Sep</xsl:when>
            <xsl:when test="$mo = '10'">Oct</xsl:when>
            <xsl:when test="$mo = '11'">Nov</xsl:when>
            <xsl:when test="$mo = '12'">Dec</xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$year" />
    </xsl:template>

<xsl:preserve-space elements="*"/>
<xsl:output method="html" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transistional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    indent="yes"
    />

<xsl:param name="twoDbarcode_url" />
<xsl:param name="barcode_url" />
<xsl:param name="int2of5barcode_url" />
<xsl:param name="code128Bbarcode_url" />
<xsl:param name="images_dir" />
<xsl:param name="css_dir" />

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
#box {
    page-break-after: always;
    page-break-inside: avoid;
    display: inline-block;
	position: relative;
    margin: 6px 10px;
	top: 0;
	left: 0;
	border-collapse: collapse;
	border-style: solid;
	border-width: 1px;
	text-align: center;
	font-family: arial;
	width: 330px;
	height: 485px;
}

#logo {
	position: absolute;
	top: 1px;
	left: 1px;
    width: 112px;
    height: 61px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    text-align: center;
}

#logo img {
    text-align: center;
    height: 56px;
}

#marketAndTransportType {
    position: absolute;
    top: 1px;
    left: 116px;
    width: 138px;
    height: 28px;
    background-color: #FFFFFF;
    font-weight: plain;
    font-size: 18px;
    text-align: left;
}

#hazardous {
    position: absolute;
    top: 22px;
    left: 116px;
    width: 138px;
    font-weight: bold;
    font-size: 16px;
    text-align: left;
}

#xray {
    position: absolute;
    top: 40px;
    left: 116px;
    width: 138px;
    font-weight: bold;
    font-size: 16px;
    text-align: left;
}

#freeCirculationIndicator {
    position: absolute;
    top: 0px;
    left: 254px;
    width: 39px;
    height: 61px;
    border-right-width: 1px;
    border-right-style: solid;
    border-left-width: 1px;
    border-left-style: solid;
    border-color: black;
    font-weight: bold;
    font-size: 45px;
    text-align: center;
}

#sortSplitIndicator {
    position: absolute;
    top: 1px;
    left: 294px;
    width: 39px;
    height: 60px;
    border-color: black;
    font-weight: bold;
    font-size: 45px;
    text-align: center;
}

#conNumber {
    position: absolute;
    top: 61px;
    left: 1px;
    width: 162px;
    height: 31px;
    line-height: 60%;
    padding-left: 3px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-right-color: black;
    border-top-width: 1px;
    border-top-style: solid;
    border-top-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-bottom-color: #FFFFFF;
    text-align: left;
}

#conNumberHeader {
    font-size: 10px;
}

#conNumberDetail {
    font-weight: bold;
    font-size: 24px;
    line-height: 100%;
}

#service {
    position: absolute;
    top: 61px;
    left: 167px;
    width: 163px;
    height: 32px;
    line-height: 70%;
    background-color: #000000;
    border-color: black;
    border-top-width: 1px;
    border-top-style: solid;
    color: #FFFFFF;
    text-align: left;
}

#serviceHeader {
    font-size: 10px;
}

#serviceDetail {
    font-weight: bold;
    line-height: 100%;
}

#option {
    position: absolute;
    top: 92px;
    left: 167px;
    width: 163px;
    height: 31px;
    line-height: 75%;
    background-color: #000000;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
    color: #FFFFFF;
}

#optionHeader {
    font-size: 10px;
}

#optionDetail {
    font-weight: bold;
    font-size: 14px;
    line-height: 100%;
}

#optionDetail {
    font-weight: bold;
    font-size: 14px;
    line-height: 75%;
}

#piece {
    position: absolute;
    top: 93px;
    left: 1px;
    width: 83px;
    height: 31px;
    padding-left: 3px;
    line-height: 75%;
    background-color: #FFFFFF;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#pieceHeader {
    font-size: 10px;
}

#pieceDetail {
    font-size: 16px;
    font-weight: bold;
    line-height: 100%;
}

#weight {
    position: absolute;
    top: 93px;
    left: 87px;
    width: 79px;
    height: 31px;
    line-height: 75%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-right-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#weightHeader {
    font-size: 10px;
}

#weightDetail {
    font-size: 16px;
    font-weight: bold;
    line-height: 100%;
}

#weightDetailHighlighted {
    font-size: 16px;
    font-weight: bold;
    line-height: 100%;
    background-color: black;
    color: white;
}

#customerReference {
    position: absolute;
    top: 125px;
    left: 1px;
    width: 162px;
    height: 24px;
    padding-left: 3px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-color: black;
    text-align: left;
}

#customerReferenceHeader {
    font-size: 9px;
}

#customerReferenceDetail {
    font-size: 9px;
    font-weight: bold;
}

#originDepot {
    position: absolute;
    top: 125px;
    left: 168px;
    width: 87px;
    height: 32px;
    padding-left: 3px;
    text-align: left;
}

#originDepotHeader {
    float:left;
    font-size: 9px;
}

#originDepotDetail {
    font-size: 24px;
    font-weight: bold;
    padding-left: 0px;
}

#pickupDate {
    position: absolute;
    top: 124px;
    left: 260px;
    width: 70px;
    height: 32px;
    text-align: left;
    line-height: 75%;
}

#pickupDateHeader {
    font-size: 10px;
}

#pickupDateDetail {
    font-size: 10px;
}

#accountNumber {
    position: absolute;
    top: 148px;
    left: 1px;
    width: 162px;
    height: 18px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-right-color: black;
    border-bottom-style: none;
    text-align: left;
    padding-left: 3px;
    font-size: 10px;
}

#accountNumberHeader {
    font-size: 10px;
}

#accountNumberDetail {
    padding-left: 3px;
    font-size: 10px;
}

#originAddress {
    position: absolute;
    top: 161px;
    left: 1px;
    width: 162px;
    height: 70px;
    padding-left: 3px;
    line-height: 70%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: dashed;
    border-top-style: solid;
    border-top-width: 1px;
    border-color: black;
    text-align: left;
}

#originAddressHeader {
    font-size: 9px;
}

#originAddressDetail {
    font-size: 9px;
    padding-left: 10px;
}

#deliveryAddress {
    position: absolute;
    top: 233px;
    left: 1px;
    width: 162px;
    height: 70px;
    padding-left: 3px;
    line-height: 70%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#deliveryAddressHeader {
    font-size: 9px;
}

#deliveryAddressDetail {
    font-size: 9px;
    padding-left: 10px;
}

#routing {
    position: absolute;
    top: 154px;
    left: 168px;
    width: 159px;
    height: 122px;
    padding-left: 3px;
    line-height: 70%;
    background-color: #FFFFFF;
    border-bottom-width: 1px;
    border-bottom-style: dashed;
    border-top-width: 1px;
    border-top-style: dashed;
    border-color: black;
    text-align: left;
}

#routingHeader {
	float:left;
    font-size: 10px;
}

#routingDetail {
    font-size: 32px;
    font-weight: bold;
    padding-left: 40px;
    line-height: 90%;
}

#sort {
    position: absolute;
    top: 278px;
    left: 167px;
    width: 159px;
    height: 32px;
    padding-left: 3px;
    background-color: #FFFFFF;
    border-bottom-width: 1px;
    border-bottom-style: dashed;
    border-color: black;
    text-align: left;
}

#sortHeader {
    float:left;
    font-size: 10px;
}

#sortDetail {
    font-size: 30px;
    font-weight: bold;
    padding-left: 8px;
}

#postcodeHeader {
    position: absolute;
    top: 312px;
    left: 0px;
    width: 60px;
    height: 34px;
    padding-left: 4px;
    font-size: 9px;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#postcode {
    position: absolute;
    top: 304px;
    left: 62px;
    width: 104px;
    height: 42px;
    background-color: black;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#postcodeDetail {
    position: relative;
    top: 6px;
    left: 3px;
    background-color: black;
    font-size: 22px;
    font-weight: bold;
    color: white;
}

#clustercodeDetail {
    position: relative;
    top: 1px;
    left: 7px;
    background-color: black;
    font-size: 34px;
    font-weight: bold;
    color: white;
}

#destinationDepot {
}

#destinationDepotHeader {
    position: absolute;
    top: 314px;
    left: 167px;
    width: 42px;
    height: 31px;
    padding-left: 3px;
    border-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    text-align: left;
    font-size: 10px;
}

#destinationDepotDetail {
    position: absolute;
    top: 309px;
    left: 203px;
    width: 128px;
    height: 36px;
    border-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    text-align: left;
    font-size: 32px;
    font-weight: bold;
}

#barcode {
    position: absolute;
    top: 348px;
    left: 1px;
    width: 327px;
}

#barcode img {
    padding-top: 10px;
    width: 326px;
    height: 105px;
}

#barcodeLabel {
    position: absolute;
    top: 473px;
    left: 1px;
    width: 327px;
    font-size: 9px;
}

#boxFR {
	position: relative;
	top: 9px;
	left: 9px;
	border-collapse: collapse;
	border-style: solid;
	border-width: 1px;
	text-align: center;
	font-family: arial;
	width: 330px;
	height: 485px;
}

#logoFR {
	position: absolute;
	top: 2px;
	left: 1px;
    width: 112px;
    height: 60px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    text-align: center;
    padding-top: 10px;
}

#logoFR img {
    text-align: center;
    height: 35px;
}

#contactDetailsFR {
    position: absolute;
    top: 1px;
    left: 114px;
    width: 214px;
    height: 40px;
    background-color: #FFFFFF;
    font-weight: normal;
    text-align: left;
}

#contactDetailsTableFR tr td {
    font-size: 10px;
    line-height: 75%;
}

#legalCommentsFR {
    position: absolute;
    top: 40px;
    left: 114px;
    width: 214px;
    height: 10px;
    border-color: black;
    font-weight: normal;
    font-size: 7px;
    text-align: left;
    text-align: justify;
}

#conNumberFR {
    position: absolute;
    top: 53px;
    left: 1px;
    width: 162px;
    height: 31px;
    line-height: 60%;
    padding-left: 3px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-right-color: black;
    border-top-width: 1px;
    border-top-style: none;
    border-top-color: black;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-bottom-color: #FFFFFF;
    text-align: left;
}

#conNumberDetailFR {
    font-weight: bold;
    font-size: 18px;
    line-height: 100%;
}

#serviceFR {
    position: absolute;
    top: 51px;
    left: 167px;
    width: 163px;
    height: 24px;
    line-height: 70%;
    background-color: #000000;
    border-color: black;
    border-top-width: 1px;
    border-top-style: solid;
    color: #FFFFFF;
    text-align: left;
}

#serviceDetailFR {
    font-weight: bold;
    line-height: 100%;
    padding-left:3px;
}

#optionFR {
    position: absolute;
    top: 78px;
    left: 167px;
    width: 163px;
    height: 17px;
    background-color: #000000;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
    line-height: 90%;
    color: #FFFFFF;
}

#optionDetailFR {
    font-weight: bold;
    font-size: 14px;
    line-height: 100%;
    padding-left:3px;
}

#pieceFR {
    position: absolute;
    top: 79px;
    left: 1px;
    width: 83px;
    height: 16px;
    padding-left: 3px;
    line-height: 75%;
    background-color: #FFFFFF;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-color: black;
    text-align: left;
}

#pieceDetailFR {
    font-size: 15px;
    font-weight: bold;
    line-height: 100%;
}

#weightFR {
    position: absolute;
    top: 79px;
    left: 68px;
    width: 83px;
    height: 16px;
    line-height: 110%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-right-color: black;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-color: black;
    text-align: right;
}

#weightDetailFR {
    font-size: 15px;
    font-weight: bold;
    line-height: 110%;
}

#weightDetailHighlightedFR {
    font-size: 16px;
    font-weight: bold;
    line-height: 110%;
    background-color: black;
    color: white;
}

#customerReferenceBarcodeFR {
    position: absolute;
    top: 99px;
    left: 90px;
    width: 230px;
    height: 15px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-color: black;
    text-align: left;
}

#customerReferenceFR {
    position: absolute;
    top: 115px;
    left: 1px;
    width: 162px;
    height: 15px;
    padding-left: 3px;
    line-height: 70%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-color: black;
    text-align: left;
}

#customerReferenceHeaderFR {
    font-size: 10px;
}

#customerReferenceDetailFR {
    font-size: 10px;
    padding-left: 3px;
}

#accountNumberFR {
    position: absolute;
    top: 129px;
    left: 1px;
    width: 162px;
    height: 15px;
    padding-left: 3px;
    line-height: 70%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-right-color: black;
    border-bottom-style: none;
    text-align: left;
}

#accountNumberHeaderFR {
    font-size: 10px;
}

#accountNumberDetailFR {
    padding-left: 3px;
    font-size: 10px;
}

#deliveryDepotFR {
    font-weight: bold;
    position: absolute;
    top: 135px;
    left: 198px;
    background-color: #FFFFFF;
    text-align: left;
    font-size: 64px;
}

#originAddressLabelFR {
    position: absolute;
    top: 147px;
    left: 1px;
    padding-left: 3px;
    line-height: 90%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-top-style: none;
    border-top-width: 1px;
    border-color: black;
    text-align: left;
    font-size: 9px;
}

#originAddressFR {
    position: absolute;
    top: 145px;
    left: 30px;
    width: 162px;
    height: 55px;
    padding-left: 3px;
    line-height: 70%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-top-style: none;
    border-top-width: 1px;
    border-color: black;
    text-align: left;
}

#originAddressHeaderFR {
	font-size: 8px;
}

#originAddressDetailFR {
    font-size: 8px;
}

#deliveryAddressLabelFR {
    position: absolute;
    top: 204px;
    left: 1px;
    padding-left: 3px;
    line-height: 90%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-color: black;
    text-align: left;
    font-size: 9px;
}

#deliveryAddressFR {
    position: absolute;
    top: 199px;
    left: 30px;
    width: 290px;
    height: 105px;
    padding-left: 3px;
    line-height: 100%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-color: black;
    text-align: left;
}

#deliveryAddressHeaderFR {
    font-size: 9px;
}

#deliveryAddressDetailFR {
    font-size: 15px;
}

#specialInstructionsFR {
    position: absolute;
    top: 277px;
    left: 1px;
    width: 325px;
    height: 10px;
    padding-left: 3px;
    line-height: 100%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-color: black;
    text-align: left;
    font-size: 10px;
}

#contactNameFR {
    position: absolute;
    top: 289px;
    left: 1px;
    width: 162px;
    height: 18px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-right-color: black;
    border-bottom-style: none;
    text-align: left;
    padding-left: 3px;
    font-size: 10px;
}

#contactNameHeaderFR {
    font-size: 10px;
}

#contactNameDetailFR {
    padding-left: 3px;
    font-size: 10px;
}

#contactPhoneFR {
    position: absolute;
    top: 301px;
    left: 1px;
    width: 162px;
    height: 18px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: none;
    border-right-color: black;
    border-bottom-style: none;
    text-align: left;
    padding-left: 3px;
    font-size: 10px;
}

#contactPhoneHeaderFR {
    font-size: 10px;
}

#contactPhoneDetailFR {
    padding-left: 3px;
    font-size: 10px;
}

#postcodeHeaderFR {
    position: absolute;
    top: 319px;
    left: 1px;
    width: 65px;
    padding-left: 3px;
    font-size: 9px;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-color: black;
    text-align: left;
}

#postcodeFR {
    position: absolute;
    top: 315px;
    left: 68px;
    width: 96px;
    height: 29px;
    background-color: black;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: none;
    border-color: black;
    text-align: left;
}

#postcodeDetailFR {
    position: relative;
    left: 3px;
    background-color: black;
    font-size: 23px;
    font-weight: bold;
    color: white;
}

#clustercodeDetailFR {
    position: relative;
    top: 0px;
    left: 7px;
    background-color: black;
    font-size: 23px;
    font-weight: bold;
    color: white;
}

#pickupDateFR {
    position: absolute;
    top: 307px;
    left: 170px;
    width: 157px;
    text-align: left;
}

#pickupDateHeaderFR {
    font-size: 9px;
}

#pickupDateDetailFR {
    font-size: 9px;
}

#cashAmountFR {
    position: absolute;
    top: 325px;
    left: 170px;
    width: 157px;
    text-align: left;
    font-size: 16px;
}


#barcodeFR {
    position: absolute;
    top: 348px;
    left: 1px;
    width: 327px;
}

#barcodeFR img {
    padding-top: 10px;
    width: 280px;
    height: 105px;
}

#barcodeLabelFR {
    position: absolute;
    top: 473px;
    left: 1px;
    width: 327px;
    font-size: 9px;
}

#boxIT {
    position: relative;
    top: 9px;
    left: 9px;
    border-collapse: collapse;
    border-style: solid;
    border-width: 1px;
    text-align: center;
    font-family: arial;
    width: 330px;
    height: 485px;
}

#logoIT {
    position: absolute;
    top: 1px;
    left: 1px;
    width: 112px;
    height: 61px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    text-align: center;
    padding-top: 10px;
}

#logoIT img {
    text-align: center;
    height: 35px;
}

#marketAndTransportTypeIT {
    position: absolute;
    top: 1px;
    left: 116px;
    width: 138px;
    height: 28px;
    background-color: #FFFFFF;
    font-weight: plain;
    font-size: 18px;
    text-align: left;
}

#hazardousIT {
    position: absolute;
    top: 22px;
    left: 116px;
    width: 138px;
    font-weight: bold;
    font-size: 16px;
    text-align: left;
}

#xrayIT {
    position: absolute;
    top: 40px;
    left: 116px;
    width: 138px;
    font-weight: bold;
    font-size: 16px;
    text-align: left;
}

#freeCirculationIndicatorIT {
    position: absolute;
    top: 0px;
    left: 254px;
    width: 39px;
    height: 61px;
    border-right-width: 1px;
    border-right-style: solid;
    border-left-width: 1px;
    border-left-style: solid;
    border-color: black;
    font-weight: bold;
    font-size: 45px;
    text-align: center;
}

#sortSplitIndicatorIT {
    position: absolute;
    top: 1px;
    left: 294px;
    width: 39px;
    height: 60px;
    border-color: black;
    font-weight: bold;
    font-size: 45px;
    text-align: center;
}

#conNumberIT {
    position: absolute;
    top: 61px;
    left: 1px;
    width: 162px;
    height: 31px;
    line-height: 60%;
    padding-left: 3px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-right-color: black;
    border-top-width: 1px;
    border-top-style: solid;
    border-top-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-bottom-color: #FFFFFF;
    text-align: left;
}

#conNumberHeaderIT {
    font-size: 10px;
}

#conNumberDetailIT {
    font-weight: bold;
    font-size: 24px;
    line-height: 100%;
}

#serviceIT {
    position: absolute;
    top: 61px;
    left: 167px;
    width: 163px;
    height: 32px;
    line-height: 70%;
    background-color: #000000;
    border-color: black;
    border-top-width: 1px;
    border-top-style: solid;
    color: #FFFFFF;
    text-align: left;
}

#serviceHeaderIT {
    font-size: 10px;
}

#serviceDetailIT {
    font-weight: bold;
    line-height: 100%;
}

#optionIT {
    position: absolute;
    top: 92px;
    left: 167px;
    width: 163px;
    height: 31px;
    line-height: 75%;
    background-color: #000000;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
    color: #FFFFFF;
}

#optionHeaderIT {
    font-size: 10px;
}

#optionDetailIT {
    font-weight: bold;
    font-size: 14px;
    line-height: 100%;
}

#optionDetailIT {
    font-weight: bold;
    font-size: 14px;
    line-height: 75%;
}

#pieceIT {
    position: absolute;
    top: 93px;
    left: 1px;
    width: 83px;
    height: 31px;
    padding-left: 3px;
    line-height: 75%;
    background-color: #FFFFFF;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#pieceHeaderIT {
    font-size: 10px;
}

#pieceDetailIT {
    font-size: 16px;
    font-weight: bold;
    line-height: 100%;
}

#weightIT {
    position: absolute;
    top: 93px;
    left: 87px;
    width: 79px;
    height: 31px;
    line-height: 75%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-right-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#weightHeaderIT {
    font-size: 10px;
}

#weightDetailIT {
    font-size: 16px;
    font-weight: bold;
    line-height: 100%;
}

#weightDetailHighlightedIT {
    font-size: 16px;
    font-weight: bold;
    line-height: 100%;
    background-color: black;
    color: white;
}

#contactInfoIT {
    position: absolute;
    top: 125px;
    left: 1px;
    width: 162px;
    height: 24px;
    padding-left: 3px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-color: black;
    text-align: left;
    line-height: 65%;
}

#contactInfoHeaderIT {
    font-size: 9px;
}

#contactInfoDetailIT {
    font-size: 12px;
    font-weight: bold;
    padding-left: 3px;
}

#referenceIT {
    position: absolute;
    top: 139px;
    left: 1px;
    width: 162px;
    height: 18px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-right-color: black;
    border-bottom-style: none;
    text-align: left;
    padding-left: 3px;
    line-height: 65%;
}

#referenceHeaderIT {
    font-size: 9px;
}

#referenceDetailIT {
    font-size: 12px;
    font-weight: bold;
    padding-left: 3px;
}

#accountNumberIT {
    position: absolute;
    top: 151px;
    left: 1px;
    width: 162px;
    height: 9px;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-right-color: black;
    border-bottom-style: solid;
    border-bottom-width: 1px;
    text-align: left;
    padding-left: 3px;
    padding-bottom: 5px;
    font-size: 10px;
}

#accountNumberHeaderIT {
    font-size: 9px;
}

#accountNumberDetailIT {
    font-size: 12px;
    font-weight: bold;
    padding-left: 3px;
}

#originDepotIT {
    position: absolute;
    top: 123px;
    left: 168px;
    width: 88px;
    height: 34px;
    padding-left: 3px;
    text-align: left;
    line-height: 90%;
}

#originDepotHeaderIT {
    float:left;
    font-size: 9px;
}

#originDepotDetailIT {
    font-size: 24px;
    font-weight: bold;
    padding-left: 20px;
    position: relative;
    top: -1px;
}

#pickupDateIT {
    position: absolute;
    top: 122px;
    left: 260px;
    width: 75px;
    height: 32px;
    text-align: left;
    line-height: 75%;
}

#pickupDateHeaderIT {
    font-size: 10px;
}

#pickupDateDetailIT {
    font-size: 10px;
}

#originAddressIT {
    position: absolute;
    top: 166px;
    left: 1px;
    width: 162px;
    height: 66px;
    padding-left: 3px;
    line-height: 65%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: dashed;
    border-color: black;
    text-align: left;
}

#originAddressHeaderIT {
    font-size: 9px;
}

#originAddressDetailIT {
    font-size: 9px;
    padding-left: 10px;
}

#deliveryAddressIT {
    position: absolute;
    top: 233px;
    left: 1px;
    width: 162px;
    height: 70px;
    padding-left: 3px;
    line-height: 70%;
    background-color: #FFFFFF;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#deliveryAddressHeaderIT {
    font-size: 9px;
}

#deliveryAddressDetailIT {
    font-size: 9px;
    padding-left: 10px;
}

#routingIT {
    position: absolute;
    top: 154px;
    left: 168px;
    width: 159px;
    height: 125px;
    padding-left: 3px;
    padding-top: 1px;
    line-height: 55%;
    background-color: #FFFFFF;
    border-bottom-width: 1px;
    border-bottom-style: dashed;
    border-top-width: 1px;
    border-top-style: dashed;
    border-color: black;
    text-align: left;
}

#routingHeaderIT {
    float:left;
    font-size: 10px;
}

#routingDetailIT {
    font-size: 32px;
    font-weight: bold;
    padding-left: 40px;
    padding-top: 0px;
    line-height: 90%;
    float: left;
}

#sortIT {
    position: absolute;
    top: 282px;
    left: 167px;
    width: 159px;
    height: 29px;
    padding-left: 3px;
    background-color: #FFFFFF;
    border-bottom-width: 1px;
    border-bottom-style: dashed;
    border-color: black;
    text-align: left;
}

#sortHeaderIT {
    float:left;
    font-size: 10px;
}

#sortDetailIT {
    font-size: 30px;
    font-weight: bold;
    padding-left: 15px;
    line-height: 100%;
}

#microzonaHeaderIT {
    position: absolute;
    top: 315px;
    left: 0px;
    width: 60px;
    height: 30px;
    padding-left: 4px;
    font-size: 9px;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: left;
}

#microzonaIT {
    position: absolute;
    top: 304px;
    left: 48px;
    width: 79px;
    height: 41px;
    background-color: black;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: center;
}

#microzonaDetailIT {
    position: relative;
    top: 6px;
    background-color: black;
    font-size: 24px;
    font-weight: bold;
    color: white;
}

#bulkShipmentHeaderIT {
    position: absolute;
    top: 304px;
    left: 123px;
    width: 11px;
    height: 41px;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
}

#bulkShipmentIT {
    position: absolute;
    top: 304px;
    left: 133px;
    width: 33px;
    height: 41px;
    background-color: black;
    border-right-width: 1px;
    border-right-style: solid;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    border-color: black;
    text-align: center;
}

#bulkShipmentDetailIT {
    position: relative;
    top: 3px;
    background-color: black;
    font-size: 30px;
    font-weight: bold;
    color: white;
}

#destinationDepotHeaderIT {
    position: absolute;
    top: 315px;
    left: 167px;
    width: 42px;
    height: 30px;
    padding-left: 3px;
    border-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    text-align: left;
    font-size: 10px;
}

#destinationDepotDetailIT {
    position: absolute;
    top: 312px;
    left: 203px;
    width: 128px;
    height: 33px;
    border-color: black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
    text-align: left;
    font-size: 32px;
    font-weight: bold;
    line-height: 100%;
}

#barcodeIT {
    position: absolute;
    top: 348px;
    left: 1px;
    width: 327px;
}

#barcodeIT img {
    padding-top: 10px;
    width: 326px;
    height: 105px;
}

#barcodeLabelIT {
    position: absolute;
    top: 473px;
    left: 1px;
    width: 327px;
    font-size: 9px;
}

#errorLogo {
	background-color: #FFFFFF;
	text-align: center;
	padding: 2px;
	float: left;
	width: 125px;
	height: 65px;
}

#errorLogo img {
	text-align: center;
	float: left;
	height: 65px;
}

#errorBox {
	border-collapse: collapse;
	border-style: none;
	width: 384px;
	page-break-after: always;
}

#errorHeader {
	padding: 2px;
	font-weight: bold;
	font-size: 23px;
	text-align: left;
	height: 45px;
}

#errorCode {
	border-width: 1px;
	border-style: solid;
	border-top-style: none;
	border-collapse: collapse;
	width: 385px;
	height: 20px;
	float: left;
}

#errorCodeHeader {
	float: left;
	font-size: 17px;
	font-weight: bold;
	text-align: left;
	border-right-width: 1px;
	border-right-style: solid;
	padding-left: 4px;
	width: 125px;
}

#errorCodeDetail {
	font-weight: normal;
	font-size: 17px;
	text-align: left;
	padding-left: 4px;
}

#errorConNumber {
	border-width: 1px;
	border-style: solid;
	border-collapse: collapse;
	width: 385px;
	height: 20px;
	float: left;
}

#errorConNumberHeader {
	float: left;
	font-size: 17px;
	font-weight: bold;
	text-align: left;
	border-right-width: 1px;
	border-right-style: solid;
	padding-left: 4px;
	width: 125px;
}

#errorConNumberDetail {
	font-weight: normal;
	font-size: 17px;
	text-align: left;
	padding-left: 4px;
}

#errorDescription {
	border-collapse: collapse;
	border-width: 1px;
	border-style: solid;
	border-top-style: none;
	width: 385px;
	height: auto;
	margin-bottom: 5px;
	float: left;
}

#errorDescriptionDetail {
	float: left;
	font-weight: normal;
	font-size: 17px;
	text-align: left;
	padding-left: 4px;
}
</style>
<title>TNT Label</title>
</head>
<body>

<xsl:choose>
    <xsl:when test="(//consignmentLabelData/sender/country = 'IT') and (//consignmentLabelData/delivery/country = 'IT')">
        <xsl:for-each select="//consignment/pieceLabelData">
            <xsl:call-template name="ItalianDomesticHtml" />
        </xsl:for-each>
    </xsl:when>
	<xsl:when test="(//consignmentLabelData/sender/country = 'FR') and (//consignmentLabelData/delivery/country = 'FR')">
		<xsl:for-each select="//consignment/pieceLabelData">
			<xsl:call-template name="FrenchDomesticHtml" />
		</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
		<xsl:for-each select="//consignment/pieceLabelData">
			<xsl:call-template name="RestOfWorldHtml" />
		</xsl:for-each>
	</xsl:otherwise>
</xsl:choose>


<!--Brokenrules-->

    <xsl:variable name="numberBrokenRules" select="count(//brokenRules)" />
    <xsl:if test="$numberBrokenRules >0">
      <!--Logo -->
      <span id="errorLogo">
          <img src='lib/tnt/label/logo_orig.jpg' alt='logo' id="tntLogo" />
      </span>
      <span id="errorHeader">ExpressLabel Error(s)</span>

    <div id="errorBox" style="clear:left">
        <xsl:for-each select="//brokenRules">
            <div id="errorConNumber">
                <span id="errorConNumberHeader">KEY:</span>
                <span id="errorConNumberDetail">
                    <xsl:value-of select="@key" />
                </span>
            </div>
            <div id="errorCode">
                <span id="errorCodeHeader">ERROR CODE:</span>
                <span id="errorCodeDetail">
                    <xsl:value-of select="errorCode" />
                </span>
            </div>
            <div id="errorDescription">
                <span id="errorDescriptionDetail">
                    <xsl:value-of select="errorDescription" />
                </span>
            </div>
        </xsl:for-each>
    </div>
    </xsl:if>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
