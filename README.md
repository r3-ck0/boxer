# boxer

This is a tool used to handle commonly repeated tasks during b2r boxes or possibly pentests.
It is designed to be completely used from the command line and should just do what it's supposed to do and then get out of the way.

Features zsh completion, so use it in conjunction with zsh.

boxer will create a directory on your filesystem under ~/machines. Here it will store all the information you provide it.
The following commands are currently implemented:


## Commands for adding stuff

 - boxer initbox \<boxsubpath\>  ------  i.e. boxer initbox htb/insane/magic_gardens
 - boxer loadbox \<boxsubpath\>
 - boxer run \<command\> \<with\> \<arguments\>  ---- Will run command and log outputs (Some stuff still buggy, i.e. Evil-WinRM)
 - boxer addcreds \<user:pass\>
 - boxer addhash \<hash\>
 - boxer addnote [Some note text] --- Note text optional - will run vim if not provided
 - boxer addtarget \<target-ip\> [hostname] ----- 
            Adds an export for TARGET=\<target-ip\>
            Increasing numbers for targets: TARGET, TARGET1, TARGET2, TARGET3, ....
            If hostname is provided, also adds target to /etc/hosts file
 - boxer addloot [path/to/loot][/file] --- 
            Moves loot to your treasure trove. If no path is provided, grabs the most recently updated file in ~/Downloads. 
            If directory is provided, grabs the most recently updated file in that directory.
            If file is provided, grabs that file.
 - boxer screenshot --- Will open screenshot tool. When screenshot is saved in clipboard, will store it away neatly in a useful place.

## Commands for showing stuff

  - boxer showcreds
  - boxer showhashes
  - boxer shownotes
  - boxer showlog
  - boxer showtargets


Utility commands are 

 - boxer log
