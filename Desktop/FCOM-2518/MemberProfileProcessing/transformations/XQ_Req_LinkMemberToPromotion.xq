(:: pragma bea:global-element-parameter parameter="$aMA_UpdateRQ1" element="ns1:AMA_UpdateRQ" location="../../PortalInterfaces/schema/AMA_UpdateRQ.xsd" ::)
(:: pragma bea:global-element-return element="ns0:ListOfAyresEnrollPromotion" location="../../SiebelInterfaces/wsdl/AYRESEnrollPromotion.wsdl" ::)

(:: pragma bea : Created By : Debarati Das            Date : 5-Aug-2010            Version : 1.0.0 ::)

declare namespace ns1 = "http://com.finnair";
declare namespace ns0= "http://www.siebel.com/xml/AYRES%20Enroll%20Promotion";
declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Req_LinkMemberToPromotion/";
declare namespace asi = "http://siebel.com/asi/";
declare namespace prof = "http://com.finnair/profileProcessing/";

declare function xf:XQ_Req_LinkMemberToPromotion($LinkMemberToPromotion as element(prof:LinkMemberToPromotion))
    as element(asi:InsertOrUpdateMemberPromotion) {
<asi:InsertOrUpdateMemberPromotion>
<SiebelMessage>
        <ns0:ListOfAyresEnrollPromotion>
            <ns0:LoyMember>
                <ns0:MemberNumber>{ data($LinkMemberToPromotion//ns1:AMA_UpdateRQ/ns1:UniqueID/@ID) }</ns0:MemberNumber>
                <ns0:ListOfLoyPromotion>
                    <ns0:LoyPromotion>
                        {
                            for $PromotionCode in $LinkMemberToPromotion//ns1:AMA_UpdateRQ/ns1:Position/ns1:Root/ns1:Profile/ns1:Customer/ns1:Rates/@PromotionCode
                            return
                                <ns0:Id>{ xs:string( data($PromotionCode) ) }</ns0:Id>
                        }
                    </ns0:LoyPromotion>
                </ns0:ListOfLoyPromotion>
            </ns0:LoyMember>
        </ns0:ListOfAyresEnrollPromotion>
</SiebelMessage>
</asi:InsertOrUpdateMemberPromotion>
};

declare variable $LinkMemberToPromotion as element(prof:LinkMemberToPromotion) external;

xf:XQ_Req_LinkMemberToPromotion($LinkMemberToPromotion)