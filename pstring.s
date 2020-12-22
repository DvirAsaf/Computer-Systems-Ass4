#	313531113	Dvir Asaf
.data
.section	.rodata
                invalid_input:    .string "invalid input!\n"
.text
.global pstring
    .type pstring, @function
pstring:
            xorq  %rax, %rax                     #set rax to be 0.
            movb (%rdi),%al                      #set rax.
            ret
.global replaceChar
    .type replaceChar, @function
                                                 #rdi - pointer to pstirng, rdx - new char, rsi - old char.
replaceChar:
            movq %rdi,%r8                        #save the pointer to start of string in r8.
            movq %r8,%r10                        #backup return val
            xorq  %rax, %rax                     #the loop counter
            xorq %r9,%r9                         #set r9 to be 0.
            movb (%r10),%r9b                     #save the length of pstring in r9
            addq $1,%r10                         #increase in one, to point to the 1'st char of pstring.
            cmp $0,%r9                           #check if length > 0.
            ja .forLoop                          #if counter > 0 -> continue loop.
            jmp .endLoop                         #else -> end loop.
            .forLoop:
                        xorq %r11,%r11           #set r11 to be 0.
                        movb (%r10),%r11b
                        cmpb %sil,%r11b          #compare between 1'st bytes of each register -> to check if the current char in pstring.
                                                 #is equal to given char
                        je .replaceChar          #if it equal - jump to replaceChar
                        jmp .comtinueLoop        #else - jump to comtinueLoop
            .replaceChar:                        #this replacing mission.
                        movb %dl,(%r10)
            .comtinueLoop:                       #this check if we finish the loop.
                        addq $1,%rax             #update loop iter
                        addq $1,%r10             #update the current index
                        cmp %rax,%r9             #check if r9 > %rax.
                        ja .forLoop              #didnt finish -> jump to forLoop
                        jmp .endLoop             #finish -> junp to endLoop
            .endLoop:                            #finish replace the old char,update the return value
                                                 #(rax) to be a pointer to the start of our pstring.
                        xorq  %rax, %rax
                        movq %r8,%rax
                        ret
.global pstrijcpy
    .type pstrijcpy, @function
                                                 #rdx - index i, rcx - index j
                                                 #rdi - pointer to 1'st string
                                                 #rsi - pointer to 2'st string
pstrijcpy:
            movq %rdi,%rdi                       #get 1'st arg.
            movq %rsi,%rsi                       #get 2'st arg.
            xorq %r9,%r9                         #set r9 to be 0.
            movq %rdi,%r9                        #backup pointer to 1'st string in %r9
                                                 #check if the index are valid input
            cmpb %dl,(%rsi)                      #check if i >= 2'st string length
            jbe .invalid_input                   #if not valid jump to invalid_input
            cmpb %dl,(%rdi)                      #check if i > 1'st string length
            jbe .invalid_input                   #if not valid jump to invalid_input
            cmpb %cl,(%rsi)                      #check if j > 2'st string length
            jbe .invalid_input                   #if not valid jump to invalid_input
            cmpb %cl,(%rdi)                      #check if j > 1'st string length
            jbe .invalid_input                   #if not valid jump to invalid_input
            leaq 1(%rsi),%rsi                    #skip 1'st byte of pstring - length
            leaq 1(%rdi),%rdi                    #skip 2'st byte of pstring - length
            movq $0,%r8                          #index of 1'st string
            cmp %r8,%rcx                         #check if counter < j
            ja .forLoopCopy
            jmp .endLoopCopy
            .forLoopCopy:
                        cmp %r8,%rdx             #if counter = i
                        je .startCopy            #if -> jump to startcopy
                        jmp .continue            #else -> jump to continue
            .startCopy:                          #start replace the string between i-j index
                        movb (%rsi),%r10b        #save in %r10 the 2'st string[i]
                        movb %r10b,(%rdi)        #replace 1'st string[i] with 2'st string[i]
                        leaq 1(%rdi),%rdi        #update index of strings
                        leaq 1(%rsi),%rsi
                        addq $1,%r8              #update counter
                        cmp %r8,%rcx             #check if counter <= j
                        jae .startCopy           #if counter <= j -> keep copy
                        jmp .endLoopCopy         #if finish copy -> end loop
            .endLoopCopy:
                        xorq  %rax, %rax         #set rax to be 0.
                        movq %r9,%rax            #set return value to be a pointer to the start of 1'st pstring.
                        ret
            .continue:                           #continue untill get to the i index
                        leaq 1(%rdi),%rdi        #update iterators
                        leaq 1(%rsi),%rsi
                        addq $1,%r8              #update counter
                        jmp .forLoopCopy
            .invalid_input:                      #user entered invalid index of i or j
                        xorq  %rax, %rax         #set rax to be 0.
                        xorq  %rdi, %rdi         #set rdi to be 0.
                        movq $invalid_input,%rdi #set the arg of printf func to be a messge
                        call printf
                        jmp .endLoopCopy         #jump to end of loop
.global swapCase
    .type swapCase, @function
                                                 #rdi - point to start of string
swapCase:
            movq %rdi,%rdi                       #get 1'st arg.
            xorq %r9,%r9                         #set r9 to be 0.
            movq %rdi,%r9                        #backup pointer to string in r9
            xorq %r8,%r8                         #set r9 to be 0.
            movb (%rdi),%r8b                     #save length of pstring in r8
            leaq 1(%rdi),%rdi                    #skip 1'st byte of pstring - length
            xorq  %rax, %rax                     #the loop counter
            .swapForLoop:
                        cmp %rax,%r8             #check if we can go over the string
                        jle .endSwap             #if we finish go over the string - counter < length
                        xorq %r11,%r11           #set r11 to be 0.
                        movb (%rdi),%r11b        #save sting[i] in r11.
                        cmpb $65,%r11b
                        jb .noNeedSwap           #if < 65 -> the char is not capital or small.
                        jae .capitalCheck        #if >= 65 check if char is capital.
            .capitalCheck:
                        cmpb $90,%r11b
                        ja .smallCheck           #if > 90 not capital, else  this capital letter 65<=i<=90
                        addb $32,%r11b           #change capital letter -> small letter
                        movb %r11b,(%rdi)
                        incq %rax                #update counter - i++ (for loop)
                        incq %rdi                #update pointer to current location of string
                        jmp .swapForLoop         #continue loop
            .smallCheck:
                        cmpb $97,%r11b           #check if letter is small : if yes replace it else continue iterate
                        jb .noNeedSwap
                        cmpb $122,%r11b          #check if ASCCI value of letter is between 97 to 122
                        ja .noNeedSwap
                        subb $32,%r11b           #change small letter -> capital letter
                        movb %r11b,(%rdi)
                        incq %rax                #update counter - i++ (for loop)
                        incq %rdi                #update pointer to current location of string
                        jmp .swapForLoop
            .noNeedSwap:
                        incq %rax                #update counter - i++ (for loop)
                        incq %rdi                #update pointer to current location of string
                        jmp .swapForLoop         #continue loop
            .endSwap:
                        xorq  %rax, %rax         #set rax to be 0.
                        movq %r9,%rax            #set return value to be pointer to start of pstring
                        ret
.global pstrijcmp
    .type pstrijcmp, @function
pstrijcmp:
                                                 #rdx - index i, rcx - index j
                                                 #rdi - pointer to 1'st string
                                                 #rsi - pointer to 2'st string
            movq %rdi,%rdi                       #get 1'st arg
            movq %rsi,%rsi                       #get 2'st arg
            xorq %r9,%r9                         #set r9 to be 0.
            movq %rdi,%r9                        #backup pointer to 1'st string in %r9
                                                 #check if the index are valid input
            cmpb %dl,(%rsi)                      #check if i >= 2'st string length
            jb .invalid                          #if not valid jump to invalid_input
            cmpb %cl,(%rsi)                      #check if i > 1'st string length
            jb .invalid                          #if not valid jump to invalid_input
            leaq 1(%rsi),%rsi                    #skip 1'st byte of pstring - length
            leaq 1(%rdi),%rdi                    #skip 2'st byte of pstring - length
            movq $0,%r8                          #index of 1'st string
            cmp %r8,%rcx                         #check if counter < j
            ja .forLoopCom
            jmp .endLoopCom
            .forLoopCom:
                        cmp %r8,%rdx             #if counter = i
                        je .compare              #if -> jump to compare
                        jmp .continueCom         #else -> jump to continueCom
            .compare:
                        movb (%rdi),%r13b
                        movb (%rsi),%r11b
                        cmpb %r13b,%r11b         # if r13b > r11b
                        jb .big                  #jump to big
                        cmpb %r13b,%r11b         # if r13b = r11b
                        je .equal                #jump to equal
                        cmpb %r13b,%r11b         # if r13b < r11b
                        ja .littel               #jump to littel
            .endLoopCom:
                        xorq  %rax, %rax         #set rax to be 0.
                        movq %r9,%rax            #set return value to be pointer to start of pstring
                        ret
            .continueCom:                        #continue untill get to the i index
                        leaq 1(%rdi),%rdi        #update iterators
                        leaq 1(%rsi),%rsi
                        addq $1,%r8              #update counter
                        jmp .forLoopCom
            .invalid:                            #we jump here if the user entered invalid index of i and j
                        xorq  %rax, %rax         #set %rax to zero
                        xorq  %rdi, %rdi         #set %rdi to zero
                        movq $invalid_input, %rdi#set the arg of printf func to be a message.
                        call printf
                        xorq  %rax, %rax         #set rax to be 0.
                        movq  $-2,%r9            #return the value -2 to func_select
                        movq  %r9,%rax           #set return value to be pointer to start of pstring
                        ret
            .big:
                        xorq  %rax, %rax         #set rax to be 0.
                        movq  $1,%r9             #return the value 1 to func_select
                        movq  %r9,%rax           #set return value to be pointer to start of pstring
                        ret
            .equal:
                        xorq  %rax, %rax         #set rax to be 0.
                        movq  $0,%r9             #return the value 0 to func_select
                        movq  %r9,%rax           #set return value to be pointer to start of pstring
                        ret
            .littel:
                        xorq  %rax, %rax         #set rax to be 0.
                        movq  $-1,%r9            #return the value -1 to func_select
                        movq  %r9,%rax           #set return value to be pointer to start of pstring
                        ret