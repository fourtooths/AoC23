HAI 1.2
I HAS A FILE
I HAS A LINE
I HAS A DIGIT
I HAS A SUM

VISIBLE "Reading calibration values from input.txt..."

I HAS A CALIBRATION_FILE
GIMMEH CALIBRATION_FILE ITZ "input.txt"

IM IN YR FILE
    BOTH SAEM AN BIGGR OF 0 AN CALIBRATION_FILE
    O RLY?
        YA RLY
            BTW Read each line from the file
            I HAS A LINE
            VISIBLE "Reading line..."
            GIMMEH LINE R LINE

            BTW Process each character in the line
            I HAS A DIGIT
            I HAS A LINE_LENGTH
            GIMMEH LINE_LENGTH R BOTH OF 0 AN COUNT OF LINE

            IM IN YR DIGIT_LOOP UPPIN YR DIGIT TIL BOTH SAEM DIGIT AN LINE_LENGTH
                I HAS A CHAR
                GIMMEH CHAR R (LINE AT DIGIT)

                BTW Check if the character is a letter
                I HAS A IS_LETTER
                GIMMEH IS_LETTER R BOTH OF 0 AN CHAR

                O RLY?
                    YA RLY
                        BTW Convert the spelled-out digit to a number
                        I HAS A DIGIT_MAP
                        GIMMEH DIGIT_MAP R SMOOSH "onetwothreefourfivesixseveneightnine"
                        I HAS A DIGIT_NUMBER
                        GIMMEH DIGIT_NUMBER R INDEX OF DIGIT_MAP IN CHAR

                        BTW Extract the first and last digit and form a two-digit number
                        I HAS A FIRST_DIGIT
                        I HAS A LAST_DIGIT
                        GIMMEH FIRST_DIGIT R (LINE AT DIGIT)
                        GIMMEH LAST_DIGIT R (LINE AT (LINE_LENGTH - DIGIT - 1))

                        BTW Convert the digits to a two-digit number
                        I HAS A TWO_DIGIT_NUMBER
                        GIMMEH TWO_DIGIT_NUMBER R BOTH OF 10 AN (SUM OF FIRST_DIGIT AN LAST_DIGIT)

                        BTW Add the two-digit number to the sum
                        GIMMEH SUM R SUM OF SUM AN TWO_DIGIT_NUMBER
                    NO WAI
                        BTW Check if the character is a digit
                        I HAS A IS_DIGIT
                        GIMMEH IS_DIGIT R BOTH OF 1 AN CHAR

                        O RLY?
                            YA RLY
                                BTW Extract the first and last digit and form a two-digit number
                                I HAS A FIRST_DIGIT
                                I HAS A LAST_DIGIT
                                GIMMEH FIRST_DIGIT R (LINE AT DIGIT)
                                GIMMEH LAST_DIGIT R (LINE AT (LINE_LENGTH - DIGIT - 1))

                                BTW Convert the digits to a two-digit number
                                I HAS A TWO_DIGIT_NUMBER
                                GIMMEH TWO_DIGIT_NUMBER R BOTH OF 10 AN (SUM OF FIRST_DIGIT AN LAST_DIGIT)

                                BTW Add the two-digit number to the sum
                                GIMMEH SUM R SUM OF SUM AN TWO_DIGIT_NUMBER
                            NO WAI
                                BTW Ignore non-digit characters
                            OIC
                    OIC
            IM OUTTA YR DIGIT_LOOP

        NO WAI
            VISIBLE "File not found!"
            GTFO
    OIC

VISIBLE "Total calibration value: " SUM

KTHXBYE