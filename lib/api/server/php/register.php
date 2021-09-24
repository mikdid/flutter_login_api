<?php

  include 'connexion.php';
  include 'crypto.php';

  $table_user = 'flu_crud_user';

  $success = 0;
  $msg = "Error register user";

  try {

    if(isset($_POST['login']) && !empty($_POST['login']) && isset($_POST['pwd']) && !empty($_POST['pwd'])){

        $login = decrypt($_POST['login']);
        $pwd = sha1(decrypt($_POST['pwd']));

        $email = null;
        if(isset($_POST['email']) && !empty($_POST['email'])) {
          $email = decrypt($_POST['email']);
        }

        $tel = null;
        if(isset($_POST['tel']) && !empty($_POST['tel'])) {
          $tel = decrypt($_POST['emtelail']);
        }

        $req = $db->prepare("SELECT login FROM $table_user WHERE login = ?");
        $req->execute(array($login));
        $login_exist = $req->rowCount();
        if($login_exist > 0){
          $success = 0;
          $msg = "login already exist";
        }

        $req = $db->prepare("SELECT email FROM $table_user WHERE email = ?");
        $req->execute(array($email));
        $email_exist = $req->rowCount();
        if($email_exist > 0){
          $success = 0;
          $msg = "email already exist";
        }

        // login + email inexistant => on save
        if($email_exist == 0 && $login_exist == 0){
          $req = $db->prepare("INSERT INTO $table_user VALUES(null, ?, ?, ?, ?)");
          $req->execute(array($login,$email,$tel,$pwd));
    
          if($req == true){
            $success = 1;
            $msg = "Success register user";
          } 
        }
    }
    else{
      $success = 0;
      $msg = "error empty data";
    }
  } catch (\Throwable $th) {
    $success = 0;
    $msg = "Error : " . $th->getMessage();
  }

  echo encrypt(json_encode([
    "data"=>[
      $msg,
      $success
    ]
  ]));

?>