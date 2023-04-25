#! /usr/bin/env bash

usage() {
  echo
  echo "usage: $0 <tag>"
  echo "  tag - Tag name of official Node docker image. e.g.: '20-alpine3.17'"
  echo "Example usage:"
  echo "$0 20-alpine3.17"
  exit 0;
}


main() {
  while getopts ":h:" opt; do
    case $opt in
      h)
        usage;
        ;;
    esac
  done

  shift "$((OPTIND-1))"

  if [ $# -ne 1 ]; then
    usage;
  fi


  tag_name="$1"
  # SEMVER_REGEX="^v([0-9]+)\.([0-9]+)\.([0-9]+)$"
  # if [[ ! $node_version =~ $SEMVER_REGEX ]]; then
  #   usage;
  # fi

  # if [[ $node_version =~ $SEMVER_REGEX ]]; then
  #   node_full_number="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
  #   node_major_number="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
  # fi

  curr_date=`date +%Y-%m-%d_%H%M`
  echo "Releasing: Node image '$tag_name', Refresh: $curr_date ";

  cp Dockerfile Dockerfile.untouched
  sed -i.bak "s/{{NODE_TAG}}/$tag_name/" Dockerfile
  sed -i.bak "s/{{DATE_TIME}}/$curr_date/" Dockerfile

  # Execute twice: for just node and node with runit

  # COUNTER=0
  # while [  $COUNTER -lt 2 ]; do

  # if [[ $COUNTER -eq 1 ]]; then

  # Node with runit
  # sed -i.bak "s/#!RUNIT//g" Dockerfile
  # runit_suffix="-runit"
  # node_full_number="$node_full_number$runit_suffix"
  # node_major_number="$node_major_number$runit_suffix"

  # fi

  echo git commit -m "$tag_name" Dockerfile
  echo git tag -d "$tag_name" # This may fail if tag doesn't yet exist. That's OK
  echo git push origin :refs/tags/$tag_name && git tag -a $tag_name -m "$tag_name"
  # git tag -d "$node_major_number" # This may fail if such major ver doesn't yet exist. That's OK
  # git push origin :refs/tags/$node_major_number && git tag -a $node_major_number -m "$node_major_number"
  # git push origin --tags

    # let COUNTER=COUNTER+1
  done

  # --- END WHILE LOOP

  # Cleanup
  mv Dockerfile.untouched Dockerfile
  rm Dockerfile.bak

  git commit -m "cleanup after $tag_name release " Dockerfile && git push

  echo "Done!"
}

main "$@"
