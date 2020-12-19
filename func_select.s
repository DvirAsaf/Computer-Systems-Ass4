#	313531113	Dvir Asaf

.data
.section	.rodata
               format_of_input_int:     .string "%d"
               format_case50_printf:    .string "first pstring length: %d, second pstring length: %d\n"
               format_case52_getChar:   .string " %c"
               format_case52_printf:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
               format_case53_printf:    .string "length: %d, string: %s\n"
               case55_format_for_print:     .string "compare result: %d\n"
               invalid_option_output_format:   .string "invalid option!\n"
.align 8 #Align address to multiple of 8
.userOptions:
              .quad .case50 #50
              .quad .defulteCase #51
              .quad .case52 #52
              .quad .case53 #53
              .quad .case54 #54
              .quad .case55 #55
              .quad .defulteCase #56
              .quad .defulteCase #57
              .quad .defulteCase #58
              .quad .defulteCase #59
              .quad .case50 #60
.text
.global run_func
.type run_func, @function

run_func:
                 pushq %rbp                           #backup %rbp
                 movq %rsp,%rbp                       #make rbp point to the address of the stack pointer

                 pushq %r12                           #backup the CALLE REGISTER
                 pushq %r14                           #%r14 - pointer to second pstring, %r12 -pointer to first pstring
                 pushq %rbx
                 pushq %r15

                 movq %rsi,%r12                       #save the argument of function in register
                 movq %rdx,%r14
		leaq -50(%rdi),%rcx                   #register %rdi contains the input value  (user option)
                                                       #compute xi=x-100
		cmpq $10,%rcx	                     #compare xi:3
		ja .defulteCase                       #if >, goto defulte case
		jmp *.userOptions(,%rcx,8)             #goto jump table[xi]

                #case 50 - the user option is 50 so call function pstrlen to get the length of both pstring

                .case50:
                        xorq  %rax, %rax               #set rgister to be zero
                        xorq  %rdi, %rdi
                        movq %r12,%rdi                 #set first argument of pstring function to be the address of start
                                                       #of the first pstring
                        call pstring
                        movq %rax,%rsi                 #set %rsi register,second argumnet of function printf, to be the return
                                                       #result of pstring function

                        xorq  %rax, %rax               #set rgister to be zero
                        xorq  %rdi, %rdi
                        movq %r14,%rdi                 #set first argument of pstring function to be the address of start
                                                       #of the second pstring
                        call pstring
                        movq %rax,%rdx                 #set %rdx register,third argumnet of function printf, to be the return
                                                       #result of pstring function

                        xorq  %rdi, %rdi
                        movq $format_case50_printf,%rdi #the first argument of scanf function is pointer to the format
                                                        #of string input
                        xorq %rax, %rax
                        call printf

                	    jmp .end_switch


                #case 52 - the user option is 52 so get from the user to char input and call replaceChar function
                .case52:
                         subq $1,%rsp                   #allocate memory on stack for scanf char input of one byte size
                         xorq %rdi,%rdi
                         movq $format_case52_getChar,%rdi
                         movq %rsp,%rsi                 #the second argument of scanf function is pointer to the
                                                        #location on stack where we want to write the input value
                         xorq  %rax, %rax               #set rgister to be zero
                         call scanf

                         xorq %rbx,%rbx                   #set rgister to be zero
                         movb (%rsp),%bl               #save the old cahr in %rbx register


                         subq $1,%rsp                   #allocate memory on stack for scanf char input of one byte size
                         xorq %rdi,%rdi
                         movq $format_case52_getChar,%rdi
                         movq %rsp,%rsi                 #the second argument of scanf function is pointer to the
                                                        #location on stack where we want to write the input value
                         xorq  %rax, %rax               #set rgister to be zero
                         call scanf

                         xorq %r15,%r15                   #set rgister to be zero
                         movb (%rsp),%r15b               #save the new cahr in %r15 register

                         addq $2,%rsp                   #reallocate

                         xorq %rdi,%rdi                 #set rgister to be zero
                         xorq %rsi,%rsi
                         xorq %rdx,%rdx
                         xorq %rax,%rax

                         movq %r12,%rdi                 #set first aegument to be pointer to start of first string
                         movq %rbx,%rsi
                         movq %r15,%rdx

                         call replaceChar              #call replaceChar function

                         movq %r14,%rdi                 #set first aegument to be pointer to start of second string
                         xorq  %rax, %rax
                         call replaceChar

                         #start printf the result:
                         xorq %rdi,%rdi                 #set rgister to be zero
                         xorq  %rsi, %rsi
                         xorq  %rcx, %rcx
                         xorq  %r8, %r8
                         xorq  %rax, %rax

                         movq $format_case52_printf,%rdi    #first aegument of function -format of printing
                         movq %rbx,%rsi                     #second argument - old char
                         movq %r15,%rdx                      #second argument - new char

                         leaq 1(%r12),%rcx                  #third argument - pointer to start of strings
                         leaq 1(%r14),%r8

                         call printf

                         jmp .end_switch

                #case 53 - the user option is 53 so get from the user 2 int input and call pstrijcpy function
                .case53:
                         leaq -4(%rsp),%rsp                 #increase the size of the stack in size if input (of type int)
                         xorq %rdi,%rdi
                         xorq  %rax, %rax
                         xorq  %rsi, %rsi

                         movq $format_of_input_int,%rdi  #the first argument of scanf function is pointer to the format
                                                            #of string input
                         movq %rsp,%rsi
                         call scanf                         #get the first input from user -index i

                         xorq %r15,%r15
                         movb (%rsp),%r15b                 #save index i in %r15 register (char is only one byte)

                         ###scanf the end index j:
                         leaq -4(%rsp),%rsp                 #increase the size of the stack in size if input (of type int)
                         xorq  %rax, %rax
                         xorq %rdi,%rdi
                         xorq  %rsi, %rsi
                         movq $format_of_input_int,%rdi  #the first argument of scanf function is pointer to the format
                                                            #of string input

                         movq %rsp,%rsi
                         call scanf                         #get the first input from user -index i

                         xorq %rbx,%rbx
                         movb (%rsp),%bl                  #save index i in %rbx egister  (char is only one byte)

                         leaq 8(%rsp),%rsp                  #reallocated

                         #prepering call pstrijcpy function:
                         xorq  %rax, %rax
                         xorq %rdi,%rdi
                         xorq  %rcx, %rcx
                         xorq  %rdx, %rdx

                         movq %r12,%rdi                     #first argument - pointer to first string
                         movq %r14,%rsi                     #second argument - pointer to second string
                         movb %r15b,%dl                     #third argumnet - index i (start) (char is only one byte)
                         movb %bl,%cl                     #forth argument - index j (end)(char is only one byte)

                         call pstrijcpy

                         xorq  %rax, %rax                   #set rgister to be zero
                         xorq %rdi,%rdi
                         movq $format_case53_printf,%rdi    #the first argument of scanf function is pointer to the format
                                                            #of string input
                         xorq %rsi,%rsi
                         movb (%r12),%sil                   #set second argument to be the length of pstring
                         leaq 1(%r12),%rdx                  #skip the pstring length

                         call printf

                         xorq  %rax, %rax                   #set rgister to be zero
                         xorq %rdi,%rdi
                         movq $format_case53_printf,%rdi    #the first argument of scanf function is pointer to the format
                                                            #of string input
                         xorq %rsi,%rsi
                         movb (%r14),%sil                   #set second argument to be the length of pstring
                         leaq 1(%r14),%rdx                  #skip the pstring length

                         call printf


                		jmp .end_switch
                #case 54 - the user option is 54 so call swapCase function
                .case54:
                         xorq %rdi,%rdi                     #set rgister to be zero
                         xorq  %rax, %rax
                         xorq  %rsi, %rsi

                         movq %r12,%rdi                     #first argument - pointer to start of first pstring
                         call swapCase

                         xorq %rdi,%rdi                     #set rgister to be zero
                         xorq  %rax, %rax
                         xorq  %rsi, %rsi

                         movq $format_case53_printf,%rdi    #first argument - format of printf function
                         movb (%r12),%sil                   #set second argument to be the length of pstring
                         leaq 1(%r12),%rdx                  #skip the pstring length

                         call printf
                         xorq %rdi,%rdi                     #set rgister to be zero
                         xorq  %rax, %rax
                         xorq  %rsi, %rsi

                         movq %r14,%rdi                     #first argument - pointer to start of second pstring
                         call swapCase

                         xorq %rdi,%rdi                     #set rgister to be zero
                         xorq  %rax, %rax
                         xorq  %rsi, %rsi

                         movq $format_case53_printf,%rdi    #first argument - format of printf functionr
                         movb (%r14),%sil                   #set second argument to be the length of pstring
                         leaq 1(%r14),%rdx                  #skip the pstring length

                         call printf
                         jmp .end_switch


                #defult case - the user enter invalid option
                .case55:
                        leaq -4(%rsp),%rsp                 #increase the size of the stack in size if input (of type int)
                        xorq %rdi,%rdi
                        xorq  %rax, %rax
                        xorq  %rsi, %rsi

                        movq $format_of_input_int,%rdi  #the first argument of scanf function is pointer to the format
                                                                            #of string input
                        movq %rsp,%rsi
                        call scanf                         #get the first input from user -index i

                        xorq %r15,%r15
                        movb (%rsp),%r15b                 #save index i in %r15 register (char is only one byte)

                        ###scanf the end index j:
                        leaq -4(%rsp),%rsp                 #increase the size of the stack in size if input (of type int)
                        xorq  %rax, %rax
                        xorq %rdi,%rdi
                        xorq  %rsi, %rsi
                        movq $format_of_input_int,%rdi  #the first argument of scanf function is pointer to the format
                                                                            #of string input

                        movq %rsp,%rsi
                        call scanf                         #get the first input from user -index i

                        xorq %rbx,%rbx
                        movb (%rsp),%bl                  #save index i in %rbx egister  (char is only one byte)

                        leaq 8(%rsp),%rsp                  #reallocated

                                         #prepering call pstrijcpy function:
                        xorq  %rax, %rax
                        xorq %rdi,%rdi
                        xorq  %rcx, %rcx
                        xorq  %rdx, %rdx

                        movq %r12,%rdi                     #first argument - pointer to first string
                        movq %r14,%rsi                     #second argument - pointer to second string
                        movb %r15b,%dl                     #third argumnet - index i (start) (char is only one byte)
                        movb %bl,%cl                     #forth argument - index j (end)(char is only one byte)

                        call pstrijcmp

                        xorq  %rax, %rax                   #set rgister to be zero
                        xorq %rdi,%rdi
                        movq $case55_format_for_print,%rdi    #the first argument of scanf function is pointer to the format
                                                                            #of string input
                        xorq %rsi,%rsi
                        movb (%r12),%sil                   #set second argument to be the length of pstring
                        leaq 1(%r12),%rdx                  #skip the pstring length

                        call printf
                        jmp .end_switch
                .case60:
                        jmp .case50
                .defulteCase:
                          movq $invalid_option_output_format, %rdi  #first argument - format of printf function
                          xorq %rax, %rax                           #set rgister to be zero
                          call printf

                .end_switch:
                         popq %r14                          #restor CALLE SAVE REGISTER
                         popq %r12
                         popq %rbx
                         popq %r15
                         movq %rbp,%rsp                      #free stack frame's memory
                         popq %rbp                            #restore %rbp
                		ret
