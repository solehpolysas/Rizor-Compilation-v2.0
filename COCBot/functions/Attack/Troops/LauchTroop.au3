; #FUNCTION# ====================================================================================================================
; Name ..........: Launchtroop
; Description ...: This file contens all functions to launch troop
; Syntax ........: LauchTroop($troopKind, $nbSides, $waveNb, $maxWaveNb, $slotsPerEdge = 0)
; Syntax ........: LaunchTroop2($listInfoDeploy, $CC, $King, $Queen, $Warden)
; Syntax ........: LaunchTroop3($listInfoDeploy, $CC, $King, $Queen, $Warden)
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......: Noyax37 (01/2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LauchTroop($troopKind, $nbSides, $waveNb, $maxWaveNb, $slotsPerEdge = 0)
	Local $troop = -1
	Local $troopNb = 0
	Local $name = ""
	For $i = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
		If $atkTroops[$i][0] = $troopKind Then
			$troop = $i
			$troopNb = Ceiling($atkTroops[$i][1] / $maxWaveNb)
			Local $plural = 0
			If $troopNb > 1 Then $plural = 1
			$name = NameOfTroop($troopKind, $plural)
		EndIf
	Next

	If ($troop = -1) Or ($troopNb = 0) Then
		;if $waveNb > 0 Then SetLog("Skipping wave of " & $name & " (" & $troopKind & ") : nothing to drop" )
		Return False; nothing to do => skip this wave
	EndIf

	Local $waveName = "first"
	If $waveNb = 2 Then $waveName = "second"
	If $waveNb = 3 Then $waveName = "third"
	If $maxWaveNb = 1 Then $waveName = "only"
	If $waveNb = 0 Then $waveName = "last"
	SetLog("Dropping " & $waveName & " wave of " & $troopNb & " " & $name, $COLOR_GREEN)

	DropTroop($troop, $nbSides, $troopNb, $slotsPerEdge)
	Return True
EndFunc   ;==>LauchTroop

Func LaunchTroop2($listInfoDeploy, $CC, $King, $Queen, $Warden)
;$debugSetlog =1
	$countFindPixCloser = 0 ;noyax for count exposed collectors
	$countCollectorexposed = 0 ;noyax for count exposed collectors
	If $debugSetlog =1 Then SetLog("LaunchTroop2 with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)
	Local $listListInfoDeployTroopPixel[0]

;Noyax based on Jarrick
	If $MilkAtt = 1 And ($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) Then
		If UBound($PixelNearCollector) = 0 Then
			Setlog ("There are no any collectors or mines close to the RedLine... skip dead base")
			$Restart = True
			$Is_ClientSyncError = True
			Return
		EndIf
	EndIf
;noyax bottom

	If ($iChkRedArea[$iMatchMode] = 1) Then
		For $i = 0 To UBound($listInfoDeploy) - 1
			Local $troop = -1
			Local $troopNb = 0
			Local $name = ""
	; $ListInfoDeploy = [Troop, No. of Sides, $WaveNb, $MaxWaveNb, $slotsPerEdge]
			$troopKind = $listInfoDeploy[$i][0]
			$nbSides = $listInfoDeploy[$i][1]
			$waveNb = $listInfoDeploy[$i][2]
			$maxWaveNb = $listInfoDeploy[$i][3]
			$slotsPerEdge = $listInfoDeploy[$i][4]
			If $debugSetlog =1 Then SetLog("**ListInfoDeploy row " & $i & ": USE "  &$troopKind & " SIDES " &  $nbSides & " WAVE " & $waveNb & " XWAVE " & $maxWaveNb & " SLOTXEDGE " & $slotsPerEdge, $COLOR_PURPLE)
			If (IsNumber($troopKind)) Then
				For $j = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
					If $atkTroops[$j][0] = $troopKind Then
						$troop = $j
						If $MilkAtt = 1 and $troopKind = $eGobl then ;Noyax if gobs set max troops to $NbTrpMilk
							local $needGobsForColl = UBound($PixelNearCollector) * Number($DBUseGobsForCollector)

							If $atkTroops[$j][1]> ($needGobsForColl + $iTSGoblReserve) Then ;Noyax + Ancient
								$troopNb = Ceiling($needGobsForColl / $maxWaveNb) ;Noyax + Ancient
							ElseIf $atkTroops[$j][1]> $iTSGoblReserve Then  ;Noyax + Ancient
								$troopNb = Ceiling(($atkTroops[$j][1] - $iTSGoblReserve) / $maxWaveNb) ;Noyax + Ancient
							EndIf ;Noyax
							SetLog("Use only " & $troopNb & " Goblins for attack " & UBound($PixelNearCollector) & " collectors")
						;Noyax add Ancient begin archer milking
						ElseIf $MilkAtt = 1 and $troopKind = $eArch then
							local $needArchsForColl = UBound($PixelNearCollector) * Number($DBUseArchForCollector)
							If $atkTroops[$j][1]> ($needArchsForColl + $iTSArchReserve) Then
								$troopNb = Ceiling($needArchsForColl / $maxWaveNb)
							ElseIf $atkTroops[$j][1]> $iTSArchReserve Then ;Noyax
								$troopNb = Ceiling(($atkTroops[$j][1]-$iTSArchReserve) / $maxWaveNb)
							EndIf
						;Noyax add Ancient end archer milking
						;Noyax add Rizor begin Barbarian milking
						ElseIf $MilkAtt = 1 and $troopKind = $eBarb then
							local $needBarbForColl = UBound($PixelNearCollector) * Number($DBUseBarbForCollector)
							If $atkTroops[$j][1]> ($needBarbForColl + $iTSArchReserve) Then
								$troopNb = Ceiling($needBarbForColl / $maxWaveNb)
							ElseIf $atkTroops[$j][1]> $iTSBarbReserve Then ;Noyax
								$troopNb = Ceiling(($atkTroops[$j][1]-$iTSBarbReserve) / $maxWaveNb)
							EndIf
						;Noyax add Rizor end Barbarian milking
						Else ;Noyax
							$troopNb = Ceiling($atkTroops[$j][1] / $maxWaveNb)
						EndIf ;Noyax
						Local $plural = 0
						If $troopNb > 1 Then $plural = 1
						$name = NameOfTroop($troopKind, $plural)
					EndIf
				Next
			EndIf
			If ($troop <> -1 And $troopNb > 0) Or IsString($troopKind) Then
				Local $listInfoDeployTroopPixel
				If (UBound($listListInfoDeployTroopPixel) < $waveNb) Then
					ReDim $listListInfoDeployTroopPixel[$waveNb]
					Local $newListInfoDeployTroopPixel[0]
					$listListInfoDeployTroopPixel[$waveNb - 1] = $newListInfoDeployTroopPixel
				EndIf
				$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$waveNb - 1]

				ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
				If (IsString($troopKind)) Then
					Local $arrCCorHeroes[1] = [$troopKind]
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
				Else
					Local $infoDropTroop = DropTroop2($troop, $nbSides, $troopNb, $slotsPerEdge, $name)
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
				EndIf
				$listListInfoDeployTroopPixel[$waveNb - 1] = $listInfoDeployTroopPixel
			EndIf
		Next
		Local $isCCDropped = False
		Local $isHeroesDropped = False
		If ( ($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) And UBound($PixelNearCollector) = 0) Then
				SetLog("Error, no pixel found near collector => Normal attack near red line")
		EndIf
;noyax top quit if collectors not exposed
;		setlog("exposés: " & $countCollectorexposed)
;		setlog("% exposés: " & Round($countCollectorexposed/$countFindPixCloser*100,2))
;		if ($countCollectorexposed/$countFindPixCloser*100) < $NbPercentExposed And $PercentExposed = 1 then
;			setlog("skip base")
;			return
;		EndIf
;noyax bottom
		If ($iCmbSmartDeploy[$iMatchMode] = 0) Then
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
					Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
					If (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
						;TEMP FIX NEED TO IMPROVED... IF NO PIXELREDAREA DEPLOY IN A PRECISE POINT
						;Local $pixelRandomDrop = $PixelRedArea[Round(Random(0, UBound($PixelRedArea) - 1))]
						If Ubound($PixelRedArea) > 0 Then
							Local $pixelRandomDrop = $PixelRedArea[Random(0, UBound($PixelRedArea) - 1,1)]
						Else
							Local $pixelRandomDrop = [747,367] ;
						EndIf
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

						If ($infoPixelDropTroop[0] = "CC") Then
							dropCC($pixelRandomDrop[0], $pixelRandomDrop[1], $CC)
						ElseIf ($infoPixelDropTroop[0] = "HEROES") Then
							dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $King, $Queen, $Warden)
							$isHeroesDropped = True
						EndIf
					Else
						If _Sleep($iDelayLaunchTroop21) Then Return
						SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop
						If _Sleep($iDelayLaunchTroop21) Then Return
						Local $waveName = "first"
						If $numWave + 1 = 2 Then $waveName = "second"
						If $numWave + 1 = 3 Then $waveName = "third"
						If $numWave + 1 = 0 Then $waveName = "last"
						SetLog("Dropping " & $waveName & " wave of " & $infoPixelDropTroop[5] & " " & $infoPixelDropTroop[4], $COLOR_GREEN)
						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], $infoPixelDropTroop[2], $infoPixelDropTroop[3])
					EndIf
					If ($isHeroesDropped) Then
						If _Sleep($iDelayLaunchTroop22) then return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
						CheckHeroesHealth()
					EndIf
					If _Sleep(SetSleep(1)) Then Return
				Next
			Next
		Else
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				If (UBound($listInfoDeployTroopPixel) > 0) Then
					Local $infoTroopListArrPixel = $listInfoDeployTroopPixel[0]
					Local $numberSidesDropTroop = 1

					For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
						$infoTroopListArrPixel = $listInfoDeployTroopPixel[$i]
						If (UBound($infoTroopListArrPixel) > 1) Then
							Local $infoListArrPixel = $infoTroopListArrPixel[1]
							$numberSidesDropTroop = UBound($infoListArrPixel)
							ExitLoop
						EndIf
					Next

					If ($numberSidesDropTroop > 0) Then
						For $i = 0 To $numberSidesDropTroop - 1
							For $j = 0 To UBound($listInfoDeployTroopPixel) - 1
								$infoTroopListArrPixel = $listInfoDeployTroopPixel[$j]
								If (IsString($infoTroopListArrPixel[0]) And ($infoTroopListArrPixel[0] = "CC" Or $infoTroopListArrPixel[0] = "HEROES")) Then
									;TEMP FIX NEED TO IMPROVED... IF NO PIXELREDAREA DEPLOY IN A PRECISE POINT
									;Local $pixelRandomDrop = $PixelRedArea[Round(Random(0, UBound($PixelRedArea) - 1))]
									If Ubound($PixelRedArea) > 0 Then
										Local $pixelRandomDrop = $PixelRedArea[Random(0, UBound($PixelRedArea) - 1,1)]
									Else
										Local $pixelRandomDrop = [747,367] ;
									EndIf
									;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

									If ($isCCDropped = False And $infoTroopListArrPixel[0] = "CC") Then
										dropCC($pixelRandomDrop[0], $pixelRandomDrop[1], $CC)
										$isCCDropped = True
									ElseIf ($isHeroesDropped = False And $infoTroopListArrPixel[0] = "HEROES" And $i = $numberSidesDropTroop - 1) Then
										dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $King, $Queen, $Warden)
										$isHeroesDropped = True
									EndIf
								Else
									$infoListArrPixel = $infoTroopListArrPixel[1]
									$listPixel = $infoListArrPixel[$i]
									;infoPixelDropTroop : First element in array contains troop and list of array to drop troop
									If _Sleep($iDelayLaunchTroop21) Then Return
									SelectDropTroop($infoTroopListArrPixel[0]) ;Select Troop
									If _Sleep($iDelayLaunchTroop23) Then Return
									SetLog("Dropping " & $infoTroopListArrPixel[2] & "  of " & $infoTroopListArrPixel[5] & " => on each side (side : " & $i + 1 & ")", $COLOR_GREEN)
									Local $pixelDropTroop[1] = [$listPixel]
									DropOnPixel($infoTroopListArrPixel[0], $pixelDropTroop, $infoTroopListArrPixel[2], $infoTroopListArrPixel[3])
								EndIf
								If ($isHeroesDropped) Then
									If _sleep (1000) then return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
									CheckHeroesHealth()
								EndIf
							Next
						Next
					EndIf
				EndIf
				If _Sleep(SetSleep(1)) Then Return
			Next
		EndIf
		For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
			Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
			For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
				Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
				If Not (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
					Local $numberLeft = ReadTroopQuantity($infoPixelDropTroop[0])
					If $MilkAtt = 1 Then $numberLeft = 0 ;Noyax
					;SetLog("NumberLeft : " & $numberLeft)
					If ($numberLeft > 0) Then
						If _Sleep($iDelayLaunchTroop21) Then Return
						SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop
						If _Sleep($iDelayLaunchTroop23) Then Return
						SetLog("Dropping last " & $numberLeft & "  of " & $infoPixelDropTroop[5], $COLOR_GREEN)

						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], Ceiling($numberLeft / UBound($infoPixelDropTroop[1])), $infoPixelDropTroop[3])
					EndIf
				EndIf
			Next
		Next
	Else
		For $i = 0 To UBound($listInfoDeploy) - 1
			If (IsString($listInfoDeploy[$i][0]) And ($listInfoDeploy[$i][0] = "CC" Or $listInfoDeploy[$i][0] = "HEROES" or $listInfoDeploy[$i][0] = "SPELL" or $listInfoDeploy[$i][0] = "EARTH")) Then
				If $iMatchMode = $LB And $iChkDeploySettings[$LB] >= 4 Then ; Used for DE or TH side attack
					Local $RandomEdge = $Edges[$BuildingEdge]
					Local $RandomXY = 2
				Else
					Local $RandomEdge = $Edges[Round(Random(0, 3))]
					Local $RandomXY = Round(Random(0, 4))
				EndIf
				If ($listInfoDeploy[$i][0] = "CC") Then
					dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $CC)
				ElseIf ($listInfoDeploy[$i][0] = "HEROES") Then
					dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $King, $Queen,$Warden)
								   ElseIf ($listInfoDeploy[$i][0] = "SPELL") Then
					If $iChkDEUseSpell = 1 Then
					   If $iChkDEUseSpellType = 0 Then
							local $spell = $eHSpell
						ElseIf $iChkDEUseSpellType = 1 Then
							local $spell = $eRSpell
						 EndIf
						 DESpellDP()
						dropSpell($SpellDP[0], $SpellDP[1], $spell)
					 EndIf
					 ElseIf ($listInfoDeploy[$i][0] = "EARTH") Then
					If $iChkUseEarthSpell = 1 Then
					   If $iChkUseEarthSpellType = 0 Then
							local $spell = $eESpell
						    Local $SwitchtoProfile = ""
						 EndIf
						If $BuildingLoc = 1 Then
					  ;drop spell towards the DE storage
  				      dropEarth(ceiling((((100-$iDeSpellDistance)*$RandomEdge[$RandomXY][0])+($iDeSpellDistance*$BuildingLocx))/100), _
					            ceiling((((100-$iDeSpellDistance)*$RandomEdge[$RandomXY][1])+($iDeSpellDistance*$BuildingLocy))/100), _
								$spell)
				   Else
				      ;drop spell towards the center
  				      dropEarth(ceiling((((100-$iDeSpellDistance)*430)+($iDeSpellDistance*$BuildingLocx))/100), _
					            ceiling((((100-$iDeSpellDistance)*313)+($iDeSpellDistance*$BuildingLocy))/100), _
								$spell)
				      EndIf
					EndIf
				EndIf
			Else
				If LauchTroop($listInfoDeploy[$i][0], $listInfoDeploy[$i][1], $listInfoDeploy[$i][2], $listInfoDeploy[$i][3], $listInfoDeploy[$i][4]) Then
					If _Sleep(SetSleep(1)) Then Return
				EndIf
			EndIf
		Next

	EndIf
	Return True
EndFunc   ;==>LaunchTroop2
