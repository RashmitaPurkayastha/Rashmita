xquery version "1.0" encoding "Cp1252";
(:: pragma  parameter="$anyType1" type="xs:anyType" ::)

(:: pragma bea : Created By : Piyush Kapoor & Pankaj Kumar            Date : 30-July-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_FPlusAppServlet/";

declare function xf:XQ_FPlusAppServlet($anyType1 as element(*),$details as element(*))
    as xs:string  {
        fn:concat('Sex','=',data($details/Sex)
        ,'&amp;','BirthDate','=',data($details/BirthDate)
        ,'&amp;','FirstName','=',data($details/FirstName)
        ,'&amp;','FqtvNum','=',data($details/FqtvNum)
        ,'&amp;','FqtvLevel','=',data($details/FqtvLevel)
        ,'&amp;','LastName','=',data($details/LastName)
        ,'&amp;','Nationality','=',data($details/Nationality)
        ,'&amp;','PreferredMailingAddress','=',data($details/PreferredMailingAddress)
        ,'&amp;','PreferredLanguage','=',data($details/PreferredLanguage)
        ,'&amp;','Email','=',data($details/Email)
        ,'&amp;','RulesAccepted','=',data($details/RulesAccepted)
        ,'&amp;','EmailOffers','=',data($details/EmailOffers)
        ,'&amp;','SmsOffers','=',data($details/SmsOffers)
        ,'&amp;','PartnerOffers','=',data($details/PartnerOffers)
        ,'&amp;','FlightSms','=',data($details/FlightSms)
        ,'&amp;','FlightEmail','=',data($details/FlightEmail)
        ,'&amp;','PreferredMailType','=',data($details/PreferredMailType)
        ,'&amp;','FpCustTypeCust','=',data($details/FpCustTypeCust)
        ,'&amp;','Format','=',data($details/Format)
        ,'&amp;','UserId','=',data($details/UserId)
        ,'&amp;','Password','=',data($details/Password)
        ,'&amp;','RegisterUser','=',data($details/RegisterUser)
        ,'&amp;','MiddleName','=',data($details/MiddleName)
        ,'&amp;','Title','=',data($details/Title)
        ,'&amp;','Street','=',data($details/Street)
        ,'&amp;','BusinessStreet','=',data($details/BusinessStreet)
        ,'&amp;','Zip','=',data($details/Zip)
        ,'&amp;','BusinessZip','=',data($details/BusinessZip)
        ,'&amp;','Country','=',data($details/Country)
        ,'&amp;','BusinessCountry','=',data($details/BusinessCountry)
        ,'&amp;','PostOffice','=',data($details/PostOffice)
        ,'&amp;','City','=',data($details/City)
        ,'&amp;','State','=',data($details/State)
        ,'&amp;','MobilePhone','=',data($details/MobilePhone)
        ,'&amp;','SiteLanguage','=',data($details/SiteLanguage)
        ,'&amp;','S_FirstName','=',data($details/S_FirstName)
        ,'&amp;','S_LastName','=',data($details/S_LastName)
        ,'&amp;','S_FqtvNum','=',data($details/S_FqtvNum)
        )
};

declare variable $anyType1 as element(*) external;
declare variable $details as element(*) external;

xf:XQ_FPlusAppServlet($anyType1,$details)