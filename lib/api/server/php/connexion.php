<?php

  $host = ''; // bdd host
  $bdd = '';  // bdd name
  $user ='';  // bdd user
  $pass = ''; // bdd password
  $port = 3306;  // bdd port

  try {
    
    // mysql
    $db = new PDO("mysql:host=$host;dbname=$bdd;port=$port;", $user, $pass);
    
  } catch (\Throwable $th) {
    echo "error : " . $th->getMessage();
  }
?>