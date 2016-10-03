xquery version "1.0" encoding "UTF-8";
(:: pragma type="xs:anyType" ::)

declare namespace xf = "http://tempuri.org/MemberProfileProcessing/transformations/XQ_MemberFileProcessing_ProducePersonalAddress/";
declare namespace prof = "http://com.finnair/profileProcessing/";
declare namespace com = "http://com.finnair";
declare namespace ayr = "http://www.siebel.com/xml/AYRES%20Member%20Information%20–%20Long%20Portal";

declare function xf:XQ_MemberFileProcessing_ProducePersonalAddress($request as element(*), $position as xs:int, $personalCountryHome as xs:string?, $personalCountryJob as xs:string?) as element(*) {
    let $address := $request/prof:InsertNewMember//com:AMA_ProfileCreateRQ/com:Profile/com:Customer/com:Address[$position][@UseType = ("13", "14")]
	return
		if (empty($address)) then
		    ()
		else
		    let $variables as element(*) :=
			    if ($address/@UseType = "13") then
			        <variables
			               addressType="Home"
			               personalCountry="{ if (empty($personalCountryHome)) then '' else $personalCountryHome }"
			           />
			    else (: $address/@UseType = "14" :)
			        <variables
		                   addressType="Job"
		                   personalCountry="{ if (empty($personalCountryJob)) then '' else $personalCountryJob }"
		                   companyName="{ string($address/com:CompanyName) }"
		               />
		    let $countryCodeStr as xs:string := string($address/com:CountryName/@Code)
		    let $postalCodeStr as xs:string := string($address/com:PostalCode)
		    let $personalStreetAddressStr as xs:string := string($address/com:AddressLine[1])
            let $personalStreetAddress2Str as xs:string? := string($address/com:AddressLine[2])
            let $personalStreetAddress3Str as xs:string? := string($address/com:AddressLine[3])
		    let $descriptionStr as xs:string := string($address/@Description)
		    let $countyStr as xs:string := string($request/com:County)
		    
		    return
		        <ayr:PersonalAddress>
		            <ayr:PersonalAddressId>{ $position }</ayr:PersonalAddressId>
		            <ayr:AYCompanyName>{ string($variables/@companyName) }</ayr:AYCompanyName>
		            <ayr:AddressId>{ $position }</ayr:AddressId>
		            <ayr:AddressType>{ string($variables/@addressType) }</ayr:AddressType>
		            <ayr:PersonalCity>{ string($address/com:CityName) }</ayr:PersonalCity>
		            <ayr:PersonalCountry>{ string($variables/@personalCountry) }</ayr:PersonalCountry>
		            <ayr:IntegrationId />
		            <ayr:PersonalPostalCode>{ if (empty($postalCodeStr) and $position != 1) then '0000' else $postalCodeStr }</ayr:PersonalPostalCode> (: $position check looks odd to me but this is how it was implemented previously... Marcus :)
		            <ayr:PersonalProvince>{
		                if ($countryCodeStr = ("CA", "US", "AU")) then
		                    string($address/com:StateProv)
		                else
		                    ""
		            }</ayr:PersonalProvince>
		            <ayr:PersonalAddressStartDate />
		            <ayr:PersonalState />
		            <ayr:PersonalStreetAddress>{ $personalStreetAddressStr }</ayr:PersonalStreetAddress>
		            <ayr:PersonalStreetAddress2>{
		                if ($countryCodeStr = ("JP", "GB")) then
		                    $descriptionStr
	                    else if ($countryCodeStr = ("KP", "KR", "CA", "CN", "IN", "NZ")) then
	                        $personalStreetAddress2Str
	                    else
	                       ""
	                }</ayr:PersonalStreetAddress2>
		            <ayr:PersonalStreetAddress3>{
		              if (xs:string($variables/@addressType) = "Job"
		                      and $countryCodeStr = ("KP", "KR", "CA", "CN", "IN", "NZ")) then
		                  $personalStreetAddress3Str
		              else
		                  ""
	                }</ayr:PersonalStreetAddress3>
		        </ayr:PersonalAddress>
};

declare variable $request as element(*) external;
declare variable $position as xs:int external;
declare variable $personalCountryHome as xs:string? external;
declare variable $personalCountryJob as xs:string? external;

xf:XQ_MemberFileProcessing_ProducePersonalAddress($request, $position, $personalCountryHome, $personalCountryJob)