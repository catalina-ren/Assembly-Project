.model small
.stack 100h
.data
semn db 0
numar dw 0
NrCifre dw 0
.code
start: 
mov ax, @data
mov ds,ax

mov cx,10  ; initializare registrul CX pentru formare numar
xor bx,bx  ; golire registrul BX pt pastrare copie val citita de la tastatura 

mov ah, 01h 
int 21h

cmp al, 2Dh ; verificare nr pozitiv sau negativ 
je NrNegativ 
jmp ConstruireVal

citireCifra:
mov ah, 01h
int 21h
cmp al, 13
je PregatireNumarare
            
ConstruireVal:
sub al, 48     ; aflare valoarea in zecimal a caracterului introdus de la tastatura       
mov bl, al  ; copiere valoare in bl
mov ax, numar ; registrul Ax primeste numarul costruit pana la citirea valorii actuale 
mul cx ; pregatirea registrului AX pentru adaugarea noii valori citite
add ax, bx ; adaugarea valorii
mov numar, ax ; pastarea numarului format in memorie 
jmp citireCifra
           

NrNegativ:
mov semn, 1 ;daca s-a citit caracterul '-', variabila semn primeste 1
jmp citireCifra 

PregatireNumarare:
xor cx,cx ; pregatim cx pt a contoriza numarul de cifre a numarului in binar
mov ax,numar ;

NumarareCifre: ; calculam efectiv numarul de cifre
shr ax,1 ; simulam mutarea virgulei asemanator VM
inc cx
cmp ax,0
jne NumarareCifre

PrelucrareExponent:
mov NrCifre, cx
add cx, 126 ; adaugam constanta-1
shl cx, 7 ; mutam exponentul(sa inceapa) pe pozitia celui de-al 2 lea bit din registru CX pentru a-i face loc bitului de semn

PrelucrareSemn:
mov ah, semn
shl ah, 7 ; mutam semnul pe prima pozitie din registrul AX

SemnExponent:
add cx, ax ; concatenam prin adunare cele doua registre AX si CX
push cx ; semnul si exponentul raman in CX si sunt trimise in stiva 

AflareMantisa:
mov ax, numar
mov bx, NrCifre
mov cx, 17 ; aflam cate pozitii trebuie deplasat numarul pentru a exclude partea intreaga 
sub cx, bx
shl ax, cl ; mutam efectiv bitii 

SemnExponentMantisa:
pop cx 
shr ax, 1 ; facem loc pentru primul bit din CL 
add cl, ah ; concatenam prin adunare primii 7 biti din mantisa la registrul CX
shl ax, 8 ; stergem cei 7 biti adaugati si astfel obtinem forma finala a restului de mantisa in registrul AX

push cx
push ax 

sfarsit:
mov ah, 4ch
int 21h

end start