# CloudFormation
***

## Help  

     $ make

## stackリスト取得  

     $ make lists

## stack情報取得  

     $ make describes NAME=stack_name

## stackのリソース情報取得  

     $ make list_resources NAME=stack_name

## stackのtemplate取得  

     $ make get_template NAME=stack_name

## stack作成  

     $ make create NAME=stack_name TEMPLATE_FILE_PATH=templates/xxxxx.json

## stack更新  

     $ make update NAME=stack_name TEMPLATE_FILE_PATH=templates/xxxx.json

## stack削除  

     $ make delete NAME=stack_name

## サンプルベースの作成/更新

     $ make create_base
     $ make update_base

## サンプルのインスタンス作成/更新

     $ make create_app
     $ make update_app

## インスタンスID取得

     $ make get_instance_id NAME=stack_name
