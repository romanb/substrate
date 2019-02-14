#!/bin/sh
#
# helper functions for gitlab scripts
#



github_label () {
	echo
	echo "# run github-api job for labelling it ${1}"
	curl -sS -X POST \
		-F "token=${CI_JOB_TOKEN}" \
		-F "ref=master" \
		-F "variables[LABEL]=${1}" \
		-F "variables[PRNO]=${CI_COMMIT_REF_NAME}" \
		${GITLAB_API}/projects/${GITHUB_API_PROJECT}/trigger/pipeline
}


# vim: noexpandtab
