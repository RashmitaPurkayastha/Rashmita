xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-parameter parameter="$aMA_ProfileCreateRQ1" element="ns0:AMA_ProfileCreateRQ" location="../../PortalInterfaces/schema/AMA_ProfileCreateRQ.xsd" ::)
(:: pragma bea:schema-type-return type="ns1:ListOfAyLoyMemberTopElmt" location="../../SiebelInterfaces/wsdl/AYRESNewMember.wsdl" ::)

(:: pragma bea : Created By : Piyush Kapoor            Date : 25-July-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Req_UpdateProfile/";
declare namespace com = "http://com.finnair";
declare namespace asi="http://siebel.com/asi/";
declare namespace ayr="http://www.siebel.com/xml/AYRES%20Member%20Information%20–%20Long%20Portal";
declare namespace prof="http://com.finnair/profileProcessing/";

declare function xf:XQ_Req_UpdateProfile($memberNumber as xs:string) {
<asi:QuerybyExampleFullMember>
	<SiebelMessage>
		<ayr:ListOfAyresMemberInformationLongPortal>
			<ayr:LoyMember>
				<ayr:MemberNumber>{$memberNumber}</ayr:MemberNumber>
			</ayr:LoyMember>
		</ayr:ListOfAyresMemberInformationLongPortal>
	</SiebelMessage>
</asi:QuerybyExampleFullMember>
};

declare variable $memberNumber as xs:string external;

xf:XQ_Req_UpdateProfile($memberNumber)