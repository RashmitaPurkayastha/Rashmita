xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-parameter parameter="$listOfAyresEnrollPromotion1" element="ns1:ListOfAyresEnrollPromotion" location="../../SiebelInterfaces/wsdl/AYRESEnrollPromotion.wsdl" ::)
(:: pragma bea:global-element-return element="ns0:AMA_UpdateRS" location="../../PortalInterfaces/schema/AMA_UpdateRS.xsd" ::)

(:: pragma bea : Created By : Debarati Das            Date : 5-Aug-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Res_LinkMemberToPromotion/";
declare namespace ns1 = "http://www.siebel.com/xml/AYRES%20Enroll%20Promotion";
declare namespace ns0 = "http://com.finnair";
declare namespace asi = "http://siebel.com/asi/";
declare namespace prof = "http://com.finnair/profileProcessing/";

declare function xf:XQ_Res_LinkMemberToPromotion($MemberNumber as xs:string)
    as element(prof:LinkMemberToPromotionResponse) {

<prof:LinkMemberToPromotionResponse>

        <ns0:AMA_UpdateRS Version="10.2">
       <ns0:Success></ns0:Success>
<ns0:UniqueID Type = "21" Instance = "2" ID_Context = "LOYALTYNUMBER"  ID = "{data($MemberNumber)}" />
</ns0:AMA_UpdateRS>

</prof:LinkMemberToPromotionResponse>
};


declare variable $MemberNumber as xs:string external;

xf:XQ_Res_LinkMemberToPromotion($MemberNumber)