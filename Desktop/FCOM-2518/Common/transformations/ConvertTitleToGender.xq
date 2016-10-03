xquery version "1.0" encoding "UTF-8";

declare namespace xf = "http://tempuri.org/Common/transformations/ConvertTitleToGender/";

(:
normalizedTitle is result of NormalizeTitle.xq, that is MR or MS
:)
declare function xf:ConvertTitleToGender($normalizedTitle as xs:string)
    as xs:string {

if ($normalizedTitle = "MR") then
	"M"
else if ($normalizedTitle = "MS") then
	"F"
else
	"-"
};

declare variable $normalizedTitle as xs:string external;

xf:ConvertTitleToGender($normalizedTitle)