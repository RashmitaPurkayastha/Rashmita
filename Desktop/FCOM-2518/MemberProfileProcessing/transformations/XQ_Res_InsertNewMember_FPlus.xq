(:: pragma bea:global-element-return element="ns0:AMA_ProfileCreateRS" location="../../PortalInterfaces/schema/AMA_ProfileCreateRS.xsd" ::)

(:: pragma bea : Created By : Piyush Kapoor            Date : 5-Aug-2010            Version : 1.0.0 ::)

declare namespace ns0 = "http://com.finnair";
declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Res_InsertNewMember/";
declare namespace m="http://com.finnair/profileProcessing/";

declare function xf:XQ_Res_InsertNewMember($MemberNumber as xs:string)
    as element(m:InsertNewMemberResponse) {
<m:InsertNewMemberResponse>
        <ns0:AMA_ProfileCreateRS Version="10.2">
<ns0:Success/>            
            <ns0:UniqueID Type = "21"
                          ID = "{$MemberNumber}"
                          Instance="1 - ODB FAIL"
                          ID_Context = "LOYALTYNUMBER"/>
        </ns0:AMA_ProfileCreateRS>
</m:InsertNewMemberResponse>
};

declare variable $MemberNumber as xs:string external;

xf:XQ_Res_InsertNewMember($MemberNumber)