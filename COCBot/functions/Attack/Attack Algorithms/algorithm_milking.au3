; #FUNCTION# ====================================================================================================================
; Name ..........: algorith_milking based on algorithm_AllTroops
; Description ...: This file contens all functions to attack algorithm for milking , using max 90 Goblins
; Syntax ........: algorithm_milking()
; Parameters ....: None
; Return values .: None
; Author ........: Noyax37 (01/2016)
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func algorithm_milking() ;Attack Algorithm for milking
	If $debugSetlog=1 Then 		Setlog("algorithm_milking",$COLOR_PURPLE)
	$King = -1
	$Queen = -1
	$CC = -1
	$Warden = -1
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $eCastle Then
			$CC = $i
		ElseIf $atkTroops[$i][0] = $eKing Then
			$King = $i
		ElseIf $atkTroops[$i][0] = $eQueen Then
			$Queen = $i
		ElseIf $atkTroops[$i][0] = $eWarden Then
			$Warden = $i
		EndIf
	Next
	If $debugSetlog=1 Then SetLog("Use king  SLOT n� " & $King, $COLOR_PURPLE)
	If $debugSetlog=1 Then SetLog("Use queen SLOT n� " & $Queen, $COLOR_PURPLE)
	If $debugSetlog=1 Then SetLog("Use CC SLOT n� " & $CC, $COLOR_PURPLE)
	If $debugSetlog=1 Then SetLog("Use Warden SLOT n� " & $Warden, $COLOR_PURPLE)


	If _Sleep($iDelayalgorithm_AllTroops1) Then Return

	If $iMatchMode = $TS  Then
		SwitchAttackTHType()
		If $zoomedin = True Then
			ZoomOut()
			$zoomedin = False
			$zCount = 0
			$sCount = 0
		EndIf
	EndIf

	;If $OptTrophyMode = 1 And SearchTownHallLoc() Then; Return ;Exit attacking if trophy hunting and not bullymode
	If $iMatchMode = $TS   Then; Return ;Exit attacking if trophy hunting and not bullymode
	  If  ($THusedKing = 0 and $THusedQueen=0 ) Then
		 Setlog("Wait few sec before close attack")
		 If _Sleep(random(2,5,1)*1000) Then Return ;wait 2-5 second before exit if king and queen are not dropped
	  Else
		 SetLog("King and/or Queen dropped, close attack")
	  EndIf

		;close battle
		For $i = 1 To 30
			;_CaptureRegion()
			If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) = True Then ExitLoop ;exit if not 'no star'
			If _Sleep($iDelayalgorithm_AllTroops2) Then Return
		Next

		If IsAttackPage() Then ClickP($aSurrenderButton, 1, 0, "#0030") ;Click Surrender
		If _Sleep($iDelayalgorithm_AllTroops3) Then Return
		If IsEndBattlePage() Then
		   ClickP($aConfirmSurrender, 1, 0, "#0031") ;Click Confirm
		   If _Sleep($iDelayalgorithm_AllTroops1) Then Return
		 EndIf
		Return
	EndIf

	If ($iChkRedArea[$iMatchMode]) Then
		SetLog("Calculating Smart Attack Strategy", $COLOR_BLUE)
		Local $hTimer = TimerInit()
		_WinAPI_DeleteObject($hBitmapFirst)
		$hBitmapFirst = _CaptureRegion2()
		_GetRedArea()

		SetLog("Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		;SetLog("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
		;SetLog("	[" & UBound($PixelTopRight) & "] pixels TopRight")
		;SetLog("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
		;SetLog("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")


		If ($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) Then
			SetLog("Locating Mines, Collectors & Drills", $COLOR_BLUE)
			$hTimer = TimerInit()
			Global $PixelMine[0]
			Global $PixelElixir[0]
			Global $PixelDarkElixir[0]
			Global $PixelNearCollector[0]
			; If drop troop near gold mine
			If ($iChkSmartAttack[$iMatchMode][0] = 1) Then
				$PixelMine = GetLocationMine()
				If (IsArray($PixelMine)) Then
					_ArrayAdd($PixelNearCollector, $PixelMine)
				EndIf
			EndIf
			; If drop troop near elixir collector
			If ($iChkSmartAttack[$iMatchMode][1] = 1) Then
				$PixelElixir = GetLocationElixir()
				If (IsArray($PixelElixir)) Then
					_ArrayAdd($PixelNearCollector, $PixelElixir)
				EndIf
			EndIf
			; If drop troop near dark elixir drill
			If ($iChkSmartAttack[$iMatchMode][2] = 1) Then
				$PixelDarkElixir = GetLocationDarkElixir()
				If (IsArray($PixelDarkElixir)) Then
					_ArrayAdd($PixelNearCollector, $PixelDarkElixir)
				EndIf
			EndIf
			SetLog("Located  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			SetLog("[" & UBound($PixelMine) & "] Gold Mines")
			SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
			SetLog("[" & UBound($PixelDarkElixir) & "] Dark Elixir Drill/s")
			$iNbrOfDetectedMines[$iMatchMode] += UBound($PixelMine)
			$iNbrOfDetectedCollectors[$iMatchMode] += UBound($PixelElixir)
			$iNbrOfDetectedDrills[$iMatchMode] += UBound($PixelDarkElixir)
			UpdateStats()
		EndIf

	EndIf

	;############################################# LSpell Attack ############################################################
	; DropLSpell()
	;########################################################################################################################
	Local $nbSides = 0
	SetLog("Attacking on all sides", $COLOR_BLUE)
	$nbSides = 4
	If _Sleep($iDelayalgorithm_AllTroops2) Then Return

	If $debugSetlog =1 Then SetLog("listdeploy standard for attack", $COLOR_PURPLE)
	; $ListInfoDeploy = [Troop, No. of Sides, $WaveNb, $MaxWaveNb, $slotsPerEdge]
		Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
			, [$eWall, $nbSides, 1, 1, 2] _
			, [$eBarb, $nbSides, 1, 2, 2] _
			, [$eArch, $nbSides, 1, 3, 3] _
			, [$eBarb, $nbSides, 2, 2, 2] _
			, [$eArch, $nbSides, 2, 3, 3] _
			, ["CC", 1, 1, 1, 1] _
			, ["HEROES", 1, 2, 1, 0] _
			, [$eHogs, $nbSides, 1, 1, 1] _
			, [$eWiza, $nbSides, 1, 1, 0] _
			, [$eMini, $nbSides, 1, 1, 0] _
			, [$eArch, $nbSides, 3, 3, 2] _
			, [$eGobl, $nbSides, 1, 1, 1] _
			]


	LaunchTroop2($listInfoDeploy, $CC, $King, $Queen, $Warden)

	If _Sleep($iDelayalgorithm_AllTroops4) Then Return

	;Activate KQ's power
	If ($checkKPower Or $checkQPower) And $iActivateKQCondition = "Manual" Then
		SetLog("Waiting " & $delayActivateKQ / 1000 & " seconds before activating Hero abilities", $COLOR_BLUE)
		If _Sleep($delayActivateKQ) Then Return
		If $checkKPower Then
			SetLog("Activating King's power", $COLOR_BLUE)
			SelectDropTroop($King)
			$checkKPower = False
		EndIf
		If $checkQPower Then
			SetLog("Activating Queen's power", $COLOR_BLUE)
			SelectDropTroop($Queen)
			$checkQPower = False
		EndIf
	EndIf

	SetLog("Finished Attacking, waiting for the battle to end")

EndFunc   ;==>algorithm_milking

