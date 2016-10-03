declare namespace co = "http://www.finnair.com";


declare function co:convertCustomerName($name as xs:string?) as xs:string {
	let $upper := if (empty($name)) then '' else upper-case(fn-bea:trim($name))
	
	let $upperArray := for $ch in string-to-codepoints($upper) return codepoints-to-string($ch)
	
	return concat(
		for $c in $upperArray
			return if ($c >= 'A' and $c <= 'Z') then $c
			else if ($c = ('Ä','Å','À','Á','Ã','Æ')) then 'A'
			else if ($c = 'Ç') then 'C'
			else if ($c = ('Ð','ð')) then 'D'
			else if ($c = ('È','É','Ê','Ë')) then 'E'
			else if ($c = ('Ì','Í','Î','Ï')) then 'I'
			else if ($c = 'Ñ') then 'N'
			else if ($c = ('Ö','Ò','Ó','Ô','Õ','Ø','Œ')) then 'O'
			else if ($c = ('Š','ß','Š')) then 'S'
			else if ($c = ('Ü','Ù','Ú','Û')) then 'U'
			else if ($c = ('Ý','Ÿ','Ÿ')) then 'Y'
			else if ($c = 'Ž') then 'Z'
			else if ($c = (' ', '-', "'")) then ' '
			else ''
	)
};


declare variable $name as xs:string external;

co:convertCustomerName($name)