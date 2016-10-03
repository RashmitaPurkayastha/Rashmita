(:: pragma bea:global-element-return element="ns0:OptOutRQ" location="../../PortalInterfaces/schema/OptOut.xsd" ::)

declare namespace ns0 = "http://com.finnair";
declare namespace xf = "http://tempuri.org/MemberProfileProcessing/transformations/XQ_Req_OptOut/";

declare function xf:XQ_Req_OptOut($memberNumber as xs:string,
    $attributeKey as xs:string)
    as element(ns0:OptOutRQ) {
        <ns0:OptOutRQ>
            <ns0:MemberNumber>{ $memberNumber }</ns0:MemberNumber>
            <ns0:AttributeKey>{ $attributeKey }</ns0:AttributeKey>
        </ns0:OptOutRQ>
};

declare variable $memberNumber as xs:string external;
declare variable $attributeKey as xs:string external;

xf:XQ_Req_OptOut($memberNumber,
    $attributeKey)