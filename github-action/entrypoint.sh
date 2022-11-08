#!/bin/sh

set -e

echo "Authentication using $INPUT_CREDENTIALS_TYPE";

# Authenticate to the server
if [ $INPUT_CREDENTIALS_TYPE == "username" ];
then
  sh -c "jf config remove && jf c add basiq --interactive=false --url=$INPUT_URL --user=$INPUT_USER --password=$INPUT_PASSWORD"
elif [ $INPUT_CREDENTIALS_TYPE == "apikey" ];
then
  sh -c "jf config remove && jf c add basiq --interactive=false --url=$INPUT_URL --apikey=$INPUT_API_KEY"
elif [ $INPUT_CREDENTIALS_TYPE == "accesstoken" ];
then
  sh -c "jf config remove && jf c add basiq --interactive=false --url=$INPUT_URL --access-token=$INPUT_ACCESS_TOKEN"
fi
sh -c "jf config use basiq"

# Set working directory if specified
if [ $INPUT_WORKING_DIRECTORY != '.' ];
then
  cd $INPUT_WORKING_DIRECTORY
fi

buildNumber=$INPUT_BUILD_NUMBER

# Log command for info
echo "[Info] jf rt u \"$INPUT_BUILD_DIRECTORY/*.zip\" Go-challenge-local/github.com/basiqio/$INPUT_BUILD_NAME/$INPUT_BUILD_NUMBER/ --flat --build-number ${buildNumber/v/} --build-name $INPUT_BUILD_NAME"
#echo "[Info] jf go build --build-name=$INPUT_BUILD_NAME --build-number=${buildNumber/v/}"
echo
#echo "[Info] jf gp $INPUT_BUILD_NUMBER --build-name=$INPUT_BUILD_NAME --build-number=${buildNumber/v/}"

# Capture output
#build=$( sh -c "jf go build --build-name=$INPUT_BUILD_NAME --build-number=${buildNumber/v/}" )
#publish=$( sh -c "jf gp $INPUT_BUILD_NUMBER --build-name=$INPUT_BUILD_NAME --build-number=${buildNumber/v/}" )
publish=$(jf rt u "$INPUT_BUILD_DIRECTORY/*.zip" Go-challenge-local/github.com/basiqio/$INPUT_BUILD_NAME/$INPUT_BUILD_NUMBER/ --flat --build-number ${buildNumber/v/} --build-name $INPUT_BUILD_NAME)

# Preserve output for consumption by downstream actions
#echo "$build" > "${HOME}/${GITHUB_ACTION}.log"
echo "$publish" >> "${HOME}/${GITHUB_ACTION}.log"

# Write output to STDOUT
echo "$output"
