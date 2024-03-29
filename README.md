# POM-versioning
A Bash script updating the version of a Maven project accordingly the [git-flow](https://nvie.com/posts/a-successful-git-branching-model/) branching model.

## Description
This script accepts [semantic versioning](https://semver.org/) syntax as `MAJOR.MINOR.FIX[.HOTFIX][-SNAPSHOT]`. Acceptable examples are:
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
Update the `POM_PATH` variable specifiyng your project POM path.

## Usage
Simply run the script:
```bash
$ ./update-pom.sh

```

## Useful links
- git-flow branching model: https://nvie.com/posts/a-successful-git-branching-model/
- semantic versioning: https://semver.org/