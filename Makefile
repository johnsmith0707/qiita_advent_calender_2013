TASK=
PREFIX=Sample
BASE=$(PREFIX)Base
NAME=StackName
TEMPLATE=templates/template_base.json
TYPE=m1.small
PARAM_FILE=
PARAM=$(shell cat $(PARAM_FILE)) ParameterValue=$(TYPE),ParameterKey=InstanceType

all: hello

lists:
	aws cloudformation list-stacks

describes:
	aws cloudformation describe-stacks --stack-name $(NAME)

list_resources:
	aws cloudformation list-stack-resources --stack-name $(NAME)

get_template:
	aws cloudformation get-template --stack-name $(NAME)

create:
	aws cloudformation create-stack --stack-name $(NAME) --template-body file://$(TEMPLATE)

create_with_param:
	aws cloudformation create-stack --stack-name $(NAME) --template-body file://$(TEMPLATE) --parameters $(PARAM)

update:
	aws cloudformation update-stack --stack-name $(NAME) --template-body file://$(TEMPLATE)

update_with_param:
	aws cloudformation update-stack --stack-name $(NAME) --template-body file://$(TEMPLATE) --parameters $(PARAM)

rollback:
	aws cloudformation cancel-update-stack --stack-name $(NAME)

delete:
	aws cloudformation delete-stack --stack-name $(NAME)

create_base:
	$(MAKE) create NAME=$(BASE) TEMPLATE=$(TEMPLATE)

update_base:
	$(MAKE) update NAME=$(BASE) TEMPLATE=$(TEMPLATE)

create_app:
	$(MAKE) create_parameters BASE=$(BASE)
	$(MAKE) create_with_param NAME=$(PREFIX)App TEMPLATE=templates/template_app.json PARAM_FILE=var/Sample.txt
	$(MAKE) remove_tmp_file

update_app:
	$(MAKE) create_parameters BASE=$(BASE)
	$(MAKE) update_with_param NAME=$(PREFIX)App TEMPLATE=templates/template_app.json PARAM_FILE=var/Sample.txt
	$(MAKE) remove_tmp_file

create_parameters:
	$(MAKE) describes NAME=$(BASE) | sed -e "s/^\[//g" | sed -e "/make/d" | sed -e "/describe-stacks/d" > var/$(BASE).json
	php bin/run.php var/$(BASE).json

get_instance_id:
	$(MAKE) describes NAME=$(NAME) | sed -e "s/^\[//g" | sed -e "/make/d" | sed -e "/describe-stacks/d" > var/$(NAME).json
	cat var/$(NAME).json |grep OutputValue|awk '{print $$2}'|sed s/,//g|sed s/\"//g > var/ID.json

assoc_eip:
	$(MAKE) get_instance_id NAME=$(NAME)
	$(MAKE) create_with_param NAME=$(NAME)Assoc TEMPLATE=templates/template_assoc.json PARAM=$(shell echo "ParameterValue=$(shell cat var/ID.json),ParameterKey=ID")
	$(MAKE) remove_tmp_file

remove_tmp_file:
	rm var/*
