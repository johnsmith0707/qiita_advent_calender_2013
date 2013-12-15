<?php

class JsonDecode {
  private $file_path = NULL;

  function __construct($file_path) {
    $this->file_path = $file_path;
  }

  function main() {
    if ($this->file_check() === FALSE) {
      print "not exist file\n";
      exit;
    }
    if ($this->format_check() === FALSE) {
      print "invalid format\n";
      exit;
    }
    $this->decode('var');
  }

  function file_check() {
    if ($this->file_path === null || file_exists($this->file_path) === FALSE) {
      return FALSE;
    }
    return TRUE;
  }

  function format_check() {
    $contents = file_get_contents($this->file_path);
    $results  = json_decode($contents);
    if ($results === NULL) {
       return FALSE;
    }
    return TRUE;
  }

  function decode($output_dir) {
    $contents = file_get_contents($this->file_path);
    $json_object = json_decode($contents);
    $stacks = $json_object->{'Stacks'};

    foreach ($stacks[0]->{'Outputs'} as $output) {
      if (isset($output->{'Description'}) === FALSE || strpos($output->{'Description'}, "|") === FALSE) {
        continue;
      }
      $keys           = split("\|", $output->{'Description'});
      $values         = split("\|", $output->{'OutputValue'});
      $key_value_pairs = array();
      $index = 0;
      foreach ($keys as $key) {
        $key_value_pairs[$key]  = "ParameterValue=" . $values[$index]. ",";
        $key_value_pairs[$key]  .= "ParameterKey=" . $key;
        $index++;
      }
      $fp = fopen($output_dir . '/' . $output->{'OutputKey'} . ".txt", "w");
      foreach ($key_value_pairs as $pairs) {
        fwrite($fp, $pairs . " ");
      }
      fclose($fp);
    }
  }
}
