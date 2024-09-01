#!/usr/bin/env bash

# System Services
system_services=(
	com.apple.EmbeddedOSInstallService
	com.apple.biomed
	com.apple.mobile.obliteration # Remote device wipe functionality
	com.apple.ospredictiond       # Predicts OS conditions
	com.apple.touchbarserver
)
for item in "${system_services[@]}"; do
	echo "Disabling system/$item ..."
	sudo launchctl disable "system/$item"
done
