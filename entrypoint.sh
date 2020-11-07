#!/bin/bash

set -e

REPOSITORY_NAME=$(basename "${GITHUB_REPOSITORY}")

[[ ! -z ${INPUT_PASSWORD} ]] && SONAR_PASSWORD="${INPUT_PASSWORD}" || SONAR_PASSWORD=""
[[ -z ${INPUT_PROJECTKEY} ]] && SONAR_PROJECTKEY="${REPOSITORY_NAME}" || SONAR_PROJECTKEY="${INPUT_PROJECTKEY}"
[[ -z ${INPUT_PROJECTNAME} ]] && SONAR_PROJECTNAME="${REPOSITORY_NAME}" || SONAR_PROJECTNAME="${INPUT_PROJECTNAME}"
[[ -z ${INPUT_PROJECTVERSION} ]] && SONAR_PROJECTVERSION="" || SONAR_PROJECTVERSION="${INPUT_PROJECTVERSION}"
[[ -z ${INPUT_PROJECTBRANCH} ]] && SONAR_PROJECTBRANCH="" || SONAR_PROJECTBRANCH="${INPUT_PROJECTBRANCH}"

if [[ "$SONAR_PROJECTBRANCH" =~ ^refs\/heads\/.* ]]; then
    SONAR_PROJECTBRANCH2=${SONAR_PROJECTBRANCH#"refs/heads/"}

    if [[ -z ${SONAR_PROJECTBRANCH2} ]]; then
      SONAR_PROJECTBRANCH2=${SONAR_PROJECTBRANCH}
    fi

    SONAR_PROJECTBRANCH=${SONAR_PROJECTBRANCH2}
fi

echo "Input Action: ${GITHUB_EVENT_NAME}"

if [[ ${GITHUB_EVENT_NAME} == "push" ]]; then
  echo "::debug::Push"
  sonar-scanner \
  -Dsonar.host.url=${INPUT_HOST} \
	-Dsonar.projectKey=${SONAR_PROJECTKEY} \
	-Dsonar.projectName=${SONAR_PROJECTNAME} \
	-Dsonar.projectVersion=${SONAR_PROJECTVERSION} \
	-Dsonar.branch.name=${SONAR_PROJECTBRANCH} \
	-Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR} \
	-Dsonar.login=${INPUT_LOGIN} \
	-Dsonar.password=${INPUT_PASSWORD} \
	-Dsonar.sources=. \
	-Dsonar.sourceEncoding=UTF-8
	exit_val=$?
	echo "::debug::Exit val: ${exit_val}"
	exit $exit_val

elif [[ ${GITHUB_EVENT_NAME} == "pull_request" ]]; then
  echo "::debug::Pull Request"
  sonar-scanner \
  -Dsonar.host.url=${INPUT_HOST} \
	-Dsonar.projectKey=${SONAR_PROJECTKEY} \
	-Dsonar.projectName=${SONAR_PROJECTNAME} \
	-Dsonar.projectVersion=${SONAR_PROJECTVERSION} \
	-Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR} \
	-Dsonar.login=${INPUT_LOGIN} \
	-Dsonar.password=${INPUT_PASSWORD} \
	-Dsonar.sources=. \
	-Dsonar.sourceEncoding=UTF-8 \
	-Dsonar.pullrequest.provider=github \
	-Dsonar.pullrequest.github.endpoint=https://api.github.com/ \
	-Dsonar.pullrequest.github.repository=${INPUT_REPOSLUG} \
	-Dsonar.pullrequest.key=${INPUT_PRKEY} \
	-Dsonar.pullrequest.branch=${INPUT_FEATUREBRANCH} \
	-Dsonar.pullrequest.base=${INPUT_BASEBRANCH}

	exit_val=$?
	echo "::debug::Exit val: ${exit_val}"
	exit $exit_val
fi