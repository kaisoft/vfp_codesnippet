* function : strtran_v2.prg
* author : kaisoft@hotmail.com
* 2021/02/13
* วนรอบจนกว่าจะครบ เพื่อเปลี่ยนสายอักษรต้นแบบ (lcMasterVal) 
* ที่มีอักขระตรงกับที่ระบุ (lcChgFrmVal) 
* ให้เป็นชุดอักขระชุดอื่นๆที่ต้องการ (lcChgToVal)
* และหากต้องการสามารถระบุให้แสดงการทำงานเพื่อการตรวจสอบ (lcDebugFlag="debug") ได้
* demo : ?strtran_v2("A--B-----C--------D","--","-")
* memo from author : สร้างเพื่อเพิ่มประสิทธิภาพให้ฟังก์ชั่น strtran สามารถวนหลายรอบเพื่อตัดอักขระพิเศษต่างๆ
PARAMETERS lcMasterVal,lcChgFrmVal,lcChgToVal,lcDebugFlag
lnLoop = 0
DO WHILE AT(lcChgFrmVal,lcMasterVal)<>0
	lcMasterVal = STRTRAN(lcMasterVal,lcChgFrmVal,lcChgToVal)
	lnLoop = lnLoop+1
	IF !EMPTY(lcDebugFlag)
		?ALLTRIM(STR(lnLoop)),"["+lcMasterVal+"]"
	ENDIF
ENDDO
IF !EMPTY(lcDebugFlag)
	?
ENDIF
RETURN lcMasterVal
