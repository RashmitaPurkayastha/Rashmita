(:: pragma bea:global-element-parameter parameter="$aMA_ProfileReadRS1" element="ns0:AMA_ProfileReadRS" location="../../PortalInterfaces/schema/AMA_ProfileReadRS.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AMA_ProfileReadRS" location="../../PortalInterfaces/schema/AMA_ProfileReadRS.xsd" ::)

declare namespace ns0 = "http://com.finnair";
declare namespace xf = "http://com.finnair/MemberProfileRetrieve_GetProfile/XQ_Res_GetProfileFault/";
declare namespace mem="http://com.finnair/MemberProfileRetrieve/";

declare function xf:XQ_Res_GetProfileFault($aMA_ProfileReadRS1 as element(ns0:AMA_ProfileReadRS),$ErrorCode as xs:string, $ErrorDescription as xs:string, $StageText as xs:string)
    as element(ns0:AMA_ProfileReadRS) {
        <ns0:AMA_ProfileReadRS Version="10.2">
            <ns0:Errors>
                <ns0:Error Type = "21"
                           ShortText = "{$ErrorDescription}"
                           Code = "{$ErrorCode}"> </ns0:Error>
            </ns0:Errors>
        </ns0:AMA_ProfileReadRS>
};

declare variable $aMA_ProfileReadRS1 as element(ns0:AMA_ProfileReadRS) external;
declare variable $ErrorCode as xs:string external;
declare variable $ErrorDescription as xs:string external;
declare variable $StageText as xs:string external;

xf:XQ_Res_GetProfileFault($aMA_ProfileReadRS1,$ErrorCode,$ErrorDescription,$StageText)