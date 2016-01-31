; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkUnbreakable()
	If GUICtrlRead($chkUnbreakable) = $GUI_CHECKED Then
		GUICtrlSetState($txtUnbreakable, $GUI_ENABLE)
		GUICtrlSetState($txtUnBrkMinGold, $GUI_ENABLE)
		GUICtrlSetState($txtUnBrkMaxGold, $GUI_ENABLE)
		GUICtrlSetState($txtUnBrkMinElixir, $GUI_ENABLE)
		GUICtrlSetState($txtUnBrkMaxElixir, $GUI_ENABLE)
		GUICtrlSetState($txtUnBrkMinDark, $GUI_ENABLE)
		GUICtrlSetState($txtUnBrkMaxDark, $GUI_ENABLE)
		$iUnbreakableMode = 1
	ElseIf GUICtrlRead($chkUnbreakable) = $GUI_UNCHECKED Then
		GUICtrlSetState($txtUnbreakable, $GUI_DISABLE)
		GUICtrlSetState($txtUnBrkMinGold, $GUI_DISABLE)
		GUICtrlSetState($txtUnBrkMaxGold, $GUI_DISABLE)
		GUICtrlSetState($txtUnBrkMinElixir, $GUI_DISABLE)
		GUICtrlSetState($txtUnBrkMaxElixir, $GUI_DISABLE)
		GUICtrlSetState($txtUnBrkMinDark, $GUI_DISABLE)
		GUICtrlSetState($txtUnBrkMaxDark, $GUI_DISABLE)
		$iUnbreakableMode = 0
	EndIf
EndFunc   ;==>chkUnbreakable

Func chkAttackNow()
	If GUICtrlRead($chkAttackNow) = $GUI_CHECKED Then
		$iChkAttackNow = 1
		GUICtrlSetState($lblAttackNow, $GUI_ENABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_ENABLE)
	Else
		$iChkAttackNow = 0
		GUICtrlSetState($lblAttackNow, $GUI_DISABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackNow

Func chkSnipeWhileTrain()
	If GUICtrlRead($ChkSnipeWhileTrain) = $GUI_CHECKED Then
		$iChkSnipeWhileTrain = 1
		GUICtrlSetState($lblSearchlimit, $GUI_ENABLE)
		GUICtrlSetState($txtSearchlimit, $GUI_ENABLE)
		GUICtrlSetState($lblminArmyCapacityTHSnipe, $GUI_ENABLE)
		GUICtrlSetState($txtminArmyCapacityTHSnipe, $GUI_ENABLE)
		GUICtrlSetState($lblSWTTiles, $GUI_ENABLE)
		GUICtrlSetState($txtSWTTiles, $GUI_ENABLE)
	Else
		$iChkSnipeWhileTrain = 0
		GUICtrlSetState($lblSearchlimit, $GUI_DISABLE)
		GUICtrlSetState($txtSearchlimit, $GUI_DISABLE)
		GUICtrlSetState($lblminArmyCapacityTHSnipe, $GUI_DISABLE)
		GUICtrlSetState($txtminArmyCapacityTHSnipe, $GUI_DISABLE)
		GUICtrlSetState($lblSWTTiles, $GUI_DISABLE)
		GUICtrlSetState($txtSWTTiles, $GUI_DISABLE)
	EndIf
	GUICtrlSetState($ChkSnipeWhileTrain, $GUI_ENABLE)

EndFunc   ;==>chkSnipeWhileTrain

#comments-start
Func GUILightSpell()
	If GUICtrlRead($chkLightSpell) = $GUI_CHECKED Then
		$iChkLightSpell = 1
		GUICtrlSetState($lbliLSpellQ, $GUI_ENABLE)
		GUICtrlSetState($cmbiLSpellQ, $GUI_ENABLE)
		GUICtrlSetState($lbliLSpellQ2, $GUI_ENABLE)
	Else
		$iChkLightSpell = 0
		GUICtrlSetState($lbliLSpellQ, $GUI_DISABLE)
		GUICtrlSetState($cmbiLSpellQ, $GUI_DISABLE)
		GUICtrlSetState($lbliLSpellQ2, $GUI_DISABLE)
	EndIf
EndFunc   ;==>GUILightSpell
#comments-end

Func chkBullyMode()
	If GUICtrlRead($chkBullyMode) = $GUI_CHECKED Then
		$OptBullyMode = 1
		GUICtrlSetState($txtATBullyMode, $GUI_ENABLE)
		GUICtrlSetState($cmbYourTH, $GUI_ENABLE)
		GUICtrlSetState($radUseDBAttack, $GUI_ENABLE)
		GUICtrlSetState($radUseLBAttack, $GUI_ENABLE)
	Else
		$OptBullyMode = 0
		GUICtrlSetState($txtATBullyMode, $GUI_DISABLE)
		GUICtrlSetState($cmbYourTH, $GUI_DISABLE)
		GUICtrlSetState($radUseDBAttack, $GUI_DISABLE)
		GUICtrlSetState($radUseLBAttack, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBullyMode

Func chkSnipeMode()
	If GUICtrlRead($chkTrophyMode) = $GUI_CHECKED Then
		$OptTrophyMode = 1
		GUICtrlSetState($txtTHaddtiles, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackTHType, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackbottomType, $GUI_ENABLE)
		GUICtrlSetState($chkUseClastleTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseQueenTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseKingTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseRSpellsTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseHSpellsTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseLSpellsTH, $GUI_ENABLE)
;Noyax top
		GUICtrlSetState($cmbTHsnMeetGE, $GUI_ENABLE)
		GUICtrlSetState($chkAttIfDB, $GUI_ENABLE)
		GUICtrlSetState($txtAttIfDB, $GUI_ENABLE)
		GUICtrlSetState($txtTHsnMinGold, $GUI_ENABLE)
		GUICtrlSetState($txtTHsnMinElixir, $GUI_ENABLE)
		GUICtrlSetState($txtTHsnMinGoldPlusElixir, $GUI_ENABLE)
		GUICtrlSetState($txtTHSnMinDarkElixir, $GUI_ENABLE)
; Noyax bottom
		;noyax add Ancient begin greed filter filter with DB
		chkAttIfDB()
		;noyax add Ancient end greed filter filter with DB
		;noyax add Ancient begin snipe live/dead filter
		GUICtrlSetState($cmbTSSearchMode, $GUI_ENABLE)
		;noyax add Ancient end snipe live/dead filter
	Else
		$OptTrophyMode = 0
		GUICtrlSetState($txtTHaddtiles, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackTHType, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackbottomType, $GUI_DISABLE)
		GUICtrlSetState($chkUseClastleTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseQueenTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseKingTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseRSpellsTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseHSpellsTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseLSpellsTH, $GUI_DISABLE)
; Noyax top
		GUICtrlSetState($cmbTHsnMeetGE, $GUI_DISABLE)
		GUICtrlSetState($chkAttIfDB, $GUI_DISABLE)
		GUICtrlSetState($txtAttIfDB, $GUI_DISABLE)
		GUICtrlSetState($txtTHsnMinGold, $GUI_DISABLE)
		GUICtrlSetState($txtTHsnMinElixir, $GUI_DISABLE)
		GUICtrlSetState($txtTHsnMinGoldPlusElixir, $GUI_DISABLE)
		GUICtrlSetState($txtTHSnMinDarkElixir, $GUI_DISABLE)
; Noyax bottom
		;noyax add Ancient begin greed filter filter with DB
		GUICtrlSetState($chkAttIfDBMeetGE, $GUI_DISABLE)
		;noyax add Ancient end greed filter filter with DB
		;noyax add Ancient begin snipe live/dead filter
		GUICtrlSetState($cmbTSSearchMode, $GUI_DISABLE)
		;noyax add Ancient end snipe live/dead filter
	EndIf
EndFunc   ;==>chkSnipeMode

;noyax top
Func cmbTHsnGoldElixir()
	If _GUICtrlComboBox_GetCurSel($cmbTHsnMeetGE) < 2 Then
		GUICtrlSetState($txtTHsnMinGold, $GUI_SHOW)
		GUICtrlSetState($picTHsnMinGold, $GUI_SHOW)
		GUICtrlSetState($txtTHsnMinElixir, $GUI_SHOW)
		GUICtrlSetState($picTHsnMinElixir, $GUI_SHOW)
		GUICtrlSetState($txtTHsnMinGoldPlusElixir, $GUI_HIDE)
		GUICtrlSetState($picTHsnMinGPEGold, $GUI_HIDE)
		GUICtrlSetState($lblTHsnMinGPE, $GUI_HIDE)
		GUICtrlSetState($picTHsnMinGPEElixir, $GUI_HIDE)
	Else
		GUICtrlSetState($txtTHsnMinGold, $GUI_HIDE)
		GUICtrlSetState($picTHsnMinGold, $GUI_HIDE)
		GUICtrlSetState($txtTHsnMinElixir, $GUI_HIDE)
		GUICtrlSetState($picTHsnMinElixir, $GUI_HIDE)
		GUICtrlSetState($txtTHsnMinGoldPlusElixir, $GUI_SHOW)
		GUICtrlSetState($picTHsnMinGPEGold, $GUI_SHOW)
		GUICtrlSetState($lblTHsnMinGPE, $GUI_SHOW)
		GUICtrlSetState($picTHsnMinGPEElixir, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbTHsnGoldElixir
;noyax bottom

Func LoadThSnipeAttacks()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirTHSnipesAttacks & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($cmbAttackTHType)
	;set combo box
	GUICtrlSetData($cmbAttackTHType, $output)

	_GUICtrlComboBox_SetCurSel($cmbAttackTHType, _GUICtrlComboBox_FindStringExact($cmbAttackTHType, $scmbAttackTHType))
EndFunc   ;==>LoadThSnipeAttacks

Func cmbAttackTHType()
	Local $arrayattack = _GUICtrlComboBox_GetListArray($cmbAttackTHType)
	$scmbAttackTHType = $arrayattack[_GUICtrlComboBox_GetCurSel($cmbAttackTHType) + 1]
EndFunc

Func btnTestTHcsv()
	AttackTHParseCSV(True) ; launch attach th parse CSV only for test in log
EndFunc

;noyax add Ancient begin greed filter filter with DB
Func chkAttIfDB()
	If GUICtrlRead($chkAttIfDB) = $GUI_CHECKED Then
		GUICtrlSetState($chkAttIfDBMeetGE, $GUI_ENABLE)
	ElseIf GUICtrlRead($chkAttIfDB) = $GUI_UNCHECKED Then
		GUICtrlSetState($chkAttIfDBMeetGE, $GUI_UNCHECKED)
		GUICtrlSetState($chkAttIfDBMeetGE, $GUI_DISABLE)
		$iOptAttIfDBMeetGE = 0
	EndIf
EndFunc
;noyax add Ancient end greed filter filter with DB
