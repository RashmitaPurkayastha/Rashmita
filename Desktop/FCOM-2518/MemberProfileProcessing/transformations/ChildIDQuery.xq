(:: pragma  parameter="$anyType1" type="anyType" ::)
(:: pragma  parameter="$QuerybyExampleFullMemberResponse" type="anyType" ::)
(:: pragma  type="anyType" ::)


(:: pragma bea : Created By : Piyush Kapoor            Date : 31-July-2010            Version : 1.0.0 ::)

declare namespace xf = "http://com.finnair/MemberProfileProcessing/transformation/ChildIDQuery/";
declare namespace ayr = "http://www.siebel.com/xml/AYRES%20Member%20Information%20–%20Long%20Portal";
declare namespace prof="http://com.finnair/profileProcessing/";
declare namespace com="http://com.finnair";
declare namespace asi = "http://siebel.com/asi/";


declare function xf:ChildIDQuery($Request as element(*),$MemberID as xs:string)
    as element(*) {
    

if (data($Request/prof:UpdateProfile/AMA_UpdateRQ/com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:Customer/com:RelatedTraveler/@Relation)="child") then

 <ayr:ListOfAyLoyMemberChildrenBirthYear>
{
for $temp in (1 to fn:count($Request/prof:UpdateProfile/AMA_UpdateRQ/com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:Customer/com:RelatedTraveler))
where data($Request/prof:UpdateProfile/AMA_UpdateRQ/com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:Customer/com:RelatedTraveler[$temp]/@Relation)="child"

return 

         

 <ayr:AyLoyMemberChildrenBirthYear>
                        <ayr:Id>{if (data($Request/prof:UpdateProfile/AMA_UpdateRQ/com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:Customer/com:RelatedTraveler[$temp]/com:UniqueID/@ID)!="") then
data($Request/prof:UpdateProfile/AMA_UpdateRQ/com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:Customer/com:RelatedTraveler[$temp]/com:UniqueID/@ID)
else
$temp
}</ayr:Id>
                        <ayr:AYChildBirthYear>{ fn:year-from-date($Request/prof:UpdateProfile//com:AMA_UpdateRQ/com:Position/com:Root/com:Profile/com:Customer/com:RelatedTraveler[$temp]/@BirthDate)}</ayr:AYChildBirthYear>
                        <ayr:MemberId>{$MemberID}</ayr:MemberId>
                        <ayr:Name>{$temp}</ayr:Name>
                        <ayr:Type>Children_Birth_Year</ayr:Type>
                     </ayr:AyLoyMemberChildrenBirthYear>


                           
                   }   
                        </ayr:ListOfAyLoyMemberChildrenBirthYear>
           
else 

                        <ayr:ListOfAyLoyMemberChildrenBirthYear/>
};

declare variable $MemberID as xs:string external;
declare variable $Request as element(*) external;


xf:ChildIDQuery($Request,$MemberID)