<?php

const METHOD = "aes-256-cbc";
const KEY = "je-suis-une-cle-de-32-caracteres"; //  CLE : 32 CARACTERES OBLIGATOIREMENT
const VECTEUR = "et-moi-une-de-16"; // vecteur d'identification : 16 CARACTERES OBLIGATOIREMENT */

function encrypt($text) {
  return openssl_encrypt($text, METHOD, KEY, 0, VECTEUR);
}


function decrypt($text) {
  return openssl_decrypt($text, METHOD, KEY, 0, VECTEUR);
}



?>