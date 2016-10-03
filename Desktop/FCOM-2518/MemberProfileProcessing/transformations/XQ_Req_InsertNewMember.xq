xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-parameter parameter="$aMA_ProfileCreateRQ1" element="ns0:AMA_ProfileCreateRQ" location="../../PortalInterfaces/schema/AMA_ProfileCreateRQ.xsd" ::)
(:: pragma bea:schema-type-return type="ns1:ListOfAyLoyMemberTopElmt" location="../../SiebelInterfaces/wsdl/AYRESNewMember.wsdl" ::)

(:: pragma bea : Created By : Piyush Kapoor            Date : 21-July-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Req_InsertNewMember/";
declare namespace com = "http://com.finnair";
declare namespace asi="http://siebel.com/asi/";
declare namespace loy="http://www.siebel.com/xml/LOY%20Member";
declare namespace prof="http://com.finnair/profileProcessing/";

declare function xf:XQ_Req_InsertNewMember($InsertNewMember as element(prof:InsertNewMember))
    as element(asi:ReturnBasicMembData) {
      <asi:ReturnBasicMembData>
         <FirstName>{data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:Customer/com:PersonName/com:GivenName)}</FirstName>
         <Gender>{ if(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:Customer/@Gender)="Male") then ("M")
else if(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:Customer/@Gender)="Female") then ("F")
else "NA"  }</Gender>
         <SiebelMessage>
            <loy:ListOfAyLoyMember>
       
               <loy:AyLoyMember>
                  
               </loy:AyLoyMember>
            </loy:ListOfAyLoyMember>
         </SiebelMessage>
         <LastName>{data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:Customer/com:PersonName/com:Surname)}</LastName>
      </asi:ReturnBasicMembData>
};

declare variable $InsertNewMember as element(prof:InsertNewMember) external;

xf:XQ_Req_InsertNewMember($InsertNewMember)