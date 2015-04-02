Cody Cocoon
=====

Update Project
-----

##### Add new xml files with git
If you are adding text files, it might be easiest to use git right from the beginning.  Instructions for images are included just below this.  For text files / xml, you'll need an ssh key installed on your local computer [instructions here](https://help.github.com/articles/generating-ssh-keys/) as well as a copy of the git repository.  If you already have it, then skip this step, otherwise, navigate to a folder where you would like the repository and enter the following:
```
git clone git@github.com:CDRH/cody.git
```
Now you can change directories into cody and pick up with the rest of the instructions.

You'll want to make sure that you have the latest version of the repository.
```
git pull
```
Now you can add your xml files.  Check that git sees them:
```
git status

On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	newfile.xml

nothing added to commit but untracked files present (use "git add" to track)

```

In the above situation, there is one file that git sees but is not going to commit.  You need to tell it specifically that you want to commit it and then go ahead and make the commit.  Then push it!

```
git add newfile.xml
# could add more files if wanted: git add xml/*
git commit -m "Adds a new file to cody"
git push origin master
```

You can verify that your files were added by looking at them in github:  [Cody Project](https://github.com/CDRH/cody).  Now you'll need to pull the files from the server where the project is hosted if you want them to be there also!

Use ssh to log onto the server (you will need an account to do this)
```
ssh server_username@server.unl.edu
cd /path/to/cody/project
```
Then pull the latest changes down:
```
git pull origin master
```

##### Add new files using FTP / SCP

If you're using an FTP client (like Cyberduck), connect to the server where the Cody project is hosted and use your client to add the new images / xml files.

If you want, you can use scp instead (works with directories given `-r` flag)
```
scp location/of/your/file.xml server_username@server.unl.edu:/project/path/cody/file.xml
```

Use ssh to log onto the server (you will need an account to do this)
```
ssh server_username@server.unl.edu
```

Navigate to the project's directory.  It is never a bad idea to make sure that you are synced up with git before you start making commits, so go ahead and pull from the master branch of the repository.

```
git pull origin master
```
Check that the permissions on the files that you just added look somewhat reasonable (path will be different depending on whether you added figures or xml).  Cyberduck seems to occasionally upload things with crazy permissions so it seems like a good idea to check here.
```
ls -al xml/

-rw-rwxr--  1 jduss users    4307 Dec  2 14:17 wfc.vid00001.xml
-rw-rwxr--  1 jduss users    4372 Dec  2 14:17 wfc.vid00002.xml
-rw-rwxr--  1 jduss users    4166 Dec  2 14:17 wfc.vid00003.xml
```
The permissions (on the far left) should look something like `rwxrwxr--` or some variation and have `users` as the group.  Something like the following would be VERY BAD.
```
-rw-r--r--  1 jduss jduss    4307 Dec  2 14:17 wfc.vid00001.xml
-rw-r--r--  1 jduss jduss    4372 Dec  2 14:17 wfc.vid00002.xml
-rw-r--r--  1 jduss jduss    4166 Dec  2 14:17 wfc.vid00003.xml
```
If the group is not users or if there are an awful lot of hyphens in the permissions then it is likely that other users are going to be unable to commit, modify, replace, or delete those files.  A developer can give you a hand with changing the privileges (and possibly figure out why Cyberduck or whatever you used uploaded them with weird permissions).

Assuming that all is well, let's move onto committing the files.
```
git status

On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	newfile.xml

nothing added to commit but untracked files present (use "git add" to track)
```
In the above situation, there is one file that git sees but is not going to commit.  You need to tell it specifically that you want to commit it and then go ahead and make the commit.  Then push it!
```
git add newfile.xml
# could add more files if wanted: git add xml/*
git commit -m "Adds a new file to cody"
git push origin master
```
You can verify that your files were added by looking at them in github:  [Cody Project](https://github.com/CDRH/cody).


Install Cody with Cocoon (First Time)
-----
This file will help you 'install' the cody project.
Note that you will (most likely) be unable to install this interface to Windows.
You will need a UNIX-like environment (anything that understands and respects
the 'ln' UNIX command).
Note: It was not deemed worth it to get this working with Windoze.

This interface is run using Cocoon. If modifying anything,
you will likely need to read up about how Cocoon works.

You will need to create/modify the following file(s):
 - config.xsl

Some of these files are soft (symbolically) linked to the proper location. You
will need to edit each file in the **config** directory.

For each file, there is a templated version (typically with some instructions on
what needs to be edited in the file). These are (respectively):
 - config.tmpl.xsl

Directions:
Copy the above templated file to its proper untemplated filename, then edit
each file to fit your configuration. Everything should work at this point.

Images:
If you need to see the images for work, you will also need to copy the images
from their archived location (probably the U drive, i.e. 
libstaff1a.unl.edu/commetextd).
Copy images to:
 - figures/250/*
 - figures/800/*
