<?php

  include 'connexion.php';
  include 'crypto.php';

  $table_user = 'flu_crud_user';

  $success = 0;
  $msg = "login error";
  $result = [];

  try {
    
    // note : on peut passer email ou login
    if(isset($_POST['login']) && !empty($_POST['login']) && isset($_POST['pwd']) && !empty($_POST['pwd'])){

        $email = decrypt($_POST['login']);
        $pwd = sha1(decrypt($_POST['pwd']));

        $req = $db->prepare("SELECT * FROM $table_user WHERE login = ? AND password = ? ");
        $req->execute(array($email, $pwd));
        $user_exist = $req->rowCount();

        if($user_exist == 1){
          $result = $req->fetch(); // retourn result sous form de array
          $success = 1;
          $msg = "login success";
        }
    } else{
      $success = 0;
      $msg = "error empty data";
      $result = [];
    } 
  } catch (\Throwable $th) {
    $success = 0;
    $msg = "Error : " . $th->getMessage();
    $result = [];
  }

  echo encrypt(json_encode([
    "data"=>[
      $msg,
      $success,
      $result
    ]
  ]));

?>
