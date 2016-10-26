#!/bin/bash

# This script stages the pull request to a publicly-visible location, so it can
# be reviewed easily. The pull request in staged to a bucket in Google Cloud,
# and automatically deleted after a certain period of time.

#Update 10

set -e

if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters."
  exit 1
fi

PR_SHA=$1
PR_NUMBER=$2
GSUTIL_KEY_ID=$3
GSUTIL_PRIVATE_KEY=$4
GITHUB_KEY=$5

GCS_PATH="gs://apache-beam-website-pull-requests/${PR_NUMBER}/"
SITE_SOURCE="content/*"
TARGET_URL="http://apache-beam-website-pull-requests.storage.googleapis.com/${PR_NUMBER}/index.html"

function install_gsutil() {
  echo "Installing gsutil."
  sudo apt-get install gcc python-dev python-setuptools libffi-dev
  sudo pip install gsutil
}

function set_up_gsutil_credentials() {
  echo "Setting up gsutil credentials."

  KEY_FILE_PATH=$(mktemp)
  KEY_FILE_CONTENT="{
    \"type\": \"service_account\",
    \"project_id\": \"apache-beam-testing\",
    \"private_key_id\": \"${GSUTIL_KEY_ID}\",
    \"private_key\": \"${GSUTIL_PRIVATE_KEY}\",
    \"client_email\": \"travis-ci-access-to-storage@apache-beam-testing.iam.gserviceaccount.com\",
    \"client_id\": \"114243603829008836805\",
    \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",
    \"token_uri\": \"https://accounts.google.com/o/oauth2/token\",
    \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",
    \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/travis-ci-access-to-storage%40apache-beam-testing.iam.gserviceaccount.com\"
}"

  BOTO_TEXT_CONTENT="
[Credentials]
gs_service_key_file = ${KEY_FILE_PATH}

[Boto]
https_validate_certificates = True

[GSUtil]
content_language = en
default_api_version = 2
default_project_id = apache-beam-testing

[OAuth2]"

  echo -e "${KEY_FILE_CONTENT}" >${KEY_FILE_PATH}
  echo -e "${BOTO_TEXT_CONTENT}" > ~/.boto
}

function remove_existing_site() {
  echo "Removing existing site."
  gsutil -m rm -r -f ${GCS_PATH} || true
}

function upload_site() {
  echo "Uploading new site."
  gsutil -m cp -R ${SITE_SOURCE} ${GCS_PATH}
}

function remove_credential {
  echo "Removing the credential."
  rm ${KEY_FILE_PATH} || true
  rm ~/.boto || true
}

function notify_pull_request {
  echo "Commenting on GitHub pull request."

  MESSAGE="Travis built the site at commit id ${PR_SHA} with Jekyll and \
staged it [here](${TARGET_URL}). Happy reviewing.\n\nNote that any \
previous site has been deleted. This staged site will be automatically \
deleted after its TTL expires. Push any commit to the pull request branch \
to get it staged again."
  GITHUB_REQUEST="{ \"body\": \"${MESSAGE}\" }"

  curl -i -d "${GITHUB_REQUEST}" -u beam-testing:${GITHUB_KEY} \
      https://api.github.com/repos/apache/incubator-beam-site/pulls/${PR_NUMBER}/comments
}

export

install_gsutil
set_up_gsutil_credentials
remove_existing_site
upload_site
remove_credential
notify_pull_request

echo "Done staging the pull request!"
