xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-parameter parameter="$aMA_ProfileReadRQ1" element="ns1:AMA_ProfileReadRQ" location="../../PortalInterfaces/schema/AMA_ProfileReadRQ.xsd" ::)
(:: pragma bea:schema-type-return type="ns0:ListOfAyresMemberInformationLongPortalTopElmt" location="../../SiebelInterfaces/wsdl/AYLoyMemberPortal.wsdl" ::)

(:: pragma bea : Created By : Piyush Kapoor            Date : 10-Jun-2010            Version : 1.0.0 ::)


declare namespace xf = "http://com.finnair/MemberProfileRetrieve_GetProfile/XQ_Req_AYLoyMemberPortal/";
declare namespace com = "http://com.finnair";
declare namespace asi="http://siebel.com/asi/"; 
declare namespace ayr="http://www.siebel.com/xml/AYRES%20Member%20Information%20–%20Long%20Portal";
declare namespace pros="http://com.finnair/MemberProfileRetrieve/" ;


declare function xf:XQ_Req_AYLoyMemberPortal($GetProfile as element())
    as element(asi:QuerybyExampleFullMember) {
 
        <asi:QuerybyExampleFullMember>
        <SiebelMessage>
    <ayr:ListOfAyresMemberInformationLongPortal>

        <ayr:LoyMember>
             <ayr:MemberNumber>{data($GetProfile/com:AMA_ProfileReadRQ/com:UniqueID/@ID)}</ayr:MemberNumber>
        </ayr:LoyMember>
    </ayr:ListOfAyresMemberInformationLongPortal>
</SiebelMessage>
   </asi:QuerybyExampleFullMember>
};

declare variable $GetProfile as element() external;

xf:XQ_Req_AYLoyMemberPortal($GetProfile)