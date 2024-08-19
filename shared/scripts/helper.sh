color_reset='\x1b[0m'
color_fg_dark_black='\x1b[38;5;0m'
color_fg_dark_red='\x1b[38;5;1m'
color_fg_dark_green='\x1b[38;5;2m'
color_fg_dark_yellow='\x1b[38;5;3m'
color_fg_dark_blue='\x1b[38;5;4m'
color_fg_dark_purple='\x1b[38;5;5m'
color_fg_dark_cyan='\x1b[38;5;6m'
color_fg_dark_white='\x1b[38;5;7m'

color_fg_light_black='\x1b[38;5;8m'
color_fg_light_red='\x1b[38;5;9m'
color_fg_light_green='\x1b[38;5;10m'
color_fg_light_yellow='\x1b[38;5;11m'
color_fg_light_blue='\x1b[38;5;12m'
color_fg_light_purple='\x1b[38;5;14m'
color_fg_light_cyan='\x1b[38;5;14m'
color_fg_light_white='\x1b[38;5;15m'

color_bg_dark_black='\x1b[48;5;0m'
color_bg_dark_red='\x1b[48;5;1m'
color_bg_dark_green='\x1b[48;5;2m'
color_bg_dark_yellow='\x1b[48;5;3m'
color_bg_dark_blue='\x1b[48;5;4m'
color_bg_dark_purple='\x1b[48;5;5m'
color_bg_dark_cyan='\x1b[48;5;6m'
color_bg_dark_white='\x1b[48;5;7m'

color_bg_light_black='\x1b[48;5;8m'
color_bg_light_red='\x1b[48;5;9m'
color_bg_light_green='\x1b[48;5;10m'
color_bg_light_yellow='\x1b[48;5;11m'
color_bg_light_blue='\x1b[48;5;12m'
color_bg_light_purple='\x1b[48;5;14m'
color_bg_light_cyan='\x1b[48;5;14m'
color_bg_light_white='\x1b[48;5;15m'

# NOTE: To understand Bash's parameter expansion:
# https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
system_hostname="${HOSTNAME/%.local/}"
if [ "$system_hostname" = "Fernando-Moreira-MacBook-Pro-16-inch-Nov-2023-" ]; then
    system_hostname="dremio"
fi

enter_password () {
    local pwd1="pwd1"
    local pwd2="pwd2"
    while [ "$pwd1" != "$pwd2" ]; do
        read -s -p Password: pwd1
        >&2 echo
        read -s -p Confirm: pwd2
        >&2 echo
        [ "$pwd1" != "$pwd2" ] &&
            log_warning "  -> Passwords don't match. Enter them again."
    done
    printf "$pwd1"
}

join_strings () {
    echo "$(IFS=; echo "$*")"
}

log_default () {
    >&2 echo -e "$1"
}

log_error () {
    >&2 echo -e "${color_bg_dark_red}${color_fg_light_white}$1${color_reset}"
}

log_info () {
	>&2 echo -e "${color_fg_dark_blue}$1${color_reset}"
}

log_success () {
	>&2 echo -e "${color_fg_dark_green}$1${color_reset}"
}

log_warning () {
	>&2 echo -e "${color_fg_dark_yellow}$1${color_reset}"
}

trap_error () {
    local exit_code=$?
    local failed_cmd="$BASH_COMMAND"
    local failed_line_nr="$BASH_LINENO"
    log_error ">>> Failed the execution of $this_script on line $failed_line_nr."
    log_error ">>> Command '$failed_cmd' failed with exit code $exit_code."
}
