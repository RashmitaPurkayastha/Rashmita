(:: pragma bea:global-element-parameter parameter="$aMA_UpdateRQ1" element="ns0:AMA_UpdateRQ" location="../../PortalInterfaces/schema/AMA_UpdateRQ.xsd" ::)
(:: pragma bea:schema-type-return type="ns1:ListOfAyLoyMemberIntTopElmt" location="../../SiebelInterfaces/wsdl/AYLoyMemberInterests.wsdl" ::)


(:: pragma bea : Created By : Piyush Kapoor            Date : 28-July-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Req_AYLoyMemberInterestSynchronize/";
declare namespace ay = "http://www.siebel.com/xml/AY%20LOY%20Member%20Int";
declare namespace com = "http://com.finnair";
declare namespace prof="http://com.finnair/profileProcessing/";
declare namespace asi="http://siebel.com/asi/";


declare function xf:XQ_Req_AYLoyMemberInterestSynchronize($UpdateProfile as element(prof:UpdateProfile))
    as element(asi:SynchronizeInterest) {
        <asi:SynchronizeInterest>
         <SiebelMessage>
            <ay:ListOfAyLoyMemberInt>
               <ay:LoyMember>
                  <ay:MemberNumber>{data($UpdateProfile//com:AMA_UpdateRQ/com:UniqueID/@ID)}</ay:MemberNumber>
                   <ay:ListOfAyLoyMemberInterests>
             {      
             for $var in (1 to fn:count($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField))
where (data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="1" or data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="2")      
       return 
      

      
             for $key1 in (1 to fn:count(fn:tokenize(data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[$var]) , ',')[. != '']))
let $Dest := data(fn:tokenize(data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[$var]),',')[$key1])
             return  
                     <ay:AyLoyMemberInterests>
                        <ay:Id>{$key1}-SS</ay:Id>
                        <ay:AYComments>PORTAL INSERTED</ay:AYComments>
                       <ay:AYInterestName>{$Dest}</ay:AYInterestName>
                        <ay:AYInterestType>{if (data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="1") then
  "Favorite Leisure Dest Type"

else if (data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="2") then
  "Favorite Vacation Type"
    
else""}

</ay:AYInterestType>
                        <ay:AYPriority/>
                        <ay:AYValue/>
                        <ay:Type>Interest</ay:Type>
                     </ay:AyLoyMemberInterests>

                   }
					{
					if (fn:exists($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:PrefCollections[1]/com:PrefCollection/com:AirlinePref/com:AirportOriginPref)) then
					<ay:AyLoyMemberInterests>
                        <ay:Id>{data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:PrefCollections[1]/com:PrefCollection/com:AirlinePref/com:AirportOriginPref/@LocationCode)}-SS</ay:Id>
                        <ay:AYComments>PORTAL INSERTED</ay:AYComments>
                        <ay:AYInterestName>{data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:PrefCollections[1]/com:PrefCollection/com:AirlinePref/com:AirportOriginPref/@LocationCode)}</ay:AYInterestName>
                        <ay:AYInterestType>Usual Departure city/Airport</ay:AYInterestType>
                        <ay:AYPriority/>
                        <ay:AYValue/>
                        <ay:Type>Interest</ay:Type>
                    </ay:AyLoyMemberInterests>
					else
						""
					}
					{
					if (fn:exists($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTBUSI"])) then 
						let $Count := fn:count(fn:tokenize(data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTBUSI"]), ',')[. != ''])
             			for $key1 in (1 to $Count)
							let $Dest := data(fn:tokenize(data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTBUSI"]),',')[$key1])
             				return  
                     <ay:AyLoyMemberInterests>
                        <ay:Id>{$key1}-SS</ay:Id>
                        <ay:AYComments>PORTAL INSERTED</ay:AYComments>
                        <ay:AYInterestName>{$Dest}</ay:AYInterestName>
                        <ay:AYInterestType>Usual Business Destination</ay:AYInterestType>
                        <ay:AYPriority/>
                        <ay:AYValue/>
                        <ay:Type>Interest</ay:Type>
                    </ay:AyLoyMemberInterests>
					else 
						""
					}                     
					{
					if (fn:exists($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTLEIS"])) then 
						let $Count := fn:count(fn:tokenize(data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTLEIS"]), ',')[. != ''])
             			for $key1 in (1 to $Count)
							let $Dest := data(fn:tokenize(data($UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTLEIS"]),',')[$key1])
             				return  
                     <ay:AyLoyMemberInterests>
                        <ay:Id>{$key1}-SS</ay:Id>
                        <ay:AYComments>PORTAL INSERTED</ay:AYComments>
                        <ay:AYInterestName>{$Dest}</ay:AYInterestName>
                        <ay:AYInterestType>Favorite Leisure Destination</ay:AYInterestType>
                        <ay:AYPriority/>
                        <ay:AYValue/>
                        <ay:Type>Interest</ay:Type>
                    </ay:AyLoyMemberInterests>
					else 
						""
					}                     
                     
                     </ay:ListOfAyLoyMemberInterests>
               
               </ay:LoyMember>
            </ay:ListOfAyLoyMemberInt>
         </SiebelMessage>

      </asi:SynchronizeInterest>
};

declare variable $UpdateProfile as element(prof:UpdateProfile) external;



xf:XQ_Req_AYLoyMemberInterestSynchronize($UpdateProfile)