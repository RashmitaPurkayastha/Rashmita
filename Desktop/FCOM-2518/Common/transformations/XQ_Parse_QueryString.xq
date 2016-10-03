xquery version "1.0" encoding "Cp1252";
(:: pragma  type="xs:anyType" ::)

declare namespace xf = "http://tempuri.org/partnerServices/LifeTime/transformations/XQ_Parse_QueryString/";

declare function xf:XQ_Parse_QueryString($qs as xs:string)
    as element(*) {
        <params>
{
for $c in fn:tokenize($qs, "&amp;")
where fn:string-length($c) != 0
return
let $arr := fn:tokenize($c, "=")
let $paramValue := fn:replace($arr[2], "_n_", "&amp;")
return
<param name="{$arr[1]}" value="{$paramValue}"/>
}
</params>

};

declare variable $qs as xs:string external;

xf:XQ_Parse_QueryString($qs)