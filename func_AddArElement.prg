*!
*! Function: AddArElement( ARRAY @taArray, tuValueToAdd )
*! Description: Adds a new element to the end of a 1D array.
*! Parameters: 
*!   taArray - The array reference (pass by reference using @).
*!   tuValueToAdd - The value to add.
*! Returns: .T. if successful, .F. otherwise.
*!
*! Example
*! - - - -
*! LOCAL ARRAY laMyArray(1)  && เริ่มต้นด้วยขนาด 1 หรือ 0 ก็ได้
*! laMyArray(1) = "Start"
*!
*! * เรียกใช้ฟังก์ชัน โดยต้องมี @ นำหน้าชื่ออาร์เรย์
*! AddArElement(@laMyArray, "Apple")
*! AddArElement(@laMyArray, "Banana")
*! AddArElement(@laMyArray, "Orange")
*! - - - -
*!
FUNCTION AddArElement(taArray, tuValueToAdd)
    LOCAL lnOldSize, lnNewSize
    
    * ต้องส่งอาร์เรย์มาแบบ Reference (ใช้ @ หน้าชื่ออาร์เรย์ตอนเรียกใช้)
    IF TYPE('taArray') <> 'A' 
        RETURN .F.
    ENDIF
    
    * ตรวจสอบว่าเป็น 1 มิติหรือไม่ (ฟังก์ชันนี้รองรับแค่ 1 มิติ)
    IF ALEN(taArray, 2) > 0
        MESSAGEBOX("AAddElement รองรับเฉพาะอาร์เรย์ 1 มิติ", 16)
        RETURN .F.
    ENDIF

    * คำนวณขนาดเดิมและขนาดใหม่
    lnOldSize = ALEN(taArray)
    lnNewSize = lnOldSize + 1
    
    * ขยายขนาดอาร์เรย์
    DIMENSION taArray(&lnNewSize) 
    
    * เพิ่มข้อมูลใหม่เข้าไปในตำแหน่งสุดท้าย
    taArray(lnNewSize) = tuValueToAdd
    
    RETURN .T.
ENDFUNC
