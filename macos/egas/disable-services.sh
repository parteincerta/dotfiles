#!/usr/bin/env bash

# System Services
system_services=(
	# Application malware scane
	com.apple.XProtect.daemon.scan
	com.apple.XProtect.daemon.scan.startup
	com.apple.XprotectFramework.PluginService

	# Diagnostics and usage data collection
	com.apple.analyticsd

	# Predicts OS conditions
	com.apple.ospredictiond
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
	# Application malware scane
	com.apple.XProtect.daemon.scan
	com.apple.XProtect.daemon.scan.startup
	com.apple.XprotectFramework.PluginService

	# Apple Pay and Wallet daemon
	com.apple.financed

	# GameKit services
	com.apple.gamed

	com.apple.studentd

	# Primarily involved in gathering data from experiments
	# assigned through CloudKit.
	com.apple.triald
)
uid=$(id -u)
for item in "${user_services[@]}"; do
	echo "Disabling user/$uid/$item ..."
	launchctl disable "user/$uid/$item"
done
