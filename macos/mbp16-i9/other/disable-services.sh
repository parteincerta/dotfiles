#!/usr/bin/env bash

is_number_re='^[0-9]+$'

# System Services
system_services=(
	# Diagnostics and usage data collection
	com.apple.analyticsd

	# Predicts OS conditions
	com.apple.ospredictiond

	# Diagnostics and usage reporting
	com.apple.rtcreportingd

	# Siri-related daemons
	com.apple.siriinferenced

	# Primarily involved in gathering data from experiments
	# assigned through CloudKit.
	com.apple.triald.system
)
system_services_launchctl="$(launchctl list)"

for item in "${system_services[@]}"; do
	echo "Disabling system/$item ..."
	# `bootout` only possible if SIP is disabled.
	# sudo launchctl bootout "system/$item"
	sudo launchctl disable "system/$item"

	pid=$(echo "$system_services_launchctl" | grep "$item" | awk '{print $1}')
	if [[ $pid =~ $is_number_re ]]; then
		sudo kill -9 "$pid" &>/dev/null || true
	fi
done

# User Services

# NOTE: Don't disable the following ones:
# com.apple.bird      -> Annoying message about iCloud pops up randomly.
# com.apple.contactsd -> Spotlight search and share stop working.


user_services=(
	# Diagnostics and usage reporting
	com.apple.DiagnosticsReporter
	com.apple.ReportCrash

	# Apple Pay and Wallet daemon
	com.apple.financed

	# GameKit services
	com.apple.gamed

	# Classroom's student control agent
	com.apple.studentd

	# Primarily involved in gathering data from experiments
	# assigned through CloudKit.
	com.apple.triald

	# Siri-related daemons
	com.apple.siriactionsd
	com.apple.siriknowledged
	com.apple.sirittsd
	com.apple.SiriTTSTrainingAgent

	com.apple.suggestd
	com.apple.tipsd
)
user_services_launchctl="$(launchctl list)"

uid=$(id -u)
for item in "${user_services[@]}"; do
	echo "Disabling user/$uid/$item ..."
	# `bootout` only possible if SIP is disabled.
	# launchctl bootout "gui/$uid/$item"
	launchctl disable "gui/$uid/$item"

	pid=$(echo "$user_services_launchctl" | grep "$item" | awk '{print $1}')
	if [[ $pid =~ $is_number_re ]]; then
		kill -9 "$pid" &>/dev/null || true
	fi
done
