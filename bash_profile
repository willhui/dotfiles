#!/bin/bash

if [ -e /etc/bash.bashrc ] ; then
	source /etc/bash.bashrc
fi

if [ -e "${HOME}/.bashrc" ] ; then
	source "${HOME}/.bashrc"
fi

