* Save webaddress to file
* syntext :  returnval = fnSaveFromUrl(<url>,<filename>,[showflag])
* returnval = .T. when download already.
*           = .F. when it's do not success.
* author : kaisoft@hotmail.com , 2019-04-05
* language : visual foxpro

FUNCTION func_SaveFromUrl(_cWebAddress,_cTarget,_flagEdit)
	LOCAL _cWebAddress,_cTarget
    _cUrl = _cWebAddress
	DECLARE INTEGER URLDownloadToFile IN urlmon INTEGER, STRING, STRING, INTEGER, INTEGER
	WAIT WINDOW NOWAIT ;
		"Downloading..."+chr(13)+;
		"From : "+subs(_cWebAddress,1,len(allt(_cTarget))+10)+chr(13)+;
		"To : "+_cTarget
	lResult = URLDownloadToFile(0, _cWebAddress, _cTarget, 0,0) = 0
	WAIT CLEAR
	IF !empty(_flagEdit) .and. lResult .and. FILE(_cTarget)
		MODI COMM &_cTarget
	ENDIF
	RETURN lResult
ENDFUNC
