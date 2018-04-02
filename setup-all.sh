#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-defaults-jan2017-check-and-do.source" || exit

"$DATADIR/aws/phase1-setup-vpc.sh" ; $iferr_exit

"$DATADIR/aws/phase1-setup-aws-web-vms.sh" ; $iferr_exit

"$DATADIR/aws/phase1-setup-aws-rds-vm.sh" ; $iferr_exit

extractIP()
{
    vmname="$1"
    resource="$2"
    (
	$starting_step "Extract AWS IP address for $vmname"
	[ "$(eval echo "\${${vmname}_ip:=}")" != "" ]
	$skip_step_if_already_done ; set -ex
	cd "$DATADIR/aws/terraform"
	eipstate="$("$ORGCODEDIR/bin/terraform" state show $resource)"

	# Parse the IP out the line that looks like this: "public_ip            = 54.227.169.222"
	read equals_sign theip therest <<<"${eipstate##*public_ip}"
	[ "${theip//[^.]/}" = "..." ] || just_exit "Expecting IP to contain three dots"
	echo "${vmname}_ip='$theip'" >>"$DATADIR/datadir.conf"
    ) ; $iferr_exit
}

(
    $starting_group "Extract IP addresses from terraform"
    false
    $skip_group_if_unnecessary
    extractIP stepvm module.stepvm.aws_eip_association.step_eip_assoc
) ; $iferr_exit

source "$DATADIR/datadir.conf"
