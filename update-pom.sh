#!/bin/bash
# Only for unix like OS!
# Useful script for upgrade project version, including modules.

# HOW TO
# simply run:
#  ./update-pom.sh
#
# This script accepts semantic versioning syntax as MAJOR.MINOR.FIX[.HOTFIX][-SNAPSHOT]. Acceptable examples are:
# - 1.0.0
# - 1.0.0-SNAPSHOT
# - 1.2.3.4
# - 1.2.3.4-SNAPSHOT
#
# To calculate next version, the script asks what are the changes introduced. For example, given a current
# version as 1.0.0.1-SNAPSHOT:
# - hotfix: new version will be 1.0.0.2
# - bugfix: new version will be 1.0.1
# - feature: new version will be 1.1.0
# - breaking change: new version will be 2.0.0
# - release: new version will be 1.0.0.1 (remove the SNAPSHOT tag)
#
# Last check is if this version is under development (snapshot) or not. If yes, the "-SNAPSHOT" suffix is added
# to the calculated version.


SNAPSHOT_VERSION="-SNAPSHOT"

CURRENT_VERSION_WITH_SNAPSHOT=$(mvn -f ./pom.xml help:evaluate -Dexpression=project.version -q -DforceStdout)
CURRENT_VERSION=$CURRENT_VERSION_WITH_SNAPSHOT

if [[ $CURRENT_VERSION =~ $SNAPSHOT_VERSION ]]; then
  CURRENT_VERSION=${CURRENT_VERSION%%"$SNAPSHOT_VERSION"}
fi

IFS='.' read -r -a version_array <<< "$CURRENT_VERSION"

MAJOR_VERSION="${version_array[0]}"
MINOR_VERSION="${version_array[1]}"
FIX_VERSION="${version_array[2]}"


PS3="New version contains (select one option): "
options=("hotfix" "bugfix" "feature" "breaking change" "release")
select opt in "${options[@]}"
do
    case $opt in
        "hotfix")
            HOTFIX_VERSION="${version_array[3]:-0}"
            new_version=$MAJOR_VERSION.$MINOR_VERSION.$FIX_VERSION.$((HOTFIX_VERSION + 1))
            break
            ;;
        "bugfix")
            new_version=$MAJOR_VERSION.$MINOR_VERSION.$((FIX_VERSION + 1))
            break
            ;;
        "feature")
            new_version=$MAJOR_VERSION.$((MINOR_VERSION + 1)).0
            break
            ;;
        "breaking change")
            new_version=$((MAJOR_VERSION + 1)).0.0
            break
            ;;
        "release")
            IS_RELEASE=true
            new_version=$CURRENT_VERSION
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

if [[ -z ${IS_RELEASE:+x} ]] 
then
    while [[ "${answer}" != "Y" && "${answer}" != "N" && "${answer}" != "y" && "${answer}" != "n" ]]
    do
	   echo "Is this a snapshot version? (Y/N)"
	   read answer
    done
fi

 if [ "${answer}" == "Y" ] || [ "${answer}" == "y" ]
 then
 	new_version="$new_version$SNAPSHOT_VERSION"
 fi

 while [[ "${confirmation}" != "Y" && "${confirmation}" != "N" && "${confirmation}" != "y" && "${confirmation}" != "n" ]]
 do
    echo "Current version is $CURRENT_VERSION_WITH_SNAPSHOT"
 	echo "New version will be $new_version. Confirm? (Y/N)"
 	read confirmation
 done

 if [ "${confirmation}" == "Y" ] || [ "${confirmation}" == "y" ]
 then
 	mvn -f ../pom.xml versions:set -DnewVersion=$new_version -DgenerateBackupPoms=false
 else
 	echo "No action will be performed. Exit"
 fi