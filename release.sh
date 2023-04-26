#!/bin/bash
#
#  A simple bash script to make new release from official NodeJS Docker image.
#
#  release.sh
#
#  Copyright (c) 2023 Alien Green LLC.
#
#  This file is part of Alien Green Projects (AGP).
#
#  AGP is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  AGP is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with AGP. If not, see <http://www.gnu.org/licenses/>.
#

#GitHub repository name (organization/reponame)
GITHUB_ORG_NAME="aliengreen"
GITHUB_REP_NAME="node-alpine"

#Docker Hub repository name (organization/reponame)
DOCKERHUB_ORG_NAME="aliengreenllc"
DOCKERHUB_REP_NAME="node-alpine"

# Docker CLI name
DOCKER=docker


# Help screen
help() {
  echo "Docker image release script v0.1"
  echo "Usage: $0 <options>"
  echo "  options:"
  echo "     --search Show list of NodeJS official docker images by tag pattern in hub.docker.com. e.g.: 20-"
  echo "     --tag    Tag name of official Node docker image. e.g.: 20-alpine3.17"
  echo
  echo "Example 1: $0 --search 20-"
  echo "Example 2: $0 --tag 20-alpine3.17"
  exit 0;
}

docker_build() {

  curl -LO "https://github.com/${GITHUB_ORG_NAME}/${GITHUB_REP_NAME}/archive/refs/tags/${tag_name}.tar.gz"
  retVal=$?
  if [ $retVal -ne 0 ]; then
      exit $retVal
  fi

  tar xzvf "${tag_name}.tar.gz"
  retVal=$?
  if [ $retVal -ne 0 ]; then
      exit $retVal
  fi

  $DOCKER build -t "${DOCKERHUB_ORG_NAME}/${DOCKERHUB_REP_NAME}:${tag_name}" "${GITHUB_REP_NAME}-${tag_name}"
  retVal=$?
  if [ $retVal -ne 0 ]; then
      exit $retVal
  fi

  # Cleanup
  rm -rf "${GITHUB_REP_NAME}-${tag_name}"
  rm "${tag_name}.tar.gz"

  echo
  echo "Now you can run 'docker push ${DOCKERHUB_ORG_NAME}/${DOCKERHUB_REP_NAME}:${tag_name}' to end this mess."
  echo "To see all your tags, take a look here: https://hub.docker.com/r/${DOCKERHUB_ORG_NAME}/${DOCKERHUB_REP_NAME}/tags"
  echo  
}

search() {
  curl -s "https://hub.docker.com/v2/repositories/library/node/tags/?name=${ACTION_PARAM}" | grep -o '"name":"[^"]*' | grep -o '[^"]*$'
  retVal=$?
  if [ $retVal -ne 0 ]; then
      exit $retVal
  fi
}

tag() {
  echo "Release with tag name '${ACTION_PARAM}', Do you wish to continue ?"
  select yn in "Yes" "No"; do
      case $yn in
      Yes) break ;;
      No) exit ;;
      esac
  done
  
  tag_name="$ACTION_PARAM"
  curr_date=`date +%Y-%m-%d_%H%M`
  echo "Releasing: Node image '$tag_name', Refresh: $curr_date ";

  cp Dockerfile Dockerfile.untouched
  sed -i.bak "s/{{NODE_TAG}}/$tag_name/" Dockerfile
  sed -i.bak "s/{{DATE_TIME}}/$curr_date/" Dockerfile

  git commit -m "$tag_name" Dockerfile
  git tag -d "$tag_name" # This may fail if tag doesn't yet exist. That's OK
  git push origin :refs/tags/$tag_name && git tag -a $tag_name -m "$tag_name"
  git push origin --tags

  # Cleanup
  mv Dockerfile.untouched Dockerfile
  rm Dockerfile.bak

  git commit -m "cleanup after $tag_name release " Dockerfile && git push

  echo "Done!"

  echo "Whant to build docker image ?. The command '$DOCKER build -t "${DOCKERHUB_ORG_NAME}/${DOCKERHUB_REP_NAME}:${tag_name}" "${GITHUB_REP_NAME}-${tag_name}"' will be invoked."
  select yn in "Yes" "No"; do
      case $yn in
      Yes) docker_build; exit;;
      No) exit ;;
      esac
  done

}

main() {

  POSITIONAL=()
  while [[ $# -gt 0 ]]; do
      key="$1"

      case $key in
      --search)
          ACTION=search
          ACTION_PARAM="$2"
          shift
          shift
          ;;
      --tag)
          ACTION=tag
          ACTION_PARAM="$2"
          shift
          shift
          ;;
      *)
          POSITIONAL+=("$1")
          shift
          ;;
      esac
  done

  set -- "${POSITIONAL[@]}" # restore positional parameters

  # Here is positional parameters tail. Basically the last command line argument(s).
  TAIL=$1

  # Check dependency. If 'docker' is here.
  # Normally docker should be here but who knows :)
  if ! hash $DOCKER &>/dev/null; then
      echo "Docker is not installed on Host computer !, Please make sure 'docker' CLI is accessible from shell"
      exit 1
  fi

  if [ "$ACTION" == "tag" ]; then
      tag;
      exit 0
  fi

  if [ "$ACTION" == "search" ]; then
      search;
      exit 0
  fi

  help;
}

main "$@"
