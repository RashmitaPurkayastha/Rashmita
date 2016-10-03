(:: pragma  parameter="$QuerybyExampleFullMemberResponse" type="anyType" ::)
(:: pragma bea:global-element-return element="com:AMA_ProfileReadRS" location="../../PortalInterfaces/schema/AMA_ProfileReadRS.xsd" ::)
 
 
 
declare namespace asi = "http://siebel.com/asi/";
declare namespace com = "http://com.finnair";
declare namespace ayr = "http://www.siebel.com/xml/AYRES%20Member%20Information%20–%20Long%20Portal";
declare namespace xf = "http://com.finnair/MemberProfileRetrieve_GetProfile/XQ_Res_GetProfile/";
declare namespace dvm="http://xmlns.oracle.com/dvm";
declare namespace ay="http://www.siebel.com/xml/AY%20LOY%20Member%20Int";
declare namespace m="http://com.finnair/MemberProfileRetrieve/";
 
 
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

declare function xf:originPref($SiebelResponse as element(*)) as element(com:AirportOriginPref) {
	if (fn:exists($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests)) then
		for $var in ( 1 to fn:count($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests))
        	where (data($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestType)="Usual Departure city/Airport")
		        let $location := $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestName/text()
        		return <com:AirportOriginPref LocationCode="{$location}" />
	else
		""
};

declare function xf:destinationPref($SiebelResponse as element(*), $keyValue as xs:string) as element(com:CustomField) {
	if (fn:exists($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests)) then
	    <com:CustomField KeyValue="{$keyValue}">
		for $var in ( 1 to fn:count($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests))
        	where (data($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestType)="Usual Departure city/Airport")
		        let $location := $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestName/text()
        		return fn:concat(",",$location)
        </com:CustomField>
	else
		""
};
 
 
declare function xf:XQ_Res_GetProfile($QuerybyExampleFullMemberResponse as element(*),$PreferredLanguagedvm as element(*),$dvmTable as element(*),$CitizendvmTable as element(*),$SiebelResponse as element(*),$HobbiesDvm as element(*),$DestinationsWithoutSpace as xs:string,$VacationsWithoutSpace as xs:string)
    as element(m:GetProfileResponse) {
        let $QuerybyExampleFullMemberResponse := $QuerybyExampleFullMemberResponse
    let $Res := data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:Citizenship)
        let $Status := $QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:Status/text()
        let $Gender := $QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact[1]/ayr:MF/text()
let $Gender1 := $QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact[1]/ayr:MM/text()
    let $Contact := $QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember/ayr:ListOfContact/ayr:Contact
    let $PrimaryPersonalAddressType := data($Contact/ayr:PrimaryPersonalAddressType)
    let $LoyMember := $QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember
        let $addresscount := fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress)
        let $DocIssueCountry := $Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportCountry/text()
return
        
<m:GetProfileResponse> 
    
    <com:AMA_ProfileReadRS Version="10.2">
    
         <com:Success/>
                <com:Profiles>
                    <com:ProfileInfo>
                        <com:UniqueID Type = "21"
                                      ID = "{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:MemberNumber) }"
                                      ID_Context = "LOYALTYNUMBER"/>
                        <com:Profile ProfileType = "1"
                       Status = "{if ($Status="Active") then
                       ("A")
                       else if ($Status="Test Member") then
                       ("A")
                       else if ($Status="Inactive") then
                       ("I")
                       else if ($Status="Dormant") then
                       ("L")
                       else if ($Status="Deleted") then
                       ("T")
                       else if ($Status="Pending") then
                       ("P")
                       else if ($Status="Deceased") then
                       ("D")
                       else "" }" >
{
if (data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate) !="") then 
if($Gender) then                           
			<com:Customer Gender = "{if ($Gender="M") then ("Male")
                                                                          else if ($Gender="F") then ("Female")
                                                                          else "" }"
 
                                                  BirthDate = "{fn:concat(
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),7,4),
"-",
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),1,2),
"-",
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),4,2))}" >
 
                      <com:PersonName>
                                  <com:GivenName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
  
                                  {if(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)) then 
                                  <com:MiddleName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
                                  else ""}
                  
                                 <com:Surname>{data($LoyMember/ayr:PrimaryContactLastName)}</com:Surname>  
                                </com:PersonName>
                       
{
for $var2 in (1 to fn:count($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms))
	return
	if (data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home")
	then
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5"
               PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
else
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5" PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[1]/ayr:AlternateSMS)}"/>
}

{
for $var3 in (1 to fn:count($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress))
	return
	if (data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	then
	 <com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)}</com:Email>
}
                                     
{    
                       if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType)="" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType)="") then
                                              ("")
 
else
 
 
for $var in (1 to fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress))
 
                       let $path := $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]
 
                       let $addressLine := $path/ayr:PersonalStreetAddress/text()
               let $Description:= $path/ayr:PersonalStreetAddress2/text()
               let $County := $path/ayr:PersonalStreetAddress3/text()
                       let $cityName :=$path/ayr:PersonalCity/text()
                       let $postalCode:=$path/ayr:PersonalPostalCode/text()
                       let $stateProv:=$path/ayr:PersonalProvince/text()
                       let $countryName:=$path/ayr:PersonalCountry/text()
                       let $companyName:=$path/ayr:AYCompanyName/text()
                       let $varRes := $path/ayr:PersonalCountry/text()
                       
                       return
 
if(data($Description!=""))then
(<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y") then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}" 
Description = "{$Description}">
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                    <com:CityName>{$cityName }</com:CityName>
									{
									if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									<com:PostalCode>0000</com:PostalCode>
									}
                                    {if(data($County)) then
                                    <com:County>{$County}</com:County>
      else ""}                                   
                                     <com:StateProv>{$stateProv}</com:StateProv>
									 
									 {
									 if (data($countryName)) then
                                    <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
									else 
									<com:CountryName/>
									}
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>)
else
(<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y") then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}" 
>
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                    <com:CityName>{$cityName }</com:CityName>
									{if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									  <com:PostalCode>0000</com:PostalCode>
									  }
                                      {if(data($County)) then
                                    <com:County>{$County}</com:County>
      else ""}                                     
                                     <com:StateProv>{$stateProv}</com:StateProv>
                                    
                                     <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>)
 
 
 
}
{
if (data($Res !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$Res, 'CitizenshipCode',"")}"/>
else ""
 
 }
{
  if (data($LoyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($LoyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($LoyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($LoyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($LoyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($LoyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($LoyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($LoyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($LoyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
else ""
                              
                                              else ()
}
 
 
{
if (data($DocIssueCountry) != "") then
 
                     <com:Document  DocID = "{if(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber)!="") then
                                                               data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber) else "0"}"
                                              DocType = "2"
                                              EffectiveDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),4,2))
else "1900-01-01"}"
                                              ExpireDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),4,2))
else "1900-01-01"}"
                                              DocIssueCountry = "{dvm:lookupValue($dvmTable,'CountryName',$DocIssueCountry, 'CountryCode',"")}"/>
 
 
else ""
 
}
 
 
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($LoyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($LoyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($LoyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($LoyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
<com:CustLoyalty>
	<com:LoyalLevel>{data($LoyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}</com:LoyalLevel>
	<com:SignupDate>{data($LoyMember/ayr:StartDate)}</com:SignupDate>
	<com:SubAccountBalance>
		<com:Balance>{data($LoyMember/ayr:Point1Value)}</com:Balance>
	</com:SubAccountBalance>
</com:CustLoyalty> 
                       </com:Customer>
 
 else if($Gender1 !="" and $Gender1 = "Mr." or $Gender1 = "Ms." or $Gender1 = "Miss" or $Gender1 = "Mrs." ) then   
            <com:Customer Gender = "{if ($Gender1="Mr.") then ("Male")
                                                                          else if ($Gender1="Mrs." or $Gender1="Miss" or $Gender1="Ms.") then ("Female")
                                                                          else "" }" BirthDate = "{fn:concat(
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),7,4),
"-",
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),1,2),
"-",
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),4,2))}" >
 
                      <com:PersonName>
                                  <com:GivenName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($LoyMember/ayr:PrimaryContactLastName)}</com:Surname>  
                                </com:PersonName>
                       
 
{
for $var2 in (1 to fn:count($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms))
	where data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home"
	return
	if (data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home")
	then
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5"
               PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
else
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5" PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
}
{
for $var3 in (1 to fn:count($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress))
where(data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	return
	if (data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	then
	 <com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)}</com:Email>
}
{    
                       if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType)="" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType)="") then
                                              ("")
 
else
 
 
for $var in (1 to fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress))
 
                       let $path := $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]
 
                       let $addressLine := $path/ayr:PersonalStreetAddress/text()
               let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
               let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
                       let $cityName :=$path/ayr:PersonalCity/text()
                       let $postalCode:=$path/ayr:PersonalPostalCode/text()
                       let $stateProv:=$path/ayr:PersonalProvince/text()
                       let $countryName:=$path/ayr:PersonalCountry/text()
                       let $companyName:=$path/ayr:AYCompanyName/text()
                       let $varRes := $path/ayr:PersonalCountry/text()
                       
                       return
 
<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y" ) then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}">
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                {if(data($addressLine2)) then <com:AddressLine>{$addressLine2}</com:AddressLine> else ""}
                                {if(data($addressLine3)) then <com:AddressLine>{$addressLine3}</com:AddressLine> else ""}                   
 
                                    <com:CityName>{$cityName }</com:CityName>
									{if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									 <com:PostalCode>0000</com:PostalCode>
									 }
                                    <com:StateProv>{$stateProv}</com:StateProv>
                                    
                                     {
									 if (data($countryName)) then
                                    <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
									else 
									<com:CountryName/>
									}
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>
 
 
}
{
if (data($Res !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$Res, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($LoyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($LoyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($LoyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($LoyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($LoyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($LoyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($LoyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($LoyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($LoyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
else ""
                              
                                              else ()
}
 
 
{
if (data($DocIssueCountry) != "") then
 
                     <com:Document  DocID = "{if(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber)!="") then
                                                               data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber) else "0"}"
                                              DocType = "2"
                                              EffectiveDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),4,2))
else "1900-01-01"}"
                                              ExpireDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),4,2))
else "1900-01-01"}"
                                              DocIssueCountry = "{dvm:lookupValue($dvmTable,'CountryName',$DocIssueCountry, 'CountryCode',"")}"/>
 
 
else ""
 
}
 
 
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($LoyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($LoyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($LoyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($LoyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
<com:CustLoyalty>
	<com:LoyalLevel>{data($LoyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}</com:LoyalLevel>
	<com:SignupDate>{data($LoyMember/ayr:StartDate)}</com:SignupDate>
	<com:SubAccountBalance>
		<com:Balance>{data($LoyMember/ayr:Point1Value)}</com:Balance>
	</com:SubAccountBalance>
</com:CustLoyalty> 
                       </com:Customer>
else
					
<com:Customer BirthDate = "{fn:concat(
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),7,4),
"-",
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),1,2),
"-",
fn:substring(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),4,2))}" >
 
                      <com:PersonName>
                                  <com:GivenName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($LoyMember/ayr:PrimaryContactLastName)}</com:Surname>  
                                </com:PersonName>
                       
 
{
for $var2 in (1 to fn:count($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms))
	where data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home"
	return
	if (data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home")
	then
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5"
               PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
else
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5" PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[1]/ayr:AlternateSMS)}"/>
}

{
for $var3 in (1 to fn:count($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress))
where(data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	return
	if (data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	then
	 <com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)}</com:Email>
}                              
{    
                       if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType)="" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType)="") then
                                              ("")
 
else
 
 
for $var in (1 to fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress))
 
                       let $path := $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]
 
                       let $addressLine := $path/ayr:PersonalStreetAddress/text()
               let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
               let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
                       let $cityName :=$path/ayr:PersonalCity/text()
                       let $postalCode:=$path/ayr:PersonalPostalCode/text()
                       let $stateProv:=$path/ayr:PersonalProvince/text()
                       let $countryName:=$path/ayr:PersonalCountry/text()
                       let $companyName:=$path/ayr:AYCompanyName/text()
                       let $varRes := $path/ayr:PersonalCountry/text()
                       
                       return
 
<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y" ) then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}">
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                {if(data($addressLine2)) then <com:AddressLine>{$addressLine2}</com:AddressLine> else ""}
                                {if(data($addressLine3)) then <com:AddressLine>{$addressLine3}</com:AddressLine> else ""}                   
 
                                    <com:CityName>{$cityName }</com:CityName>
									{if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									 <com:PostalCode>0000</com:PostalCode>
									 }
                                    <com:StateProv>{$stateProv}</com:StateProv>
                                    
                                     {
									 if (data($countryName)) then
                                    <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
									else 
									<com:CountryName/>
									}
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>
 
 
}
{
if (data($Res !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$Res, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($LoyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($LoyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($LoyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($LoyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($LoyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($LoyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($LoyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($LoyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($LoyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
else ""
                              
                                              else ()
}
 
 
{
if (data($DocIssueCountry) != "") then
 
                     <com:Document  DocID = "{if(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber)!="") then
                                                               data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber) else "0"}"
                                              DocType = "2"
                                              EffectiveDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),4,2))
else "1900-01-01"}"
                                              ExpireDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),4,2))
else "1900-01-01"}"
                                              DocIssueCountry = "{dvm:lookupValue($dvmTable,'CountryName',$DocIssueCountry, 'CountryCode',"")}"/>
 
 
else ""
 
}
 
 
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($LoyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($LoyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($LoyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($LoyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
<com:CustLoyalty>
	<com:LoyalLevel>{data($LoyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}</com:LoyalLevel>
	<com:SignupDate>{data($LoyMember/ayr:StartDate)}</com:SignupDate>
	<com:SubAccountBalance>
		<com:Balance>{data($LoyMember/ayr:Point1Value)}</com:Balance>
	</com:SubAccountBalance>
</com:CustLoyalty>
                       </com:Customer>
					   
else
if($Gender) then                           
			<com:Customer Gender = "{if ($Gender="M") then ("Male")
                                                                          else if ($Gender="F") then ("Female")
                                                                          else "" }"
 
                                                >
 
                      <com:PersonName>
                                  <com:GivenName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
  
                                  {if(data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)) then 
                                  <com:MiddleName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
                                  else ""}
                  
                                 <com:Surname>{data($LoyMember/ayr:PrimaryContactLastName)}</com:Surname>  
                                </com:PersonName>
                       
{
for $var2 in (1 to fn:count($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms))
	where data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home"
	return
	if (data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home")
	then
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5"
               PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
else
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5" PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[1]/ayr:AlternateSMS)}"/>
}

{
for $var3 in (1 to fn:count($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress))
where(data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	return
	if (data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	then
	 <com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)}</com:Email>
}                                    
{    
                       if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType)="" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType)="") then
                                              ("")
 
else
 
 
for $var in (1 to fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress))
 
                       let $path := $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]
 
                       let $addressLine := $path/ayr:PersonalStreetAddress/text()
               let $Description:= $path/ayr:PersonalStreetAddress2/text()
               let $County := $path/ayr:PersonalStreetAddress3/text()
                       let $cityName :=$path/ayr:PersonalCity/text()
                       let $postalCode:=$path/ayr:PersonalPostalCode/text()
                       let $stateProv:=$path/ayr:PersonalProvince/text()
                       let $countryName:=$path/ayr:PersonalCountry/text()
                       let $companyName:=$path/ayr:AYCompanyName/text()
                       let $varRes := $path/ayr:PersonalCountry/text()
                       
                       return
 
if(data($Description!=""))then
(<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y") then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}" 
Description = "{$Description}">
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                    <com:CityName>{$cityName }</com:CityName>
									{
									if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									<com:PostalCode>0000</com:PostalCode>
									}
                                    {if(data($County)) then
                                    <com:County>{$County}</com:County>
      else ""}                                   
                                     <com:StateProv>{$stateProv}</com:StateProv>
                                    
                                     {
									 if (data($countryName)) then
                                    <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
									else 
									<com:CountryName/>
									}
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>)
else
(<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y") then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}" 
>
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                    <com:CityName>{$cityName }</com:CityName>
									{if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									  <com:PostalCode>0000</com:PostalCode>
									  }
                                      {if(data($County)) then
                                    <com:County>{$County}</com:County>
      else ""}                                     
                                     <com:StateProv>{$stateProv}</com:StateProv>
                                    
                                     {
									 if (data($countryName)) then
                                    <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
									else 
									<com:CountryName/>
									}
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>)
 
 
 
}
{
if (data($Res !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$Res, 'CitizenshipCode',"")}"/>
else ""
 
 }
{
  if (data($LoyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($LoyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($LoyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($LoyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($LoyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($LoyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($LoyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($LoyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($LoyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
else ""
                              
                                              else ()
}
 
 
{
if (data($DocIssueCountry) != "") then
 
                     <com:Document  DocID = "{if(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber)!="") then
                                                               data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber) else "0"}"
                                              DocType = "2"
                                              EffectiveDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),4,2))
else "1900-01-01"}"
                                              ExpireDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),4,2))
else "1900-01-01"}"
                                              DocIssueCountry = "{dvm:lookupValue($dvmTable,'CountryName',$DocIssueCountry, 'CountryCode',"")}"/>
 
 
else ""
 
}
 
 
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($LoyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($LoyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($LoyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($LoyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
<com:CustLoyalty>
	<com:LoyalLevel>{data($LoyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}</com:LoyalLevel>
	<com:SignupDate>{data($LoyMember/ayr:StartDate)}</com:SignupDate>
	<com:SubAccountBalance>
		<com:Balance>{data($LoyMember/ayr:Point1Value)}</com:Balance>
	</com:SubAccountBalance>
</com:CustLoyalty> 
                       </com:Customer>
 
 else if($Gender1 !="" and $Gender1 = "Mr." or $Gender1 = "Ms." or $Gender1 = "Miss" or $Gender1 = "Mrs." ) then   
            <com:Customer Gender = "{if ($Gender1="Mr.") then ("Male")
                                                                          else if ($Gender1="Mrs." or $Gender1="Miss" or $Gender1="Ms.") then ("Female")
                                                                          else "" }" >
 
                      <com:PersonName>
                                  <com:GivenName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($LoyMember/ayr:PrimaryContactLastName)}</com:Surname>  
                                </com:PersonName>
                       
 
{
for $var2 in (1 to fn:count($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms))
	where data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home"
	return
	if (data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home")
	then
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5"
               PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
else
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5" PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
}
{
for $var3 in (1 to fn:count($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress))
where(data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	return
	if (data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	then
	 <com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
}
                                                        
{    
                       if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType)="" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType)="") then
                                              ("")
 
else
 
 
for $var in (1 to fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress))
 
                       let $path := $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]
 
                       let $addressLine := $path/ayr:PersonalStreetAddress/text()
               let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
               let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
                       let $cityName :=$path/ayr:PersonalCity/text()
                       let $postalCode:=$path/ayr:PersonalPostalCode/text()
                       let $stateProv:=$path/ayr:PersonalProvince/text()
                       let $countryName:=$path/ayr:PersonalCountry/text()
                       let $companyName:=$path/ayr:AYCompanyName/text()
                       let $varRes := $path/ayr:PersonalCountry/text()
                       
                       return
 
<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y" ) then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}">
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                {if(data($addressLine2)) then <com:AddressLine>{$addressLine2}</com:AddressLine> else ""}
                                {if(data($addressLine3)) then <com:AddressLine>{$addressLine3}</com:AddressLine> else ""}                   
 
                                    <com:CityName>{$cityName }</com:CityName>
									{if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									 <com:PostalCode>0000</com:PostalCode>
									 }
                                    <com:StateProv>{$stateProv}</com:StateProv>
                                    
                                     {
									 if (data($countryName)) then
                                    <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
									else 
									<com:CountryName/>
									}
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>
 
 
}
{
if (data($Res !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$Res, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($LoyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($LoyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($LoyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($LoyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($LoyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($LoyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($LoyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($LoyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($LoyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
else ""
                              
                                              else ()
}
 
 
{
if (data($DocIssueCountry) != "") then
 
                     <com:Document  DocID = "{if(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber)!="") then
                                                               data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber) else "0"}"
                                              DocType = "2"
                                              EffectiveDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),4,2))
else "1900-01-01"}"
                                              ExpireDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),4,2))
else "1900-01-01"}"
                                              DocIssueCountry = "{dvm:lookupValue($dvmTable,'CountryName',$DocIssueCountry, 'CountryCode',"")}"/>
 
 
else ""
 
}
 
 
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($LoyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($LoyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($LoyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($LoyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
<com:CustLoyalty>
	<com:LoyalLevel>{data($LoyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}</com:LoyalLevel>
	<com:SignupDate>{data($LoyMember/ayr:StartDate)}</com:SignupDate>
	<com:SubAccountBalance>
		<com:Balance>{data($LoyMember/ayr:Point1Value)}</com:Balance>
	</com:SubAccountBalance>
</com:CustLoyalty> 
                       </com:Customer>
else
					
<com:Customer >
 
                      <com:PersonName>
                                  <com:GivenName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($LoyMember/ayr:PrimaryContactLastName)}</com:Surname>  
                                </com:PersonName>
                       
 
{
for $var2 in (1 to fn:count($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms))
	where data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home"
	return
	if (data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMSName)="Home")
	then
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5"
               PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
else
<com:Telephone PhoneLocationType = "6" PhoneTechType = "5" PhoneNumber = "{data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[$var2]/ayr:AlternateSMS)}"/>
}

{
for $var3 in (1 to fn:count($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress))
where(data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	return
	if (data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:CommunicationAddressName)="Home")
	then
	 <com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($LoyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
}
{    
                       if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType)="" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType)="") then
                                              ("")
 
else
 
 
for $var in (1 to fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress))
 
                       let $path := $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]
 
                       let $addressLine := $path/ayr:PersonalStreetAddress/text()
               let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
               let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
                       let $cityName :=$path/ayr:PersonalCity/text()
                       let $postalCode:=$path/ayr:PersonalPostalCode/text()
                       let $stateProv:=$path/ayr:PersonalProvince/text()
                       let $countryName:=$path/ayr:PersonalCountry/text()
                       let $companyName:=$path/ayr:AYCompanyName/text()
                       let $varRes := $path/ayr:PersonalCountry/text()
                       
                       return
 
<com:Address ValidationStatus = "{if (data($LoyMember/ayr:AYMailReturnedFlg) = "Y" ) then
                                                                    ("N")
                                                                         else
                                                                         "V" }"
                                                                         UseType = "{if (data($path/ayr:AddressType)="Job") then
                                                                                            ("14")
                                                                                           else "13" }"
FormattedInd = "1" DefaultInd = "{if (data($PrimaryPersonalAddressType)="Home" and data($path/ayr:AddressType)="Home") 
                                                                                          then ("1")
                                                else if (data($PrimaryPersonalAddressType)="Job" and data($path/ayr:AddressType)="Job") 
                                                                                          then ("1")
                                                                                          else "0"}">
 
                                {if(data($addressLine)) then <com:AddressLine>{$addressLine}</com:AddressLine> else ""}
                                {if(data($addressLine2)) then <com:AddressLine>{$addressLine2}</com:AddressLine> else ""}
                                {if(data($addressLine3)) then <com:AddressLine>{$addressLine3}</com:AddressLine> else ""}                   
 
                                    <com:CityName>{$cityName }</com:CityName>
									{if(data($postalCode)!="") then
                                    <com:PostalCode>{$postalCode}</com:PostalCode>
									else
									 <com:PostalCode>0000</com:PostalCode>
									 }
                                    <com:StateProv>{$stateProv}</com:StateProv>
                                    
                                     {
									 if (data($countryName)) then
                                    <com:CountryName Code = "{dvm:lookupValue($dvmTable,'CountryName',$varRes, 'CountryCode',"")}"/>
									else 
									<com:CountryName/>
									}
                                    
                                   <com:CompanyName>{if (data($path/ayr:AddressType)="Job") then ($companyName) else ""}</com:CompanyName>
                                   
              
                                   {data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[$var]/ayr:PrimaryPersonalAddressId)}
 
</com:Address>
 
 
}
{
if (data($Res !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$Res, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($LoyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($LoyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($LoyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($LoyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($LoyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($LoyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($LoyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($LoyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($LoyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($LoyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
else ""
                              
                                              else ()
}
 
 
{
if (data($DocIssueCountry) != "") then
 
                     <com:Document  DocID = "{if(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber)!="") then
                                                               data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportNumber) else "0"}"
                                              DocType = "2"
                                              EffectiveDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportIssueDate),4,2))
else "1900-01-01"}"
                                              ExpireDate = "{if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate) != "") then fn:concat(
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),7,4),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),1,2),
"-",
fn:substring(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportExpirationDate),4,2))
else "1900-01-01"}"
                                              DocIssueCountry = "{dvm:lookupValue($dvmTable,'CountryName',$DocIssueCountry, 'CountryCode',"")}"/>
 
 
else ""
 
}
 
<com:CustLoyalty>
	<com:SubAccountBalance>
		<com:Balance>{data($LoyMember/ayr:Point1Value)}</com:Balance>
	</com:SubAccountBalance>
	<com:LoyalLevel>{data($LoyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}</com:LoyalLevel>
	<com:SignupDate>{data($LoyMember/ayr:StartDate)}</com:SignupDate>
</com:CustLoyalty>
 
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($LoyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($LoyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($LoyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($LoyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}

                       </com:Customer>					   
					   
					   
}
 
 
 
                       <com:UserID Type = "1"
                                        ID = "{data($LoyMember/ayr:MemberNumber)}"
                                        ID_Context = "Login"/>
                            <com:PrefCollections>
                                <com:PrefCollection>
                                    <com:AirlinePref>
	{
	if (fn:exists($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests)) then
		for $var in ( 1 to fn:count($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests))
        	where (data($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestType)="Usual Departure city/Airport")
		        let $location := $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestName/text()
        		return <com:AirportOriginPref LocationCode="{$location}" />
	else
		""
	}
                                        <com:SeatPref>{
                                            if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PreferredSeatType)= "Window") then
                                                                     <com:SeatPreferences>5</com:SeatPreferences>
                                                                     else if(data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PreferredSeatType)= "Aisle") then
                                                                     <com:SeatPreferences>3</com:SeatPreferences>
                                                                     else "" }
                                            </com:SeatPref>
{
if (data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PreferredMealType) != "")
then
   <com:SSR_Pref SSR_Code = "{data($Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PreferredMealType)}"/>
else ""
}
                                    </com:AirlinePref>
                                         
 
                                </com:PrefCollection>
                            </com:PrefCollections>
                            <com:CustomFields>
                               
                               <com:CustomField KeyValue = "1">{$DestinationsWithoutSpace}</com:CustomField>
                                <com:CustomField KeyValue = "2">{$VacationsWithoutSpace}</com:CustomField>
 
                                <com:CustomField KeyValue = "3">{for $var2 in ( 1 to fn:count($Contact/ayr:ListOfEautoContactHobby/ayr:EautoContactHobby))
 
                                                         let $HName := $Contact/ayr:ListOfEautoContactHobby/ayr:EautoContactHobby[$var2]/ayr:HobbyLOV/text()
                              let $HID := dvm:lookupValue($HobbiesDvm,'HobbyName',$HName, 'HobbyID','')
                                                         let $HCount := fn:count($Contact/ayr:ListOfEautoContactHobby/ayr:EautoContactHobby)
                                                         return
                                                         
                                                       
                                                         $HID
 
                                                         }</com:CustomField>
    <com:CustomField KeyValue = "7">{if ($Contact/ayr:SuppressSMSPromos = "N") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
<com:CustomField KeyValue = "8">{if ($LoyMember/ayr:ReceivePartnerPromotionFlag = "Y") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
<com:CustomField KeyValue = "9">{if ($Contact/ayr:SuppresseMailWeeklyOffers = "N") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
 
<com:CustomField KeyValue = "10">{if ($Contact/ayr:SuppressAllEmails = "N") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
<com:CustomField KeyValue = "11">{if ($Contact/ayr:SuppressAllFaxes = "N") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
<com:CustomField KeyValue = "12">{if ($Contact/ayr:SuppressAllSMS = "N") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
<com:CustomField KeyValue = "13">{if ($Contact/ayr:eMailFlightInfo = "Y") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
	    <com:CustomField KeyValue="DESTBUSI">
	{
	if (fn:exists($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests)) then
		for $var in ( 1 to fn:count($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests))
        	where (data($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestType)="Usual Business Destination")
		        let $location := $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestName/text()
        		return fn:concat($location)
	else
		""
	}
        </com:CustomField>
	    <com:CustomField KeyValue="DESTLEIS">
	{
	if (fn:exists($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests)) then
		for $var in ( 1 to fn:count($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests))
        	where (data($SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestType)="Favorite Leisure Destination")
		        let $location := $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[$var]/ay:AYInterestName/text()
        		return fn:concat($location)
	else
		""
	}
        </com:CustomField>
	    <com:CustomField KeyValue="HHOLD">{ data($LoyMember/ayr:AYHouseholdSize) } </com:CustomField>
	    <com:CustomField KeyValue="PREFLANG">{
	    	let $PreferredLanguage_ISO := dvm:lookupValue($PreferredLanguagedvm,'Output',$Contact/ayr:PreferredLanguageCode, 'Input','EN')
	     	return $PreferredLanguage_ISO 
	    } </com:CustomField>
	    <com:CustomField KeyValue="XFRPTS">{if ($LoyMember/ayr:AYTransferPoints = "Y") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
	    <com:CustomField KeyValue="FRXFRPTS">{if ($LoyMember/ayr:AYFreePointTransfer = "Y") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
	    <com:CustomField KeyValue="FPTSXCGH">{if ($LoyMember/ayr:AYFreePointExchange = "Y") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
        <com:CustomField KeyValue="XPTSALLW">{ if ($LoyMember/ayr:AYExchangePointsFlg = "Y") then
                                                                              ("TRUE")
                                                                          else 
                                                                              "FALSE" }</com:CustomField>
                            </com:CustomFields>
 
 
                        </com:Profile>
                    </com:ProfileInfo>
                </com:Profiles>
            </com:AMA_ProfileReadRS>
      </m:GetProfileResponse> 
    
};
 
declare variable $QuerybyExampleFullMemberResponse as element(*) external;
declare variable $PreferredLanguagedvm as element(*) external;
declare variable $dvmTable as element(*) external;
declare variable $CitizendvmTable as element(*) external;
declare variable $HobbiesDvm as element(*) external;
declare variable $SiebelResponse as element(*) external;
declare variable $VacationsWithoutSpace as xs:string external;
declare variable $DestinationsWithoutSpace as xs:string external;
 
xf:XQ_Res_GetProfile($QuerybyExampleFullMemberResponse,$PreferredLanguagedvm,$dvmTable,$CitizendvmTable,$SiebelResponse,$HobbiesDvm,$DestinationsWithoutSpace,$VacationsWithoutSpace)