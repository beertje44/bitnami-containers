#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/liblog.sh

info "** Starting phpScope **"
declare -a args=("-pyroscopeUrl" "https://alloy.beerstra.org/pyroscope" "-appName" "my-wordpress" "-concurrent" "8" "-phpspyBufferSize" "524288" "-tags" "environement=homeserver" "-phpspyRequestInfo" "qup")
exec "phpscope" "${args[@]}"
