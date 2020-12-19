#	313531113	Dvir Asaf
.data
.section	.rodata
    input_not_valid:    .string "invalid input!\n"
.text
.global pstring
.type pstring, @function
pstring:
    
    # write your code here
    xorq  %rax, %rax            #set %rax to be 0
    movb (%rdi),%al            #set %rax                 
    ret
    
.global replaceChar
    .type replaceChar, @function
    #%rdi - pointer to p-stirng, %rsi - old char, %rdx - new char
replaceChar:
    movq %rdi,%r8               #save in %r8 the pointer to start of string
    movq %r8,%r10               #backup return value
   
    xorq  %rax, %rax            #the loop counter
    xorq %r9,%r9
    movb (%r10),%r9b            #save the length of p-string in %r9
    
    addq $1,%r10                #increase in one step %r10 - to point to the first char of p-string

    cmp $0,%r9                  #compare -check if length of string is bigger than 0
    ja .forLoop                 #if the counter is bigger than zero continue loop
    jmp .endForLoop             #else end loop
    
    .forLoop: 
        xorq %r11,%r11
        movb (%r10),%r11b
                
                                  #the compiler jump to start go over the p-string and replace old cahr with new char
        cmpb %sil,%r11b        #compare between the first bytes of each register to check if the current char in p-string
                                #is equal to given char
        je .replaceOldChar      #if it equal - jump to part of code with lable - replaceOldChar
        jmp .comtinueIterateLoop #else - jump to part of code with lable - comtinueIterateLoop
        
    .replaceOldChar:            #this part of code does the replacing mission
        movb %dl,(%r10)
        
    .comtinueIterateLoop:       #this part of code update our iterators and check if we finish the loop
        addq $1,%rax            #update for loop iterator
        addq $1,%r10            #update the curent index of p-string
        cmp %rax,%r9            #check if we finish go over the loop - if %r9 still bigger than counter %rax
        ja .forLoop             #we didnt finish go over the loop -> jump to .forLoop again
        jmp .endForLoop         #finished going over the loop - > junp to .endForLoop

    .endForLoop:                #when we are in this part of code- we finish replace the old char, so weupdate the
                                #return value (%rax) to be a pointer to the start of our p-string
        xorq  %rax, %rax
        movq %r8,%rax
        ret

.global pstrijcpy
    .type pstrijcpy, @function
    #rdi - pointer to first string
    #rsi - pointer to second string
    #rdx - index i, %rcx - index j
pstrijcpy:
    movq %rdi,%rdi          #get first aegument
    movq %rsi,%rsi          #get second argument
    xorq %r9,%r9
    movq %rdi,%r9           #backup pointer to first string in %r9

#first let's check if the index are valid input

    cmpb %dl,(%rsi)     #check if i >= second string length
    jbe .invalid_index
    
    cmpb %dl,(%rdi)     #check if i> first string length
    jbe .invalid_index
    
    cmpb %cl,(%rsi)     #check if j > second string length
    jbe .invalid_index
    
    cmpb %cl,(%rdi)     #check if j> first string length
    jbe .invalid_index
    
   # cmp %rcx, $0        #check if j<0
    #ja .invalid_index
    
    #cmp %rdx, $0        #check if i<0
    #ja .invalid_index
    leaq 1(%rsi),%rsi     #increase in one byte to skip first byte of pstring - length
    leaq 1(%rdi),%rdi
    
    movq $0,%r8            #index of first string
    
    cmp %r8,%rcx           #check if counter < j
    ja .forLoopCopy
    jmp .endLoopCopy       
    
    .forLoopCopy:
        cmp %r8,%rdx       #check if counter == i
        je .startCopy      #if we got to the i indexstart copy  
        jmp .continue      #else - continue iterate the string

    .startCopy:              #if we got here we can start replace the string between i-j index
        movb (%rsi),%r10b    #save in %r10 the secondString[i]
        movb %r10b,(%rdi)     #replace firstString[i] with secondString[i]
        
        leaq 1(%rdi),%rdi    #update index of strings
        leaq 1(%rsi),%rsi
        addq $1,%r8          #update counter
        cmp %r8,%rcx        #check if counter < =j
        jae .startCopy      #if counter still less than j keep copy
        jmp .endLoopCopy    #if we finish copy end loop
    
    .endLoopCopy:
        xorq  %rax, %rax    #set %rax to zero
        movq %r9,%rax       #set return value to be a pointer to the start of first pstring
        ret

    .continue:              #continue itarate the strings untill we get to the i index
        leaq 1(%rdi),%rdi   #update iterators
        leaq 1(%rsi),%rsi
        addq $1,%r8          #update counter
        jmp .forLoopCopy
    
    .invalid_index:        #we jump here if the user entered invalid index of i and j
        xorq  %rax, %rax   #set %rax to zero
        xorq  %rdi, %rdi   #set %rdi to zero
        movq $input_not_valid,%rdi  #set the argument of printf function to be a messge
        call printf
        jmp .endLoopCopy   #jump to end of loop      
       
                
.global swapCase
    .type swapCase, @function
    #rdi - point to start of string
swapCase:
    movq %rdi,%rdi          #get first aegument
    xorq %r9,%r9
    movq %rdi,%r9           #backup pointer to string in %r9
    
    xorq %r8,%r8
    movb (%rdi),%r8b            #save the length of p-string in %r8
    
    leaq 1(%rdi),%rdi       #increase in one byte to skip first byte of pstring - length

    xorq  %rax, %rax            #the loop counter
    
    
    
    .forLoopSwap:
    cmp %rax,%r8            #check if we can go over the string
    jle .endSwap            #if we finish go over the string - counter<length
    
    xorq %r11,%r11
    movb (%rdi),%r11b       #save sting[i] in %r11
    
    cmpb $65,%r11b               
    jb .noNeedSwap          #if < 65 not capital/small
    jae .checkIfCapital     #if >= 65 check if capital
    
 #   cmpb $90,%r11b         
  #  ja .noNeedSwap          #if > 122 not capital/small
    #jbe .checkIfSmall       #if <=122 check if small
    
    .checkIfCapital:
    cmpb $90,%r11b
    ja .checkIfSmall        #if > 90 not capital, else 65<=i<=90 -> this is capital letter!
    addb $32,%r11b          #make the capital letter to be small leter
    movb %r11b,(%rdi)       #replace mission
    incq %rax               #update counter of for loop - i++
    incq %rdi               #update pointer to current location of string
    jmp .forLoopSwap        #continue loop
    
   .checkIfSmall:
   cmpb $97,%r11b           #check if the letter is small letter - if not continue iterate, else replace it
   jb .noNeedSwap
   cmpb $122,%r11b          #check if ASCCI value of letter is between 97 to 122
   ja .noNeedSwap
   subb $32,%r11b           #make the small letter to be capital leter
   movb %r11b,(%rdi)        #replace mission
   incq %rax                #update counter of for loop - i++
   incq %rdi                #update pointer to current location of string
   jmp .forLoopSwap
   
   .noNeedSwap: 
   incq %rax                #update counter of for loop - i++
   incq %rdi                #update pointer to current location of string
   jmp .forLoopSwap         #continue loop
   
   .endSwap:
   xorq  %rax, %rax         #set register to be zero
   movq %r9,%rax            #set return value to be pointer to start of pstring
   ret   

.global pstrijcmp
    .type pstrijcmp, @function
pstrijcmp:
         #rdi - pointer to first string
         #rsi - pointer to second string
         #rdx - index i, %rcx - index j
         movq %rdi,%rdi          #get first aegument
         movq %rdi,%r11
         movq %rsi,%rsi          #get second argument
         movq %rsi,%r12
         xorq %r9,%r9
         movq %rdi,%r9           #backup pointer to first string in %r9
         #first let's check if the index are valid input
         cmpb %dl,(%r11)        #check if i > first string length
         jbe .invalid
         cmpb %cl,(%r12)        #check if j > second string length
         jbe .invalid
         leaq 1(%r12),%r12      #increase in one byte to skip first byte of pstring - length
         leaq 1(%r11),%r11
         movq $0,%r8            #index of first string
         cmp %r8,%rcx           #check if counter < j
         ja .forLoopCompare
         jmp .endLoopCompare
         .forLoopCompare:
         cmp %r8,%rdx              #check if counter == i
         je .compare               #if we got to the i indexstart copy
         jmp .continueCompare      #else - continue iterate the string
        .compare:
        cmpb %r11,%r12
        jb .big                    # if rdi > rsi
        je .equal                  # if rdi = rsi
        ja .littel                 # if rdi < rsi
        .endLoopCompare:
        xorq  %rax, %rax           #set %rax to zero
        movq %r9,%rax              #set return value to be a pointer to the start of first pstring
        ret
        .continueCompare:          #continue itarate the strings untill we get to the i index
        leaq 1(%r11),%r11          #update iterators
        leaq 1(%r12),%r12
        addq $1,%r8                #update counter
        jmp .forLoopCompare
        .invalid:            #we jump here if the user entered invalid index of i and j
        xorq  %rax, %rax           #set %rax to zero
        xorq  %r11, %r11           #set %rdi to zero
        movq $input_not_valid, %r11  #set the argument of printf function to be a messge
        call printf
        xorq  %rax, %rax           #set %rax to zero
        movq  $-2,%rax              #set return value to be a pointer to the start of first pstring
        ret
        .big:
        xorq  %rax, %rax            #set %rax to zero
        movq  %r9,%rax              #set return value to be a pointer to the start of first pstring
        movq  $1,%r9
        ret
        .equal:
        xorq  %rax, %rax            #set %rax to zero
        movq  %r9,%rax              #set return value to be a pointer to the start of first pstring
        movq  $0,%r9
        ret
        .littel:
        xorq  %rax, %rax            #set %rax to zero
        movq  %r9,%rax              #set return value to be a pointer to the start of first pstring
        movq  $-1,%r9
        ret