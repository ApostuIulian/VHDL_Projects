.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Exemplu proiect desenare", 0
area_width EQU 640
area_height EQU 480
area DD 0
click DD 0
counter DD 0 ; numara evenimentele de tip timer
xm1 DD 0
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20
symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc
butonx1 equ 180
butony1 equ 60
butonx2 equ 280
butony2 equ 60
butonx3 equ 380
butony3 equ 60
butonx4 equ 180
butony4 equ 160
butonx5 equ 280
butony5 equ 160
butonx6 equ 380
butony6 equ 160
butonx7 equ 180
butony7 equ 260
butonx8 equ 280
butony8 equ 260
butonx9 equ 380
butony9 equ 260
butons equ 100
cx1 DD 0
cx2 DD 0
cx3 DD 0
cx4 DD 0
cx5 DD 0
cx6 DD 0
cx7 DD 0
cx8 DD 0
cx9 DD 0
co1 DD 0
co2 DD 0
co3 DD 0
co4 DD 0
co5 DD 0
co6 DD 0
co7 DD 0
co8 DD 0
co9 DD 0
eg DD 0
butonMs equ 300
butonMx equ 180
butonMy equ 60
.code
s:
make_text proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] 
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 
	lea esi, letters
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] 
	shl eax, 2 
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
line_oriz macro x, y, len, culoare
local bucla_linie
mov eax, y
mov ebx, area_width
mul ebx
add  eax, x
shl eax, 2
add eax, area
mov ecx, len
bucla_linie:
mov dword ptr[eax], culoare
add eax, 4
loop bucla_linie
endm
line_vert macro x, y, len, culoare
local bucla_linie
mov eax, y
mov ebx, area_width
mul ebx
add  eax, x
shl eax, 2
add eax, area
mov ecx, len
bucla_linie:
mov dword ptr[eax], culoare
add eax, 4*area_width
loop bucla_linie
endm
draw proc
	push ebp
	mov ebp, esp
	pusha	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer 
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere	
evt_click:
inc click
  cmp click,1
  je X
    cmp click,2
  je O
    cmp click,3 
  je X
    cmp click,4 
  je O
    cmp click,5 
  je X
    cmp click,6 
  je O
    cmp click,7 
  je X
    cmp click,8 
  je O
    cmp click,9 
  je X
  cmp click, 10
  je stop
  X:  
  mov eax, [ebp+arg2]
cmp eax, butonx1
jl b1x2
cmp eax, butonx1+butons
jg b1x2
 mov eax, [ebp+arg3]
 cmp eax, butony1
jl b1x2
cmp eax, butony1+butons
jg b1x2
cmp cx1, 1
je e1
cmp co1, 1
je e1
	make_text_macro 'X', area, 225, 100
	mov cx1, 1
	jmp b1x2
	e1:
	dec click
	b1x2:
   mov eax, [ebp+arg2]
cmp eax, butonx2
jl b1x3
cmp eax, butonx2+butons
jg b1x3
 mov eax, [ebp+arg3]
 cmp eax, butony2
jl b1x3
cmp eax, butony2+butons
jg b1x3
cmp cx2, 1
je e2
cmp co2, 1
je e2
	make_text_macro 'X', area, 325, 100
	mov cx2, 1
	jmp b1x3
	e2: 
	dec click
  b1x3:
    mov eax, [ebp+arg2]
cmp eax, butonx3
jl b1x4
cmp eax, butonx3+butons
jg b1x4
 mov eax, [ebp+arg3]
 cmp eax, butony3
jl b1x4
cmp eax, butony3+butons
jg b1x4
cmp cx3, 1
je e3
cmp co3, 1
je e3
	make_text_macro 'X', area, 425, 100
	mov cx3, 1
	jmp b1x4
	e3:
	dec click
	b1x4:
      mov eax, [ebp+arg2]
cmp eax, butonx4
jl b1x5
cmp eax, butonx4+butons
jg b1x5
 mov eax, [ebp+arg3]
 cmp eax, butony4
jl b1x5
cmp eax, butony4+butons
jg b1x5
cmp cx4, 1
je e4
cmp co4, 1
je e4
	make_text_macro 'X', area, 225, 200
	mov cx4, 1
  jmp b1x5
  e4: dec click
  b1x5:
        mov eax, [ebp+arg2]
cmp eax, butonx5
jl b1x6
cmp eax, butonx5+butons
jg b1x6
 mov eax, [ebp+arg3]
 cmp eax, butony5
jl b1x6
cmp eax, butony5+butons
jg b1x6
cmp cx5, 1
je e5
cmp co5, 1
je e5
	make_text_macro 'X', area, 325, 200
	mov cx5, 1
  jmp b1x6
  e5: dec click
  b1x6:
          mov eax, [ebp+arg2]
cmp eax, butonx6
jl b1x7
cmp eax, butonx6+butons
jg b1x7
 mov eax, [ebp+arg3]
 cmp eax, butony6
jl b1x7
cmp eax, butony6+butons
jg b1x7
cmp cx6, 1
je e6
cmp co6, 1
je e6
	make_text_macro 'X', area, 425, 200
	mov cx6, 1
	jmp b1x7
	e6: dec click  
  b1x7:
            mov eax, [ebp+arg2]
cmp eax, butonx7
jl b1x8
cmp eax, butonx7+butons
jg b1x8
 mov eax, [ebp+arg3]
 cmp eax, butony7
jl b1x8
cmp eax, butony7+butons
jg b1x8
cmp cx7, 1
je e7
cmp co7, 1
je e7
	make_text_macro 'X', area, 225,300
		mov cx7, 1
  jmp b1x8
  e7: dec click
  b1x8:
              mov eax, [ebp+arg2]
cmp eax, butonx8
jl b1x9
cmp eax, butonx8+butons
jg b1x9
 mov eax, [ebp+arg3]
 cmp eax, butony8
jl b1x9
cmp eax, butony8+butons
jg b1x9
cmp cx8, 1
je e8
cmp co8, 1
je e8
	make_text_macro 'X', area, 325, 300
	mov cx8, 1
jmp b1x9
e8: dec click
  b1x9:
  cmp eax, butonx9
jl butonfail
cmp eax, butonx9+butons
jg butonfail
 mov eax, [ebp+arg3]
 cmp eax, butony9
jl butonfail
cmp eax, butony9+butons
jg butonfail
cmp cx9, 1
je e9
cmp co9, 1
je e9
	make_text_macro 'X', area, 425, 300
		mov cx9, 1	
		jmp butonfail
		
e9: dec click
  jmp butonfail
  O:
    mov eax, [ebp+arg2]
cmp eax, butonx1
jl b1o2
cmp eax, butonx1+butons
jg b1o2
 mov eax, [ebp+arg3]
 cmp eax, butony1
jl b1o2
cmp eax, butony1+butons
jg b1o2
cmp cx1, 1
je eo1
cmp co1, 1
je eo1
	make_text_macro 'O', area, 225, 100
		mov co1, 1
	jmp b1o2
	eo1: dec click
	b1o2:
   mov eax, [ebp+arg2]
cmp eax, butonx2
jl b1o3
cmp eax, butonx2+butons
jg b1o3
 mov eax, [ebp+arg3]
 cmp eax, butony2
jl b1o3
cmp eax, butony2+butons
jg b1o3
jg b1o2
cmp cx2, 1
je eo2
cmp co2, 1
je eo2
	make_text_macro 'O', area, 325, 100
  		mov co2, 1
  jmp b1o3
  eo2: dec click  
  b1o3:
    mov eax, [ebp+arg2]
cmp eax, butonx3
jl b1o4
cmp eax, butonx3+butons
jg b1o4
 mov eax, [ebp+arg3]
 cmp eax, butony3
jl b1o4
cmp eax, butony3+butons
jg b1o4
cmp cx3, 1
je eo3
cmp co3, 1
je eo3
	make_text_macro 'O', area, 425, 100
  			mov co3, 1
			jmp b1o4
			eo3: 
			dec click
	b1o4:
      mov eax, [ebp+arg2]
cmp eax, butonx4
jl b1o5
cmp eax, butonx4+butons
jg b1o5
 mov eax, [ebp+arg3]
 cmp eax, butony4
jl b1o5
cmp eax, butony4+butons
jg b1o5
jg b1o4
cmp cx4, 1
je eo4
cmp co4, 1
je eo4
	make_text_macro 'O', area, 225, 200
  		mov co4, 1
		jmp b1o5
		eo4: dec click
  b1o5:
        mov eax, [ebp+arg2]
cmp eax, butonx5
jl b1o6
cmp eax, butonx5+butons
jg b1o6
 mov eax, [ebp+arg3]
 cmp eax, butony5
jl b1o6
cmp eax, butony5+butons
jg b1o6
cmp cx5, 1
je eo5
cmp co5, 1
je eo5
	make_text_macro 'O', area, 325, 200
  		mov co5, 1
		jmp b1o6
		eo5:
		dec click
  b1o6:
          mov eax, [ebp+arg2]
cmp eax, butonx6
jl b1o7
cmp eax, butonx6+butons
jg b1o7
 mov eax, [ebp+arg3]
 cmp eax, butony6
jl b1o7
cmp eax, butony6+butons
jg b1o7
jg b1o6
cmp cx6, 1
je eo6
cmp co6, 1
je eo6
	make_text_macro 'O', area, 425, 200
  		mov co6, 1
		jmp b1o7
		eo6: dec click
  b1o7:
            mov eax, [ebp+arg2]
cmp eax, butonx7
jl b1o8
cmp eax, butonx7+butons
jg b1o8
 mov eax, [ebp+arg3]
 cmp eax, butony7
jl b1o8
cmp eax, butony7+butons
jg b1o8
jg b1o6
cmp cx7, 1
je eo7
cmp co7, 1
je eo7
	make_text_macro 'O', area, 225, 300
			mov co7, 1
  jmp b1o8
  eo7: dec click
  b1o8:
              mov eax, [ebp+arg2]
cmp eax, butonx8
jl b1o9
cmp eax, butonx8+butons
jg b1o9
 mov eax, [ebp+arg3]
 cmp eax, butony8
jl b1o9
cmp eax, butony8+butons
jg b1o9
cmp cx8, 1
je eo8
cmp co8, 1
je eo8
	make_text_macro 'O', area, 325, 300
  		mov co8, 1
		jmp b1o9
		eo8:
	dec click
  b1o9:
  cmp eax, butonx9
jl butonfail
cmp eax, butonx9+butons
jg butonfail
 mov eax, [ebp+arg3]
 cmp eax, butony9
jl butonfail
cmp eax, butony9+butons
jg butonfail
cmp cx9, 1
je eo9
cmp co9, 1
je eo9
	make_text_macro 'O', area, 425, 300
		mov co9, 1	
		jmp butonfail
		eo9:
		dec click
  butonfail: 
  mov eax, [ebp+arg2]
cmp eax, butonMx
jl langa
cmp eax, butonMx+butonMs
jg langa
 mov eax, [ebp+arg3]
 cmp eax, butonMy
jl langa
cmp eax, butonMy+butonMs
jg langa
jmp btf
langa:
dec click
btf:
  cmp cx1, 1
  jne c2
  cmp cx4, 1
  jne c2
  cmp cx7, 1
je xcastiga
c2:
  cmp cx2, 1
  jne c3
  cmp cx5, 1
  jne c3
  cmp cx8, 1
  je xcastiga
c3:
  cmp cx3, 1
  jne l1
  cmp cx6, 1
  jne l1
  cmp cx9, 1
je xcastiga
l1:
  cmp cx1, 1
  jne l2
  cmp cx2, 1
  jne l2
  cmp cx3, 1
je xcastiga
 l2:
  cmp cx4, 1
  jne l3
  cmp cx5, 1
  jne l3
  cmp cx6, 1
je xcastiga 
 l3:
  cmp cx7, 1
  jne diag1
  cmp cx8, 1
  jne diag1
  cmp cx9, 1
je xcastiga
diag1:
  cmp cx1, 1
  jne diag2
  cmp cx5, 1
  jne diag2
  cmp cx9, 1
je xcastiga
diag2:
  cmp cx3, 1
  jne co
  cmp cx5, 1
  jne co
  cmp cx7, 1
je xcastiga
  co:
     cmp co1, 1
  jne c02
  cmp co4, 1
  jne c02
  cmp co7, 1
je ocastiga
c02:
  cmp co2, 1
  jne c03
  cmp co5, 1
  jne c03
  cmp co8, 1
  je ocastiga
c03:
  cmp co3, 1
  jne l01
  cmp co6, 1
  jne l01
  cmp co9, 1
je ocastiga
l01:
  cmp co1, 1
  jne l02
  cmp co2, 1
  jne l02
  cmp co3, 1
je ocastiga
 l02:
  cmp co4, 1
  jne l03
  cmp co5, 1
  jne l03
  cmp co6, 1
je ocastiga 
 l03:
  cmp co7, 1
  jne diag01
  cmp co8, 1
  jne diag01
  cmp co9, 1
je ocastiga
diag01:
  cmp co1, 1
  jne diag02
  cmp co5, 1
  jne diag02
  cmp co9, 1
je ocastiga
diag02:
  cmp co3, 1
  jne egal
  cmp co5, 1
  jne egal
  cmp co7, 1
je ocastiga 
  jmp egal
  xcastiga:
  	make_text_macro 'X', area, 300, 400
		make_text_macro 'W', area, 320, 400
			make_text_macro 'O', area, 330, 400
  	make_text_macro 'N', area, 340, 400
	mov click, 9
  jmp gata
  		egal:
		cmp click, 9
		jne gata
      	make_text_macro 'T', area, 320, 400
		make_text_macro 'I', area, 330, 400
			make_text_macro 'E', area, 340, 400
			jmp gata
  ocastiga:
    	make_text_macro 'O', area, 300, 420
		make_text_macro 'W', area, 320, 420
			make_text_macro 'O', area, 330, 420
  	make_text_macro 'N', area, 340, 420
		mov click, 9
  gata:  
  jmp afisare_litere
evt_timer:
	inc counter
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	;scriem un mesaj
	make_text_macro 'T', area, 287, 10
	make_text_macro 'I', area, 297, 10
	make_text_macro 'C', area, 307, 10
	make_text_macro 'T', area, 317, 10
	make_text_macro 'A', area, 327, 10
	make_text_macro 'C', area, 337, 10
	make_text_macro 'T', area, 347, 10
	make_text_macro 'O', area, 357, 10
    make_text_macro 'E', area, 367, 10		
				line_oriz butonMx, butonMy, butonMs , 0000000H
		line_oriz butonMx, butonMy+butonMs, butonMs , 0000000H
		line_vert butonMx, butonMy, butonMs , 0000000H
			line_vert butonMx+butonMs, butonMy, butonMs , 0000000H				
		line_oriz butonx1, butony1, butons, 0000000H
		line_oriz butonx1, butony1+butons, butons, 0000000H
		line_vert butonx1, butony1, butons, 0000000H
		line_vert butonx1+butons, butony1, butons, 0000000H
				line_oriz butonx2, butony2, butons, 0000000H
		line_oriz butonx2, butony2+butons, butons, 0000000H
		line_vert butonx2, butony2, butons, 0000000H
		line_vert butonx2+butons, butony2, butons, 0000000H						
						line_oriz butonx3, butony3, butons, 0000000H
		line_oriz butonx3, butony3+butons, butons, 0000000H
		line_vert butonx3, butony3, butons, 0000000H
		line_vert butonx3+butons, butony3, butons, 0000000H								
								line_oriz butonx4, butony4, butons, 0000000H
		line_oriz butonx4, butony4+butons, butons, 0000000H
		line_vert butonx4, butony4, butons, 0000000H
		line_vert butonx4+butons, butony4, butons, 0000000H		
										line_oriz butonx5, butony5, butons, 0000000H
		line_oriz butonx5, butony5+butons, butons, 0000000H
		line_vert butonx5, butony5, butons, 0000000H
		line_vert butonx5+butons, butony5, butons, 0000000H
												line_oriz butonx6, butony6, butons, 0000000H
		line_oriz butonx6, butony6+butons, butons, 0000000H
		line_vert butonx6, butony6, butons, 0000000H
		line_vert butonx6+butons, butony6, butons, 0000000H
												line_oriz butonx7, butony7, butons, 0000000H
		line_oriz butonx7, butony7+butons, butons, 0000000H
		line_vert butonx7, butony7, butons, 0000000H
		line_vert butonx7+butons, butony7, butons, 0000000H
														line_oriz butonx8, butony8, butons, 0000000H
		line_oriz butonx8, butony8+butons, butons, 0000000H
		line_vert butonx8, butony8, butons, 0000000H
		line_vert butonx8+butons, butony8, butons, 0000000H	
														line_oriz butonx9, butony9, butons, 0000000H
		line_oriz butonx9, butony9+butons, butons, 0000000H
		line_vert butonx9, butony9, butons, 0000000H
		line_vert butonx9+butons, butony9, butons, 0000000H
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp
start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	;terminarea programului
	stop:
	push 0
	call exit
end start