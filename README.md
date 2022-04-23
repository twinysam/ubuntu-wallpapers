# How to add wallpapers for a new Ubuntu release

## Before starting

It is good practice to file a bug in Launchpad to track the addition of the wallpapers for a new Ubuntu release, against the ubuntu-wallpapers source package.
This bug will be referenced in the changelog entry as well as in the VCS revision history.
See e.g. https://bugs.launchpad.net/ubuntu/+source/ubuntu-wallpapers/+bug/1921139.

## Sources

Wallpapers typically come from two sources:
  * the Canonical design team will provide the official wallpaper (and a greyscale variant)
  * a selection of community-provided pictures (see https://wiki.ubuntu.com/UbuntuFreeCultureShowcase for details)

## Scripts and pre-requisites

There are scripts in the `scripts/` directory that partially automate the task of adding wallpapers for a new Ubuntu release. Some of these scripts assume they are being run on the target release (they call `lsb_release`), so make sure you fulfill that requirement, or you will need to hand-edit generated files (alternatively export `$LSB_OS_RELEASE` to point to a file that overwrites your host system's `/usr/lib/os-release` with the values corresponding to the new release that wallpapers are being generated for − that file is installed by the `base-files` package).

Some of these scripts assume that the community-provided wallpapers are named following this convention:

    SUBJECT_by_AUTHOR.EXTENSION

where SUBJECT and AUTHOR may be made up several words, either dash (-) or underscore (_) separated, and EXTENSION may either be "jpg" or "png".

## Disclaimer

At the time of writing, this is still largely a manual (and as such, error-prone) process. A good goal would be to automate it as much as possible.

## Step-by-step instructions

 0) `export CODENAME=$(lsb_release -cs)`

1a) get the new official wallpaper and replace the existing `warty-final-ubuntu.png` with it
1b) get the new greyscale official wallpaper and copy it at the root of this branch
1c) get the community wallpapers for the upcoming Ubuntu release (codenamed `$CODENAME`) and unpack them in a staging subfolder (e.g. named `staging/`) inside this branch

 2) create `$CODENAME-wallpapers.xml.in` (which references only the community wallpapers):

        cd staging
        ../scripts/generate-xml.sh > ../$CODENAME-wallpapers.xml.in
        cd ..

 3) now copy the greyscale official wallpaper to the `staging/` directory

 4) create `contest/$CODENAME.xml` (which references both the community wallpapers and the greyscale official one):

        cd staging
        ../scripts/update-background.py > ../contest/$CODENAME.xml
        cd ..

 5) create `debian/ubuntu-wallpapers-$CODENAME.install` listing all relevant files:

        INSTALL_FILE=debian/ubuntu-wallpapers-$CODENAME.install
        for i in $(ls staging); do echo usr/share/backgrounds/$i >> $INSTALL_FILE; done
        echo usr/share/gnome-background-properties/$CODENAME-wallpapers.xml >> $INSTALL_FILE
        echo usr/share/backgrounds/contest/$CODENAME.xml >> $INSTALL_FILE

 6) move all the files from the staging folder to the root of the branch, and delete the empty folder:

        mv staging/* ./
        rmdir staging

 7) update `po/POTFILES.in`:

        echo $CODENAME-wallpapers.xml.in | sort -m po/POTFILES.in - > po/POTFILES.in.new
        mv po/POTFILES.in.new po/POTFILES.in

 8) update the translation template (`po/ubuntu-wallpapers.pot`):

        cd po
        intltool-update -p -g ubuntu-wallpapers
        cd ..

 9) update `debian/ubuntu-wallpapers.links` to change the target of the ubuntu-default-greyscale-wallpaper.png symlink

10) update `debian/control`:
    * add a new package at the end of the file named `ubuntu-wallpapers-$CODENAME`
    * make `ubuntu-wallpapers` depend on `ubuntu-wallpapers-$CODENAME` (and remove the dependency on the previous version)
    * add the previous version to the `Suggests` section

11) update `debian/copyright` to add all the new wallpapers (community and greyscale official background) and their authors under the corresponding `License` block

12) update the `AUTHORS` file, adding a new section at the top listing all the community wallpapers and their authors for the new release

13) add a new `debian/changelog` entry referencing the Launchpad bug number by running `dch -v $(lsb_release -sr).1-0ubuntu1`

Once this is done, don't forget to add new files to the VCS and commit using the `debian/changelog` entry and linking to the Launchpad bug (use `bzr commit --fixes="lp:NNNNNN"`).
