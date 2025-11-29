FUNCTION readcsv
PARAMETERS cFilename,cOption,cCursorName
* readcsv with [filename.csv]							> normals case
* readcsv with [filename.csv],"header"					> in case of the csv file have header in 1'st line.
* readcsv with [filename.csv],"header,silence"			> in case of the csv file have header in 1'st line. and don't need to browse output
* readcsv with [filename.csv],"header,silence","tmp1"	> in case of the csv file have header in 1'st line. and don't need to browse output and into cursor tmp1


LOCAL nFileHandle, cFirstLine, nLineCount
nLineCount = 0

IF EMPTY(cOption)
	cOption = "-"
ENDIF
IF EMPTY(cCursorName)
	cCursorName = "readcsv"
ENDIF
IF USED(cCursorName)
	SELECT &cCursorName
	USE
ENDIF

* เปิดไฟล์ในโหมดอ่านอย่างเดียว (read-only) เพื่ออ่านข้อมูลตัวอย่างมาสร้างจำนวนคอลัมน์
nFileHandle = FOPEN(cFilename)
cFirstLine = ""
IF nFileHandle = -1
    WAIT WINDOW "ไม่สามารถเปิดไฟล์ได้ ตรวจสอบสิทธิ์หรือชื่อไฟล์"
    RETURN nFileHandle
ELSE
    * ใช้ FGETS() เพื่ออ่านข้อมูลจนกว่าจะเจออักขระขึ้นบรรทัดใหม่ (CR/LF)
    * หรืออ่านจนถึงจำนวนไบต์ที่ระบุ หรือจนกว่าจะสิ้นสุดไฟล์
    * โดยค่าเริ่มต้น FGETS() จะอ่านได้สูงสุด 254 ไบต์ หากไม่ระบุ nBytes
    * หากบรรทัดแรกยาวกว่านั้น ควรระบุ nBytes ให้เพียงพอ (เช่น 1024)
    cFirstLine = FGETS(nFileHandle, 1024)
    FCLOSE(nFileHandle)	&& ปิดไฟล์ทันทีหลังจากอ่านเสร็จ
	IF EMPTY(ALLTRIM(cFirstLine))
		?"ไม่มีข้อมูล"
		RETURN nLineCount	&& ไม่มีข้อมูล
	ENDIF
ENDIF

* สร้าง cursor และนำเข้า
nElements = ALINES(aColumn,cFirstLine, ",")
cmd = "CREATE CURSOR "+cCursorName+"( "
FOR i=1 TO nElements
	IF "header"$cOption
		cmd = cmd+aColumn(i)+" c(150)"+IIF(i<nElements,","," )")
	ELSE
		cmd = cmd+"col"+ALLTRIM(STR(i))+" c(150)"+IIF(i<nElements,","," )")
	ENDIF
NEXT i
&cmd
SELECT &cCursorName
APPEND FROM &cFilename TYPE DELIMITED
nLineCount = RECCOUNT(ALIAS())
IF "header"$cOption
	GO top
	DELETE
	nLineCount = nLineCount-1
	SET DELETED ON
ENDIF

* ปรับขนาดคอลัมน์
FOR i=1 TO nElements
	cmd = "CALCULATE MAX(LEN(ALLTRIM("+field(i)+"))) to maxlen"
	&cmd
	cmd = "ALTER TABLE ALIAS() ALTER COLUMN "+field(i)+" c("+ALLTRIM(STR(IIF(maxlen<=1,1,maxlen)))+")"
	&cmd
NEXT i
GO top
IF !("silence"$cOption)
	BROWSE NOEDIT NODELETE noapp
ENDIF

RETURN nLineCount
ENDFUNC
