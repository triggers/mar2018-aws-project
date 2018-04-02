#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-defaults-jan2017-check-and-do.source" || exit

# TODO:(when are these needed?)  : ${TF_VAR_aws_access_key:?} ${TF_VAR_aws_secret_key:?}

# Note: Assuming phase1-setup-vpc-vms.sh already set up terraform

(
    $starting_group "Phase1: Launch AWS util VMs (only run if AWS_* keys are set)"
    [ "${AWS_ACCESS_KEY_ID:=}" == "" ] || [ "${AWS_SECRET_ACCESS_KEY:=}" == "" ]
    $skip_group_if_unnecessary

    (
	$starting_step "Run terraform apply for AWS Web1 and Web2 VMs and Step VM"
	a="$(find "$DATADIR/terraform" -name web1.log -mmin -${logcachetime:=120})"
	pat='*Apply*complete*Resources:* 0 added,* 0 changed,* 0 destroyed*'
	[[ "$a" == */web1.log ]] && [[ "$(tail -n 2 "$a")" == $pat ]]
	$skip_step_if_already_done; set -ex
	cd "$DATADIR/terraform"
	"$ORGCODEDIR/bin/terraform" apply -auto-approve=true -target=module.web1vm  -target=module.web2vm -target=module.stepvm | tee -a web1.log
    ) ; $iferr_exit

) ; $iferr_exit
