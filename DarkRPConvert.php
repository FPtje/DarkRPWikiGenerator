<?php
include 'globals.php';

$api_url = 'http://wiki.darkrp.com/api.php';
$username = 'DarkRPBot';
$password = file('botpassword.txt')[0];

try
{
    $wiki = new Wikimate($api_url);
    if ($wiki->login($username,$password))
        echo 'Success: user logged in.' ;
    else {
        $error = $wiki->getError();
        echo "<b>Wikimate error</b>: ".$error['login'];
    }
}
catch ( Exception $e )
{
    echo "<b>Wikimate error</b>: ".$e->getMessage();
}

?>