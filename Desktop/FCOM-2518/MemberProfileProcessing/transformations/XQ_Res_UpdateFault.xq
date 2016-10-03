(:: pragma bea:global-element-parameter parameter="$aMA_ProfileCreateRS1" element="ns0:AMA_ProfileCreateRS" location="../../PortalInterfaces/schema/AMA_ProfileCreateRS.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AMA_ProfileCreateRS" location="../../PortalInterfaces/schema/AMA_ProfileCreateRS.xsd" ::)

(:: pragma bea : Created By : Piyush Kapoor            Date : 5-Aug-2010            Version : 1.0.0 ::)

declare namespace ns0 = "http://com.finnair";
declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Res_MemberProcessingFault/";
declare namespace m = "http://com.finnair/profileProcessing/";
declare namespace soapenv="http://schemas.xmlsoap.org/soap/envelope/";

declare function xf:XQ_Res_MemberProcessingFault($ErrorCode as xs:string, $ErrorDescription as xs:string, $StageText as xs:string)
    as element() {
<soapenv:Body>
<m:UpdateProfileResponse>
        <ns0:AMA_UpdateRS Version="10.2">
            <ns0:Errors>
                <ns0:Error Type = "21"
                           ShortText = "{$ErrorDescription}"
                           Code = "{$ErrorCode}">{$StageText}</ns0:Error>
            </ns0:Errors>
        </ns0:AMA_UpdateRS>
</m:UpdateProfileResponse>
</soapenv:Body>

};


declare variable $ErrorCode as xs:string external;
declare variable $ErrorDescription as xs:string external;
declare variable $StageText as xs:string external;
declare variable $OperationName as xs:string external;

xf:XQ_Res_MemberProcessingFault($ErrorCode,$ErrorDescription,$StageText)