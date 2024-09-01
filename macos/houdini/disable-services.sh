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
	com.apple.siriinferenced
	com.apple.touchbarserver
	com.apple.triald.system
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
  com.apple.bird
  com.apple.cloudd
  com.apple.cmio.ContinuityCaptureAgent
  com.apple.commerce
  com.apple.gamed
  com.apple.homed
  com.apple.imagent
  com.apple.email.maild
  com.apple.parsec-fbf
  com.apple.parsecd
  com.apple.photoanalysisd
  com.apple.photolibraryd
  com.apple.routined
  com.apple.security.keychain-circle-notification
  com.apple.siriactionsd
  com.apple.storedownloadd
  com.apple.studentd
  com.apple.suggestd
  com.apple.triald
)
for item in "${user_services[@]}"; do
	echo "Disabling user/501/$item ..."
	launchctl disable "user/501/$item"
done
