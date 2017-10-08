# bash command-line completion for VBoxManage command
#
# Author: Roman 'gryf' Dobosz <gryf73@gmail.com>
# URL: https://bitbucket.org/gryf/vboxmanage-bash-completion
# URL: https://github.com/gryf/vboxmanage-bash-completion
# License: 3-clause BSD-style license (see LICENSE file)
# Version: 5.1.26

_VBoxManage() {
    local cur prev opts cmd subcommand tmp items name index result

    # Check the COMP_WORDS looking for name of the vm. If name contain space or
    # is enclosed in quotes, glue name together in variable name. Variable index
    # will hold the last index of COMP_WORDS array which contain the end of the
    # name.
    _find_item_name() {
        local idx=$1
        name=""

        while true
        do
            name="${name}${COMP_WORDS[$idx]}"
            [[ ${COMP_WORDS[$idx]} = *'"' ]] && break

            if [[ ${COMP_WORDS[$idx]} = '"'* || ${COMP_WORDS[$idx]} = *'\ ' ]]
            then
                idx=$((++idx))
                continue
            fi
            break
        done
        index=$idx
    }

    _get_excluded_items() {
        local i

        result=""
        for i in $@; do
            [[ " ${COMP_WORDS[@]} " == *" $i "* ]] && continue
            result="$result $i"
        done
    }

    # Generate registered hard disk files.
    # NOTE: This function may introduce some quirks, if there is a space or
    # other characters which usually are treated as IFS - like space. Pipe
    # character used in disk filename will ruin this completions.
    _hdd_comp() {
        local hdds
        local item

        hdds=$(VBoxManage list hdds | \
            grep -A 1 'normal (base)' | \
            grep "Location:" | \
            sed 's/Location:\s\+//' | \
            sed 's/\s/\\ /g' | \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra hdds <<< "$hdds"

        for item in "${hdds[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _floppy_comp() {
        local floppies
        local item

        floppies=$(VBoxManage list floppies | \
            grep "Location:" | \
            sed 's/Location:\s\+//' | \
            sed 's/\s/\\ /g' | \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra floppies <<< "$floppies"

        for item in "${floppies[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _dvds_comp() {
        local dvds
        local item

        dvds=$(VBoxManage list dvds | \
            grep "Location:" | \
            sed 's/Location:\s\+//' | \
            sed 's/\s/\\ /g' | \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra dvds <<< "$dvds"

        for item in "${dvds[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    # Complete registered VM names.
    # Issues are the same as in above function.
    _vms_comp() {
        local command=$1
        local exclude_running=false
        local vms
        local running_vms
        local item


        compopt -o filenames
        if [[ $# == 2 ]]
        then
            exclude_running=true
            running_vms=$(VBoxManage list runningvms | \
                awk -F ' {' '{ print $1 }' | \
                tr '\n' '|' | \
                sed 's/|$//' | \
                sed 's/"//g')
            IFS='|' read -ra running_vms <<< "$running_vms"
        fi

        vms=$(VBoxManage list $command | \
            awk -F ' {' '{ print $1 }' | \
            tr '\n' '|' | \
            sed 's/|$//' | \
            sed 's/"//g')
        IFS='|' read -ra vms <<< "$vms"
        for item in "${vms[@]}"
        do
            if $exclude_running
            then
                _is_in_array "$item" "${running_vms[@]}"
                [[ $? == 0 ]] && continue
            fi

            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _vms_state_comp() {
        local vms
        local item

        compopt -o filenames

        vms=$(VBoxManage list vms -l | \
            egrep '^Name|State' | \
            egrep -B1 'State:\s+saved' | \
            grep Name |sed 's/Name:\s\+//' | \
            tr '\n' '|' | \
            sed 's/|$//' | \
            sed 's/"//g')
        IFS='|' read -ra vms <<< "$vms"
        for item in "${vms[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _group_comp() {
        local list
        local item

        list=$(VBoxManage list groups | \
            tr '\n' '|' | \
            sed 's/|$//' | \
            sed 's/\s/\\ /g'| \
            sed 's/"//g')
        IFS='|' read -ra list <<< "$list"

        for item in "${list[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _os_comp() {
        local list
        local item

        list=$(VBoxManage list ostypes | \
            egrep ^ID: | \
            sed 's/ID:\s\+//' | \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra list <<< "$list"

        for item in "${list[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _dhcp_comp() {
        local list
        local item

        list=$(VBoxManage list dhcpservers | \
            grep NetworkName: | \
            sed 's/NetworkName:\s\+//' | \
            sed 's/\s/\\ /g'| \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra list <<< "$list"

        for item in "${list[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _hostonlyif_comp() {
        local list
        local item

        list=$(VBoxManage list hostonlyifs | \
            egrep ^Name: | \
            sed 's/Name:\s\+//' | \
            sed 's/\s/\\ /g'| \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra list <<< "$list"

        for item in "${list[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _bandwidthctl_comp() {
        local rules
        local item

        _find_item_name 2
        rules=$(VBoxManage bandwidthctl "${name//\\/}" \
            list --machinereadable | \
            awk -F ',' '{print $1}' | \
            awk -F '=' '{print $2}' | \
            tr '\n' '|' | \
            sed 's/|$//' | \
            sed 's/\s/\\ /g')
        IFS='|' read -ra rules <<< "$rules"

        for item in "${rules[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _snapshot_comp() {
        local snap
        local item

        _find_item_name 2
        snap=$(VBoxManage snapshot "${name//\\/}" \
            list | \
            grep UUID |
            awk -F ': ' '{print $2}' | \
            sed 's/ (.*//' | \
            tr '\n' '|' | \
            sed 's/|$//' | \
            sed 's/\s/\\ /g')
        IFS='|' read -ra snap <<< "$snap"

        for item in "${snap[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _webcam_comp() {
        local devs
        local item

        _find_item_name 2
        devs=$(VBoxManage controlvm "${name//\\/}" \
            webcam list | \
            tr '\n' ' ' | \
            sed 's/|s$//')
        read -ra devs <<< "$devs"

        for item in "${devs[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _webcam_avail_comp() {
        local devs
        local item

        _find_item_name 2
        devs=$(VBoxManage list webcams | \
            grep dev | \
            tr '\n' ' ' | \
            sed 's/|s$//')
        read -ra devs <<< "$devs"

        for item in "${devs[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _list_comp() {
        local list
        list=$(VBoxManage list | \
            grep '|' | \
            sed 's/\[.*\]//g'| \
            sed 's/VBoxManage list//' | \
            tr "\\n" " " | \
            sed 's/$/\n/' | \
            sed 's/\s\+//g' | \
            sed 's/|/ /g')
        COMPREPLY=( $(compgen -W "$list" -- ${cur}) )
    }

    _sharedfolder_comp() {
        local vm="$@"
        local folders
        local item

        folders=$(VBoxManage showvminfo ${vm} --machinereadable | \
            grep SharedFolderName | \
            awk -F= '{print $2}' | \
            sed 's/\s/\\ /g'| \
            tr '\n' '|' | \
            sed 's/|$//' | \
            sed 's/"//g')
        IFS='|' read -ra folders <<< "$folders"

        for item in "${folders[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _natnet_comp() {
        local list
        local item

        list=$(VBoxManage list natnets | \
            grep NetworkName: | \
            sed 's/NetworkName:\s\+//' | \
            sed 's/\s/\\ /g'| \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra list <<< "$list"

        for item in "${list[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _bridgedif_comp() {
        local list
        local item

        list=$(VBoxManage list bridgedifs | \
            egrep ^Name: | \
            sed 's/Name:\s\+//' | \
            sed 's/\s/\\ /g'| \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra list <<< "$list"

        for item in "${list[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _intnet_comp() {
        local list
        local item

        list=$(VBoxManage list intnets| \
            egrep ^Name: | \
            sed 's/Name:\s\+//' | \
            sed 's/\s/\\ /g'| \
            tr '\n' '|' | \
            sed 's/|$//')
        IFS='|' read -ra list <<< "$list"

        for item in "${list[@]}"
        do
            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
        done
    }

    _is_in_array() {
        local element
        for element in "${@:2}"
        do
            [[ "$element" == "$1" ]] && return 0
        done
        return 1
    }

    # search for the word before current one, and try to match apropriate item
    # to be displayed
    # for example:
    # foo bar disk baz
    # will search for word disk.
    _get_medium () {
        case "${COMP_WORDS[COMP_CWORD-2]}" in
            disk)
                _hdd_comp
                ;;
            dvd)
                _dvds_comp
                ;;
            floppy)
                _floppy_comp
                ;;
        esac
    }

    COMP_WORDBREAKS=${COMP_WORDBREAKS//|/}  # remove pipe from comp word breaks
    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    if [[ COMP_CWORD -ge 2 ]]; then
        cmd="${COMP_WORDS[1]}"
        if [[ $cmd == "-q" ]]; then
                cmd="${COMP_WORDS[2]}"
        fi
    fi

    # all possible commands for the VBoxManage
    opts=$(VBoxManage -q help | \
        egrep -o "^\s\s[a-z]+ " | \
        grep -v VBoxManage | \
        awk '{print $1}'| \
        sort | \
        uniq)

    # add debugvm command manually, since it's described differently in
    # vboxmanage help
    opts="${opts} debugvm"

    if [[ ${cur} == "-q" || ${COMP_CWORD} -eq 1 ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi

    case "${cmd}" in
        adoptstate)
            _find_item_name 2
            COMPREPLY=()
            [[ -z "${name}" ]] &&
                _vms_state_comp
            ;;

        bandwidthctl)
            local items=(add set remove list)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                _find_item_name 2
                subcommand=${COMP_WORDS[$((index+1))]}
                if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                    case "${subcommand}" in
                        add)
                            items=(--type --limit)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        set)
                            if [[ ${prev} == "set" ]]; then
                                _bandwidthctl_comp
                            else
                                [[ " ${COMP_WORDS[@]} " != *" --limit "* ]] && \
                                    COMPREPLY=( $(compgen -W "--limit" -- \
                                    ${cur}) )
                            fi
                            ;;
                        remove)
                            if [[ ${prev} == "remove" ]]; then
                                _bandwidthctl_comp
                            fi
                            ;;
                        list)
                            if [[ ${prev} == "list" ]]; then
                                COMPREPLY=( $(compgen -W "--machinereadable" \
                                    -- ${cur}) )
                            fi
                            ;;
                    esac
                    case "${prev}" in
                        --type)
                            COMPREPLY=( $(compgen -W "disk network" -- ${cur}) )
                            ;;
                    esac
                else
                    [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                        COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
                fi
            fi
            ;;

        checkmediumpwd)
            if [[ ${prev} == ${cmd} ]]; then
                _hdd_comp
                _floppy_comp
                _dvds_comp
            fi
            ;;

        clonemedium)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "disk dvd floppy" -- ${cur}) )
            else
                case "${prev}" in
                    disk)
                        _hdd_comp
                        ;;
                    dvd)
                        _dvds_comp
                        ;;
                    floppy)
                        _floppy_comp
                        ;;
                    *)
                        _find_item_name 2
                        items=(--format --variant --existing)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )

                        case "${prev}" in
                            --format)
                                COMPREPLY=( $(compgen -W "VDI VMDK VHD RAW" --\
                                    ${cur}) )
                                ;;
                            --variant)
                                COMPREPLY=( $(compgen -W "Standard Fixed Split2G
                                Stream ESX" -- ${cur}) )
                                ;;
                        esac
                    ;;
                esac
            fi
            ;;

        clonevm)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                _find_item_name 2
                items=(--snapshot --mode --options --name --groups --basefolder
                --uuid --register)
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                case "${prev}" in
                    --snapshot)
                        COMPREPLY=()
                        _snapshot_comp
                        ;;
                    --mode)
                        COMPREPLY=( $(compgen -W "machine machineandchildren
                        all" -- ${cur}) )
                        ;;
                    --options)
                        COMPREPLY=( $(compgen -W "link keepallmacs keepnatmacs
                        keepdisknames" -- ${cur}) )
                        ;;
                    --groups)
                        COMPREPLY=()
                        _group_comp
                        ;;
                    --basefolder)
                        COMPREPLY=( $(compgen -o dirnames -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        closemedium)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "disk dvd floppy" -- ${cur}) )
                _hdd_comp
                _dvds_comp
                _floppy_comp
            else
                case "${prev}" in
                    disk)
                        _hdd_comp
                        ;;
                    dvd)
                        _dvds_comp
                        ;;
                    floppy)
                        _floppy_comp
                        ;;
                    *)
                        items=(--delete)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        controlvm)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp runningvms
            else
                local items=(acpipowerbutton acpisleepbutton clipboard
                cpuexecutioncap draganddrop guestmemoryballoon
                keyboardputscancode natpf1 nic1 nicpromisc1 nicproperty1
                nictrace1 nictracefile1 natpf2 nic2 nicpromisc2 nicproperty2
                nictrace2 nictracefile2 natpf3 nic3 nicpromisc3 nicproperty3
                nictrace3 nictracefile3 natpf4 nic4 nicpromisc4 nicproperty4
                nictrace4 nictracefile4 natpf5 nic5 nicpromisc5 nicproperty5
                nictrace5 nictracefile5 natpf6 nic6 nicpromisc6 nicproperty6
                nictrace6 nictracefile6 natpf7 nic7 nicpromisc7 nicproperty7
                nictrace7 nictracefile7 natpf8 nic8 nicpromisc8 nicproperty8
                nictrace8 pause plugcpu poweroff reset resume savestate
                screenshotpng setcredentials setlinkstate1 setlinkstate2
                setlinkstate3 setlinkstate4 setlinkstate5 setlinkstate6
                setlinkstate7 setlinkstate8 setvideomodehint teleport unplugcpu
                usbattach usbdetach vrde vrdeport vrdeproperty
                vrdevideochannelquality webcam videocap videocapscreens
                videocapfile videocapres videocaprate videocapfps
                videocapmaxtime videocapmaxsize addencpassword removeencpassword
                removeallencpasswords)

                _find_item_name 2
                subcommand=${COMP_WORDS[$((index+1))]}

                if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                    case "${subcommand}" in
                        nictracefile[1-8])
                            [[ ${prev} == "nictracefile"* ]] && \
                                COMPREPLY=( $(compgen -f -- ${cur}) )
                            ;;
                        nictrace[1-8])
                            [[ ${prev} == "nictrace"* ]] && \
                                COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
                            ;;
                        nicpromisc[1-8])
                            [[ ${prev} == "nicpromisc"* ]] && \
                                COMPREPLY=( $(compgen -W "deny allow-vms
                                allow-all" -- ${cur}) )
                            ;;
                        nic[1-8])
                            [[ ${prev} == "nic"* ]] && \
                                COMPREPLY=( $(compgen -W "null nat bridged intnet
                                hostonly generic natnetwork" -- ${cur}) )
                            ;;
                        natpf[1-8])
                            [[ ${prev} == "natpf"* ]] && \
                                COMPREPLY=( $(compgen -W "delete tcp
                                udp" -- ${cur}) )
                            ;;
                        setlinkstate[1-8])
                            [[ ${prev} == "setlinkstate"* ]] && \
                                COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
                            ;;
                        clipboard)
                            [[ ${prev} == "clipboard" ]] && \
                                COMPREPLY=( $(compgen -W "disabled hosttoguest
                                guesttohost bidirectional" -- ${cur}) )
                            ;;
                        draganddrop)
                            [[ ${prev} == "draganddrop" ]] && \
                                COMPREPLY=( $(compgen -W "disabled
                                hosttoguest" -- ${cur}) )
                            ;;
                        vrde|videocap)
                            [[ ${prev} == "vrde" ||
                            ${prev} == "videocap" ]] && \
                                COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
                            ;;
                        videocapscreens)
                            [[ ${prev} == "videocapscreens" ]] && \
                                COMPREPLY=( $(compgen -W "all none" -- ${cur}) )
                            ;;
                        setcredentials)
                            tmp=(--passwordfile --allowlocallogon)
                            _get_excluded_items "${tmp[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        teleport)
                            tmp=(--host --port --maxdowntime --passwordfile
                            --password)
                            _get_excluded_items "${tmp[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        webcam)
                            [[ ${prev} == "webcam" ]] && \
                                COMPREPLY=( $(compgen -W "attach detach
                                list" -- ${cur}) )
                            [[ ${prev} == "detach" ]] && \
                                _webcam_comp
                            [[ ${prev} == "attach" ]] && \
                                _webcam_avail_comp
                            ;;
                        usbattach)
                            tmp=(--capturefile)
                            _get_excluded_items "${tmp[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        --removeonsuspend)
                            COMPREPLY=( $(compgen -W "yes no" -- ${cur}) )
                            ;;
                        addencpassword)
                            tmp=(--host --port --maxdowntime --passwordfile
                            --password)
                            _get_excluded_items "${tmp[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                    esac
                else
                    [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                            COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
                fi
            fi
            ;;

        convertfromraw)
            local items=(--format --variant --uuid)

            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            else
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                case "${prev}" in
                    --format)
                        COMPREPLY=( $(compgen -W "VDI VMDK VHD" -- ${cur}) )
                        ;;
                    --variant)
                        COMPREPLY=( $(compgen -W "Standard Fixed Split2G Stream
                        ESX" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        createmedium)
            items=(--filename --size --sizebyte --diffparent --format --variant)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "disk dvd floppy" -- ${cur}) )
            else
                case "${prev}" in
                    disk|dvd|floppy)
                        COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
                        ;;
                    *)
                        [[ " ${COMP_WORDS[@]} " == *" --size "* ||
                            " ${COMP_WORDS[@]} " == *" --sizebyte "* ]] &&
                            items=(--filename --diffparent --format --variant)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )

                        case "${prev}" in
                            --filename)
                                COMPREPLY=( $(compgen -- ${cur}) )
                                ;;
                            --diffparent)
                                COMPREPLY=()
                                _hdd_comp
                                ;;
                            --format)
                                COMPREPLY=( $(compgen -W "VDI VMDK VHD" --\
                                    ${cur}) )
                                ;;
                            --variant)
                                COMPREPLY=( $(compgen -W "Standard Fixed Split2G
                                Stream ESX" -- ${cur}) )
                                ;;
                        esac
                        ;;
                esac
            fi
            ;;

        createvm)
            items=(--name --groups --ostype --register --basefolder --uuid)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            else
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )

                case "${prev}" in
                    --groups)
                        COMPREPLY=()
                        _group_comp
                        ;;
                    --ostype)
                        COMPREPLY=()
                        _os_comp
                        ;;
                    --basefolder)
                        COMPREPLY=( $(compgen -o dirnames -- ${cur}) )
                        ;;
                    --variant)
                        COMPREPLY=( $(compgen -W "Standard Fixed Split2G Stream
                        ESX" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        "debugvm")
            items=(dumpguestcore info injectnmi log logdest logflags osdetect
            osinfo osdmesg getregisters setregisters show statistics stack)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp runningvms
            else
                _find_item_name 2
                subcommand=${COMP_WORDS[$((index+1))]}
                if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                    case "${subcommand}" in
                        dumpguestcore)
                            _get_excluded_items "--filename"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        log|logdest|logflags)
                            items=(--release --debug)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        getregisters|setregisters|stack)
                            _get_excluded_items "--cpu"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        show)
                            items=(--human-readable --sh-export --sh-eval
                            --cmd-set)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        statistics)
                            items=(--reset --pattern --descriptions)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        osdmesg)
                            items=()
                            [[ " ${COMP_WORDS[@]} " != *" --lines "* &&
                                " ${COMP_WORDS[@]} " != *" -n "* ]] &&
                                items+=(--lines -n)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                    esac
                    COMPREPLY+=( $(compgen -W "$result" -- ${cur}) )
                else
                    [[ "${prev}" == "--filename" ]] && \
                        COMPREPLY=( $(compgen -- ${cur}) )
                    [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                        COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
                fi
            fi
            ;;

        dhcpserver)
            items=(add modify remove)
            subcommand=${COMP_WORDS[2]}
            if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                case "${subcommand}" in
                    add|modify)
                        items=(--ip --netmask --lowerip --upperip)

                        [[ " ${COMP_WORDS[@]} " != *" --ifname"* &&
                            " ${COMP_WORDS[@]} " != *" --netname"* ]] &&
                            items+=(--netname --ifname)

                        [[ " ${COMP_WORDS[@]} " != *" --enable"* &&
                            " ${COMP_WORDS[@]} " != *" --disable"* ]] &&
                            items+=(--enable --disable)

                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    remove)
                        case "${prev}" in
                            --netname)
                                COMPREPLY=()
                                _dhcp_comp
                                ;;
                            --ifname)
                                COMPREPLY=()
                                _hostonlyif_comp
                                ;;
                        esac

                        if [[ " ${COMP_WORDS[@]} " != *" --ifname"* &&
                            " ${COMP_WORDS[@]} " != *" --netname"* ]]; then
                            items=(--netname --ifname)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        fi
                        ;;
                esac
            else
                [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                    COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            fi
            ;;

        discardstate)
            _find_item_name 2
            COMPREPLY=()
            [[ -z "${name}" ]] &&
                _vms_state_comp
            ;;

        encryptmedium)
            if [[ ${prev} == ${cmd} ]]; then
                _hdd_comp
                _floppy_comp
                _dvds_comp
            else
                COMPREPLY=( $(compgen -W "--newpassword --oldpassword --cipher
                --newpasswordid" -- ${cur}) )
            fi
            ;;

        "export")
            items=( --manifest --iso --options --vsys)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                [[ " ${COMP_WORDS[@]} " != *" -o "* &&
                    " ${COMP_WORDS[@]} " != *" --output "* ]] &&
                    items+=(-o --output)
                [[ " ${COMP_WORDS[@]} " != *" --legacy09 "* &&
                    " ${COMP_WORDS[@]} " != *" --ovf09 "* &&
                    " ${COMP_WORDS[@]} " != *" --ovf10 "* &&
                    " ${COMP_WORDS[@]} " != *" --ovf20 "* ]] &&
                    items+=(--legacy09 --ovf09 --ovf10 --ovf20)
                [[ " ${COMP_WORDS[@]} " == *" --vsys "* ]] &&
                    items+=(--product --producturl --vendor --vendorurl
                    --version --description --eula --eulafile)
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )

                case "${prev}" in
                    --options)
                        COMPREPLY=( $(compgen -W "manifest iso nomacs
                        nomacsbutnat" -- ${cur}) )
                        ;;
               esac
                [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                    COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            fi
            ;;

        extpack)
            items=(install uninstall cleanup)
            subcommand=${COMP_WORDS[2]}
            if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                case "${subcommand}" in
                    install)
                        _get_excluded_items "--replace"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    uninstall)
                        _get_excluded_items "--force"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    cleanup)
                        COMPREPLY=()
                        ;;
                    --replace)
                        COMPREPLY=()
                        ;;
                esac
            else
                [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                    COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            fi
            ;;

        getextradata)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "global" -- ${cur}) )
                _vms_comp vms
            else
                _get_excluded_items "enumerate"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
            fi
            ;;

        guestcontrol)
            local items=(run start copyfrom copyto mkdir createdir
            createdirectory rmdir removedir removedirectory removefile rm mv
            move ren rename mktemp createtemp createtemporary stat list
            closeprocess closesession updatega updateguestadditions
            updateadditions watch)

            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp runningvms
            else
                _find_item_name 2
                subcommand=${COMP_WORDS[$((index+1))]}
                if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                    case "${subcommand}" in
                        run)
                            items=(--exe --timeout --unquoted-args
                            --ignore-operhaned-processes --profile
                            --dos2unix --unix2dos --username --domain --)

                            [[ " ${comp_words[@]} " != *" --password "* ||
                                " ${comp_words[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --putenv "* &&
                                " ${COMP_WORDS[@]} " != *" -E "* ]] &&
                                items+=(--putenv -E)
                            [[ " ${COMP_WORDS[@]} " != *" --no-wait-stdout "* &&
                                " ${COMP_WORDS[@]} " != *" --wait-stdout "* ]] &&
                                items+=(--no-wait-stdout --wait-stdout)
                            [[ " ${COMP_WORDS[@]} " != *" --no-wait-stderr"* &&
                                " ${COMP_WORDS[@]} " != *" --wait-stderr "* ]] &&
                                items+=(--no-wait-stderr --wait-stderr)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            compreply=( $(compgen -w "$result" -- ${cur}) )
                            ;;

                        start)
                            items=(--exe --timeout --unquoted-args
                            --ignore-operhaned-processes --profile
                            --username --domain --passwordfile --password --)

                            [[ " ${comp_words[@]} " != *" --password "* ||
                                " ${comp_words[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            compreply=( $(compgen -w "$result" -- ${cur}) )
                            ;;

                        copyfrom|copyto)
                            items=(--dryrun --follow --target-directory
                            --username --domain)

                            [[ " ${COMP_WORDS[@]} " != *" --recursive "* &&
                                " ${COMP_WORDS[@]} " != *" -R "* ]] &&
                                items+=(--recursive -R)
                            [[ " ${comp_words[@]} " != *" --password "* ||
                                " ${comp_words[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        createdirectory|createdir|mkdir)
                            items=(--parents --mode --username --domain)
                            [[ " ${COMP_WORDS[@]} " != *" --password "* ||
                                " ${COMP_WORDS[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        removedir|removedirectory|rmdir)
                            items=(--username --domain)
                            [[ " ${COMP_WORDS[@]} " != *" --password "* &&
                                " ${COMP_WORDS[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --recursive "* &&
                                " ${COMP_WORDS[@]} " != *" -R "* ]] &&
                                items+=(--recursive -R)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        removefile|rm)
                            items=(--username --domain)
                            [[ " ${COMP_WORDS[@]} " != *" --force "* &&
                                " ${COMP_WORDS[@]} " != *" -f "* ]] &&
                                items+=(--force -f)
                            [[ " ${COMP_WORDS[@]} " != *" --password "* &&
                                " ${COMP_WORDS[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        rename|ren|move|mv)
                            items=(--username --domain)
                            [[ " ${COMP_WORDS[@]} " != *" --password "* &&
                                " ${COMP_WORDS[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        createtemporary|createtemp|mktemp)
                            items=(--username --domain --secure --tmpdir --mode)
                            [[ " ${COMP_WORDS[@]} " != *" --password "* &&
                                " ${COMP_WORDS[@]} " != *" --passwordfile "* ]] &&
                                items+=(--passwordfile --password)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        list)
                            items=()
                            [[ " ${COMP_WORDS[@]} " != *" all "* &&
                                " ${COMP_WORDS[@]} " != *" sessions  "* &&
                                " ${COMP_WORDS[@]} " != *" processes "* &&
                                " ${COMP_WORDS[@]} " != *" files "* ]] &&
                                items+=(all sessions processes files)

                                [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                    " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                    items+=(--verbose -v)
                                [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                    " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                    items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        closeprocess)
                            items=()
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)
                            [[ " ${COMP_WORDS[@]} " != *" --session-id "* ]] &&
                                items+=(--session-name)
                            [[ " ${COMP_WORDS[@]} " != *" --session-name "* ]] &&
                                items+=(--session-id)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        closesession)
                            items=()
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)
                            [[ " ${COMP_WORDS[@]} " != *" --session-id "* &&
                                " ${COMP_WORDS[@]} " != *" --session-name "* &&
                                " ${COMP_WORDS[@]} " != *" --all "* ]] &&
                                items+=(--session-id --session-name --all)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        process)
                            if [[ " ${COMP_WORDS[@]} " == *" process kill "* ]];
                            then
                                items=(--verbose)
                                [[ " ${COMP_WORDS[@]} " != *" --session-name "* &&
                                    " ${COMP_WORDS[@]} " != *" --session-id "* ]] &&
                                    items+=(--session-id --session-name)
                                _get_excluded_items "${items[@]}"
                                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            else
                                _get_excluded_items "kill"
                                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            fi
                            ;;

                        stat)
                            if [[ "${cur}" == "stat" ]]; then
                                COMPREPLY=( $(compgen -- ${cur}) )
                            else
                                items=(--username --domain --verbose)
                                [[ " ${COMP_WORDS[@]} " != *" --password "* &&
                                    " ${COMP_WORDS[@]} " != *" --passwordfile "* ]] &&
                                    items+=(--passwordfile --password)
                                [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                    " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                    items+=(--verbose -v)
                                [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                    " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                    items+=(--quiet -q)

                                _get_excluded_items "${items[@]}"
                                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            fi
                            ;;

                        updatega|updateguestadditions|updateadditions)
                            items=(--source --wait-start)
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;

                        watch)
                            items=()
                            [[ " ${COMP_WORDS[@]} " != *" --verbose "* &&
                                " ${COMP_WORDS[@]} " != *" -v "* ]] &&
                                items+=(--verbose -v)
                            [[ " ${COMP_WORDS[@]} " != *" --quiet "* &&
                                " ${COMP_WORDS[@]} " != *" -q "* ]] &&
                                items+=(--quiet -q)

                            _get_excluded_items "--verbose"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                    esac

                    case "${prev}" in
                        close)
                            items=(--verbose)
                            [[ " ${COMP_WORDS[@]} " != *" --session-name "* &&
                                " ${COMP_WORDS[@]} " != *" --session-id "* &&
                                " ${COMP_WORDS[@]} " != *" --all "* ]] &&
                                items+=(--session-id --session-name --all)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        --image)
                            COMPREPLY=( $(compgen -- ${cur}) )
                            ;;
                        --tmpdir)
                            COMPREPLY=( $(compgen -o dirnames -- ${cur}) )
                            ;;
                        --source)
                            compopt -o nospace
                            COMPREPLY=( $(compgen -o plusdirs -f -X '!*.iso' \
                                -- ${cur}) )
                            [[ ${#COMPREPLY[@]} = 1 && \
                                "${COMPREPLY[0]}" != *".iso" ]] && \
                                COMPREPLY[0]="${COMPREPLY[0]}/"
                            ;;
                    esac
                else
                    [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                        COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
                fi
            fi
            ;;

        guestproperty)
            items=(get set delete unset enumerate wait)
            subcommand=${COMP_WORDS[2]}

            if [[ "${prev}" == "${subcommand}" ]]; then
                _vms_comp vms
            elif [[ " ${items[@]} " == *" $subcommand "* ]]; then
                case "${subcommand}" in
                    get)
                        _get_excluded_items "--verbose"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    set)
                        _get_excluded_items "--flags"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    enumerate)
                        _get_excluded_items "--patterns"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    wait)
                        items=(--timeout --fail-on-timeout)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                esac
            else
                [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                    COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            fi
            ;;

        hostonlyif)
            items=(ipconfig create remove)
            subcommand=${COMP_WORDS[2]}
            case "${prev}" in
                ipconfig|remove)
                    _hostonlyif_comp
                    ;;
            esac

            if [[ ${#COMPREPLY[@]} -eq 0  && \
                " ${items[@]} " == *" $subcommand "* ]]; then
                case "${subcommand}" in
                    ipconfig)
                        items=(--dhcp --ip --ipv6 --netmask --netmasklengthv6)
                        [[ " ${COMP_WORDS[@]} " == *" --dhcp "* ]] && items=()
                        [[ " ${COMP_WORDS[@]} " == *" --ip "* ]] &&
                            items=(--netmask)
                        [[ " ${COMP_WORDS[@]} " == *" --netmask "* ]] &&
                            items=(--ip)
                        [[ " ${COMP_WORDS[@]} " == *" --ipv6 "* ]] &&
                            items=(--netmasklengthv6)
                        [[ " ${COMP_WORDS[@]} " == *" --netmasklengthv6 "* ]] &&
                            items=(--ipv6)

                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                esac
            else
                [[ ${COMP_CWORD} -eq 2 ]] && \
                    COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            fi
            ;;

        import)
            items=(--options)
            if [[ "${prev}" == "import" ]]; then
                COMPREPLY=( $(compgen -o plusdirs -f -X '!@(*.ovf|*.ova)' \
                    -- ${cur}) )
            else
                case "${prev}" in
                    --options)
                        COMPREPLY=( $(compgen -W "keepallmacs keepnatmacs
                        importtovdi" -- ${cur}) )
                        ;;
                esac
                [[ " ${COMP_WORDS[@]} " != *" --dry-run"* &&
                    " ${COMP_WORDS[@]} " != *" -n"* ]] &&
                    items+=(-n --dry-run)

                if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
                    _get_excluded_items "${items[@]}"
                    COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                fi
            fi
            ;;

        list)
            if [[ ${prev} == ${cmd} ]]; then
                _list_comp ${cur}
            else
                case "${prev}" in
                    --long|-l)
                        COMPREPLY=()
                        ;;
                    *)
                        COMPREPLY=( $(compgen -W "-l --long" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        mediumproperty)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "disk dvd floppy" -- ${cur}) )
            else
                case "${prev}" in
                    disk|dvd|floppy)
                        COMPREPLY=( $(compgen -W "get set delete" -- ${cur}) )
                        ;;
                    get|set|floppy)
                        _get_medium
                        ;;
                esac
            fi
            ;;

        metrics)
            items=(list setup query enable disable collect)
            subcommand=${COMP_WORDS[2]}
            if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                case "${subcommand}" in
                    list|query)
                        if [[ "${subcommand}" == "${prev}" ]]; then
                            _vms_comp vms
                            items=(host)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY+=( $(compgen -W '$result' -- ${cur}) )
                        fi
                        ;;
                    setup)
                        if [[ "${subcommand}" == "${prev}" ]]; then
                            _vms_comp vms
                            items=(host)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY+=( $(compgen -W '$result' -- ${cur}) )
                        else
                            items=(--period --samples --list)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        fi
                        ;;
                    enable|disable)
                        if [[ "${subcommand}" == "${prev}" ]]; then
                            _vms_comp vms
                            items=(host)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY+=( $(compgen -W '$result' -- ${cur}) )
                        else
                            _get_excluded_items "--list"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        fi
                        ;;
                    collect)
                        if [[ "${subcommand}" == "${prev}" ]]; then
                            _vms_comp vms
                            items=(host)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY+=( $(compgen -W '$result' -- ${cur}) )
                        else
                            items=(--period --samples --detach --list)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        fi
                        ;;
                esac
            else
                [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                    COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            fi
            ;;

        modifymedium)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "disk dvd floppy" -- ${cur}) )
            else
                case "${prev}" in
                    disk)
                        _hdd_comp
                        ;;
                    dvd)
                        _dvds_comp
                        ;;
                    floppy)
                        _floppy_comp
                        ;;
                    *)
                        _find_item_name 2
                        items=(--type --autoreset --property --compact --resize
                        --move)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        case "${prev}" in
                            --type)
                                COMPREPLY=( $(compgen -W "normal writethrough
                                immutable shareable readonly multiattach" --\
                                    ${cur}) )
                                ;;
                            --autoreset)
                                COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
                                ;;
                            --move)
                                COMPREPLY=( $(compgen -o dirnames -- ${cur}) )
                                ;;
                        esac
                    ;;
                esac
            fi
            ;;

        modifyvm)
            items=(--name --groups --description --ostype --iconfile --memory
            --pagefusion --vram --acpi --pciattach --pcidetach --ioapic --hpet
            --triplefaultreset --hwvirtex --nestedpaging --largepages --vtxvpid
            --vtxux --pae --longmode --cpuidset --cpuidremove
            --cpuidremoveall --hardwareuuid --cpus --cpuhotplug --plugcpu
            --unplugcpu --cpuexecutioncap --rtcuseutc --graphicscontroller
            --monitorcount --accelerate3d --accelerate2dvideo --firmware
            --chipset --bioslogofadein --bioslogofadeout --bioslogodisplaytime
            --bioslogoimagepath --biosbootmenu --biossystemtimeoffset
            --biospxedebug --boot1 --boot2 --boot3 --boot4 --nicbootprio1
            --nicbandwidthgroup1 --bridgeadapter1 --bridgeadapter2
            --bridgeadapter3 --bridgeadapter4 --bridgeadapter5 --bridgeadapter6
            --bridgeadapter7 --bridgeadapter8 --hostonlyadapter1
            --hostonlyadapter2 --hostonlyadapter3 --hostonlyadapter4
            --hostonlyadapter5 --hostonlyadapter6 --hostonlyadapter7
            --hostonlyadapter8 --intnet1 --intnet2 --intnet3 --intnet4 --intnet5
            --intnet6 --intnet7 --intnet8 --nat-network1 --nicgenericdrv1
            --natnet1 --natsettings1 --nat-network2 --nicgenericdrv2 --natnet2
            --natsettings2 --nat-network3 --nicgenericdrv3 --natnet3
            --natsettings3 --nat-network4 --nicgenericdrv4 --natnet4
            --natsettings4 --nat-network5 --nicgenericdrv5 --natnet5
            --natsettings5 --nat-network6 --nicgenericdrv6 --natnet6
            --natsettings6 --nat-network7 --nicgenericdrv7 --natnet7
            --natsettings7 --nat-network8 --nicgenericdrv8 --natnet8
            --natsettings8 --natpf1 --nic1 --nicpromisc1 --nicproperty1
            --nictrace1 --nictracefile1 --natpf2 --nic2 --nicpromisc2
            --nicproperty2 --nictrace2 --nictracefile2 --natpf3 --nic3
            --nicpromisc3 --nicproperty3 --nictrace3 --nictracefile3 --natpf4
            --nic4 --nicpromisc4 --nicproperty4 --nictrace4 --nictracefile4
            --natpf5 --nic5 --nicpromisc5 --nicproperty5 --nictrace5
            --nictracefile5 --natpf6 --nic6 --nicpromisc6 --nicproperty6
            --nictrace6 --nictracefile6 --natpf7 --nic7 --nicpromisc7
            --nicproperty7 --nictrace7 --nictracefile7 --natpf8 --nic8
            --nicpromisc8 --nicproperty8 --nictrace8 --nictype1 --nictype2
            --nictype3 --nictype4 --nictype5 --nictype6 --nictype7 --nictype8
            --cableconnected1 --cableconnected2 --cableconnected3
            --cableconnected4 --cableconnected5 --cableconnected6
            --cableconnected7 --cableconnected8 --nicspeed1 --nicspeed2
            --nicspeed3 --nicspeed4 --nicspeed5 --nicspeed6 --nicspeed7
            --nicspeed8 --nattftpprefix1 --nattftpprefix2 --nattftpprefix3
            --nattftpprefix4 --nattftpprefix5 --nattftpprefix6 --nattftpprefix7
            --nattftpprefix8 --nattftpfile1 --nattftpfile2 --nattftpfile3
            --nattftpfile4 --nattftpfile5 --nattftpfile6 --nattftpfile7
            --nattftpfile8 --nattftpserver1 --nattftpserver2 --nattftpserver3
            --nattftpserver4 --nattftpserver5 --nattftpserver6 --nattftpserver7
            --nattftpserver8 --natbindip1 --natbindip2 --natbindip3 --natbindip4
            --natbindip5 --natbindip6 --natbindip7 --natbindip8
            --natdnspassdomain1 --natdnspassdomain2 --natdnspassdomain3
            --natdnspassdomain4 --natdnspassdomain5 --natdnspassdomain6
            --natdnspassdomain7 --natdnspassdomain8 --natdnsproxy1
            --natdnsproxy2 --natdnsproxy3 --natdnsproxy4 --natdnsproxy5
            --natdnsproxy6 --natdnsproxy7 --natdnsproxy8 --natdnshostresolver1
            --natdnshostresolver2 --natdnshostresolver3 --natdnshostresolver4
            --natdnshostresolver5 --natdnshostresolver6 --natdnshostresolver7
            --natdnshostresolver8 --nataliasmode1 --nataliasmode2
            --nataliasmode3 --nataliasmode4 --nataliasmode5 --nataliasmode6
            --nataliasmode7 --nataliasmode8 --macaddress1 --macaddress2
            --macaddress3 --macaddress4 --macaddress5 --macaddress6
            --macaddress7 --macaddress8 --mouse --keyboard --uart1 --uartmode1
            --uart2 --uartmode2 --lpt1 --lptmode1 --guestmemoryballoon --audio
            --audiocontroller --clipboard --draganddrop --vrde --vrdeextpack
            --vrdeproperty --vrdeport --vrdeaddress --vrdeauthtype
            --vrdeauthlibrary --vrdemulticon --vrdereusecon --vrdevideochannel
            --vrdevideochannelquality --usb --usbehci --snapshotfolder
            --teleporter --teleporterport --teleporteraddress
            --teleporterpassword --teleporterpasswordfile --tracing-enabled
            --tracing-config --tracing-allow-vm-access --usbcardreader
            --autostart-enabled --autostart-delay --videocap --videocapscreens
            --videocapfile --videocapres --videocaprate --videocapfps
            --videocapmaxtime --videocapmaxsize --videocapopts --defaultfrontend
            --cpuid-portability-level --paravirtprovider --audiocodec --usbxhci
            --usbrename --apic --x2apic --paravirtdebug --cpu-profile
            --biosapic --videocapopts)

            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                case "${prev}" in
                    --groups)
                        COMPREPLY=()
                        _group_comp
                        ;;

                    --ostype)
                        COMPREPLY=()
                        _os_comp
                        ;;

                    --pagefusion|--acpi|--ioapic|--hpet|--triplefaultreset|\
                    --hwvirtex|--nestedpaging|--largepages|--vtxvpid|--vtxux|\
                    --pae|--longmode|--cpuhotplug|--rtcuseutc|\
                    --accelerate3d|--accelerate2dvideo|--bioslogofadein|\
                    --bioslogofadeout|--biospxedebug|--cableconnected1|\
                    --cableconnected2|--cableconnected3|--cableconnected4|\
                    --cableconnected5|--cableconnected6|--cableconnected7|\
                    --cableconnected8|--nictrace1|--nictrace2|--nictrace3|\
                    --nictrace4|--nictrace5|--nictrace6|--nictrace7|--nictrace8|\
                    --natdnspassdomain1|--natdnspassdomain2|--natdnspassdomain3|\
                    --natdnspassdomain4|--natdnspassdomain5|--natdnspassdomain6|\
                    --natdnspassdomain7|--natdnspassdomain8|--natdnsproxy1|\
                    --natdnsproxy2|--natdnsproxy3|--natdnsproxy4|--natdnsproxy5|\
                    --natdnsproxy6|--natdnsproxy7|--natdnsproxy8|\
                    --natdnshostresolver1|--natdnshostresolver2|\
                    --natdnshostresolver3|--natdnshostresolver4|\
                    --natdnshostresolver5|--natdnshostresolver6|\
                    --natdnshostresolver7|--natdnshostresolver8|--vrde|\
                    --vrdemulticon|--vrdereusecon|--vrdevideochannel|--usb|\
                    --usbehci|--teleporter|--tracing-enabled|\
                    --tracing-allow-vm-access|--usbcardreader|\
                    --autostart-enabled|--videocap|--usbxhci|--apic|--x2apic)
                        COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
                        ;;

                    --graphicscontroller)
                        COMPREPLY=( $(compgen -W "none vboxvga vmsvga" \
                            -- ${cur}) )
                        ;;

                    --firmware)
                        COMPREPLY=( $(compgen -W "bios efi efi32 efi64" \
                            -- ${cur}) )
                        ;;

                    --chipset)
                        COMPREPLY=( $(compgen -W "ich9 piix3" -- ${cur}) )
                        ;;

                    --biosbootmenu)
                        COMPREPLY=( $(compgen -W "disabled menuonly
                        messageandmenu" -- ${cur}) )
                        ;;

                    --boot[1-4])
                        COMPREPLY=( $(compgen -W "none floppy dvd disk net" \
                            -- ${cur}) )
                        ;;

                    --nic[1-8])
                        COMPREPLY=( $(compgen -W "none null nat bridged intnet
                        hostonly generic natnetwork" -- ${cur}) )
                        ;;

                    --nictype[1-8])
                        COMPREPLY=( $(compgen -W "Am79C970A Am79C973 82540EM
                        82543GC 82545EM virtio" -- ${cur}) )
                        ;;

                    --nicpromisc[1-8])
                        COMPREPLY=( $(compgen -W "deny allow-vms allow-all" \
                            -- ${cur}) )
                        ;;

                    --nicbandwidthgroup[1-8])
                        COMPREPLY=()
                        _bandwidthctl_comp
                        _get_excluded_items "none"
                        COMPREPLY+=( $(compgen -W "$result" -- ${cur}) )
                        ;;

                    --bridgeadapter[1-8])
                        COMPREPLY=()
                        _bridgedif_comp
                        _get_excluded_items "none"
                        COMPREPLY+=( $(compgen -W "$result" -- ${cur}) )
                        ;;

                    --hostonlyadapter[1-8])
                        COMPREPLY=()
                        _hostonlyif_comp
                        _get_excluded_items "none"
                        COMPREPLY+=( $(compgen -W "$result" -- ${cur}) )
                        ;;

                    --intnet[1-8])
                        COMPREPLY=()
                        _intnet_comp
                        ;;

                    --nat-network[1-8])
                        COMPREPLY=()
                        _natnet_comp
                        ;;

                    --natnet[1-8])
                        COMPREPLY=()
                        _natnet_comp
                        ;;

                    --natpf[1-8])
                        COMPREPLY+=( $(compgen -W "delete" -- ${cur}) )
                        ;;

                    --nataliasmode[1-8])
                        COMPREPLY+=( $(compgen -W "default" -- ${cur}) )
                        ;;

                    --macaddress[1-8])
                        COMPREPLY+=( $(compgen -W "auto" -- ${cur}) )
                        ;;

                    --mouse)
                        COMPREPLY+=( $(compgen -W "ps2 usb usbtablet
                        usbmultitouch" -- ${cur}) )
                        ;;

                    --keyboard)
                        COMPREPLY+=( $(compgen -W "ps2 usb" -- ${cur}) )
                        ;;

                    --uart[1-2]|--lpt[1-2])
                        COMPREPLY+=( $(compgen -W "off" -- ${cur}) )
                        ;;

                    --uartmode[1-2])
                        COMPREPLY+=( $(compgen -W "disconnected server client
                        tcpserver tcpclient file" -- ${cur}) )
                        ;;

                    --audio)
                        COMPREPLY+=( $(compgen -W "none null oss alsa pulse" \
                            -- ${cur}) )
                        ;;

                    --audiocontroller)
                        COMPREPLY+=( $(compgen -W "ac97 hda sb16" -- ${cur}) )
                        ;;

                    --audiocodec)
                        COMPREPLY+=( $(compgen -W "stac9700 ad1980 stac9221
                        sb16" -- ${cur}) )
                        ;;

                    --clipboard)
                        COMPREPLY+=( $(compgen -W "disabled hosttoguest
                        guesttohost bidirectional" -- ${cur}) )
                        ;;

                    --draganddrop)
                        COMPREPLY+=( $(compgen -W "disabled hosttoguest" \
                            -- ${cur}) )
                        ;;

                    --vrdeextpack|--vrdeauthlibrary|--snapshotfolder|\
                        --defaultfrontend)
                        COMPREPLY+=( $(compgen -W "default" -- ${cur}) )
                        ;;

                    --vrdeauthtype)
                        COMPREPLY+=( $(compgen -W "null external guest" \
                            -- ${cur}) )
                        ;;

                    --paravirtprovider)
                        COMPREPLY=( $(compgen -W "none default legacy minimal
                        hyperv kvm" -- ${cur}) )
                        ;;

                    --cpuid-portability-level)
                        COMPREPLY=( $(compgen -W "0 1 2 3" -- ${cur}) )
                        ;;

                    --cpu-profile)
                        COMPREPLY=( $(compgen -W "host 8086 80286 80386" \
                            -- ${cur}) )
                        ;;

                    --biosapic)
                        COMPREPLY=( $(compgen -W "disabled apic x2apic" \
                            -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        natnetwork)
            items=(add remove modify start stop list)
            subcommand=${COMP_WORDS[2]}
            if [[ "${prev}" == "--netname" ]]; then
                _natnet_comp
            elif [[ "${prev}" == "--dhcp" ]]; then
                COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
            elif [[ " ${items[@]} " == *" $subcommand "* ]]; then
                case "${subcommand}" in
                    add|modify)
                        items=(--netname --network --dhcp --port-forward-4
                        --loopback-4 --ipv6 --port-forward-6 --loopback-6)

                        [[ " ${COMP_WORDS[@]} " != *" --enable"* &&
                            " ${COMP_WORDS[@]} " != *" --disable"* ]] &&
                            items+=(--enable --disable)

                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    start|stop|remove)
                        _get_excluded_items "--netname"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                esac
            else
                [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                    COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            fi
            ;;

        registervm)
            if [[ ${prev} == ${cmd} ]]; then
                bind 'set mark-directories on'
                compopt -o nospace
                IFS=$'\n'
                COMPREPLY=( $(compgen -o plusdirs -f -X '!*.vbox' -- ${cur}) )
                [[ ${#COMPREPLY[@]} = 1 && "${COMPREPLY[0]}" != *".vbox" ]] && \
                    COMPREPLY[0]="${COMPREPLY[0]}/"
            fi
            ;;

        setextradata)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "global" -- ${cur}) )
                _vms_comp vms
            fi
            ;;

        setproperty)
            items=(machinefolder hwvirtexclusive vrdeauthlibrary
            websrvauthlibrary vrdeextpack autostartdbpath loghistorycount
            defaultfrontend logginglevel)
            subcommand=${COMP_WORDS[2]}
            if [[ "${prev}" == "${cmd}" ]]; then
                COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            else
                case "${prev}" in
                    machinefolder)
                        COMPREPLY=( $(compgen -o dirnames -- ${cur}) )
                        _get_excluded_items "default"
                        COMPREPLY+=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    hwvirtexclusive)
                        COMPREPLY+=( $(compgen -W "on off" -- ${cur}) )
                        ;;
                    websrvauthlibrary)
                        COMPREPLY+=( $(compgen -W "default null" -- ${cur}) )
                        ;;
                    vrdeextpack)
                        COMPREPLY+=( $(compgen -W "default null" -- ${cur}) )
                        ;;
                    autostartdbpath)
                        COMPREPLY=( $(compgen -o dirnames -- ${cur}) )
                        COMPREPLY+=( $(compgen -W "null" -- ${cur}) )
                        ;;
                    defaultfrontend)
                        COMPREPLY=( $(compgen -W "null" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        sharedfolder)
            items=(add remove)
            subcommand=${COMP_WORDS[2]}
            case "${prev}" in
                add|remove)
                    _vms_comp vms
                    ;;
                --hostpath)
                    COMPREPLY=( $(compgen -o dirnames -- ${cur}) )
                    ;;
                --name)
                    if [[ ${subcommand} == "remove" ]]; then
                        _find_item_name 3
                        _sharedfolder_comp "${name}"
                    fi
                    ;;
            esac
            if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
                case "${subcommand}" in
                    add)
                        items=(--name --hostpath --transient --readonly
                        --automount)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                    remove)
                        items=(--name --transient)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                esac
            fi

            [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
            ;;

        showmediuminfo)
            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "disk dvd floppy" -- ${cur}) )
                _hdd_comp
                _dvds_comp
                _floppy_comp
            else
                case "${prev}" in
                    disk)
                        _hdd_comp
                        ;;
                    dvd)
                        _dvds_comp
                        ;;
                    floppy)
                        _floppy_comp
                        ;;
                    *)
                        items=(--delete)
                        _get_excluded_items "${items[@]}"
                        COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        showvminfo)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                if [[ " ${COMP_WORDS[@]} " == *" --log "* ]]; then
                    COMPREPLY=()
                elif [[ " ${COMP_WORDS[@]} " == *" --details "* ||
                    " ${COMP_WORDS[@]} " == *" --machinereadable "*  ]]; then
                    local items=(--details --machinereadable)
                    _get_excluded_items "${items[@]}"
                    COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                else
                    local items=(--details --machinereadable --log)
                    _get_excluded_items "${items[@]}"
                    COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                fi
            fi
            ;;

        snapshot)
            items=(take delete restore restorecurrent edit list showvminfo)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                _find_item_name 2
                subcommand=${COMP_WORDS[$((index+1))]}
                if [[ " ${items[@]} " == *" $subcommand "* ]]; then
                    case "${subcommand}" in
                        take)
                            items=(--description --live --uniquename)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        delete|restore|showvminfo)
                            _snapshot_comp
                            ;;
                        restorecurrent)
                            COMPREPLY=()
                            ;;
                        edit)
                            if [[ ${prev} == "edit" &&
                                ${#COMP_WORDS[@]} == 5 ]]; then
                                _snapshot_comp
                                COMPREPLY+=("--current")
                            else
                                items=(--name --description)
                                _get_excluded_items "${items[@]}"
                                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            fi
                            ;;
                        list)
                            items=(--details --machinereadable)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                    esac
                else
                    [[ ${#COMPREPLY[@]} -eq 0 ]] && \
                        COMPREPLY=( $(compgen -W "${items[*]}" -- ${cur}) )
                fi
            fi
            ;;

        startvm)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms 1
            elif [[ "${prev}" == "--type" ]]; then
                COMPREPLY=( $(compgen -W "gui sdl headless separate" -- ${cur}) )
            else
                local items=(--type)
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
            fi
            ;;

        storageattach)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                _find_item_name 2
                local items=(--storagectl --port --device --type --medium --mtype
                --comment --setuuid --setparentuuid --passthrough --tempeject
                --nonrotational --discard --hotpluggable --bandwidthgroup
                --forceunmount --server --target --tport --lun --encodedlun
                --username --password --initiator --intnet)
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )

                case "${prev}" in
                    --type)
                        COMPREPLY=( $(compgen -W "dvddrive hdd fdd" -- ${cur}) )
                        ;;
                    --medium)
                        COMPREPLY=()
                        local tmp=(none emptydrive additions)
                        _hdd_comp
                        _floppy_comp
                        _dvds_comp
                        for item in "${tmp[@]}"
                        do
                            [[ ${item^^} == ${cur^^}* ]] && COMPREPLY+=("$item")
                        done
                        ;;
                    --mtype)
                        COMPREPLY=( $(compgen -W "normal writethrough immutable
                        shareable readonly multiattach" -- ${cur}) )
                        ;;
                    --passthrough|--tempeject|--nonrotational|--discard)
                        COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        storagectl)
            local items=(--name --add --controller --portcount --hostiocache
            --bootable --rename --remove)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                case "${prev}" in
                    --add)
                        COMPREPLY=( $(compgen -W "ide sata scsi floppy
                        sas usb pcie" -- ${cur}) )
                        ;;
                    --controller)
                        COMPREPLY=( $(compgen -W "LSILogic LSILogicSAS BusLogic
                        IntelAHCI PIIX3 PIIX4 ICH6 I82078 USB NVMe" -- ${cur}) )
                        ;;
                    --bootable|--hostiocache)
                        COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
                        ;;
                esac
            fi
            ;;

        unregistervm)
            if [[ ${prev} == ${cmd} ]]; then
                _vms_comp vms
            else
                local items=(--delete)
                _get_excluded_items "${items[@]}"
                COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
            fi
            ;;

        usbfilter)
            if [[ COMP_CWORD -ge 3 ]]; then
                subcommand="${COMP_WORDS[2]}"
                if [[ $subcommand == "${cmd}" ]]; then
                    subcommand="${COMP_WORDS[3]}"
                fi
            fi

            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "add modify remove" -- ${cur}) )
            else
                case "${prev}" in
                    --target)
                        _vms_comp vms
                        COMPREPLY+=( $(compgen -W "global" -- ${cur}) )
                        ;;
                    --action)
                        COMPREPLY=( $(compgen -W "ignore hold" -- ${cur}) )
                        ;;
                    --active|--remote)
                        COMPREPLY=( $(compgen -W "yes no" -- ${cur}) )
                        ;;
                esac
                if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
                    case "${subcommand}" in
                        add|modify)
                            local items=(--target --name --action --active
                            --vendorid --productid --revision --manufacturer
                            --product --remote --serialnumber --maskedinterfaces)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                        remove)
                            local items=(--target)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                    esac
                fi
            fi
            ;;

        usbdevsource)
            if [[ COMP_CWORD -ge 3 ]]; then
                subcommand="${COMP_WORDS[2]}"
                if [[ $subcommand == "${cmd}" ]]; then
                    subcommand="${COMP_WORDS[3]}"
                fi
            fi

            if [[ ${prev} == ${cmd} ]]; then
                COMPREPLY=( $(compgen -W "add remove" -- ${cur}) )
            else
                if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
                    case "${subcommand}" in
                        add)
                            local items=(--address --backend)
                            _get_excluded_items "${items[@]}"
                            COMPREPLY=( $(compgen -W "$result" -- ${cur}) )
                            ;;
                    esac
                fi
            fi
            ;;
    esac
}
complete -o default -F _VBoxManage VBoxManage
complete -o default -F _VBoxManage vboxmanage

# vim: set ft=sh tw=80 sw=4 et :
