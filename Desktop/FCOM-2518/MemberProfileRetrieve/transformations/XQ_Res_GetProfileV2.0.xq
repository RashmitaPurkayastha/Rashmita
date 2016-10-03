(:: pragma  parameter="$QuerybyExampleFullMemberResponse" type="anyType" ::)
(:: pragma bea:global-element-return element="com:AMA_ProfileReadRS" location="../../PortalInterfaces/schema/AMA_ProfileReadRS.xsd" ::)
 
declare namespace asi = "http://siebel.com/asi/";
declare namespace com = "http://com.finnair";
declare namespace ayr = "http://www.siebel.com/xml/AYRES%20Member%20Information%20–%20Long%20Portal";
declare namespace xf = "http://com.finnair/MemberProfileRetrieve_GetProfile/XQ_Res_GetProfile/";
declare namespace dvm = "http://xmlns.oracle.com/dvm";
declare namespace ay = "http://www.siebel.com/xml/AY%20LOY%20Member%20Int";
(: declare namespace m = "http://com.finnair/MemberProfileRetrieve/"; :)
declare namespace xf2 = "http://tempuri.org/partnerServices/Partners_common/transformations/XQ_DateTime_Converter/";

declare function xf2:Convert_SiebelDateTime_To_YYYY-MM-DD($SourceDate as xs:string) as xs:string {
    if (fn:string-length($SourceDate) > 0) then
   		let $dateString := substring($SourceDate, 1, 10)
   		return
   		concat(substring($dateString, 7, 4), '-', substring($dateString, 1, 2), '-', substring($dateString, 4, 2))
	else
		''
};

(: declare variable $SourceDate as xs:string external; :)
 
declare function dvm:lookupValue($dvmTable as element(*), $sourceColumnName as xs:string, $sourceValue as xs:string, $targetColumnName as xs:string, $defaultValue as xs:string) as xs:string {
    let $idxSource as xs:integer := for $column at $i in $dvmTable/dvm:columns/dvm:column where ($column/@name = $sourceColumnName) return $i
    let $idxTarget as xs:integer := for $column at $i in $dvmTable/dvm:columns/dvm:column where ($column/@name = $targetColumnName) return $i
    let $res1 := $dvmTable/dvm:rows/dvm:row/dvm:cell[$idxSource][text() = $sourceValue]/../dvm:cell[$idxTarget]/text()
    return
        if (fn:string-length($res1) > 0) then
            $res1
       else
         $defaultValue
};

declare function xf:originPref($SiebelResponse as element(*)) as element(com:AirportOriginPref) {
    let $location := $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[ay:AYInterestType = "Usual Departure city/Airport"]/ay:AYInterestName/text()
    return
	if (fn:exists($location)) then
		<com:AirportOriginPref LocationCode="{ $location }" />
	else
		()
};

(:
declare function xf:destinationPref($SiebelResponse as element(*), $keyValue as xs:string) as element(com:CustomField) {
    let $memberInterests := $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests 
    return
	if (fn:exists($memberInterests)) then
	    <com:CustomField KeyValue="{ $keyValue }">
		for $var in $memberInterests[ay:AYInterestType = "Usual Departure city/Airport"]/ay:AYInterestName/text()
		    return fn:concat(",", $var)
        </com:CustomField>
	else
		()
};
:)
 
declare function xf:XQ_Res_GetProfile($QuerybyExampleFullMemberResponse as element(*), $PreferredLanguagedvm as element(*), $dvmTable as element(*), $CitizendvmTable as element(*), $SiebelResponse as element(*), $HobbiesDvm as element(*), $DestinationsWithoutSpace as xs:string, $VacationsWithoutSpace as xs:string) as element(com:AMA_ProfileReadRS) {
    let $loyMember := $QuerybyExampleFullMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformationLongPortal/ayr:LoyMember
    let $citizenship := data($loyMember/ayr:ListOfContact/ayr:Contact/ayr:Citizenship)
    let $Status := $loyMember[1]/ayr:Status/text()
    let $GenderMF := $loyMember[1]/ayr:ListOfContact/ayr:Contact[1]/ayr:MF/text()
    let $GenderMM := $loyMember[1]/ayr:ListOfContact/ayr:Contact[1]/ayr:MM/text()
    let $Contact := $loyMember/ayr:ListOfContact/ayr:Contact
    let $PrimaryPersonalAddressType := data($Contact/ayr:PrimaryPersonalAddressType)
    let $addresscount := fn:count($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress)
    let $DocIssueCountry := $Contact/ayr:ListOfLoyTravelProfile/ayr:LoyTravelProfile/ayr:PassportCountry/text()
    return
	    <com:AMA_ProfileReadRS Version="10.2">
	        <com:Success />
	        <com:Profiles>
	            <com:ProfileInfo>
	                <com:UniqueID Type = "21" ID = "{ data($loyMember[1]/ayr:MemberNumber) }" ID_Context = "LOYALTYNUMBER" />
	                <com:Profile ProfileType = "1" Status = "{
	                        if ($Status = ("Active", "Test Member")) then
	                            "A"
	                        else if ($Status="Inactive") then
	                            "I"
	                        else if ($Status="Dormant") then
	                            "L"
	                        else if ($Status="Deleted") then
	                            "T"
	                        else if ($Status="Pending") then
	                            "P"
	                        else if ($Status="Deceased") then
	                            "D"
	                        else
	                            ""
	                        }">
	                    {
	                    if (data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate) !="") then 
	                        if ($GenderMF) then                           
				                <com:Customer
				                        Gender = "{ if ($GenderMF="M") then ("Male") else if ($GenderMF="F") then ("Female") else "" }"
	                                    BirthDate = "{ xf2:Convert_SiebelDateTime_To_YYYY-MM-DD(data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate)) }">
	                                <com:PersonName>
	                                    <com:GivenName>{ data($loyMember[1]/ayr:PrimaryContactFirstName) }</com:GivenName>
	                                    {
	                                    if (data($loyMember[1]/ayr:PrimaryContactMiddleName)) then 
	                                        <com:MiddleName>{ data($loyMember[1]/ayr:PrimaryContactMiddleName) }</com:MiddleName>
	                                    else
	                                        ()
	                                    }
	                                    <com:Surname>{ data($loyMember/ayr:PrimaryContactLastName) }</com:Surname>  
	                                </com:PersonName>
	                                {
	                                for $sms in $Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms
		                            return
		                                if (data($sms/ayr:AlternateSMSName) = "Home") then
	                                        <com:Telephone
	                                                PhoneLocationType = "6"
	                                                PhoneTechType = "5"
	                                                PhoneNumber = "{ data($sms/ayr:AlternateSMS) }" />
	                                    else
	                                        <com:Telephone
	                                                PhoneLocationType = "6"
	                                                PhoneTechType = "5"
	                                                PhoneNumber = "{ data($Contact/ayr:ListOfLoyCommunicationSms/ayr:LoyCommunicationSms[1]/ayr:AlternateSMS) }" />
	                                }
	                                {
	                                for $communicationAddress in $Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress
		                            return
                                        <com:Email
	                                            DefaultInd = "{ if (data($loyMember/ayr:AYeMailReturnedFlg) = 'Y') then '1' else '0' }"
	                                            EmailType = "1">{
                                            if (data($communicationAddress/ayr:CommunicationAddressName) = "Home") then 
                                                data($communicationAddress/ayr:AlternateEmailAddress)
                                            else
                                                data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)
                                        }</com:Email>
	                                }
									{    
									if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType) = "" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType) = "") then
									    ()
									else
										for $path in $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress
									        let $countryName := $path/ayr:PersonalCountry/text()
									        let $countryCode := dvm:lookupValue($dvmTable, 'CountryName', (if (exists($countryName)) then $countryName else "-"), 'CountryCode', "")
									        let $addressType := data($path/ayr:AddressType)
										    let $addressLine := $path/ayr:PersonalStreetAddress/text()
										    let $PersonalStreetAddress2 := $path/ayr:PersonalStreetAddress2/text()
									        let $PersonalStreetAddress3 := $path/ayr:PersonalStreetAddress3/text()
										    let $Description :=
										           if ($countryCode = ("JP", "GB")) then
										               $PersonalStreetAddress2
									               else
									                   ""
										    let $County :=
										            (: 
										               FCOM-1653 -- County is no longer passed
										               $PersonalStreetAddress3
										            :)
										            ""
										    let $cityName := $path/ayr:PersonalCity/text()
										    let $postalCode := $path/ayr:PersonalPostalCode/text()
										    let $stateProv := $path/ayr:PersonalProvince/text()
										    let $companyName := $path/ayr:AYCompanyName/text()
										    return
										        if (data($Description != "")) then
										            <com:Address
											                ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = 'Y') then 'N' else 'V' }"
											                UseType = "{ if ($addressType = 'Job') then '14' else '13' }"
											                FormattedInd = "1"
											                DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $addressType) then '1' else '0' }"
											                Description = "{ $Description }">
										                {
										                if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
										                }
										                {
										                if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ")) then <com:AddressLine>{ $PersonalStreetAddress2 }</com:AddressLine> else ()
										                }
										                {
										                if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ") and $addressType = 'Job') then <com:AddressLine>{ $PersonalStreetAddress3 }</com:AddressLine> else ()
										                }
										                <com:CityName>{ $cityName }</com:CityName>
										                <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
										                {
										                if (data($County) != "") then <com:County>{ $County }</com:County> else ()
										                }
										                <com:StateProv>{ $stateProv }</com:StateProv>
										                {
										                if (data($countryName)) then <com:CountryName Code = "{ $countryCode }" /> else <com:CountryName />
										                }
										                <com:CompanyName>{ if ($addressType = "Job") then ($companyName) else "" }</com:CompanyName>
										                {
										                data($path/ayr:PrimaryPersonalAddressId)
										                }
										            </com:Address>
										        else
										            <com:Address
										                    ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = 'Y') then 'N' else 'V' }"
										                    UseType = "{ if ($addressType = 'Job') then '14' else '13' }"
										                    FormattedInd = "1"
									                        DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $addressType) then '1' else '0' }">
									                    {
									                    if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
									                    }
									                    {
									                    if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ")) then <com:AddressLine>{ $PersonalStreetAddress2 }</com:AddressLine> else ()
									                    }
									                    {
									                    if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ") and $addressType = 'Job') then <com:AddressLine>{ $PersonalStreetAddress3 }</com:AddressLine> else ()
									                    }
									                    <com:CityName>{ $cityName }</com:CityName>
									                    {
									                    <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
									                    }
									                    {
									                    if (data($County) != "") then <com:County>{ $County }</com:County> else ()
									                    }
									                    <com:StateProv>{ $stateProv }</com:StateProv>
									                    <com:CountryName Code = "{ $countryCode }" />
									                    <com:CompanyName>{ if ($addressType = "Job") then $companyName else "" }</com:CompanyName>
									                    {
									                    data($path/ayr:PrimaryPersonalAddressId)
									                    }
										            </com:Address>
									}
									{
									if (data($citizenship != "")) then
									    <com:CitizenCountryName Code = "{ dvm:lookupValue($CitizendvmTable, 'CitizenshipName', $citizenship, 'CitizenshipCode', "")}" />
									else
									    ()
								    }
											{
											if (data($loyMember/ayr:AYGuardianName) != "") then
											    <com:RelatedTraveler Relation = "guardian">
											    {
												if (data($loyMember/ayr:AYGuardianMemberNumber) != "") then
			                                        <com:UniqueID
			                                                Type = "21"
			                                                ID = "{ data($loyMember/ayr:AYGuardianMemberNumber) }" />
		                                        else
		                                            ()
												}
												{
												if (data($loyMember/ayr:AYGuardianName) != "") then                                      
							                        <com:PersonName>
							                            <com:Surname>{ data($loyMember/ayr:AYGuardianName) }</com:Surname>
							                        </com:PersonName>
												else
												    () 
												}
												{
												if (data($loyMember/ayr:AYGuardianPhoneNumber) != "") then
    											    <com:Telephone
    											            PhoneLocationType = "6"
    											            PhoneTechType = "5"
    											            PhoneNumber = "{ data($loyMember/ayr:AYGuardianPhoneNumber) }"/>
												else
												    ()
												}
												{  
												if (data($loyMember/ayr:AYGuardianEmail) != "") then                                
												    <com:Email EmailType="1">{ data($loyMember/ayr:AYGuardianEmail) }</com:Email>
												else
												    ()                                    
												}
	   										    </com:RelatedTraveler>
    				                       else
    				                           ()
    									   } 
{
                       if (data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{ fn:concat(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear), "-01-01") }" />
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
 
 
<com:CustLoyalty LoyalLevel="{data($loyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}" EffectiveDate="{xf2:Convert_SiebelDateTime_To_YYYY-MM-DD(data($loyMember/ayr:StartDate))}">
	<com:SubAccountBalance Balance="{data($loyMember/ayr:Point1Value)}"/>
</com:CustLoyalty>
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($loyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($loyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($loyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($loyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
                       </com:Customer>
 
 else if($GenderMM !="" and $GenderMM = "Mr." or $GenderMM = "Ms." or $GenderMM = "Miss" or $GenderMM = "Mrs." ) then   
            <com:Customer Gender = "{if ($GenderMM="Mr.") then ("Male")
                                                                          else if ($GenderMM="Mrs." or $GenderMM="Miss" or $GenderMM="Ms.") then ("Female")
                                                                          else "" }" BirthDate = "{fn:concat(
fn:substring(data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),7,4),
"-",
fn:substring(data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),1,2),
"-",
fn:substring(data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),4,2))}" >
 
                      <com:PersonName>
                                  <com:GivenName>{data($loyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($loyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($loyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($loyMember/ayr:PrimaryContactLastName)}</com:Surname>  
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
	 <com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)}</com:Email>
}


{    
if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType) = "" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType) = "") then
    ()
else
	for $path in $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress
	    let $addressLine := $path/ayr:PersonalStreetAddress/text()
	    let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
	    let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
	    let $cityName := $path/ayr:PersonalCity/text()
	    let $postalCode := $path/ayr:PersonalPostalCode/text()
	    let $stateProv := $path/ayr:PersonalProvince/text()
	    let $countryName := $path/ayr:PersonalCountry/text()
	    let $companyName := $path/ayr:AYCompanyName/text()
	    return
	        <com:Address
	                ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = 'Y' ) then 'N' else 'V' }"
	                UseType = "{ if (data($path/ayr:AddressType) = "Job") then '14' else '13' }"
	                FormattedInd = "1"
	                DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $path/ayr:AddressType) then '1' else '0' }">
	            {
	            if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
	            }
	            {
	            if (data($addressLine2)) then <com:AddressLine>{ $addressLine2 }</com:AddressLine> else ()
	            }
	            {
	            if (data($addressLine3)) then <com:AddressLine>{ $addressLine3 }</com:AddressLine> else ()
	            }                   
	            <com:CityName>{$cityName }</com:CityName>
	            <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
	            <com:StateProv>{$stateProv}</com:StateProv>
	            {
			    if (data($countryName)) then
	                <com:CountryName Code = "{dvm:lookupValue($dvmTable, 'CountryName', $countryName, 'CountryCode',"") }" />
				else 
				    <com:CountryName />
				}
	            <com:CompanyName>{ if (data($path/ayr:AddressType) = "Job") then $companyName else "" }</com:CompanyName>
	            {
	            data($path/ayr:PrimaryPersonalAddressId)
	            }
	        </com:Address>
}

{
if (data($citizenship !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$citizenship, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($loyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($loyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($loyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($loyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($loyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($loyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($loyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($loyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($loyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
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
 
 
<com:CustLoyalty LoyalLevel="{data($loyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}" EffectiveDate="{xf2:Convert_SiebelDateTime_To_YYYY-MM-DD(data($loyMember/ayr:StartDate))}">
	<com:SubAccountBalance Balance="{data($loyMember/ayr:Point1Value)}"/>
</com:CustLoyalty>
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($loyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($loyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($loyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($loyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
                       </com:Customer>
else
					
<com:Customer BirthDate = "{fn:concat(
fn:substring(data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),7,4),
"-",
fn:substring(data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),1,2),
"-",
fn:substring(data($loyMember[1]/ayr:ListOfContact/ayr:Contact/ayr:BirthDate),4,2))}" >
 
                      <com:PersonName>
                                  <com:GivenName>{data($loyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($loyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($loyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($loyMember/ayr:PrimaryContactLastName)}</com:Surname>  
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
	 <com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)}</com:Email>
}                              
{    
if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType) = "" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType) = "") then
    ()
else
    for $path in $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress
	    let $addressLine := $path/ayr:PersonalStreetAddress/text()
	    let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
	    let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
	    let $cityName := $path/ayr:PersonalCity/text()
	    let $postalCode := $path/ayr:PersonalPostalCode/text()
	    let $stateProv := $path/ayr:PersonalProvince/text()
	    let $countryName := $path/ayr:PersonalCountry/text()
	    let $companyName := $path/ayr:AYCompanyName/text()
	    return
            <com:Address
                    ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = 'Y' ) then 'N' else 'V' }"
                    UseType = "{ if (data($path/ayr:AddressType) = "Job") then '14' else '13' }"
                    FormattedInd = "1"
                    DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $path/ayr:AddressType) then '1' else '0' }">
                {
                if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
                }
                {
                if (data($addressLine2)) then <com:AddressLine>{ $addressLine2 }</com:AddressLine> else ()
                }
                {
                if (data($addressLine3)) then <com:AddressLine>{ $addressLine3 }</com:AddressLine> else ()
                }                   
                <com:CityName>{ $cityName }</com:CityName>
                <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
                <com:StateProv>{$stateProv}</com:StateProv>
                {
				if (data($countryName)) then
                    <com:CountryName Code = "{ dvm:lookupValue($dvmTable, 'CountryName', $countryName, 'CountryCode', "") }" />
				else 
				    <com:CountryName />
				}
				<com:CompanyName>{ if (data($path/ayr:AddressType) = "Job") then $companyName else "" }</com:CompanyName>
                {
                data($path/ayr:PrimaryPersonalAddressId)
                }
            </com:Address>
}
{
if (data($citizenship !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$citizenship, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($loyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($loyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($loyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($loyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($loyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($loyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($loyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($loyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($loyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
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
 
 
<com:CustLoyalty LoyalLevel="{data($loyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}" EffectiveDate="{xf2:Convert_SiebelDateTime_To_YYYY-MM-DD(data($loyMember/ayr:StartDate))}">
	<com:SubAccountBalance Balance="{data($loyMember/ayr:Point1Value)}"/>
</com:CustLoyalty>
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($loyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($loyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($loyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($loyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
                       </com:Customer>
					   
else
if($GenderMF) then                           
			<com:Customer Gender = "{if ($GenderMF="M") then ("Male")
                                                                          else if ($GenderMF="F") then ("Female")
                                                                          else "" }"
 
                                                >
 
                      <com:PersonName>
                                  <com:GivenName>{data($loyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
  
                                  {if(data($loyMember[1]/ayr:PrimaryContactMiddleName)) then 
                                  <com:MiddleName>{data($loyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
                                  else ""}
                  
                                 <com:Surname>{data($loyMember/ayr:PrimaryContactLastName)}</com:Surname>  
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
	 <com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[1]/ayr:AlternateEmailAddress)}</com:Email>
}                                    
{    
if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType) = "" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType) = "") then
    ()
else
    for $path in $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress
        let $countryName := $path/ayr:PersonalCountry/text()
        let $countryCode := dvm:lookupValue($dvmTable, 'CountryName', dvm:lookupValue($dvmTable, 'CountryName', $countryName, 'CountryCode', ""), 'CountryCode', "")
        let $addressType := data($path/ayr:AddressType)
	    let $addressLine := $path/ayr:PersonalStreetAddress/text()
        let $PersonalStreetAddress2 := $path/ayr:PersonalStreetAddress2/text()
        let $PersonalStreetAddress3 := $path/ayr:PersonalStreetAddress3/text()
        let $Description :=
               if ($countryCode = ("JP", "GB")) then
                   $PersonalStreetAddress2
               else
                   ""
        let $County :=
                (: 
                   FCOM-1653 -- County is no longer passed
                   $PersonalStreetAddress3
                :)
                ""
	    let $cityName := $path/ayr:PersonalCity/text()
	    let $postalCode := $path/ayr:PersonalPostalCode/text()
	    let $stateProv := $path/ayr:PersonalProvince/text()
	    let $companyName := $path/ayr:AYCompanyName/text()
        return
            if (data($Description != "")) then
                <com:Address
                        ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = 'Y') then 'N' else 'V' }"
                        UseType = "{ if ($addressType = "Job") then '14' else '13' }"
                        FormattedInd = "1"
                        DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $addressType) then '1' else '0' }" 
                        Description = "{ $Description }">
                    {
                    if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
                    }
                    {
                    if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ")) then <com:AddressLine>{ $PersonalStreetAddress2 }</com:AddressLine> else ()
                    }
                    {
                    if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ") and $addressType = 'Job') then <com:AddressLine>{ $PersonalStreetAddress3 }</com:AddressLine> else ()
                    }
                    <com:CityName>{ $cityName }</com:CityName>
                    <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
                    {
                    if (data($County) != "") then <com:County>{ $County }</com:County> else ()
                    }
                    <com:StateProv>{ $stateProv }</com:StateProv>
                    {
                    if (data($countryName)) then <com:CountryName Code = "{ $countryCode }" /> else <com:CountryName />
					}
					<com:CompanyName>{ if ($addressType = "Job") then $companyName else "" }</com:CompanyName>
                    {
                    data($path/ayr:PrimaryPersonalAddressId)
                    }
                </com:Address>
            else
                <com:Address
                        ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = "Y") then 'N' else 'V' }"
                        UseType = "{ if ($addressType = "Job") then '14' else '13' }"
                        FormattedInd = "1"
                        DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $addressType) then '1' else '0' }">
                    {
                    if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
                    }
                    {
                    if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ")) then <com:AddressLine>{ $PersonalStreetAddress2 }</com:AddressLine> else ()
                    }
                    {
                    if ($countryCode = ("KP", "KR", "CA", "CN", "IN", "NZ") and $addressType = 'Job') then <com:AddressLine>{ $PersonalStreetAddress3 }</com:AddressLine> else ()
                    }
                    <com:CityName>{ $cityName }</com:CityName>
                    <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
                    {
                    if (data($County) != "") then <com:County>{ $County }</com:County> else ()
                    }
                    <com:StateProv>{ $stateProv }</com:StateProv>
                    {
                    if (data($countryName)) then <com:CountryName Code = "{ $countryCode }" /> else <com:CountryName />
					}
					<com:CompanyName>{ if ($addressType = "Job") then $companyName else "" }</com:CompanyName>
					{
					data($path/ayr:PrimaryPersonalAddressId)
					}
                </com:Address>
}
{
if (data($citizenship !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$citizenship, 'CitizenshipCode',"")}"/>
else ""
 
 }
{
  if (data($loyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($loyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($loyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($loyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($loyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($loyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($loyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($loyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($loyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
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
 
 
<com:CustLoyalty LoyalLevel="{data($loyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}" EffectiveDate="{xf2:Convert_SiebelDateTime_To_YYYY-MM-DD(data($loyMember/ayr:StartDate))}">
	<com:SubAccountBalance Balance="{data($loyMember/ayr:Point1Value)}"/>
</com:CustLoyalty>
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($loyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($loyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($loyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($loyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
                       </com:Customer>
 
 else if($GenderMM !="" and $GenderMM = "Mr." or $GenderMM = "Ms." or $GenderMM = "Miss" or $GenderMM = "Mrs." ) then   
            <com:Customer Gender = "{if ($GenderMM="Mr.") then ("Male")
                                                                          else if ($GenderMM="Mrs." or $GenderMM="Miss" or $GenderMM="Ms.") then ("Female")
                                                                          else "" }" >
 
                      <com:PersonName>
                                  <com:GivenName>{data($loyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($loyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($loyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($loyMember/ayr:PrimaryContactLastName)}</com:Surname>  
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
	 <com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
}
                                                        
{    
if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType) = "" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType) = "") then
    ()
else
    for $path in $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress
	    let $addressLine := $path/ayr:PersonalStreetAddress/text()
	    let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
	    let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
	    let $cityName := $path/ayr:PersonalCity/text()
	    let $postalCode := $path/ayr:PersonalPostalCode/text()
	    let $stateProv := $path/ayr:PersonalProvince/text()
	    let $countryName := $path/ayr:PersonalCountry/text()
	    let $companyName := $path/ayr:AYCompanyName/text()
	    return
            <com:Address
                    ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = 'Y') then 'N' else 'V' }"
                    UseType = "{ if (data($path/ayr:AddressType) = 'Job') then '14' else '13' }"
                    FormattedInd = "1"
                    DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $path/ayr:AddressType) then '1' else '0' }">
                {
                if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
                }
                {
                if (data($addressLine2)) then <com:AddressLine>{ $addressLine2 }</com:AddressLine> else ()
                }
                {
                if (data($addressLine3)) then <com:AddressLine>{ $addressLine3 }</com:AddressLine> else ()
                }
                <com:CityName>{ $cityName }</com:CityName>
                <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
                <com:StateProv>{$stateProv}</com:StateProv>
                {
				if (data($countryName)) then <com:CountryName Code = "{ dvm:lookupValue($dvmTable, 'CountryName', $countryName, 'CountryCode', "") }" /> else <com:CountryName />
				}
                <com:CompanyName>{ if (data($path/ayr:AddressType) = "Job") then $companyName else "" }</com:CompanyName>
                {
                data($path/ayr:PrimaryPersonalAddressId)
                }
            </com:Address>
}
{
if (data($citizenship !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$citizenship, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($loyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($loyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($loyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($loyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($loyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($loyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($loyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($loyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($loyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
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
 
 
<com:CustLoyalty LoyalLevel="{data($loyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}" EffectiveDate="{xf2:Convert_SiebelDateTime_To_YYYY-MM-DD(data($loyMember/ayr:StartDate))}">
	<com:SubAccountBalance Balance="{data($loyMember/ayr:Point1Value)}"/>
</com:CustLoyalty>
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($loyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($loyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($loyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($loyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}
                       </com:Customer>
else
					
<com:Customer >
 
                      <com:PersonName>
                                  <com:GivenName>{data($loyMember[1]/ayr:PrimaryContactFirstName)}</com:GivenName>
{
if (data($loyMember[1]/ayr:PrimaryContactMiddleName)!="") then 
                  <com:MiddleName>{data($loyMember[1]/ayr:PrimaryContactMiddleName)}</com:MiddleName>
else "" 
}
                                  <com:Surname>{data($loyMember/ayr:PrimaryContactLastName)}</com:Surname>  
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
	 <com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
else
<com:Email DefaultInd = "{if (data($loyMember/ayr:AYeMailReturnedFlg) = "Y") then
                                                                    ("1")
                                                                    else
                                                                    "0"  }" EmailType = "1">{data($Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress[$var3]/ayr:AlternateEmailAddress)}</com:Email>
}
{    
if (data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[1]/ayr:AddressType) = "" and data($Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress[2]/ayr:AddressType) = "") then
    ()
else
    for $path in $Contact/ayr:ListOfPersonalAddress/ayr:PersonalAddress
        let $addressLine := $path/ayr:PersonalStreetAddress/text()
        let $addressLine2 := $path/ayr:PersonalStreetAddress2/text()
        let $addressLine3 := $path/ayr:PersonalStreetAddress3/text()
        let $cityName := $path/ayr:PersonalCity/text()
        let $postalCode:= $path/ayr:PersonalPostalCode/text()
        let $stateProv := $path/ayr:PersonalProvince/text()
        let $countryName := $path/ayr:PersonalCountry/text()
        let $companyName := $path/ayr:AYCompanyName/text()
        return
            <com:Address
                    ValidationStatus = "{ if (data($loyMember/ayr:AYMailReturnedFlg) = 'Y') then 'N' else 'V' }"
                    UseType = "{ if (data($path/ayr:AddressType) = "Job") then '14' else '13' }"
                    FormattedInd = "1"
                    DefaultInd = "{ if (data($PrimaryPersonalAddressType) = ('Home', 'Job') and data($PrimaryPersonalAddressType) = $path/ayr:AddressType) then '1' else '0' }">
                {
                if (data($addressLine)) then <com:AddressLine>{ $addressLine }</com:AddressLine> else ()
                }
                {
                if (data($addressLine2)) then <com:AddressLine>{ $addressLine2}</com:AddressLine> else ()
                }
                {
                if (data($addressLine3)) then <com:AddressLine>{ $addressLine3}</com:AddressLine> else ()
                }                   
                <com:CityName>{$cityName }</com:CityName>
                <com:PostalCode>{ if (data($postalCode) != "") then $postalCode else "0000" }</com:PostalCode>
                <com:StateProv>{$stateProv}</com:StateProv>
                {
                if (data($countryName)) then <com:CountryName Code = "{ dvm:lookupValue($dvmTable, 'CountryName', $countryName, 'CountryCode', "") }" /> else <com:CountryName />
		        }
		        <com:CompanyName>{ if (data($path/ayr:AddressType) = "Job") then $companyName else "" }</com:CompanyName>
		        {
		        data($path/ayr:PrimaryPersonalAddressId)
		        }
            </com:Address>
}
{
if (data($citizenship !=""))then
<com:CitizenCountryName Code = "{dvm:lookupValue($CitizendvmTable,'CitizenshipName',$citizenship, 'CitizenshipCode',"")}"/>
else ""
}
 
{
  if (data($loyMember/ayr:AYGuardianName) != "") then
                        
 <com:RelatedTraveler Relation = "guardian">
{
if(data($loyMember/ayr:AYGuardianMemberNumber)!="") then
                                        <com:UniqueID Type = "21"
                                                      ID = "{data($loyMember/ayr:AYGuardianMemberNumber)}"/>
                                         else ""
}
{
if  (data($loyMember/ayr:AYGuardianName)!="")then                                      
                                            <com:PersonName>
                                            <com:Surname>{data($loyMember/ayr:AYGuardianName)}</com:Surname>
                                          </com:PersonName>
else "" 
}
                                      
{
if(data($loyMember/ayr:AYGuardianPhoneNumber)!="") then

 <com:Telephone PhoneLocationType = "6"
                                                      PhoneTechType = "5"
                                                       PhoneNumber = "{data($loyMember/ayr:AYGuardianPhoneNumber)}"/>
else ""
}
{  
 if(data($loyMember/ayr:AYGuardianEmail)!="")   then                                
 <com:Email EmailType="1">{data($loyMember/ayr:AYGuardianEmail)}</com:Email>

else ""                                    
}

</com:RelatedTraveler>
                       else ()

} 
{
                       if (data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear/ayr:AYChildBirthYear) != "") then
 
                       for $var1 in (1 to fn:count($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear))
 
return
                        
if(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear)!="")
then
<com:RelatedTraveler Relation = "child"
                                                 BirthDate = "{fn:concat(data($loyMember/ayr:ListOfAyLoyMemberChildrenBirthYear/ayr:AyLoyMemberChildrenBirthYear[$var1]/ayr:AYChildBirthYear),"-01-01")}" />
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
 
<com:CustLoyalty LoyalLevel="{data($loyMember/ayr:ListOfLoyMemberDominantTier[1]/ayr:LoyMemberDominantTier/ayr:TierName)}" EffectiveDate="{xf2:Convert_SiebelDateTime_To_YYYY-MM-DD(data($loyMember/ayr:StartDate))}">
	<com:SubAccountBalance Balance="{data($loyMember/ayr:Point1Value)}"/>
</com:CustLoyalty>
 
{
if(data($Contact/ayr:JobTitle) != "") then 
 
                       <com:EmployeeInfo EmployeeTitle = "{data($Contact/ayr:JobTitle)}"/>
 
else "" }
                       <com:LanguageSpoken Code = "{if (data($loyMember/ayr:LanguageId)="FIN") then
                       ("fi")
                       else if (data($loyMember/ayr:LanguageId)="ENU") then
                       ("en")
                       else if (data($loyMember/ayr:LanguageId)="SVE") then
                       ("sv")
                       else "" }"/>
                                
{
if (data($loyMember/ayr:MemberGroup) != "")
then
                       <com:Rates RateCategory = "19"/> 
else ""
}

                       </com:Customer>					   
					   
					   
}
 
 
 
                       <com:UserID Type = "1"
                                        ID = "{data($loyMember/ayr:MemberNumber)}"
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
                            <com:CustomField KeyValue = "1">{ $DestinationsWithoutSpace }</com:CustomField>
                            <com:CustomField KeyValue = "2">{ $VacationsWithoutSpace }</com:CustomField>
                            <com:CustomField KeyValue = "3">{
	                            for $hobby in $Contact/ayr:ListOfEautoContactHobby/ayr:EautoContactHobby
	                                return
	                                dvm:lookupValue($HobbiesDvm, 'HobbyName', $hobby/ayr:HobbyLOV/text(), 'HobbyID', '')
                            }</com:CustomField>
						    <com:CustomField KeyValue = "7">{ if ($Contact/ayr:SuppressSMSPromos = "N") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue = "8">{ if ($loyMember/ayr:ReceivePartnerPromotionFlag = "Y") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue = "9">{ if ($Contact/ayr:SuppresseMailWeeklyOffers = "N") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue = "10">{ if ($Contact/ayr:SuppressAllEmails = "N") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue = "11">{ if ($Contact/ayr:SuppressAllFaxes = "N") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue = "12">{ if ($Contact/ayr:SuppressAllSMS = "N") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue = "13">{ if ($Contact/ayr:eMailFlightInfo = "Y") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue="DESTBUSI">
							{
							for $var in $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[ay:AYInterestType = "Usual Business Destination"]
				        		return
				        		fn:concat($var/ay:AYInterestName/text())
							}
						    </com:CustomField>
						    <com:CustomField KeyValue="DESTLEIS">
							{
							for $var in $SiebelResponse/asi:QueryPageInterestResponse/Siebel_spcMessage/ay:ListOfAyLoyMemberInt/ay:LoyMember/ay:ListOfAyLoyMemberInterests/ay:AyLoyMemberInterests[ay:AYInterestType = "Favorite Leisure Destination"]
				        		return
				        		fn:concat($var/ay:AYInterestName/text())
							}
						    </com:CustomField>
						    <com:CustomField KeyValue="HHOLD">{ data($loyMember/ayr:AYHouseholdSize) } </com:CustomField>
						    <com:CustomField KeyValue="PREFLANG">{ dvm:lookupValue($PreferredLanguagedvm, 'SiebelPreferredLangCode', $Contact/ayr:PreferredLanguageCode, 'ISOCode', 'EN') } </com:CustomField>
						    <com:CustomField KeyValue="XFRPTS">{ if ($loyMember/ayr:AYTransferPoints = "Y") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue="FRXFRPTS">{if ($loyMember/ayr:AYFreePointTransfer = "Y") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue="FPTSXCGH">{if ($loyMember/ayr:AYFreePointExchange = "Y") then "TRUE" else "FALSE" }</com:CustomField>
						    <com:CustomField KeyValue="XPTSALLW">{ if ($loyMember/ayr:AYExchangePointsFlg = "Y") then "TRUE" else "FALSE" }</com:CustomField>
                        </com:CustomFields>
                    </com:Profile>
                </com:ProfileInfo>
            </com:Profiles>
        </com:AMA_ProfileReadRS>
};
 
declare variable $QuerybyExampleFullMemberResponse as element(*) external;
declare variable $PreferredLanguagedvm as element(*) external;
declare variable $dvmTable as element(*) external;
declare variable $CitizendvmTable as element(*) external;
declare variable $SiebelResponse as element(*) external;
declare variable $HobbiesDvm as element(*) external;
declare variable $DestinationsWithoutSpace as xs:string external;
declare variable $VacationsWithoutSpace as xs:string external;
 
xf:XQ_Res_GetProfile($QuerybyExampleFullMemberResponse, $PreferredLanguagedvm, $dvmTable, $CitizendvmTable, $SiebelResponse, $HobbiesDvm, $DestinationsWithoutSpace, $VacationsWithoutSpace)