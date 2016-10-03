xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-parameter parameter="$aMA_ProfileReadRQ1" element="ns0:AMA_ProfileReadRQ" location="../../PortalInterfaces/schema/AMA_ProfileReadRQ.xsd" ::)
(:: pragma bea:schema-type-return type="ns1:ListOfAyLoyMemberIntTopElmt" location="../../SiebelInterfaces/wsdl/AYLoyMemberInterests.wsdl" ::)


(:: pragma bea : Created By : Piyush Kapoor            Date : 26-Jun-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileRetrieve_GetProfile/XQ_Req_AYLoyMemberInterest/";
declare namespace com = "http://com.finnair";
declare namespace asi="http://siebel.com/asi/";
declare namespace ay="http://www.siebel.com/xml/AY%20LOY%20Member%20Intascc";
declare namespace pros="http://com.finnair/MemberProfileRetrieve/";


declare function xf:XQ_Req_AYLoyMemberInterest($MainRequest as element())
    as element(asi:QueryPageInterest) {
<asi:QueryPageInterest>
         <Siebel_spcMessage>
            <ay:ListOfAyLoyMemberInt>
           
               <ay:LoyMember>
                  
                  <ay:MemberNumber>{data($MainRequest/com:AMA_ProfileReadRQ/com:UniqueID/@ID)}</ay:MemberNumber>
                 
               </ay:LoyMember>
            </ay:ListOfAyLoyMemberInt>
         </Siebel_spcMessage>
         <PageSize>50</PageSize>
         <ViewMode>All</ViewMode>
         <StartRowNum>0</StartRowNum>
      </asi:QueryPageInterest>

};

declare variable $MainRequest as element() external;

xf:XQ_Req_AYLoyMemberInterest($MainRequest)