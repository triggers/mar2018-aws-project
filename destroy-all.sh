#!/bin/bash

source "$(dirname $(readlink -f "$0"))/bashsteps-defaults-jan2017-check-and-do.source" || exit

"$DATADIR/aws/phase1-destroy-aws-rds-vm.sh" ; $iferr_exit

"$DATADIR/aws/phase1-destroy-aws-web-vms.sh" ; $iferr_exit

"$DATADIR/aws/phase1-destroy-vpc.sh" ; $iferr_exit
