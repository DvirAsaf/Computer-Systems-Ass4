#	313531113	Dvir Asaf
.data
.section .rodata
    format_of_input_int: .string "%d"
    foramt_of_input_string:    .string "%s\0"
    string_output_format:   .string "your string is: %s\n"


.text
.global main
    .type main, @function
main:
   # movq %rsp, %rbp #for correct debugging
   
     
    pushq %rbp                                     #start of function - backup the old %rsp
    movq %rsp,%rbp                                 #make rbp point to the address of the stack pointer
    
    leaq -4(%rsp),%rsp                            #increase the size of the stack in size if input (of type int)
    
    
    movq $format_of_input_int,%rdi                #the first argument of scanf function is pointer to the format 
                                                  #of string input
    
    movq %rsp,%rsi                                #the second argument of scanf function is pointer to the 
                                                  #location on stack where we want to write the input value
   
    xorq  %rax, %rax                                 #set rgister to be zero
    call scanf                                        #call scanf function
    
    
    movl (%rsp),%ebx                              #save the size of first string(input) in CALLEE SAVE REGISTER
    leaq 4(%rsp),%rsp                             #resize the stack original size
    
    subq %rbx,%rsp                                #increase the stack size according to the size of first string
    subq $2,%rsp                                  #we need extra 2 bytes - one for saving the string's length, and one for '\0'
    
                                                    #now we want to set the lowest address of the main frame to be the length of the 
                                                    #first string. according to the exercize instruction we know that the maximum length of
                                                    #a p-string is between 0 to 255, but as a string we can this is one byte (char)
                                                    #so we used movb and %bl - represent the first byte of %rbx register
    movb %bl,(%rsp)
    
    ##############################################################################
    #prepering scanf the string from the user
    ##############################################################################
    
    #we set %rsi register(second argument) points to wher %rsp points
    #(location on stack where we want to write the input value)   
    movq %rsp,%rsi
    #because we already set the lowest address to be the length of first string as required
    #so now we want to increase in 1 this address so can continue writing the rest of the user string
    addq $1,%rsi
    
    #the first argument of scanf function is pointer to the format of string input
    movq $foramt_of_input_string,%rdi
   
    movq $0,%rax
    call scanf
    
    
  #  movq $string_output_format,%rdi
  #  movq %rsp,%rsi
   # movq $0,%rax
    #call printf
    
    
    
    #save in CALLE SAVE register the assress of the start of first p-string
    movq %rsp,%r12
    
    ####################################################################
    #start scaning the second part of user input: second string and its size
   
     #increase the size of the stack in size if input (of type int)
    leaq -4(%rsp),%rsp
    #the first argument of scanf function is pointer to the format of string input
    movq $format_of_input_int,%rdi 
    #the second argument of scanf function is pointer to the location on stack where we want to write the input value
    movq %rsp,%rsi
    #set rgister to be zero
    xorq  %rax, %rax
    call scanf
    
    movl (%rsp),%r13d #save the size of first string(input) in CALLEE SAVE REGISTER
    leaq 4(%rsp),%rsp#resize the stack original size
    
    subq %r13,%rsp #increase the stack size according to the size of first string
    #we need extra 2 bytes - one for saving the string's length, and one for '\0'
    subq $2,%rsp
    #now we want to set the lowest address of the main frame to be the length of the 
    #first string. according to the exercize instruction we know that the maximum length of
    #a p-string is between 0 to 255, but as a string we can this is one byte (char)
    #so we used movb and %bl - represent the first byte of %rbx register
    movb %r13b,(%rsp)
    
    
     ##############################################################################
    #prepering scanf the string from the user
    ##############################################################################
    
    #we set %rsi register(second argument) points to wher %rsp points
    #(location on stack where we want to write the input value)   
    movq %rsp,%rsi
    #because we already set the lowest address to be the length of first string as required
    #so now we want to increase in 1 this address so can continue writing the rest of the user string
    addq $1,%rsi
    
    #the first argument of scanf function is pointer to the format of string input
    movq $foramt_of_input_string,%rdi
    movq $0,%rax
    call scanf
    
    #save in CALLE SAVE register the assress of the start of second string
    movq %rsp,%r14
    
    ########################################################################################
    #start scaning the third part of user input:the user option
    ########################################################################################
    
    leaq -4(%rsp),%rsp                  #increase the size of the stack in size if input (of type int)
    movq $format_of_input_int,%rdi      #the first argument of scanf function is pointer to the format 
                                        #of string input
    movq %rsp,%rsi                      #the second argument of scanf function is pointer to the 
                                        #location on stack where we want to write the input value
    xorq  %rax, %rax                    #set rgister to be zero
    call scanf
    
    xorq %rbx,%rbx                      #set rgister to be zero
    movl (%rsp),%ebx                    #set %rbx CALLE SAVE to be the user option
    leaq 4(%rsp),%rsp                   #resize the stack original size
    
    movq %rbx,%rdi                      #set first argunment to be the option number
    movq %r12,%rsi                      #set second argunment to be the pointer to the start of first pstring
    movq %r14,%rdx                      #set third argunment to be the pointer to the start of second pstring
    
    call run_func
    
    
    
    movq %rbp,%rsp                      #free stack frame's memory
    pop %rbp                            #restore %rbp
    ret    
