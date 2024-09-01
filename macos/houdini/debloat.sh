#!/usr/bin/env bash

# NOTE: Based on https://github.com/Wamphyre/macOS_Silverback-Debloater

defaults write com.apple.loginwindow TALLogoutSavesState -bool false

services=(com.apple.CallHistoryPluginHelper com.apple.AddressBook.abd
	com.apple.ReportPanic com.apple.ReportCrash com.apple.ReportCrash.Self
	com.apple.siriknowledged com.apple.helpd com.apple.mobiledeviceupdater
	com.apple.TrustEvaluationAgent com.apple.iTunesHelper.launcher
	com.apple.softwareupdate_notify_agent com.apple.appstoreagent
	com.apple.familycircled com.apple.SafariCloudHistoryPushAgent
	com.apple.Safari.SafeBrowsing.Service com.apple.SafariNotificationAgent
	com.apple.SafariPlugInUpdateNotifier com.apple.SafariHistoryServiceAgent
	com.apple.SafariLaunchAgent com.apple.SafariPlugInUpdateNotifier
	com.apple.safaridavclient)
for item in "${services[@]}"; do
	echo "Removing $item ..."
	sudo launchctl remove "$item"
done


services=(com.apple.analyticsd com.apple.mediaanalysisd com.apple.photoanalysisd
	com.apple.java.InstallOnDemand com.apple.voicememod com.apple.geod
	com.apple.locate com.apple.locationd com.apple.netbiosd com.apple.recentsd
	com.apple.suggestd com.apple.metadata.mds.spindump com.apple.ReportPanic
	com.apple.ReportCrash com.apple.ReportCrash.Self
	com.apple.DiagnosticReportCleanup)
for item in "${services[@]}"; do
	echo "Disabling system/$item ..."
	sudo launchctl disable "system/$item"
done

launchctl unload -w /System/Library/LaunchAgents/com.apple.cloudpaird.plist

user_agents=(com.apple.AddressBook.ContactsAccountsService
com.apple.AMPArtworkAgent com.apple.AMPDeviceDiscoveryAgent
com.apple.AMPLibraryAgent com.apple.ap.adprivacyd com.apple.ap.adservicesd
com.apple.ap.promotedcontentd com.apple.assistant_service com.apple.assistantd
com.apple.avconferenced com.apple.BiomeAgent com.apple.biomesyncd
com.apple.CalendarAgent com.apple.calaccessd com.apple.CallHistoryPluginHelper
com.apple.cloudd com.apple.cloudpaird com.apple.cloudphotod
com.apple.CloudPhotosConfiguration com.apple.CloudSettingsSyncAgent
com.apple.ContactsAgent com.apple.CoreLocationAgent
com.apple.dataaccess.dataaccessd com.apple.familycircled
com.apple.familycontrols.useragent com.apple.familynotificationd
com.apple.financed com.apple.gamed com.apple.geodMachServiceBridge
com.apple.homed com.apple.icloud.fmfd com.apple.iCloudNotificationAgent
com.apple.iCloudUserNotifications com.apple.icloud.searchpartyuseragent
com.apple.imagent com.apple.imautomatichistorydeletionagent
com.apple.imtransferagent com.apple.intelligenceplatformd com.apple.itunescloudd
com.apple.knowledge-agent com.apple.ManagedClient.cloudconfigurationd
com.apple.ManagedClientAgent.enrollagent com.apple.Maps.mapspushd
com.apple.Maps.pushdaemon com.apple.mediaanalysisd
com.apple.mediastream.mstreamd com.apple.newsd com.apple.parsec-fbf
com.apple.parsecd com.apple.passd com.apple.photoanalysisd
com.apple.photolibraryd com.apple.protectedcloudstorage.protectedcloudkeysyncing
com.apple.quicklook com.apple.quicklook.ui.helper
com.apple.quicklook.ThumbnailsAgent com.apple.rapportd-user
com.apple.SafariCloudHistoryPushAgent com.apple.ScreenTimeAgent
com.apple.sidecar-hid-relay com.apple.sidecar-relay com.apple.Siri.agent
com.apple.siri.context.service com.apple.macos.studentd com.apple.siriknowledged
com.apple.suggestd com.apple.tipsd com.apple.telephonyutilities.callservicesd
com.apple.TMHelperAgent com.apple.TMHelperAgent.SetupOffer com.apple.triald
com.apple.universalaccessd com.apple.UsageTrackingAgent
com.apple.videosubscriptionsd com.apple.WiFiVelocityAgent)
for item in "${user_agents[@]}"
do
	echo "Disabling gui/501/$item ..."
	sudo launchctl bootout "gui/501/$item"
	sudo launchctl disable "gui/501/$item"
done

system_agents=(com.apple.backupd com.apple.backupd-helper com.apple.cloudd
com.apple.cloudpaird com.apple.cloudphotod com.apple.CloudPhotosConfiguration
com.apple.CoreLocationAgent com.apple.coreduetd com.apple.familycontrols
com.apple.findmymacmessenger com.apple.GameController.gamecontrollerd
com.apple.icloud.fmfd com.apple.icloud.searchpartyd com.apple.itunescloudd
com.apple.ManagedClient.cloudconfigurationd
com.apple.protectedcloudstorage.protectedcloudkeysyncing
com.apple.siri.morphunassetsupdaterd com.apple.siriinferenced
com.apple.triald.system com.apple.wifianalyticsd)

for item in "${system_agents[@]}"
do
	echo "Disabling system/501/$item ..."
	sudo launchctl bootout "system/$item"
	sudo launchctl disable "system/$item"
done
