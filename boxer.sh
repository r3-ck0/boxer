#!/bin/bash

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit

# ===================================================================================================
# Init
# ===================================================================================================

__boxerinitbox() {
    if [[ $# < 1 ]]; then
        echo "Please provide box-name: initbox <boxname>"
        return 
    fi

    echo "Initializing Box $1"
    cd ~/machines
    mkdir -p $1
    cd $1
    touch .box
    export CURRENTBOX=$1

    __boxerlog "Initialized box $1"
}

__boxerloadbox() {
    cd ~/machines/$1
    export CURRENTBOX=$1
    [ -f ~/machines/$1/targets.txt ] && source ~/machines/$1/targets.txt
}

# ===================================================================================================
# Add
# ===================================================================================================

__boxerlog() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    local str="[[$(date)]]: $@" 
    echo $str >> ~/machines/$CURRENTBOX/log.txt
    echo $str
}

__boxeraddtarget() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi


    if [[ $# -ge 1 ]]; then
    	if [[ ! -f ~/machines/$CURRENTBOX/targets.txt ]]; then
		local targetname=TARGET
		echo "export $targetname=$1" >> ~/machines/$CURRENTBOX/targets.txt
	else
		local targetname=TARGET$(wc -l ~/machines/$CURRENTBOX/targets.txt | awk '{print $1}')
        	echo "export $targetname=$1" >> ~/machines/$CURRENTBOX/targets.txt
	fi
    fi

    if [[ $# -ge 2 ]]; then
        echo "$1    $2" | sudo tee -a /etc/hosts
    fi

    source ~/machines/$CURRENTBOX/targets.txt
    __boxerlog "Added target: $targetname" 
}


__boxeraddcreds() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    echo $1 >> ~/machines/$CURRENTBOX/creds.txt 
    __boxerlog "Added creds: $1" 
}

__boxeraddhash() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    echo $1 >> ~/machines/$1/hashes.txt 
    __boxerlog "Added hash: $1" 
}

__boxeraddnote() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    __boxerlog "Updated notes." 

    if [[ $# < 1 ]]; then
        vim ~/machines/$CURRENTBOX/notes.txt
        return
    fi

    echo $@ >> ~/machines/$CURRENTBOX/notes.txt 
}

__boxerscreenshot() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    local dir=~/machines/$CURRENTBOX/screenshots

    if [[ ! -d $dir ]]; then
        mkdir $dir
    fi

    local nscreens=$(($(ls -al $dir | wc -l ) - 3))
    local screenpath=$dir/screenshot_$nscreens.png

    xfce4-screenshooter
    xclip -selection c -o -t image/png > $screenpath
    echo "$screenpath" | xclip -selection c

    __boxerlog "Saved at $dir/screenshot_$nscreens.png. (Path stored in clipboard)"
}

__boxeraddloot() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    if [[ -f $1 ]]; then
	    local latestfile=$(readlink -f $1)
    else
        if [[ -d $1 ]]; then
	    local downloadsdir=$(readlink -f $1)
        else
    	    local downloadsdir=~/Downloads
        fi
	local file=$(ls -alt $downloadsdir --ignore=. --ignore=.. | head -n 2 | tail -n 1 | awk '{print $9}')
        local latestfile=$downloadsdir/$file
    fi

    local dir=~/machines/$CURRENTBOX/loot

    if [[ ! -d $dir ]]; then
	mkdir $dir
    fi

    mv $latestfile $dir

    __boxerlog "Added $latestfile to loot."
}


# ===================================================================================================
# Show 
# ===================================================================================================

__boxershowlog() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    cat ~/machines/$CURRENTBOX/log.txt 
}

__boxershownotes() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    cat ~/machines/$CURRENTBOX/notes.txt 
}

__boxershowcreds() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    cat ~/machines/$CURRENTBOX/creds.txt 
}

__boxershowhashes() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    cat ~/machines/$CURRENTBOX/hashes.txt 
}

__boxershowtargets() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    echo "Targets   ========================"
    echo ""
    cat ~/machines/$CURRENTBOX/targets.txt
    echo ""
    echo "Host File ========================"
    cat /etc/hosts
}

__boxerrun() {
    if [[ ! $CURRENTBOX ]]; then
        echo "Please run initbox or loadbox first!"
        return
    fi

    a=$@

    local outpath=~/machines/$CURRENTBOX/${${a// /_}//\//}.txt
    __boxerlog "Running $a (See $outpath)"

    $@ | tee $outpath
}

boxer() {
	case $1 in
		run)
			__boxerrun "${@:2}"
			;;
		showtargets)
			__boxershowtargets "${@:2}"
			;;
		showhashes)
			__boxershowhashes "${@:2}"
			;;
		showcreds)
			__boxershowcreds "${@:2}"
			;;
		shownotes)
			__boxershownotes "${@:2}"
			;;
		showlog)
			__boxershowlog "${@:2}"
			;;
		initbox)
			__boxerinitbox "${@:2}"
			;;
		addtarget)
			__boxeraddtarget "${@:2}"
			;;
		addhash)
			__boxeraddhash "${@:2}"
			;;
		addcreds)
			__boxeraddcreds "${@:2}"
			;;
		addnote)
			__boxeraddnote "${@:2}"
			;;
		screenshot)
			__boxerscreenshot "${@:2}"
			;;
		addloot)
			__boxeraddloot "${@:2}"
			;;
		loadbox)
			__boxerloadbox "${@:2}"
			;;
		log)
			__boxerlog "${@:2}"
			;;
		*)
			echo "Not a boxer command: $1"
			;;

	esac
}
