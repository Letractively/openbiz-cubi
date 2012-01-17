<?php

/* 
 * Test web service API
 */

include_once 'httpClient.php';

$url="http://localhost/ob3/cubi/ws.php/package/PackageListService";

echo "\n#######################";
echo "\n### Test xml format ###";
echo "\n#######################\n";
$query = array(	"username=admin","api_key=f79fe4a8bffcb044490a720a3295a842","secret=",
                "service=TicketService","method=search","format=xml");
                //"arg_searchrule=".urlencode("[Id]=1"),"arg_limit=10");
testSvc($url, $query);
return;

echo "\n\n#######################";
echo "\n### Test xml format ###";
echo "\n#######################\n";
$argsJson = json_encode(array("searchrule"=>"[Id]=1","limit"=>10));
$query = array(	"username=admin","api_key=f79fe4a8bffcb044490a720a3295a842","secret=",
                "service=TicketService","method=search","format=json");
                //"argsJson=$argsJson");
echo testSvc($url, $query);


function testSvc($url, $query=null, $cookie=null)
{
	$httpClient = new HttpClient('POST');
	$httpClient->setCookie($cookie);
	foreach ($query as $q)
		$httpClient->addQuery($q);
    
    $headerList = array();
	$out = $httpClient->fetchContents($url, $headerList, false);
	return $out;
}

?>