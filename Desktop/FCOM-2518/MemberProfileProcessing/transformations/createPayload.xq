(:: pragma bea:global-element-parameter parameter="$aMA_UpdateRQ1" element="ns0:AMA_UpdateRQ" location="../../PortalInterfaces/schema/AMA_UpdateRQ.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AMA_UpdateRQ" location="../../PortalInterfaces/schema/AMA_UpdateRQ.xsd" ::)


(:: pragma bea : Created By : Piyush Kapoor            Date : 10-Aug-2010            Version : 1.0.0 ::)

declare namespace ns0 = "http://com.finnair";
declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/createPayload/";
declare namespace prof = "http://com.finnair/profileProcessing/";

declare function xf:createPayload($aMA_UpdateRQ1 as element(ns0:AMA_UpdateRQ))
    as element(prof:UpdateProfile) {
<prof:UpdateProfile>
	<AMA_UpdateRQ>
        <ns0:AMA_UpdateRQ>
           {
                for $UniqueID in $aMA_UpdateRQ1/ns0:UniqueID
                return
                    <ns0:UniqueID ID = "{ data($UniqueID/@ID) }"/>
            }
             <ns0:Position>
                <ns0:Root>
            <ns0:Profile>
                {
                    for $Customer in $aMA_UpdateRQ1/ns0:Position/ns0:Root/ns0:Profile/ns0:Customer
                    return
                        <ns0:Customer Gender = "{ data($Customer/@Gender) }"
                                      BirthDate = "{ data($Customer/@BirthDate) }">
                            {
                                for $PersonName in $Customer/ns0:PersonName
                                return
                                    <ns0:PersonName>
                                        {
                                            for $GivenName in $PersonName/ns0:GivenName
                                            return
                                                <ns0:GivenName>{ data($GivenName) }</ns0:GivenName>
                                        }
                                        {
                                            for $MiddleName in $PersonName/ns0:MiddleName
                                            return
                                                <ns0:MiddleName>{ data($MiddleName) }</ns0:MiddleName>
                                        }
                                        <ns0:Surname>{ data($PersonName/ns0:Surname) }</ns0:Surname>
                                    </ns0:PersonName>
                            }
                            {
                                for $Telephone in $Customer/ns0:Telephone
                                return
                                    <ns0:Telephone PhoneLocationType = "{ data($Telephone/@PhoneLocationType) }" PhoneTechType = "{ data($Telephone/@PhoneTechType) }"
                                                                         PhoneNumber = "{ data($Telephone/@PhoneNumber) }"/>
                            }
                            {
                                for $Email in $Customer/ns0:Email
                                return
                                    <ns0:Email DefaultInd = "{ data($Email/@DefaultInd) }"
                                               EmailType = "{ data($Email/@EmailType) }">{ data($Email) }</ns0:Email>
                            }
                            {
                                for $Address in $Customer/ns0:Address
                                return
                                    <ns0:Address FormattedInd = "{ data($Address/@FormattedInd) }"
                                                 ValidationStatus = "{ data($Address/@ValidationStatus) }"
                                                 Description = "{ data($Address/@Description) }"
                                                 DefaultInd = "{ data($Address/@DefaultInd) }"
                                                 UseType = "{ data($Address/@UseType) }">
                                        {
                                            for $AddressLine in $Address/ns0:AddressLine
                                            return
                                                <ns0:AddressLine>{ data($AddressLine) }</ns0:AddressLine>
                                        }
                                        {
                                            for $CityName in $Address/ns0:CityName
                                            return
                                                <ns0:CityName>{ data($CityName) }</ns0:CityName>
                                        }
                                        {
                                            for $PostalCode in $Address/ns0:PostalCode
                                            return
                                                <ns0:PostalCode>{ data($PostalCode) }</ns0:PostalCode>
                                        }
                                        {
                                            for $County in $Address/ns0:County
                                            return
                                                <ns0:County>{ data($County) }</ns0:County>
                                        }
                                        {
                                            for $StateProv in $Address/ns0:StateProv
                                            return
                                                <ns0:StateProv>{ data($StateProv) }</ns0:StateProv>
                                        }
                                        {
                                            for $CountryName in $Address/ns0:CountryName
                                            return
                                                <ns0:CountryName Code = "{ data($CountryName/@Code) }">{ data($CountryName) }</ns0:CountryName>
                                        }
                                        {
                                            for $CompanyName in $Address/ns0:CompanyName
                                            return
                                                <ns0:CompanyName>{ data($CompanyName) }</ns0:CompanyName>
                                        }
                                    </ns0:Address>
                            }
                            {
                                for $CitizenCountryName in $Customer/ns0:CitizenCountryName
                                return
                                    <ns0:CitizenCountryName Code = "{ data($CitizenCountryName/@Code) }"/>
                            }
                            {
                                for $RelatedTraveler in $Customer/ns0:RelatedTraveler
                                return
                                    <ns0:RelatedTraveler BirthDate = "{ data($RelatedTraveler/@BirthDate) }" Relation = "{data($RelatedTraveler/@Relation)}">
                                        {
                                            for $UniqueID in $RelatedTraveler/ns0:UniqueID
                                            return
                                                <ns0:UniqueID ID = "{ data($UniqueID/@ID) }"/>
                                        }
                                        {
                                            for $PersonName in $RelatedTraveler/ns0:PersonName
                                            return
                                                <ns0:PersonName>
                                                    <ns0:Surname>{ data($PersonName/ns0:Surname) }</ns0:Surname>
                                                </ns0:PersonName>
                                        }
                                        {
                                            for $Telephone in $RelatedTraveler/ns0:Telephone
                                            return
                                                <ns0:Telephone PhoneLocationType = "{data($Telephone/@PhoneLocationType)}"
PhoneTechType = "{data($Telephone/@PhoneTechType)}" 
PhoneNumber = "{ data($Telephone/@PhoneNumber) }"/>
                                        }
                                        {
                                            for $Email in $RelatedTraveler/ns0:Email
                                            return
                                                <ns0:Email>{ data($Email) }</ns0:Email>
                                        }
                                    </ns0:RelatedTraveler>
                            }
                            {
                                for $Document in $Customer/ns0:Document
                                return
                                    <ns0:Document DocType = "{data($Document/@DocType)}" DocID = "{ data($Document/@DocID) }"
                                                  EffectiveDate = "{ data($Document/@EffectiveDate) }"
                                                  ExpireDate = "{ data($Document/@ExpireDate) }"
                                                  DocIssueCountry = "{ data($Document/@DocIssueCountry) }"/>
                            }
                            {
                                for $EmployeeInfo in $Customer/ns0:EmployeeInfo
                                return
                                    <ns0:EmployeeInfo EmployeeTitle = "{ data($EmployeeInfo/@EmployeeTitle) }">{ data($EmployeeInfo) }</ns0:EmployeeInfo>
                            }
                            {
                                for $LanguageSpoken in $Customer/ns0:LanguageSpoken
                                return
                                    <ns0:LanguageSpoken Code = "{ data($LanguageSpoken/@Code) }"/>
                            }
                        </ns0:Customer>
                }
                {
                    for $UserID in $aMA_UpdateRQ1/ns0:Position/ns0:Root/ns0:Profile/ns0:UserID
                    return
                        <ns0:UserID PinNumber = "{ data($UserID/@PinNumber) }"/>
                }
                {
                    for $PrefCollections in $aMA_UpdateRQ1/ns0:Position/ns0:Root/ns0:Profile/ns0:PrefCollections
                    return
                        <ns0:PrefCollections>
                            {
                                for $PrefCollection in $PrefCollections/ns0:PrefCollection
                                return
                                    <ns0:PrefCollection>
                                        {
                                            for $AirlinePref in $PrefCollection/ns0:AirlinePref
                                            return
                                                <ns0:AirlinePref>
                                                        {
                                                        for $AL_Pref in $AirlinePref/ns0:AirportOriginPref
                                                        return
                                                            <ns0:AirportOriginPref LocationCode = "{ data($AL_Pref/@LocationCode) }"/>
                                                    	}
                                                    {
                                                        for $SeatPref in $AirlinePref/ns0:SeatPref
                                                        return
                                                            <ns0:SeatPref>
                                                                {
                                                                    for $SeatPreferences in $SeatPref/ns0:SeatPreferences
                                                                    return
                                                                        <ns0:SeatPreferences>{ data($SeatPreferences) }</ns0:SeatPreferences>
                                                                }
                                                            </ns0:SeatPref>
                                                    }
                                                    {
                                                        for $SSR_Pref in $AirlinePref/ns0:SSR_Pref
                                                        return
                                                            <ns0:SSR_Pref SSR_Code = "{ data($SSR_Pref/@SSR_Code) }"/>
                                                    }
                                                </ns0:AirlinePref>
                                        }
                                        {
                                            for $CommonPref in $PrefCollection/ns0:CommonPref
                                            return
                                                <ns0:CommonPref>
                                                    {
                                                        for $ContactPref in $CommonPref/ns0:ContactPref
                                                        return
                                                            <ns0:ContactPref PreferLevel = "{ data($ContactPref/@PreferLevel) }"
                                                                             DistribType = "{ data($ContactPref/@DistribType) }">{ data($ContactPref) }</ns0:ContactPref>
                                                    }
                                                </ns0:CommonPref>
                                        }
                                    </ns0:PrefCollection>
                            }
                        </ns0:PrefCollections>
                }
                <ns0:CustomFields>
                    {
                        for $CustomField in $aMA_UpdateRQ1/ns0:Position/ns0:Root/ns0:Profile/ns0:CustomFields/ns0:CustomField
                        return
                            <ns0:CustomField KeyValue = "{ data($CustomField/@KeyValue) }">{ data($CustomField) }</ns0:CustomField>
                    }
                </ns0:CustomFields>
            </ns0:Profile>
              </ns0:Root>
            </ns0:Position>
        </ns0:AMA_UpdateRQ>

</AMA_UpdateRQ>
</prof:UpdateProfile>
};

declare variable $aMA_UpdateRQ1 as element(ns0:AMA_UpdateRQ) external;

xf:createPayload($aMA_UpdateRQ1)