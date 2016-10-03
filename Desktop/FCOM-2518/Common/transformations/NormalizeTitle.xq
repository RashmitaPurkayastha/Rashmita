xquery version "1.0" encoding "UTF-8";

declare namespace xf = "http://tempuri.org/Authentication/transformations/NormalizeTitle/";

(: 
Flight booking ALPI form has MR/MS, so thats the norm for now:
https://www.finnair.com/AYOnline/dyn/air/addElements
:)
declare function xf:NormalizeTitle($title as xs:string)
    as xs:string {

		let $ut as xs:string := upper-case(normalize-space(replace($title, '\.', '')))
		
		return
		if ($ut = ("MR", "M")) then
			"MR"
		else if ($ut = ("MS", "MRS", "MISS", "F")) then
			"MS"
		else  ""
};

declare variable $title as xs:string external;

xf:NormalizeTitle($title)