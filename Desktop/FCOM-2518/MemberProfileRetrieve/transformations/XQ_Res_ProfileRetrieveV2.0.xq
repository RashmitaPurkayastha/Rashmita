declare namespace mem="http://com.finnair/MemberProfileRetrieve/";
declare namespace ayr = "http://www.siebel.com/xml/AYRES%20Member%20Information%20-%20Short";
declare namespace xf = "http://com.finnair/ProfileRetieve/transformations/XQ_Req_QueryByExampleFullMember/";
declare namespace asi = "http://siebel.com/asi/";
declare namespace com="http://com.finnair";

declare function xf:XQ_Res_IdentifyResponse($body as element(), $LangID as xs:string, $DateOfBirth as xs:string, $Country as xs:string, $PreferredMailingAddress as xs:string, $AYTierStartDate as xs:string, $AYTierEndDate as xs:string, $PersonalTitle as xs:string)
    as element(com:IdentifyRS) {
	<com:IdentifyRS>
    	<com:Success/>
        <com:Language>{ $LangID }</com:Language>
        <com:LifetimePoint2Value>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:LifetimePoint2Value)}</com:LifetimePoint2Value>
        <com:MemberNumber>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:MemberNumber)}</com:MemberNumber>
        <com:AwardPoints>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:Point1Value)}</com:AwardPoints>
        <com:Firstname>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:PrimaryContactFirstName)}</com:Firstname>
        <com:PreferredMailingAddress>{data($PreferredMailingAddress) }</com:PreferredMailingAddress>
        <com:Lastname>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:PrimaryContactLastName)}</com:Lastname>
        <com:Middlename>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:PrimaryContactMiddleName)}</com:Middlename>
        <com:DateOfBirth>{data($DateOfBirth)}</com:DateOfBirth>
        <com:Tier>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:Tier)}</com:Tier>
        <com:TierPoints>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:QualPeriodPoint2Qual)}</com:TierPoints>
        <com:Status>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:Status)}</com:Status>
        <com:AYSEBCard>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYSEBCard)}</com:AYSEBCard>
        <com:LifetimeTierName>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYLifetimeTierName)}</com:LifetimeTierName>
        <com:AYCardType>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYCardType)}</com:AYCardType>
        <com:AYSEBDC>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYSEBDC)}</com:AYSEBDC>
        <com:AYSEBMC>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYSEBMC)}</com:AYSEBMC>
        <com:PlatinumGift>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYAGOGift)}</com:PlatinumGift>
        <com:NextTierName>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYNextTierName)}</com:NextTierName>
        <com:NextLifetimeTier>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYNextLifetimeTier)}</com:NextLifetimeTier>
        <com:FlightsToNextTier>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYFlightsToNextTier)}</com:FlightsToNextTier>
        <com:TierPointsToNextTier>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYTierPointsToNextTier)}</com:TierPointsToNextTier>
        <com:LifetimePointsToNextTier>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYReqLFTMTierPtstoNextTier)}</com:LifetimePointsToNextTier>
        <com:ExchangePoints>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYExchangePointsFlg)}</com:ExchangePoints>
        <com:TransferPoints>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYTransferPoints)}</com:TransferPoints>
        <com:FreePointExchange>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYFreePointExchange)}</com:FreePointExchange>
        <com:FreePointTransfer>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYFreePointTransfer)}</com:FreePointTransfer>
        {
        if (data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalAddressType) eq "Home") then (
	    	<com:City>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalCity)}</com:City>,
            <com:Country>{data($Country) }</com:Country>,
            <com:PostalCode>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalPostalCode)}</com:PostalCode>,
            <com:State>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalState)}</com:State>,
            <com:StreetAddress>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalStreetAddress)}</com:StreetAddress>
       	) else ( 
	    	<com:WorkCity>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalCity)}</com:WorkCity>,
            <com:WorkCountry>{data($Country) }</com:WorkCountry>,
            <com:WorkPostalCode>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalPostalCode)}</com:WorkPostalCode>,
            <com:WorkState>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalState)}</com:WorkState>,
            <com:WorkStreetAddress>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimaryPersonalStreetAddress)}</com:WorkStreetAddress>
		)}           
        <com:LifeCycleSegment/>
        <com:HomePhone/>
        <com:MobilePhone>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:PrimarySMSNumber)}</com:MobilePhone>
        <com:WorkPhone/>
        <com:Email>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:ListOfCommunicationAddress/ayr:CommunicationAddress/ayr:AlternateEmailAddress)}</com:Email>
        <com:Fax/>
        <com:WorkFax/>
        <com:FQVTCClub/>
        <com:WDBCompanyCode/>
        <com:WDBPermission/>
        <com:WDBCompanyName/>
        <com:AYPrimaryCompanyName>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:ListOfContact/ayr:Contact/ayr:AYPrimaryCompanyName)}</com:AYPrimaryCompanyName>
        <com:PersonalTitle>{$PersonalTitle}</com:PersonalTitle>
        <com:Title/>
        <com:SeatPreference/>
        <com:MealOptions/>
        <com:QualPeriodPoint2Qual>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:QualPeriodPoint2Qual)}</com:QualPeriodPoint2Qual>
        <com:AYQPNumQFlightCalc>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYQPNumQFlightCalc)}</com:AYQPNumQFlightCalc>
        <com:AYTierStartDate>{$AYTierStartDate}</com:AYTierStartDate>
        <com:AYTierEndDate>{$AYTierEndDate}</com:AYTierEndDate>
        <com:TierLifetimeFlag>{data($body/asi:QueryByExampleMemberResponse/SiebelMessage/ayr:ListOfAyresMemberInformation-Short/ayr:LoyMember/ayr:AYLifetimeTierFlg)}</com:TierLifetimeFlag>
	</com:IdentifyRS>
         
};

declare variable $body as element() external;
declare variable $LangID as xs:string external;
declare variable $Country as xs:string external;
declare variable $PreferredMailingAddress as xs:string external;
declare variable $DateOfBirth as xs:string external;
declare variable $AYTierStartDate as xs:string external;
declare variable $AYTierEndDate as xs:string external;
declare variable $PersonalTitle as xs:string external;




xf:XQ_Res_IdentifyResponse($body, $LangID, $DateOfBirth, $Country, $PreferredMailingAddress, $AYTierStartDate, $AYTierEndDate, $PersonalTitle)