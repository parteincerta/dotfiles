#!/usr/bin/env bash

# System Services
system_services=(
	com.apple.AppStoreDaemon.StorePrivilegedODRService
	com.apple.AppStoreDaemon.StorePrivilegedTaskService
	com.apple.EmbeddedOSInstallService
	com.apple.XProtect.daemon.scan
	com.apple.XProtect.daemon.scan.startup
	com.apple.XprotectFramework.PluginService
	com.apple.analyticsd
	com.apple.appstored
	com.apple.biomed
	com.apple.icloud.findmydeviced
	com.apple.icloud.searchpartyd
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

# NOTE: Don't disable the following ones:
# com.apple.bird      -> Annoying message about iCloud pops up randomly.
# com.apple.contactsd -> Spotlight search and share stop working.

user_services=(
	com.apple.BTServer.cloudpairing
	com.apple.GameController.gamecontrolleragentd
	com.apple.Safari.History
	com.apple.Safari.PasswordBreachAgent
	com.apple.Safari.SafeBrowsing.Service
	com.apple.SafariBookmarksSyncAgent
	com.apple.SafariHistoryServiceAgent
	com.apple.SafariLaunchAgent
	com.apple.SafariNotificationAgent
	com.apple.amsengagementd
	com.apple.ap.adprivacyd
	com.apple.ap.promotedcontentd
	com.apple.appstoreagent
	com.apple.appstorecomponentsd
	com.apple.assistantd
	com.apple.betaenrollmentd
	com.apple.calaccessd
	com.apple.cloudd
	com.apple.cmio.ContinuityCaptureAgent
	com.apple.commerce
	com.apple.corespeechd
	com.apple.financed
	com.apple.gamed
	com.apple.homed
	com.apple.icloud.fmfd
	com.apple.imagent
	com.apple.email.maild
	com.apple.familycircled
	com.apple.familycontrols.useragent
	com.apple.familynotificationd
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
uid=$(id -u)
for item in "${user_services[@]}"; do
	echo "Disabling user/$uid/$item ..."
	launchctl disable "user/$uid/$item"
done
