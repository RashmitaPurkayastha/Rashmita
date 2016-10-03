declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformations/XQ_BVServlet/";

declare function xf:XQ_BVServlet($UserId as xs:string,
    $Password as xs:string,$SiteLanguage as xs:string,
    $ApplicationId as xs:string,
    $Command as xs:string) {
        concat("UserId=",$UserId,"&amp;Password=",$Password,"&amp;SiteLanguage=",$SiteLanguage,"&amp;ApplicationId=",$ApplicationId,"&amp;Command=",$Command)
};

declare variable $UserId as xs:string external;
declare variable $Password as xs:string external;
declare variable $SiteLanguage as xs:string external;

declare variable $ApplicationId as xs:string external;
declare variable $Command as xs:string external;



xf:XQ_BVServlet($UserId,
    $Password,$SiteLanguage,
    $ApplicationId,
    $Command)