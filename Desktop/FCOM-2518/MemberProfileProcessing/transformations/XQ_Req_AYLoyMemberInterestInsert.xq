xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-parameter parameter="$aMA_ProfileCreateRQ1" element="ns0:AMA_ProfileCreateRQ" location="../../PortalInterfaces/schema/AMA_ProfileCreateRQ.xsd" ::)
(:: pragma bea:schema-type-return type="ns1:ListOfAyLoyMemberIntTopElmt" location="../../SiebelInterfaces/wsdl/AYLoyMemberInterests.wsdl" ::)


(:: pragma bea : Created By : Piyush Kapoor            Date : 11-Aug-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Req_AYLoyMemberInterestInsert/";
declare namespace ay = "http://www.siebel.com/xml/AY%20LOY%20Member%20Int";
declare namespace com = "http://com.finnair";
declare namespace prof="http://com.finnair/profileProcessing/";
declare namespace asi="http://siebel.com/asi/";


declare function xf:XQ_Req_AYLoyMemberInterestInsert($InsertNewMember as element(prof:InsertNewMember),$MID as xs:string)
    as element(asi:InsertOrUpdateInterest) {
        <asi:InsertOrUpdateInterest>
         <SiebelMessage>
            <ay:ListOfAyLoyMemberInt>
               <ay:LoyMember>
                  <ay:MemberNumber>{$MID}</ay:MemberNumber>
                   <ay:ListOfAyLoyMemberInterests>
              {      
             for $var in (1 to fn:count($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField))
where (data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="1" or data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="2")
 
let $Count := fn:count(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]) , ',')[. != ''])
             return 
             
             for $key1 in (1 to $Count)
let $Dest := data(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]),',')[$key1])
             return  
                     <ay:AyLoyMemberInterests>
                        <ay:Id>{$key1}-SS</ay:Id>
                        <ay:AYComments>PORTAL INSERTED</ay:AYComments>
                       <ay:AYInterestName>{$Dest}</ay:AYInterestName>
                        <ay:AYInterestType>{if (data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="1") then
  "Favorite Leisure Dest Type"

else if (data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="2") then
  "Favorite Vacation Type"
    
else""}

</ay:AYInterestType>

                        <ay:AYPriority/>
                        <ay:AYValue/>
                        <ay:Type>Interest</ay:Type>
                     </ay:AyLoyMemberInterests>

                   }
					{
					if (fn:exists($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:PrefCollections[1]/com:PrefCollection/com:AirlinePref/com:AirportOriginPref)) then
					<ay:AyLoyMemberInterests>
                        <ay:Id>{data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:PrefCollections[1]/com:PrefCollection/com:AirlinePref/com:AirportOriginPref/@LocationCode)}-SS</ay:Id>
                        <ay:AYComments>PORTAL INSERTED</ay:AYComments>
                        <ay:AYInterestName>{data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:PrefCollections[1]/com:PrefCollection/com:AirlinePref/com:AirportOriginPref/@LocationCode)}</ay:AYInterestName>
                        <ay:AYInterestType>Usual Departure city/Airport</ay:AYInterestType>
                        <ay:AYPriority/>
                        <ay:AYValue/>
                        <ay:Type>Interest</ay:Type>
                    </ay:AyLoyMemberInterests>
					else
						""
					}
					{
					if (fn:exists($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTBUSI"])) then 
						let $Count := fn:count(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTBUSI"]), ',')[. != ''])
             			for $key1 in (1 to $Count)
							let $Dest := data(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTBUSI"]),',')[$key1])
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
					if (fn:exists($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTLEIS"])) then 
						let $Count := fn:count(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTLEIS"]), ',')[. != ''])
             			for $key1 in (1 to $Count)
							let $Dest := data(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[@KeyValue="DESTLEIS"]),',')[$key1])
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

      </asi:InsertOrUpdateInterest>
};

declare variable $InsertNewMember as element(prof:InsertNewMember) external;
declare variable $MID as xs:string external;


xf:XQ_Req_AYLoyMemberInterestInsert($InsertNewMember,$MID)