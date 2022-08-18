#! /bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/secrets/default_credentials.json"
export SERVICE_ACCOUNT_CREDENTIALS="${HOME}/secrets/service_account.json"

dirs=()

IFS=$'\n' read -r -d '' -a dirs < <( find . -name 'package.json' -not -path '*/node_modules/*' -exec dirname '{}' \; | sort -u )

exit_code=0

for dir in "${dirs[@]}"; do
  pushd "${dir}" || exit
  npm install
  npm run test --if-present
  status=$?
  if [ $status -ne 0 ]; then
    exit_code=$status
  fi
  popd || exit
done

if [ $exit_code -ne 0 ]; then
  echo "Tests failed."
fi

exit $exit_code