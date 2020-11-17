C> @file
C> @brief THIS IS THE FORTRAN 32 bit VERSION OF SBYTE.
C      
C> @author DR. ROBERT C. GAMMILL, CONSULTANT, NATIONAL CENTER FOR ATMOSPHERIC RESEARCH
C> @date JULY 1972 
C>
C> THIS IS THE FORTRAN 32 bit VERSION OF SBYTE.
C> Changes for SiliconGraphics IRIS-4D/25
C> SiliconGraphics 3.3 FORTRAN 77
C> MARCH 1991  RUSSELL E. JONES
C> NATIONAL WEATHER SERVICE
C>
      SUBROUTINE SBYTE(IOUT,IN,ISKIP,NBYTE)                            
      INTEGER    IN
      INTEGER    IOUT(*)
      INTEGER    MASKS(32)
C
      SAVE
C
      DATA  NBITSW/32/
C
C     DATA  MASKS /Z'00000001',Z'00000003',Z'00000007',Z'0000000F',
C    &             Z'0000001F',Z'0000003F',Z'0000007F',Z'000000FF',
C    &             Z'000001FF',Z'000003FF',Z'000007FF',Z'00000FFF',
C    &             Z'00001FFF',Z'00003FFF',Z'00007FFF',Z'0000FFFF',
C    &             Z'0001FFFF',Z'0003FFFF',Z'0007FFFF',Z'000FFFFF',
C    &             Z'001FFFFF',Z'003FFFFF',Z'007FFFFF',Z'00FFFFFF',
C    &             Z'01FFFFFF',Z'03FFFFFF',Z'07FFFFFF',Z'0FFFFFFF',
C    &             Z'1FFFFFFF',Z'3FFFFFFF',Z'7FFFFFFF',Z'FFFFFFFF'/
C
C     MASK TABLE PUT IN DECIMAL SO IT WILL COMPILE ON AN 32 BIT 
C     COMPUTER 
C
      DATA  MASKS / 1, 3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047,
     & 4095, 8191, 16383, 32767, 65535, 131071, 262143, 524287,
     & 1048575, 2097151, 4194303, 8388607, 16777215, 33554431,
     & 67108863, 134217727, 268435455, 536870911, 1073741823,
     & 2147483647, -1/
C                                                                               
C NBYTE MUST BE LESS THAN OR EQUAL TO NBITSW
C
        ICON  = NBITSW - NBYTE
        IF (ICON.LT.0) RETURN   
        MASK  = MASKS(NBYTE)
C
C INDEX TELLS HOW MANY WORDS INTO IOUT THE NEXT BYTE IS TO BE STORED.           
C
        INDEX = ISHFT(ISKIP,-5) 
C
C II TELLS HOW MANY BITS IN FROM THE LEFT SIDE OF THE WORD TO STORE IT.         
C
        II    = MOD(ISKIP,NBITSW)
C
        J     = IAND(MASK,IN)    
        MOVEL = ICON - II         
C                                                                               
C BYTE IS TO BE STORED IN MIDDLE OF WORD.  SHIFT LEFT.                          
C
        IF (MOVEL.GT.0) THEN          
          MSK           = ISHFT(MASK,MOVEL)  
          IOUT(INDEX+1) = IOR(IAND(NOT(MSK),IOUT(INDEX+1)),
     &    ISHFT(J,MOVEL))
C                                                                               
C THE BYTE IS TO BE SPLIT ACROSS A WORD BREAK.                                  
C
        ELSE IF (MOVEL.LT.0) THEN          
          MSK           = MASKS(NBYTE+MOVEL)      
          IOUT(INDEX+1) = IOR(IAND(NOT(MSK),IOUT(INDEX+1)),
     &    ISHFT(J,MOVEL))  
          ITEMP         = IAND(MASKS(NBITSW+MOVEL),IOUT(INDEX+2))
          IOUT(INDEX+2) = IOR(ITEMP,ISHFT(J,NBITSW+MOVEL))
C             
C BYTE IS TO BE STORED RIGHT-ADJUSTED.                                          
C
        ELSE
          IOUT(INDEX+1) = IOR(IAND(NOT(MASK),IOUT(INDEX+1)),J)
        ENDIF
C
      RETURN
      END
