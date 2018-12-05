# Pstring
Pstring is a representation of a string with its length on the stack frame of the main function.

# main.s:
In main function. I can two Pstrings. For each one I scan his length first and than the string itself. Afterwards, I take the first byte of the length and put it after the string on the stack frame.

After the scanning, I scan an integer, which will be a choice for the switch-case in func_select.s. Main calls run_func
with the choice as a integer, and two pointers to the pstrings

# func_select.s:
In function run_func, there is a swtich-case where each case(50 - 54) calls a different function from pstring.s and works on the pstrings.

case 50 - calls pstrln on each pstring and prints the string with his length.

case 51 - scans two chars, calling replaceChar on each pstring and prints the chars with the updated pstrings.

case 52 - scans two integers, calling pstrijcpy, and prints each pstring with his length.

case 53 - calls swapCase on each pstring and prints the updated string.

case 54 - scans two integers, calls pstrijcmp, and prints the comparison result.

# psring.s:
Four functions that works on the pstrings:

char pstrlen(Pstring* pstr) : resturns the length of the pstring.

Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar) : replace each appearance of oldChar with newChar. Returns a pointer to the pstring.

Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j) : copy the subsrting(i, j) of src to dst. If i or j are out of bounds(with first pstring length or second pstring), prints invalid input. Returns a pointer to the first pstring.

Pstring* swapCase(Pstring* pstr): swaps each lower case letter to upper case and vice versa. Returns a pointer to the pstring.

int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j): Compares the substring(i,j) of both pstrings. Returns -1 if pstr1 < pstr2, 1 if pstr1 > pstr2 and 0 if equals. In case on out of bounds index, returnes -2.





