#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-defaults-jan2017-check-and-do.source" || exit

# TODO:(when are these needed?)  : ${TF_VAR_aws_access_key:?} ${TF_VAR_aws_secret_key:?}

(
    $starting_group "Download/Install stuff needed locally"
    false
    $skip_group_if_unnecessary

    (
	$starting_step "Install terraform"
	[ -f "$ORGCODEDIR/bin/terraform" ]
	$skip_step_if_already_done; set -e
	mkdir -p "$ORGCODEDIR/bin/"
	cd "$ORGCODEDIR/bin/"
	curl -o terraform_0.11.0_linux_amd64.zip -O https://releases.hashicorp.com/terraform/0.11.0/terraform_0.11.0_linux_amd64.zip
	unzip terraform_0.11.0_linux_amd64.zip
	# rm -f terraform_0.11.0_linux_amd64.zip
    ) ; $iferr_exit

) ; $iferr_exit

(
    $starting_group "Phase1: Instantiate main VPC components (only run if AWS_* keys are set)"
    [ "${AWS_ACCESS_KEY_ID:=}" == "" ] || [ "${AWS_SECRET_ACCESS_KEY:=}" == "" ]
    $skip_group_if_unnecessary

    (
	$starting_step "Run terraform init"
	[ -d "$DATADIR/terraform/.terraform" ]
	$skip_step_if_already_done; set -e
	cd "$DATADIR/terraform"
	"$ORGCODEDIR/bin/terraform" init
    ) ; $iferr_exit

    (
	$starting_step "Run terraform apply for the VPC"
	a="$(find "$DATADIR/terraform" -name t.log -mmin -${logcachetime:=120})"
	pat='*Apply*complete*Resources:* 0 added,* 0 changed,* 0 destroyed*'
	[[ "$a" == */t.log ]] && [[ "$(tail -n 2 "$a")" == $pat ]]
	$skip_step_if_already_done; set -ex
	cd "$DATADIR/terraform"
	"$ORGCODEDIR/bin/terraform" apply -auto-approve=true -target=module.thevpc | tee -a t.log
    ) ; $iferr_exit

    (
	$starting_step "Extract private key"
	[ -f "$DATADIR/thekey.pem" ]
	$skip_step_if_already_done ; set -ex
	cd "$DATADIR/terraform"
	keystate="$("$ORGCODEDIR/bin/terraform" state show tls_private_key.dev_sshkey)"
	begpat="-----BEGIN RSA PRIVATE KEY-----"
	endpat="-----END RSA PRIVATE KEY-----"
	[[ "$keystate" == *$begpat* ]]
	tmp1="${keystate#*$begpat}"
	[[ "$tmp1" == *$endpat* ]]
	tmp2="${tmp1%$endpat*}"
	{
	    echo -n "$begpat"
	    echo -n "$tmp2"
	    echo "$endpat"
	} >"$DATADIR/thekey.pem"
	chmod 600 "$DATADIR/thekey.pem"
    ) ; $iferr_exit

) ; $iferr_exit
