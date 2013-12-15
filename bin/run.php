<?php
require_once __DIR__ . '/../lib/json_decode.php';

$json_decoder = new JsonDecode($argv[1]);
$json_decoder->main();