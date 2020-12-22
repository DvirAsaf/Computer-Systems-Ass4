#	313531113	Dvir Asaf
.data
.section .rodata
            input_int_format:       .string "%d"
            input_string_format:    .string "%s\0"
            output_string_format:      .string "your string is: %s\n"
.text
.global main
    .type main, @function
main:                                            #part 1 : scan input int & string
            pushq %rbp                           #func start - backup the old rsp
            movq %rsp,%rbp                       #rbp point to the add of the stack pointer
            leaq -4(%rsp),%rsp                   #increase size of stack in size of input
            movq $input_int_format,%rdi          #1'st arg of scanf func is pointer to the format of string input
            movq %rsp,%rsi                       #2'st arg of scanf func is pointer to the location on stack where writing the input val.
            xorq  %rax, %rax                     #set rax to be 0.
            call scanf
            movl (%rsp),%ebx                     #saving 1'st input string size in callee register
            leaq 4(%rsp),%rsp                    #resize the stack original size
            subq %rbx,%rsp                       #increase the stack size according to 1'st string size.
            subq $2,%rsp                         #need extra 2 bytes : 1. for string's length 2. for '\0'
            movb %bl,(%rsp)
                                                 #scanf the string
            movq %rsp,%rsi                       #set rsi points to where rsp points(the location on stack where writing the input val)
            addq $1,%rsi                         #increase address so can continue writing the rest of the user string
            movq $input_string_format,%rdi       #the 1'st arg of scanf func is pointer to the format of string input
            movq $0,%rax
            call scanf
            movq %rsp,%r12
                                                 #part 2 : scan input int & string
                                                 #scanf the 2'st input
            leaq -4(%rsp),%rsp                   #increase size of stack in size of input
            movq $input_int_format,%rdi          #the 1'st arg of scanf func is pointer to the format of string input
            movq %rsp,%rsi                       #2'st arg of scanf func is pointer to the location on stack where writing the input val.
            xorq  %rax, %rax                     #set rax to be 0.
            call scanf
            movl (%rsp),%r13d                    #saving 1'st input string size in callee register
            leaq 4(%rsp),%rsp                    #resize the stack original size
            subq %r13,%rsp                       #increase the stack size according to 1'st string size.
            subq $2,%rsp                         #need extra 2 bytes : 1. for string's length 2. for '\0'
            movb %r13b,(%rsp)
                                                 #scanf the 2'st string
            movq %rsp,%rsi                       #set rsi points to where rsp points(the location on stack where writing the input val)
            addq $1,%rsi                         #increase address so can continue writing the rest of the user string
            movq $input_string_format,%rdi       #the 1'st arg of scanf func is pointer to the format of string input
            movq $0,%rax
            call scanf
            movq %rsp,%r14                       #saving 2'st input string size in callee register
                                                 #part 3 : scan input int option
            leaq -4(%rsp),%rsp                   #increase size of stack in size of input
            movq $input_int_format,%rdi          #the 1'st arg of scanf func is pointer to the format of string input
            movq %rsp,%rsi                       #2'st arg of scanf func is pointer to the location on stack where writing the input val.
            xorq  %rax, %rax                     #set rax to be 0.
            call scanf
            xorq %rbx,%rbx                       #set rbx to be 0.
            movl (%rsp),%ebx                     #set rbx callee -> user option
            leaq 4(%rsp),%rsp                    #resize the stack original size
            movq %rbx,%rdi                       #set 1'st arg to be the option number
            movq %r12,%rsi                       #set 2'st arg to be the pointer to the start of 1;st pstring
            movq %r14,%rdx                       #set 3'st arg to be the pointer to the start of 2'st pstring
            call run_func
            movq %rbp,%rsp                       #free stack frame's memory
            pop %rbp                             #restore %rbp
            xorq %rax,%rax                       #set rax to be 0.
            ret
