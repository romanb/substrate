#!/bin/sh
#
# check if there is a merge conflict with this pull request only about wasm 
# binary blobs. if so trigger a rebuild of it and push it on the feature 
# branch if owned by paritytech
#



# used for github-label
. ./scripts/gitlab/common.sh

set -x

curl -sS -H "Accept: application/vnd.github.v3+json" \
  "${GITHUB_API}/repos/paritytech/substrate/pulls/${CI_COMMIT_REF_NAME}"


exit 1

TEST_RUNTIME="./core/test-runtime/wasm/target/wasm32-unknown-unknown/release/substrate_test_runtime.compact.wasm"
NODE_RUNTIME="./node/runtime/wasm/target/wasm32-unknown-unknown/release/node_runtime.compact.wasm"

cat <<-EOT

# wasm rebuild automation

wasm source files have changed.

a job will be triggered in gitlab github-api project that will rebuild the
wasm runtime for this pr and will then push it to the feature branch of this
repository.


EOT


curl -sS -X POST -o trigger.json \
	-F "token=${CI_JOB_TOKEN}" \
	-F "ref=master" \
	-F "variables[REBUILD_WASM]=true" \
	-F "variables[PRNO]=${CI_COMMIT_REF_NAME}" \
	${GITLAB_API}/projects/${GITHUB_API_PROJECT}/trigger/pipeline

echo "see $(jq -r .web_url trigger.json)"
echo

rm -fv trigger.json

# vim: noexpandtab
