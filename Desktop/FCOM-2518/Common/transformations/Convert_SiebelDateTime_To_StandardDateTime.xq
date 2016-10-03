declare namespace xf = "http://tempuri.org/partnerServices/Partners_common/transformations/XQ_DateTime_Converter/";

declare function xf:Convert_SiebelDateTime_To_YYYY-MM-DD($SourceDate as xs:string ?, $ShortFormat as xs:boolean)
    as xs:string {
    if (fn:not(fn:exists($SourceDate))) then 
		string('')
    else if (fn:string-length($SourceDate) = 19 and fn:not($ShortFormat)) then
   		let $retValue := concat(substring($SourceDate, 7, 4), '-', substring($SourceDate, 1, 2), '-', substring($SourceDate, 4, 2), 'T', substring($SourceDate, 12))
		return $retValue
    else if (fn:string-length($SourceDate) > 0  and $ShortFormat) then
   		let $retValue := concat(substring($SourceDate, 7, 4), '-', substring($SourceDate, 1, 2), '-', substring($SourceDate, 4, 2))
		return $retValue
    else if (fn:string-length($SourceDate) > 0) then
   		let $retValue := concat(substring($SourceDate, 7, 4), '-', substring($SourceDate, 1, 2), '-', substring($SourceDate, 4, 2), 'T00:00:00')
		return $retValue
	else
		string('')
};

declare variable $SourceDate as xs:string external;
declare variable $ShortFormat as xs:boolean external;

xf:Convert_SiebelDateTime_To_YYYY-MM-DD($SourceDate, $ShortFormat)