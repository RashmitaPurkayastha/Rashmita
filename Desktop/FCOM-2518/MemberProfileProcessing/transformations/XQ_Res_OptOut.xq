(:: pragma bea:global-element-return element="ns0:OptOutRS" location="../../PortalInterfaces/schema/OptOut.xsd" ::)

declare namespace ns0 = "http://com.finnair";
declare namespace xf = "http://tempuri.org/MemberProfileProcessing/transformations/XQ_Res_OptOut/";
declare namespace prof = "http://com.finnair/profileProcessing/";

declare function xf:Wrap($e as element())
    as element() {
        <prof:MarketingCommunicationsOptOutResponse>
	    	{$e}
        </prof:MarketingCommunicationsOptOutResponse>
};

declare function xf:XQ_Res_OptOut($ErrorCode as xs:string,
    $ErrorMessage as xs:string)
    as element(ns0:OptOutRS) {
        <ns0:OptOutRS>
            <ns0:ErrorCode>{ $ErrorCode }</ns0:ErrorCode>
            <ns0:ErrorMessage>{ $ErrorMessage }</ns0:ErrorMessage>
        </ns0:OptOutRS>
};

declare variable $ErrorCode as xs:string external;
declare variable $ErrorMessage as xs:string external;

xf:Wrap(xf:XQ_Res_OptOut($ErrorCode, $ErrorMessage))