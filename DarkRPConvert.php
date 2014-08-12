<?php
include "globals.php";

ini_set('safe_mode', false);

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

function createWikiPage($name, $content)
{
	global $wiki;

	$page = $wiki->getPage($name);
	$page->setText($content);
}

$ignore = [
	"." => true,
	".." => true
];

/*
	Get hooks
*/

if (!($hookFolderHandle = opendir('pages/hooks'))) {echo "ERROR GETTING HOOK FOLDERS\n"; return;}
while (false !== ($hookRealm = readdir($hookFolderHandle))) {
	if (array_key_exists($hookRealm, $ignore)) { continue; }

	if (!($hookRealmFolder = opendir("pages/hooks/$hookRealm"))) {echo "ERROR GETTING REALMS\n"; return;}

	while (false !== ($hookFile = readdir($hookRealmFolder))) {
		if (array_key_exists($hookFile, $ignore)) { continue; }
		$nicename = substr("hooks/$hookRealm/$hookFile", 0, -4);
		$contents = file_get_contents("pages/hooks/$hookRealm/$hookFile");
		echo "$nicename\n";

		// Write to wiki
		createWikiPage($nicename, $contents);
	}
}

/*
	Get functions
*/
if (!($functionFolderHandle = opendir('pages/functions'))) {echo "ERROR GETTING FUNCTION FOLDERS\n"; return;}

while (false !== ($metatable = readdir($functionFolderHandle))) {
	if (array_key_exists($metatable, $ignore)) { continue; }

	if (!($functionMetatableFolder = opendir("pages/functions/$metatable"))) {echo "ERROR GETTING METATABLES\n"; return;}

	while (false !== ($functionRealm = readdir($functionMetatableFolder))) {
		if (array_key_exists($functionRealm, $ignore)) { continue; }

		if (!($fnRealmFolder = opendir("pages/functions/$metatable/$functionRealm"))) {echo "ERROR GETTING REALMS\n"; return;}

		while (false !== ($file = readdir($fnRealmFolder))) {
			if (array_key_exists($file, $ignore)) { continue; }
			$nicename = substr("functions/$metatable/$functionRealm/$file", 0, -4);
			echo "$nicename\n";
			$contents = file_get_contents("pages/functions/$metatable/$functionRealm/$file");

			// Write to wiki
			createWikiPage($nicename, $contents);
		}
	}
}
?>
