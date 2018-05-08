;Stanley Yoang
;
;

INCLUDELIB	libcmt.lib
INCLUDELIB	legacy_stdio_definitions.lib

EXTERN	printf:PROC
EXTERN	scanf:PROC

.DATA
corp	BYTE	"Find combination or permutation? (c or p) ", 0
promptn	BYTE	"Enter the total objects (n): ", 0
promptr	BYTE	"Enter the objects taken (r): ", 0
promptc BYTE	"The number of combinations is %d.	", 0
promptp BYTE	"The number of permutations is %d.	", 0
errmsg	BYTE	"Incorrect inputs, try again.	", 10, 0
rbign	BYTE	"r must be smaller than n. Try again.", 10, 0
again	BYTE	10, "Would you like to perform another operation? ", 0
prompt0 BYTE	"Value must be larger than 0.", 10, 0
prompte BYTE	"Closing program.", 0
checky	BYTE	"yes", 0
infmt	BYTE	"%d", 0
inpt	BYTE	"%s", 0
num		QWORD	?
user	BYTE	60 DUP (0)
user2	BYTE	3 DUP (0)

.CODE
main	PROC
		sub		rsp, 120
prompt:
		lea		rcx, corp
		call	printf
		lea		rdx, user
		lea		rcx, inpt
		call	scanf
		mov		al, user
		cmp		al, "c"
		jne		L1
		call	comb
		jmp		yes
L1:
		cmp		al, "p"
		jne		check
		call	perm
		jmp		yes
check:
		lea		rcx, errmsg
		call	printf
		jmp		prompt
yes:
		lea		rcx, again
		call	printf
		lea		rdx, user2
		lea		rcx, inpt
		call	scanf

		lea		rsi, user2
		lea		rdi, checky
		mov		ecx, 4
		repe	cmpsb
		je		prompt
		
extCd:
		lea		rcx, prompte
		call	printf
		add		rsp, 120
		mov		rax, 0
		ret
main	ENDP

fact	PROC
		push	rbp
		mov		rbp, rsp

		mov		rax, [rbp+16]
		cmp		rax, 1
		jle		extCd
		dec		rax

		push	rax
		call	fact
		mov		rbx, [rbp+16]
		imul	rbx
extCd:
		mov		rsp, rbp
		pop		rbp
		ret
fact	ENDP

;n!/((n-r)!*r!)
comb	PROC
		sub		rsp, 24
		push	rbp
		mov		rbp, rsp
L1:
		;get n
		lea		rcx, promptn
		call	printf
		lea		rdx, num
		lea		rcx, infmt
		call	scanf
		mov		r12, num
		shl		r12, 32
		sar		r12, 32
		cmp		r12, 0
		jg		L2
		lea		rcx, prompt0
		call	printf
		jmp		L1
L2:
		;get r
		lea		rcx, promptr
		call	printf
		lea		rdx, num
		lea		rcx, infmt
		call	scanf
		mov		r13, num
		shl		r13, 32
		sar		r13, 32
		cmp		r13, 0
		jg		L3
		lea		rcx, prompt0
		call	printf
		jmp		L2
L3:
		;check n and r
		cmp		r12, r13
		jnl		eval
		lea		rcx, rbign
		call	printf
		jmp		L2

eval:
		;(n-r)!
		cmp		r12, r13
		jne		eval2
		mov		r14, 1
		jmp		eval3

eval2:
		mov		rcx, r12
		sub		rcx, r13
		push	rcx
		call	fact
		mov		r14, rax

eval3:
		;r!
		mov		rcx, r13
		push	rcx
		call	fact
		imul	r14, rax

		;n!
		mov		rcx, r12
		push	rcx
		call	fact

		;n!/((n-r)!*r!)
		div		r14
		mov		r15, rax

		lea		rcx, promptc
		mov		rdx, r15
		call	printf

		mov		rsp, rbp
		pop		rbp
		add		rsp, 24
		ret
comb	ENDP

;n!/(n-r)!
perm	PROC
		sub		rsp, 24
		push	rbp
		mov		rbp, rsp
L1:
		;get n
		lea		rcx, promptn
		call	printf
		lea		rdx, num
		lea		rcx, infmt
		call	scanf
		mov		r12, num
		shl		r12, 32
		sar		r12, 32
		cmp		r12, 0
		jg		L2
		lea		rcx, prompt0
		call	printf
		jmp		L1
L2:
		;get r
		lea		rcx, promptr
		call	printf
		lea		rdx, num
		lea		rcx, infmt
		call	scanf
		mov		r13, num
		shl		r13, 32
		sar		r13, 32
		cmp		r13, 0
		jg		L3
		lea		rcx, prompt0
		call	printf
		jmp		L2
L3:
		;check n and r
		cmp		r12, r13
		jnl		eval
		lea		rcx, rbign
		call	printf
		jmp		L2
eval:
		;(n-r)!
		cmp		r12, r13
		jne		eval2
		mov		r14, 1
		jmp		eval3
eval2:
		mov		rcx, r12
		sub		rcx, r13
		push	rcx
		call	fact
		mov		r14, rax	
eval3:
		;n!
		mov		rcx, r12
		push	rcx
		call	fact

		;n!/(n-r)!
		div		r14
		mov		r15, rax

		lea		rcx, promptp
		mov		rdx, r15
		call	printf

		mov		rsp, rbp
		pop		rbp
		add		rsp, 24
		ret
perm	ENDP
END