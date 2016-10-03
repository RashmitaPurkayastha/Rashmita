declare namespace mem="http://com.finnair/MemberProfileRetrieve/";
declare namespace ayr = "http://www.siebel.com/xml/AYRES%20Member%20Information%20-%20Short";
declare namespace xf = "http://com.finnair/ProfileRetieve/transformations/XQ_Req_QueryByExampleFullMember/";
declare namespace asi = "http://siebel.com/asi/";
declare namespace com="http://com.finnair";

declare function xf:XQ_Req_QueryByExampleMember($profileRetieveRequest as element())
    as element(asi:QueryByExampleMember) {
 <asi:QueryByExampleMember>
        <SiebelMessage>
    <ayr:ListOfAyresMemberInformation-Short>

        <ayr:LoyMember>
             <ayr:MemberNumber>{ data($profileRetieveRequest/mem:Identify/com:IdentifyRQ/com:MemberNumber) }</ayr:MemberNumber>
        </ayr:LoyMember>
    </ayr:ListOfAyresMemberInformation-Short>
</SiebelMessage>
   </asi:QueryByExampleMember>
         
};

declare variable $profileRetieveRequest as element() external;

xf:XQ_Req_QueryByExampleMember($profileRetieveRequest)