xquery version "1.0" encoding "UTF-8";

declare namespace xf = "http://tempuri.org/Common/transformations/CorrelationId/";
declare namespace fin = "http://finnair.com/customxpath";
declare variable $timePattern as xs:string := ".*_[0-9]{4}_[0-9]{2}:[0-9]{2}:[0-9]{2}:[0-9]{3}";

(:
@param $id primary value
@param $default fallback value incase primary is empty

- if selected id allready contains timestamp, its used as is.
- if both empty, a randomized alphanumeric id is generated
:)
declare function xf:CorrelationId($id as xs:string?, $default as xs:string?)
    	as xs:string {
    let $value as xs:string := if (string-length($id) > 0) then
    	$id
    else if (string-length($default) > 0) then
    	$default
    else fin:random-string(xs:int(9))
    
    return
    if (matches($value, $timePattern)) then
		$value
	else
	    let $currentTime:= fn:current-dateTime()
	    let $prefix:=fn:upper-case(fn:normalize-space($value))
	    return concat($prefix,"_",xf:toDdMMyy($currentTime))
};

declare function xf:toDdMMyy($dateTime as xs:dateTime)
as xs:string {
     let $dt := fn:adjust-dateTime-to-timezone($dateTime, ())
     return fn-bea:dateTime-to-string-with-format("ddMM_HH:mm:ss:SSS", $dt)
};

declare variable $id external;
declare variable $default external;

(:xpathstub:)
xf:CorrelationId($id, $default)