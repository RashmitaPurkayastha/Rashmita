xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-parameter parameter="$aMA_ProfileCreateRQ1" element="ns0:AMA_ProfileCreateRQ" location="../../PortalInterfaces/schema/AMA_ProfileCreateRQ.xsd" ::)
(:: pragma bea:schema-type-return type="ns1:ListOfAyLoyMemberIntTopElmt" location="../../SiebelInterfaces/wsdl/AYLoyMemberInterests.wsdl" ::)


(:: pragma bea : Created By : Piyush Kapoor            Date : 11-Aug-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_Hobby/";
declare namespace ayr =  "http://www.siebel.com/xml/AYRES%20Member%20Information%20–%20Long%20Portal";
declare namespace com = "http://com.finnair";
declare namespace prof="http://com.finnair/profileProcessing/";
declare namespace asi="http://siebel.com/asi/";
declare namespace dvm="http://xmlns.oracle.com/dvm";


declare function dvm:lookupValue($dvmTable as element(*), $sourceColumnName as xs:string,
    $sourceValue as xs:string, $targetColumnName as xs:string, $defaultValue as xs:string)
    as xs:string {
       let $idxSource as xs:integer := for $n at $i in $dvmTable/dvm:columns/dvm:column where ($n/@name = $sourceColumnName) return $i
       let $idxTarget as xs:integer := for $n at $i in $dvmTable/dvm:columns/dvm:column where ($n/@name = $targetColumnName) return $i
       
       
  let $res1 := $dvmTable/dvm:rows/dvm:row/dvm:cell[position() = $idxSource and text()=$sourceValue]/../dvm:cell[position() = $idxTarget]/text()
return
 if (fn:string-length($res1) > 0) then
        string($res1)
       else
         string(  $defaultValue)
      
};


declare function xf:XQ_Hobby($InsertNewMember as element(prof:InsertNewMember),$PrimaryContactID as xs:string,$HobbyDVM as element(*))
    as element() {
    
<ayr:ListOfEautoContactHobby>
{

       
             for $var in (1 to fn:count($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField))
where (data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]/@KeyValue)="3") 
let $HCount := fn:count(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]) , '\W+')[. != ''])

return

for $key1 in (1 to $HCount)
let $Hobby := data(fn:tokenize(data($InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:CustomFields/com:CustomField[$var]),',')[$key1])
let $flag := dvm:lookupValue($HobbyDVM,'HobbyID',$Hobby, 'HobbyName','')
          
   return  

if (data($flag) !="") then

<ayr:EautoContactHobby>
                              <ayr:Id>{$key1}</ayr:Id>
                              <ayr:HobbyDesc/>
                              <ayr:HobbyLOV>{dvm:lookupValue($HobbyDVM,'HobbyID',$Hobby, 'HobbyName','')}</ayr:HobbyLOV>
                              <ayr:Name></ayr:Name>
                              <ayr:ParentContactId>{$PrimaryContactID}</ayr:ParentContactId>
                              <ayr:Type2>HOBBY</ayr:Type2>

</ayr:EautoContactHobby>
else ""

}
</ayr:ListOfEautoContactHobby>
};

declare variable $InsertNewMember as element(prof:InsertNewMember) external;
declare variable $PrimaryContactID as xs:string external;
declare variable $HobbyDVM as element(*) external;


xf:XQ_Hobby($InsertNewMember,$PrimaryContactID,$HobbyDVM)