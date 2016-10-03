xquery version "1.0" encoding "Cp1252";

declare namespace xf = "http://tempuri.org/Common/transformations/Convert_SiebelDate_To_YYYY-MM-DD/";

declare function xf:Convert_YYYY-MM-DD_To_SiebelDate($sourceDate as xs:string)
    as xs:string {
    if (fn:not(fn:exists($sourceDate))) then 
		string('')
    else if (fn:string-length($sourceDate) = 10) then
   		let $retValue := concat(substring($sourceDate, 6, 2), '/', substring($sourceDate, 9, 2), '/', substring($sourceDate, 1, 4))
		return $retValue
	else
		''
};

declare variable $sourceDate as xs:string external;

xf:Convert_YYYY-MM-DD_To_SiebelDate($sourceDate)