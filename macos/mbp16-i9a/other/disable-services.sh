#!/usr/bin/env bash

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
for item in "${system_services[@]}"; do
	echo "Disabling system/$item ..."
	sudo launchctl disable "system/$item"
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
	com.apple.triald

	com.apple.tipsd
)
uid=$(id -u)
for item in "${user_services[@]}"; do
	echo "Disabling user/$uid/$item ..."
	launchctl disable "user/$uid/$item"
done
