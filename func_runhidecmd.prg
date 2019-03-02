* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
* FROM http://pclandpk.blogspot.com/2014/05/how-to-hide-black-run-window-in-vfp.html
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

FUNCTION func_runhide
	PARAMETERS rfile, lcmdpara, ls_showdos

	DECLARE INTEGER ShellExecute IN shell32.dll ; 
	INTEGER hndWin, ; 
	STRING cAction, ; 
	STRING cFileName, ; 
	STRING cParams, ;  
	STRING cDir, ; 
	INTEGER nShowWin
	local lcCMD, lcParas
	DECLARE Sleep IN Win32API INTEGER
	lcCmd = rfile   && command to Execute 
	lcParas = lcmdpara   && Extra parameter to pass your command 
	 * --- Execute the command.
	****   shellExecute last parameter 0  will hide DOS window
	***  If you want to show DOS window change it to value  1 

	showdos = iif(empty(ls_showdos),0,iif(ls_showdos="noshow",0,1))
	ShellExecute(0,'open','cmd', '/C'+lcCmd+' '+lcParas, '',showdos)
	sleep(2000)  && delay time to come  back
	 *** sleep value  can be reduced according to your need
	CLEAR DLLS ShellExecute
	* --- Return to caller.
	RETURN
ENDFUNC