declare namespace co = "http://com.finnair";

declare function co:xmlToJson($data as element(), $jsonp as xs:string?) as xs:string {
	let $json := concat('{', replace(replace(replace( co:xmlToJsonInternal($data) , ',\}' , '}' ), ',\{' , '{'), ', \]', ']'), '}')
	return if (empty($jsonp))
		then $json
	else concat($jsonp, '( ', $json ,' )') 
};

declare function co:xmlToJsonInternal($data as element()) as xs:string {
if ($data/text()) then concat('"', name($data), '" : "', $data/text(), '"')
else if (count($data/*) = 0) then concat('"', name($data), '" : ""')
else if ($data/@array) then concat('"', name($data), '" : [', for $x in $data/* return concat(co:xmlToJsonInternal($x), ' , '), ']')
else if ($data/../@array) then concat('{', for $x in $data/* return concat(co:xmlToJsonInternal($x), ','), '}')
else concat('"', name($data), '" : {', for $x in $data/* return concat(co:xmlToJsonInternal($x), ','), '}')
};

declare variable $data as element() external;
declare variable $jsonp as xs:string external;


co:xmlToJson($data, $jsonp)