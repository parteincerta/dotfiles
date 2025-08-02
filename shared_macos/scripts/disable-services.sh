#!/usr/bin/env bash

system_services=(
	com.apple.GameController.gamecontrollerd
	com.apple.XProtect.daemon.scan
	com.apple.XProtect.daemon.scan.startup
	com.apple.XprotectFramework.PluginService
	com.apple.analyticsd
	com.apple.audioanalyticsd
	com.apple.backupd
	com.apple.backupd-helper
	com.apple.diagnosticd
	com.apple.ecosystemanalyticsd
	com.apple.familycontrols
	com.apple.logd
	com.apple.mobile.softwareupdated
	com.apple.ospredictiond
	com.apple.rtcreportingd
	com.apple.security.syspolicy
	com.apple.siriinferenced
	com.apple.softwareupdated
	com.apple.syslogd
	com.apple.triald.system
	com.apple.wifianalyticsd
)
for item in "${system_services[@]}"; do
	echo "Disabling system/$item ..."
	sudo launchctl bootout "system/$item"
	sudo launchctl disable "system/$item"
done

user_services=(
	com.apple.ContextStoreAgent
	com.apple.DiagnosticsReporter
	com.apple.GameController.gamecontrolleragentd
	com.apple.ManagedClientAgent.enrollagent
	com.apple.ReportCrash
	com.apple.ScreenTimeAgent
	com.apple.Siri.agent
	com.apple.SiriTTSTrainingAgent
	com.apple.SoftwareUpdateNotificationManager
	com.apple.TMHelperAgent
	com.apple.TMHelperAgent.SetupOffer
	com.apple.UsageTrackingAgent
	com.apple.WiFiVelocityAgent
	com.apple.XProtect.agent.scan
	com.apple.XProtect.daemon.scan
	com.apple.XProtect.daemon.scan.startup
	com.apple.XprotectFramework.PluginService
	com.apple.accessibility.MotionTrackingAgent
	com.apple.accessibility.axassetsd
	com.apple.accessibility.heard
	com.apple.ap.adprivacyd
	com.apple.ap.adservicesd
	com.apple.ap.promotedcontentd
	com.apple.assistant_cdmd
	com.apple.assistant_service
	com.apple.assistantd
	com.apple.betaenrollmentd
	com.apple.corespeechd
	com.apple.diagnosticextensionsd
	com.apple.diagnostics_agent
	com.apple.familycircled
	com.apple.familycontrols.useragent
	com.apple.familynotificationd
	com.apple.financed
	com.apple.gamed
	com.apple.generativeexperiencesd
	com.apple.geoanalyticsd
	com.apple.geodMachServiceBridge
	com.apple.helpd
	com.apple.homed
	com.apple.inputanalyticsd
	com.apple.intelligencecontextd
	com.apple.intelligenceflowd
	com.apple.intelligenceplatformd
	com.apple.knowledge-agent
	com.apple.knowledgeconstructiond
	com.apple.macos.studentd
	com.apple.naturallanguaged
	com.apple.newsd
	com.apple.parsec-fbf
	com.apple.parsecd
	com.apple.routined
	com.apple.siri.context.service
	com.apple.siriactionsd
	com.apple.siriinferenced
	com.apple.siriknowledged
	com.apple.sirittsd
	com.apple.suggestd
	com.apple.tipsd
	com.apple.triald
	com.apple.voicebankingd
)

uid=$(id -u)
for item in "${user_services[@]}"; do
	echo "Disabling user/$uid/$item ..."
	launchctl bootout "user/$uid/$item"
	launchctl disable "user/$uid/$item"
done
