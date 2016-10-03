xquery version "1.0" encoding "Cp1252";
(:: pragma  type="xs:anyType" ::)

declare namespace xf = "http://com.finnair/Common/transformations/DVMFunction";
declare namespace dvm="http://xmlns.oracle.com/dvm";

declare function xf:DVMFunction($dvmTable as element(*), $sourceColumnName as xs:string,
    $sourceValue as xs:string, $targetColumnName as xs:string, $defaultValue as xs:string)
    as xs:string {
       let $idxSource as xs:integer := for $n at $i in $dvmTable/dvm:columns/dvm:column where ($n/@name = $sourceColumnName) return $i
       let $idxTarget as xs:integer := for $n at $i in $dvmTable/dvm:columns/dvm:column where ($n/@name = $targetColumnName) return $i
       
       let $res1 := $dvmTable/dvm:rows/dvm:row/dvm:cell[position() = $idxSource 
       		and text()=$sourceValue]/../dvm:cell[position() = $idxTarget]/text()
       return
       if (fn:string-length($res1) > 0) then
        string($res1)
       else
         string($defaultValue)
};




declare variable $dvmTable as element(*) external;
declare variable $sourceColumnName as xs:string external;
declare variable $sourceValue as xs:string external;
declare variable $targetColumnName as xs:string external;
declare variable $defaultValue as xs:string external;

xf:DVMFunction($dvmTable, $sourceColumnName, $sourceValue, $targetColumnName, $defaultValue)