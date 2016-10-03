(:: pragma bea:global-element-parameter parameter="$aMA_ProfileCreateRS1" element="ns0:AMA_ProfileCreateRS" location="../../PortalInterfaces/schema/AMA_ProfileCreateRS.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AMA_ProfileCreateRS" location="../../PortalInterfaces/schema/AMA_ProfileCreateRS.xsd" ::)

(:: pragma bea : Created By : Gaurav Kumar           Date : 19-Jan-2012            Version : 1.0.0 ::)

declare namespace com = "http://com.finnair";
declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Res_MemberProcessingFault/";
declare namespace mem="http://com.finnair/MemberProfileRetrieve/";

declare function xf:XQ_Res_ProfileRetrieveFault($ErrorCode as xs:string, $ErrorDescription as xs:string, $StageText as xs:string)
    as element() {
        <com:IdentifyRS >
            <com:Errors>
                <com:Error Type = "21"
                           ShortText = "{$ErrorDescription}"
                           Code = "{$ErrorCode}">{$StageText}</com:Error>
            </com:Errors>
        </com:IdentifyRS>



};

declare variable $ErrorCode as xs:string external;
declare variable $ErrorDescription as xs:string external;
declare variable $StageText as xs:string external;
declare variable $OperationName as xs:string external;

xf:XQ_Res_ProfileRetrieveFault($ErrorCode,$ErrorDescription,$StageText)