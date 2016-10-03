(:: pragma bea:global-element-return element="ns0:AMA_UpdateRS" location="../../PortalInterfaces/schema/AMA_UpdateRS.xsd" ::)

(:: pragma bea : Created By : Piyush Kapoor            Date : 5-Aug-2010            Version : 1.0.0 ::)

declare namespace ns0 = "http://com.finnair";
declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Res_UpdateProfile/";
declare namespace prof = "http://com.finnair/profileProcessing/";

declare function xf:Wrap($e as element())
    as element() {
        <prof:UpdateProfileResponse>
	    	{$e}
        </prof:UpdateProfileResponse>
};

declare function xf:XQ_Res_UpdateProfile($MemberNumber as xs:string)
    as element(ns0:AMA_UpdateRS) {
        <ns0:AMA_UpdateRS Version="10.2">
        <ns0:Success/>
            <ns0:UniqueID Type = "21"
            			  Instance = "2"
                          ID = "{$MemberNumber}"
                          ID_Context = "LOYALTYNUMBER"/>
           
        </ns0:AMA_UpdateRS>
};

declare variable $MemberNumber as xs:string external;

xf:Wrap(xf:XQ_Res_UpdateProfile($MemberNumber))