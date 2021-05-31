# POM-versioning
A Bash script updating the version of a Maven project

## Description
This script accepts semantic versioning syntax as `MAJOR.MINOR.FIX[.HOTFIX][-SNAPSHOT]`. Acceptable examples are:
- `1.0.0`
- `1.0.0-SNAPSHOT`
- `1.2.3.4`
- `1.2.3.4-SNAPSHOT`

To calculate next version, the script asks what are the changes introduced. For example, given a current
version as `1.0.0.1-SNAPSHOT`:
- hotfix: new version will be `1.0.0.2`
- bugfix: new version will be `1.0.1`
- feature: new version will be `1.1.0`
- breaking change: new version will be `2.0.0`
- release: new version will be `1.0.0.1` (remove the SNAPSHOT tag)

Last check is if this version is under development (snapshot) or not. If yes, the "-SNAPSHOT" suffix is added
to the calculated version.

## Configuration
Update the POM path accordingly to your project.

## Usage
Simply run the script:
```bash
$ ./update-pom.sh

```