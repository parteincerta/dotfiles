#!/usr/bin/env bash

# System Services
system_services=(
  com.apple.AppStoreDaemon.StorePrivilegedODRService
  com.apple.AppStoreDaemon.StorePrivilegedTaskService
	com.apple.EmbeddedOSInstallService
	com.apple.appstored
	com.apple.biomed
	com.apple.mobile.obliteration # Remote device wipe functionality
	com.apple.ospredictiond       # Predicts OS conditions
	com.apple.touchbarserver
)
for item in "${system_services[@]}"; do
	echo "Disabling system/$item ..."
	sudo launchctl disable "system/$item"
done

# User Services
user_services=(
  com.apple.GameController.gamecontrolleragentd
  com.apple.Safari.History
  com.apple.Safari.PasswordBreachAgent
  com.apple.Safari.SafeBrowsing.Service
  com.apple.SafariBookmarksSyncAgent
  com.apple.SafariHistoryServiceAgent
  com.apple.SafariLaunchAgent
  com.apple.SafariNotificationAgent
  com.apple.appstoreagent
  com.apple.appstorecomponentsd
  com.apple.assistantd
  com.apple.gamed
  com.apple.homed
  com.apple.imagent
  com.apple.suggestd
)
for item in "${user_services[@]}"; do
	echo "Disabling user/501/$item ..."
	launchctl disable "user/501/$item"
done
