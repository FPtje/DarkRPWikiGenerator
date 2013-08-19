<?php
include "globals.php";

$api_url = "http://wiki.darkrp.com/api.php";
$username = "DarkRPBot";
$password = file("botpassword.txt")[0];

try
{
    $wiki = new Wikimate($api_url);
    if ($wiki->login($username,$password))
        echo "Success: user logged in.\n" ;
    else {
        $error = $wiki->getError();
        echo "<b>Wikimate error</b>: ".$error["login"]."\n";
    }
}
catch ( Exception $e )
{
    echo "<b>Wikimate error</b>: ".$e->getMessage();
    return;
}

$testpage = $wiki->getPage("BotTest");
$testpage->delete("it was just a test");

$testpage = $wiki->getPage("BotTest/test2");
$testpage->delete("it was just a test");
print_r($wiki->getError());
?>