#!/bin/bash

set -eo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# hardcode GITHUB_OWNER to work around https://github.com/integrations/terraform-provider-github/issues/823
docker pull ghcr.io/axetrading/terraform-test-image:latest
docker run \
    -v ~/.aws:/root/.aws \
    -e AWS_PROFILE -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN \
    -e GITHUB_TOKEN -e GITHUB_OWNER=axetrading -e NO_DESTROY \
    --rm -i -w "$dir" -v "$dir:$dir" \
    ghcr.io/axetrading/terraform-test-image:latest test/check.py