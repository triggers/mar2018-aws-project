#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-defaults-jan2017-check-and-do.source" || exit

# TODO:(when are these needed?)  : ${TF_VAR_aws_access_key:?} ${TF_VAR_aws_secret_key:?}

# Note: Assuming phase1-setup-vpc-vms.sh already set up terraform

(
    $starting_group "Phase1: Launch the RDS (only run if AWS_* keys are set) AND (only is \$DORDS is not empty)"
    [ "${AWS_ACCESS_KEY_ID:=}" == "" ] || [ "${AWS_SECRET_ACCESS_KEY:=}" == "" ]|| [ "${DORDS:=}" == "" ]
    $skip_group_if_unnecessary

    (
	$starting_step "Run terraform apply for the RDS"
	a="$(find "$DATADIR/terraform" -name rds.log -mmin -${logcachetime:=120})"
	pat='*Apply*complete*Resources:* 0 added,* 0 changed,* 0 destroyed*'
	[[ "$a" == */rds.log ]] && [[ "$(tail -n 2 "$a")" == $pat ]]
	$skip_step_if_already_done; set -ex
	cd "$DATADIR/terraform"
	"$ORGCODEDIR/bin/terraform" apply -auto-approve=true -target=module.rdsvm | tee -a rds.log
    ) ; $iferr_exit

) ; $iferr_exit
