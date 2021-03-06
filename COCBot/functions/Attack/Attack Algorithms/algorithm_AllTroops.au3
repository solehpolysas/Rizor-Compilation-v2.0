; #FUNCTION# ====================================================================================================================
; Name ..........: algorith_AllTroops
; Description ...: This file contens all functions to attack algorithm will all Troops , using Barbarians, Archers, Goblins, Giants and Wallbreakers as they are available
; Syntax ........: algorithm_AllTroops()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Didipe (May-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func algorithm_AllTroops() ;Attack Algorithm for all existing troops
	If $debugSetlog=1 Then 		Setlog("algorithm_AllTroops",$COLOR_PURPLE)
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

;Noyax top
	If $iMatchMode = $TS And $iOptAttIfDB = 1 Then
		Local $SaveSetting = 1
		$iMatchMode = $DB
	Else
		Local $SaveSetting = 0
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
			Local $PixelMineToAttack[0]
			Global $PixelElixir[0]
			Local $PixelElixirToAttack[0]
			Global $PixelDarkElixir[0]
			Local $PixelDarkElixirToAttack[0]
			Global $PixelNearCollector[0]
			; If drop troop near gold mine
			If ($iChkSmartAttack[$iMatchMode][0] = 1) Then
				SetLog("Get Location of Mines...")
				$PixelMine = GetLocationMine()
				If (IsArray($PixelMine)) Then
					For $i = 0 To UBound($PixelMine) - 1
						Local $pixelTemp = $PixelMine[$i]
						Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, True)
						Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
						If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed) Then
							Local $tmpArrayOfPixel[1]
							$tmpArrayOfPixel[0] = $pixelTemp
							_ArrayAdd($PixelMineToAttack, $tmpArrayOfPixel)
						EndIf
					Next
					_ArrayAdd($PixelNearCollector, $PixelMineToAttack)
				EndIf
			EndIf
			; If drop troop near elixir collector
			If ($iChkSmartAttack[$iMatchMode][1] = 1) Then
				SetLog("Get Location of Elixir Collectors...")
				$PixelElixir = GetLocationElixir()
				If (IsArray($PixelElixir)) Then
					For $i = 0 To UBound($PixelElixir) - 1
						Local $pixelTemp = $PixelElixir[$i]
						Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, True)
						Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
						If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed) Then
							Local $tmpArrayOfPixel[1]
							$tmpArrayOfPixel[0] = $pixelTemp
							_ArrayAdd($PixelElixirToAttack, $tmpArrayOfPixel)
						EndIf
					Next
					_ArrayAdd($PixelNearCollector, $PixelElixirToAttack)
				EndIf
			EndIf
			; If drop troop near dark elixir drill
			If ($iChkSmartAttack[$iMatchMode][2] = 1) Then
				SetLog("Get Location of Dark Elixir Drills...")
				$PixelDarkElixir = GetLocationDarkElixir()
				If (IsArray($PixelDarkElixir)) Then
					For $i = 0 To UBound($PixelDarkElixir) - 1
						Local $pixelTemp = $PixelDarkElixir[$i]
						Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, True)
						Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
						If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed) Then
							Local $tmpArrayOfPixel[1]
							$tmpArrayOfPixel[0] = $pixelTemp
							_ArrayAdd($PixelDarkElixirToAttack, $tmpArrayOfPixel)
						EndIf
					Next
					_ArrayAdd($PixelNearCollector, $PixelDarkElixirToAttack)
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

	If $SaveSetting = 1 Then
		Local $SaveSetting = 0
		$iMatchMode = $TS
	EndIf

	If $iMatchMode = $DB Then
		$TypeAtt = "DB" ; for stats
		setlog("Type attack = " & $TypeAtt)
	EndIf
	If $iMatchMode = $LB Then
		$TypeAtt = "LB" ; for stats
		setlog("Type attack = " & $TypeAtt)
	EndIf

;Noyax bottom

	If $iMatchMode = $TS  Then
;Noyax top for stats
		If $SnipeChangedSettings = True	Then
			$TypeAtt = "SWT"
		Else
			$TypeAtt = "TS"
		Endif
		setlog("Type attack = " & $TypeAtt)
; Noyax bottom
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
; Noyax		 If _Sleep(random(2,5,1)*1000) Then Return ;wait 2-5 second before exit if king and queen are not dropped
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

	;############################################# LSpell Attack ############################################################
	; DropLSpell()
	;########################################################################################################################
	Local $nbSides = 0
	Switch $iChkDeploySettings[$iMatchMode]
		Case 0 ;Single sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on a single side", $COLOR_BLUE)
			$nbSides = 1
		Case 1 ;Two sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on two sides", $COLOR_BLUE)
			$nbSides = 2
		Case 2 ;Three sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on three sides", $COLOR_BLUE)
			$nbSides = 3
		Case 3 ;All sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on all sides", $COLOR_BLUE)
			$nbSides = 4
		Case 4 ;DE Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Dark Elixir Side.", $COLOR_BLUE)
			$nbSides = 1
			If NOT ($iChkRedArea[$iMatchMode]) Then GetBuildingEdge($eSideBuildingDES) ; Get DE Storage side when Redline is not used.
		Case 5 ;TH Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Town Hall Side.", $COLOR_BLUE)
			$nbSides = 1
			If NOT ($iChkRedArea[$iMatchMode]) Then GetBuildingEdge($eSideBuildingTH) ; Get Townhall side when Redline is not used.
	EndSwitch
	If ($nbSides = 0) Then Return
	If _Sleep($iDelayalgorithm_AllTroops2) Then Return

	; $ListInfoDeploy = [Troop, No. of Sides, $WaveNb, $MaxWaveNb, $slotsPerEdge]
	If $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 Then   ; Customise DE side wave deployment here
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
	Else
; Noyax top
		If $MilkAtt = 1 then
			If $debugSetlog =1 Then SetLog("listdeploy for milking", $COLOR_PURPLE)
                ;Noyax add Ancient begin archer milking
			Local $listInfoDeploy[5][5] = [[$eGobl, $nbSides, 1, 1, 0] _
				, [$eBarb, 1, 1, 1, 2] _
				, [$eArch, 1, 1, 1, 1] _
				, ["CC", 1, 1, 1, 1] _
				, ["HEROES", 1, 2, 1, 1] _
				]
                ;Noyax add Ancient end archer milking
		Else
; Noyax bottom
			If $debugSetlog =1 Then SetLog("listdeploy standard for attack", $COLOR_PURPLE)
			Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
				, [$eBarb, $nbSides, 1, 2, 0] _
				, [$eWall, $nbSides, 1, 1, 1] _
				, [$eArch, $nbSides, 1, 2, 0] _
				, [$eBarb, $nbSides, 2, 2, 0] _
				, [$eGobl, $nbSides, 1, 2, 0] _
				, ["CC", 1, 1, 1, 1] _
				, [$eHogs, $nbSides, 1, 1, 1] _
				, [$eWiza, $nbSides, 1, 1, 0] _
				, [$eMini, $nbSides, 1, 1, 0] _
				, [$eArch, $nbSides, 2, 2, 0] _
				, [$eGobl, $nbSides, 2, 2, 0] _
				, ["HEROES", 1, 2, 1, 1] _
				]
		EndIf ;Noyax

	EndIf

	LaunchTroop2($listInfoDeploy, $CC, $King, $Queen, $Warden)

	If _Sleep($iDelayalgorithm_AllTroops4) Then Return
	If $MilkAtt = 1 then ;Noyax
		SetLog("The End") ;Noyax
	Else ;Noyax
		SetLog("Dropping left over troops", $COLOR_BLUE)
		For $x = 0 To 1
			PrepareAttack($iMatchMode, True) ;Check remaining quantities
			For $i = $eBarb To $eLava ; lauch all remaining troops
				;If $i = $eBarb Or $i = $eArch Then
				LauchTroop($i, $nbSides, 0, 1)
				CheckHeroesHealth()
				;Else
				;	 LauchTroop($i, $nbSides, 0, 1, 2)
				;EndIf
				If _Sleep($iDelayalgorithm_AllTroops5) Then Return
			Next
		Next
	EndIf ;Noyax
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
EndFunc   ;==>algorithm_AllTroops

