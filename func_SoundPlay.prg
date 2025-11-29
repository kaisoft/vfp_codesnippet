*!
*! Function: SoundPlay(tcFilename, tnSeconds)
*! Description: Plays a sound file (WAV or MP3) for a specified duration.
*! Parameters: 
*!   tcFilename - The full path to the sound file.
*!   tnSeconds - Optional. The number of seconds to play. If omitted, plays the whole file.
*!
FUNCTION SoundPlay(tcFilename, tnSeconds)
    LOCAL lcFilename, lnRet, lcReturnString, lcAlias, lnDurationMS, lnEndPositionMS
    
    * กำหนด Alias ชั่วคราว
    lcAlias = "MyVfpAlarm" 
    DECLARE INTEGER mciSendString IN winmm.dll STRING cString, STRING @lcReturnString, INTEGER nReturnLength, INTEGER nCallback
    STORE SPACE(255) TO lcReturnString

    lcFilename = ALLTRIM(tcFilename)

    IF EMPTY(lcFilename) OR !FILE(lcFilename)
        MESSAGEBOX("ไม่พบไฟล์เสียง: " + lcFilename, 16, "ข้อผิดพลาด SoundPlay")
        RETURN .F.
    ENDIF
    
    * ปิดอุปกรณ์เก่าก่อนเปิดใหม่เสมอ เพื่อป้องกัน Error 289
    mciSendString("close " + lcAlias, @lcReturnString, 255, 0)
    
    * 1. เปิดอุปกรณ์ MCI
    lnRet = mciSendString("open " + lcFilename + " alias " + lcAlias, @lcReturnString, 255, 0)

    IF lnRet = 0
        * 2. ตรวจสอบความยาวไฟล์จริง (เป็นมิลลิวินาที)
        * ตั้งค่า Time Format เป็น Milliseconds ก่อน
        mciSendString("set " + lcAlias + " time format milliseconds", @lcReturnString, 255, 0)
        * ดึงความยาวไฟล์
        mciSendString("status " + lcAlias + " length", @lcReturnString, 255, 0)
        lnDurationMS = VAL(ALLTRIM(lcReturnString))

        * 3. คำนวณตำแหน่งสิ้นสุด
        IF PARAMETERS() >= 2 AND VARTYPE(tnSeconds) = 'N' AND tnSeconds > 0
            * คำนวณตำแหน่งสิ้นสุดจากวินาทีที่ผู้ใช้ระบุ (แปลงวินาทีเป็นมิลลิวินาที)
            lnEndPositionMS = tnSeconds * 1000
            * ตรวจสอบว่าตำแหน่งที่ต้องการเล่น ไม่เกินความยาวไฟล์จริง
            IF lnEndPositionMS > lnDurationMS
                lnEndPositionMS = lnDurationMS
            ENDIF
        ELSE
            * ถ้าไม่ได้ระบุวินาที ให้เล่นจนจบไฟล์
            lnEndPositionMS = lnDurationMS
        ENDIF

        * 4. สั่งเล่นเสียง โดยใช้ "TO" เพื่อกำหนดจุดหยุด
        * เรายังคงใช้ "WAIT" เพื่อให้ VFP รอจนกว่าจะเล่นจบตามเวลาที่กำหนด แล้วค่อยปิดอุปกรณ์
        lcCommand = "play " + lcAlias + " TO " + TRANSFORM(lnEndPositionMS) + " WAIT"
        lnRet = mciSendString(lcCommand, @lcReturnString, 255, 0)
        
        * 5. เมื่อเล่นจบตามเวลาแล้ว ค่อยสั่งปิดอุปกรณ์
        mciSendString("close " + lcAlias, @lcReturnString, 255, 0)
        
        RETURN .T. 
    ELSE
        * จัดการข้อผิดพลาด
        MESSAGEBOX("ไม่สามารถเปิดไฟล์เสียงได้ รหัสข้อผิดพลาด: " + TRANSFORM(lnRet), 16, "MCI Error")
        RETURN .F.
    ENDIF
ENDFUNC
