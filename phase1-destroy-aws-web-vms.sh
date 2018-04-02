#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-defaults-jan2017-check-and-do.source" || exit

# TODO:(when are these needed?)  : ${TF_VAR_aws_access_key:?} ${TF_VAR_aws_secret_key:?}

(
    $starting_group "Phase1: Destroy AWS util VMs (only run if AWS_* keys are set)"
    [ "${AWS_ACCESS_KEY_ID:=}" == "" ] || [ "${AWS_SECRET_ACCESS_KEY:=}" == "" ]
    $skip_group_if_unnecessary

    (
	$starting_step "Run terraform destroy for AWS Web1 VM"
	a="$(find "$DATADIR/terraform" -name web1.log -mmin -${logcachetime:=120})"
	pat='*Destroy*complete*Resources:* 0 destroyed*'
	[[ "$a" == */web1.log ]] && [[ "$(tail -n 2 "$a")" == $pat ]]
	$skip_step_if_already_done; set -ex
	cd "$DATADIR/terraform"
	"$ORGCODEDIR/bin/terraform" destroy -force -target=module.web1vm | tee -a web1.log
    ) ; $iferr_exit

) ; $iferr_exit
