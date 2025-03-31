#!/usr/bin/env bash

system_services=(
	com.apple.GameController.gamecontrollerd
	com.apple.analyticsd
	com.apple.backupd
	com.apple.backupd-helper
	com.apple.familycontrols
	com.apple.ospredictiond
	com.apple.rtcreportingd
	com.apple.security.syspolicy
	com.apple.siriinferenced
	com.apple.triald.system
	com.apple.wifianalyticsd
)
for item in "${system_services[@]}"; do
	echo "Disabling system/$item ..."
	sudo launchctl bootout "system/$item"
	sudo launchctl disable "system/$item"
done

user_services=(
	com.apple.DiagnosticsReporter
	com.apple.GameController.gamecontrolleragentd
	com.apple.ReportCrash
	com.apple.SiriTTSTrainingAgent
	com.apple.Siri.agent
	com.apple.TMHelperAgent
	com.apple.TMHelperAgent.SetupOffer
	com.apple.UsageTrackingAgent
	com.apple.WiFiVelocityAgent
	com.apple.ap.adprivacyd
	com.apple.ap.adservicesd
	com.apple.ap.promotedcontentd
	com.apple.assistant_service
	com.apple.assistantd
	com.apple.betaenrollmentd
	com.apple.corespeechd
	com.apple.familycircled
	com.apple.familycontrols.useragent
	com.apple.familynotificationd
	com.apple.financed
	com.apple.gamed
	com.apple.intelligenceplatformd
	com.apple.knowledge-agent
	com.apple.macos.studentd
	com.apple.newsd
	com.apple.parsec-fbf
	com.apple.parsecd
	com.apple.routined
	com.apple.siri.context.service
	com.apple.siriactionsd
	com.apple.siriknowledged
	com.apple.sirittsd
	com.apple.suggestd
	com.apple.tipsd
	com.apple.triald
)

uid=$(id -u)
for item in "${user_services[@]}"; do
	echo "Disabling user/$uid/$item ..."
	launchctl bootout "user/$uid/$item"
	launchctl disable "user/$uid/$item"
done
