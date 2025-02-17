#!/usr/bin/env bash

function zellij-attach
    set sessions $(zellij list-sessions -s | string collect)
    set no_sessions (echo $sessions | wc -l)

    if test $no_sessions -ge 2
        zellij attach (echo $sessions | tv --preview 'zellij list-sessions | rg {0}')
    else
        zellij attach -c
    end
end
