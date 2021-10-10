	Space::r		; report
	Shift::Escape	; cancel task
	
	F3::
		Suspend On
		MsgBox, 0, Among Us KeyBind-Status, Chat-Mode, 1
		Pause On
	return

	#If (A_IsPaused)
		F3::
			Suspend Off
			Pause Off
		MsgBox, 0, Among Us KeyBind-Status, Game-Mode, 1
		
		return
	#If	
		
	return
}
