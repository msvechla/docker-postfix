#!/usr/bin/env bash

declare reset green yellow orange orange_emphasis lightblue red gray emphasis underline

##################################################################################
# Check if one string is contained in another.
# Parameters:
#   $1 string to check
#   $2 the substring
#
# Exists:
#   0 (success) if $2 is in $1
#   1 (fail) if $2 is NOT in $1
#
# Example:
#   contains "foobar" "bar" -> 0 (true)
#   coinains "foobar" "e"   -> 1 (false)
#
##################################################################################
contains() {
	string="$1"    substring="$2"
	if test "${string#*$substring}" != "$string"; then return 0; else return 1; fi
}

##################################################################################
# Check if we're running on a color term or not and setup color codes appropriately
##################################################################################
is_color_term() {
	if test -t 1 || [ -n "$FORCE_COLOR" ]; then
		# Quick and dirty test for color support
		if [ "$FORCE_COLOR" == "256" ] || contains "$TERM" "256" || contains "$COLORTERM" "256"  || contains "$COLORTERM" "color" || contains "$COLORTERM" "24bit"; then
			reset="$(printf '\033[0m')"
			green="$(printf '\033[38;5;46m')"
			yellow="$(printf '\033[38;5;178m')"
			orange="$(printf '\033[38;5;208m')"
			orange_emphasis="$(printf '\033[38;5;220m')"
			lightblue="$(printf '\033[38;5;147m')"
			red="$(printf '\033[91m')"
			gray="$(printf '\033[38;5;245m')"
			emphasis="$(printf '\033[38;5;111m')"
			underline="$(printf '\033[4m')"
		elif [ -n "$FORCE_COLOR" ] || contains "$TERM" "xterm"; then
			reset="$(printf '\033[0m')"
			green="$(printf '\033[32m')"
			yellow="$(printf '\033[33m')"
			orange="$(printf '\033[31m')"
			orange_emphasis="$(printf '\033[31m\033[1m')"
			lightblue="$(printf '\033[36;1m')"
			red="$(printf '\033[31;1m')"
			gray="$(printf '\033[30;1m')"
			emphasis="$(printf '\033[1m')"
			underline="$(printf '\033[4m')"
		fi
	fi
}
is_color_term


deprecated() {
	printf "${reset}‣ ${lightblue}DEPRECATED!${reset} "
	echo -e "$@${reset}"
}

debug() {
	printf "${reset}‣ ${gray}DEBUG${reset} "
	echo -e "$@${reset}"
}

info() {
	printf "${reset}‣ ${green}INFO ${reset} "
	echo -e "$@${reset}"
}

infon() {
	printf "${reset}‣ ${green}INFO ${reset} "
	echo -en "$@${reset}"
}

notice() {
	printf "${reset}‣ ${yellow}NOTE ${reset} "
	echo -e "$@${reset}"
}

noticen() {
	printf "${reset}‣ ${yellow}NOTE ${reset} "
	echo -en "$@${reset}"
}

warn() {
	printf "${reset}‣ ${orange}WARN ${reset} "
	echo -e "$@${reset}"
}

error() {
	printf "${reset}‣ ${red}ERROR${reset} " >&2
	echo -e "$@${reset}" >&2
}

fatal_no_exit() {
	printf "${reset}‣ ${red}FATAL${reset} " >&2
	echo -e "$@${reset}" >&2
}

fatal() {
	fatal_no_exit $@
	exit 1
}

# Return a DKIM selector from DKIM_SELECTOR environment variable.
# See README.md for details.
get_dkim_selector() {
	if [ -z "${DKIM_SELECTOR}" ]; then
		echo "mail"
		return
	fi

	local domain="$1"
	local old="$IFS"
	local no_domain_selector="mail"
	local IFS=","
	for part in ${DKIM_SELECTOR}; do
		if contains "$part" "="; then
			k="$(echo "$part" | cut -f1 -d=)"
			v="$(echo "$part" | cut -f2 -d=)"
			if [ "$k" == "$domain" ]; then
				echo "$v"
				IFS="${old}"
				return
			fi
		else
			no_domain_selector="$part"
		fi
	done
	IFS="${old}"

	echo "${no_domain_selector}"
}

export reset green yellow orange orange_emphasis lightblue red gray emphasis underline
