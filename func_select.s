#	313531113	Dvir Asaf
.data
.section	.rodata
               input_format:                .string "%d"
               case50_format_for_print:     .string "first pstring length: %d, second pstring length: %d\n"
               case52_getChar:              .string " %c"
               case52_format_for_print:     .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
               case53_format_for_print:     .string "length: %d, string: %s\n"
               case55_format_for_print:     .string "compare result: %d\n"
               invalid_option_format:       .string "invalid option!\n"
.align 8 #Align address to multiple of 8
.userOptions:
              .quad .case50                  #50
              .quad .defulte                 #51
              .quad .case52                  #52
              .quad .case53                  #53
              .quad .case54                  #54
              .quad .case55                  #55
              .quad .defulte                 #56
              .quad .defulte                 #57
              .quad .defulte                 #58
              .quad .defulte                 #59
              .quad .case50                  #60
.text
.global run_func
    .type run_func, @function
run_func:
               pushq %rbp                    #backup register rbp.
               movq %rsp,%rbp                #make rbp point to the address of the stack pointer.
               pushq %r12                    #backup the calle registers: r12,r14,rbx,r15.
               pushq %r14                    #r12 - pointer to 1'st pstring & r14 - pointer to 2'st pstring.
               pushq %rbx
               pushq %r15
               movq %rsi,%r12                #function argument save in register.
               movq %rdx,%r14
		       leaq -50(%rdi),%rcx           #rdi contains the input value that user choose.
                                             #compute xi=x-100
		       cmpq $10,%rcx	             #compare xi:10
		       ja .defulte                   #goto defulte
		       jmp *.userOptions(,%rcx,8)    #goto jump table[xi]
                #user option -> 50 : so call func pstring to get the length of both pstring
                .case50:
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq  %rdi, %rdi     #set rdi to be 0.
                        movq %r12,%rdi       #set 1'st arg of pstring func to be the add of start of the 1'st pstring.
                        call pstring
                        movq %rax,%rsi       #set rsi reg, 2'st arg of func printf, to be the return result of pstring func.
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq  %rdi, %rdi     #set rdi to be 0.
                        movq %r14,%rdi       #set 1'st arg of pstring func to be the add of start of the 2'st pstring.
                        call pstring
                        movq %rax,%rdx       #set rdx reg, 3'st arg of func printf, to be the return result of pstring func.
                        xorq  %rdi, %rdi     #set rdi to be 0.
                        movq $case50_format_for_print,%rdi
                                             #the 1'st arg of scanf func is pointer to the format of string input
                        xorq %rax, %rax      #set rax to be 0.
                        call printf
                	    jmp .end
                #user option -> 52 : so get char from user & call func replaceChar.
                .case52:
                        subq $1,%rsp         #allocate memory on stack for scanf char input of 1 byte size.
                        xorq %rdi,%rdi       #set rdi to be 0.
                        movq $case52_getChar,%rdi
                        movq %rsp,%rsi       #the 2'st arg of scanf func is pointer to the location on stack where we want to write the input val.
                        xorq  %rax, %rax     #set rax to be 0.
                        call scanf
                        xorq %rbx,%rbx       #set rbx to be 0.
                        movb (%rsp),%bl      #save the old char in rbx.
                        subq $1,%rsp         #allocate memory on stack for scanf char input of 1 byte size.
                        xorq %rdi,%rdi       #set rdi to be 0.
                        movq $case52_getChar,%rdi
                        movq %rsp,%rsi       #the 2'st arg of scanf func is pointer to location on stack where we want to write the input val.
                        xorq  %rax, %rax     #set rax to be 0.
                        call scanf
                        xorq %r15,%r15       #set r15 to be 0.
                        movb (%rsp),%r15b    #save the new char in r15.
                        addq $2,%rsp         #reallocate
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq %rsi,%rsi       #set rsi to be 0.
                        xorq %rdx,%rdx       #set rdx to be 0.
                        xorq %rax,%rax       #set rax to be 0.
                        movq %r12,%rdi       #set 1'st arg to be pointer to start of 1'st string.
                        movq %rbx,%rsi
                        movq %r15,%rdx
                        call replaceChar
                        movq %r14,%rdi       #set 1'st arg to be pointer to start of 2'st string.
                        xorq  %rax, %rax     #set rax to be 0.
                        call replaceChar
                        #start printf the result:
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rsi, %rsi     #set rsi to be 0.
                        xorq  %rcx, %rcx     #set rcx to be 0.
                        xorq  %r8, %r8       #set r8 to be 0.
                        xorq  %rax, %rax     #set rax to be 0.
                        movq $case52_format_for_print,%rdi
                                             #1'st arg of func - format of print.
                        movq %rbx,%rsi       #2'st arg - old char.
                        movq %r15,%rdx       #2'st arg - new char.
                        leaq 1(%r12),%rcx    #3'st arg - pointer to start of strings
                        leaq 1(%r14),%r8
                        call printf
                        jmp .end
                #user option -> 53 : so get 2 int from user & call func pstrijcpy.
                .case53:
                        #scanf index i:
                        leaq -4(%rsp),%rsp   #increase size of stack in size of input.
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq  %rsi, %rsi     #set rsi to be 0.
                        movq $input_format,%rdi
                                             #1'st arg of scanf func is pointer to the format of string input.
                        movq %rsp,%rsi
                        call scanf           #get 1'st input from user - index i.
                        xorq %r15,%r15       #set r15 to be 0.
                        movb (%rsp),%r15b    #save index i in r15 (1 byte).
                        #scanf index j:
                        leaq -4(%rsp),%rsp   #increase size of stack in size of input.
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rsi, %rsi     #set rsi to be 0.
                        movq $input_format,%rdi
                                             #1'st arg of scanf func is pointer to the format of string input.
                        movq %rsp,%rsi
                        call scanf           #get 2'st input from user - index j.
                        xorq %rbx,%rbx       #set rbx to be 0.
                        movb (%rsp),%bl      #save index j in rbx (1 byte).
                        leaq 8(%rsp),%rsp    #reallocated
                        #call pstrijcpy func:
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rcx, %rcx     #set rcx to be 0.
                        xorq  %rdx, %rdx     #set rdx to be 0.
                        movq %r12,%rdi       #1'st arg - pointer to 1'st string.
                        movq %r14,%rsi       #2'st arg - pointer to 2'st string.
                        movb %r15b,%dl       #3'st arg - index i : start (1 byte).
                        movb %bl,%cl         #4'st arg - index j : end (1 byte).
                        call pstrijcpy
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq %rdi,%rdi       #set rdi to be 0.
                        movq $case53_format_for_print,%rdi
                                             #1'st arg of scanf func is pointer to the format of string input.
                        xorq %rsi,%rsi       #set rsi to be 0.
                        movb (%r12),%sil     #set 2'st arg to be the length of pstring.
                        leaq 1(%r12),%rdx    #skip the pstring length
                        call printf
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq %rdi,%rdi       #set rdi to be 0.
                        movq $case53_format_for_print,%rdi
                                             #1'st arg of scanf func is pointer to the format of string input
                        xorq %rsi,%rsi       #set rsi to be 0.
                        movb (%r14),%sil     #set 2'st arg to be the length of pstring.
                        leaq 1(%r14),%rdx    #skip the pstring length.
                        call printf
                		jmp .end
                #user option -> 54 : call func swapCase to change capital <-> small letters.
                .case54:
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq  %rsi, %rsi     #set rsi to be 0.
                        movq %r12,%rdi       #1'st arg - pointer to start of 1'st pstring.
                        call swapCase
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq  %rsi, %rsi     #set rsi to be 0.
                        movq $case53_format_for_print,%rdi
                                             #1'st arg - format of printf func.
                        movb (%r12),%sil     #set 2'st arg to be the length of pstring.
                        leaq 1(%r12),%rdx    #skip the pstring length
                        call printf
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq  %rsi, %rsi     #set rsi to be 0.
                        movq %r14,%rdi       #1'st arg - pointer to start of 2'st pstring.
                        call swapCase
                        xorq %rdi,%rdi       #set rdi to be 0.
                        xorq  %rax, %rax     #set rax to be 0.
                        xorq  %rsi, %rsi     #set rsi to be 0.
                        movq $case53_format_for_print,%rdi
                                             #1'st arg - format of printf func.
                        movb (%r14),%sil     #set 2'st arg to be the length of pstring.
                        leaq 1(%r14),%rdx    #skip the pstring length.
                        call printf
                        jmp .end
                #user option -> 55 : so get 2 int from user & call func pstrijcmp.
                .case55:
                        leaq -4(%rsp),%rsp  #increase size of stack in size of input.
                        xorq %rdi,%rdi      #set rdi to be 0.
                        xorq  %rax, %rax    #set rax to be 0.
                        xorq  %rsi, %rsi    #set rsi to be 0.
                        movq $input_format,%rdi
                                            #1'st arg of scanf func is pointer to the format of string input.
                        movq %rsp,%rsi
                        call scanf          #get 1'st input from user - index i
                        xorq %r15,%r15      #set r15 to be 0.
                        movb (%rsp),%r15b   #save index i in r15 (1 byte).
                        #scanf index j:
                        leaq -4(%rsp),%rsp  #increase size of stack in size of input.
                        xorq  %rax, %rax    #set rax to be 0.
                        xorq %rdi,%rdi      #set rdi to be 0.
                        xorq  %rsi, %rsi    #set rsi to be 0.
                        movq $input_format,%rdi
                                           #1'st arg of scanf func is pointer to the format of string input.
                        movq %rsp,%rsi
                        call scanf         #get 2'st input from user - index j.
                        xorq %rbx,%rbx     #set rbx to be 0.
                        movb (%rsp),%bl    #save index i in rbx (1 byte).
                        leaq 8(%rsp),%rsp  #reallocated
                        #call pstrijcpy func:
                        xorq  %rax, %rax   #set rax to be 0.
                        xorq %rdi,%rdi     #set rdi to be 0.
                        xorq  %rcx, %rcx   #set rcx to be 0.
                        xorq  %rdx, %rdx   #set rdx to be 0.
                        movq %r12,%rdi     #1'st arg - pointer to 1'st string.
                        movq %r14,%rsi     #2'st arg - pointer to 2'st string.
                        movb %r15b,%dl     #3'st arg - index i : start (1 byte).
                        movb %bl,%cl       #4'st arg - index j : end (1 byte).
                        call pstrijcmp
                        movq $case55_format_for_print,%rdi
                                           #1'st arg of scanf func is pointer to the format of string input.
                        movq %rax,%rsi
                        movq $0, %rax
                        call printf
                        jmp .end
                #user option -> 60 : call case 50.
                .case60:
                        jmp .case50
                #defult - user enter invalid option.
                .defulte:
                        movq $invalid_option_format, %rdi
                                            #1'st arg - format of printf func.
                        xorq %rax, %rax     #set rax to be 0.
                        call printf
                .end:
                        popq %r14           #restor calle save registers: r14
                        popq %r12           #r12
                        popq %rbx           #rbx
                        popq %r15           #r15
                        movq %rbp,%rsp      #free stack frame's memory
                        popq %rbp           #restore rbp
                		ret