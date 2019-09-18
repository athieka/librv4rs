.section .init, "ax"
.equ CSR_MSTATUS, 0x300
.equ MSTATUS_MIE, 0x00000008
.equ CSR_MCOUNTINHIBIT,0x320
.equ REGBYTES,4
.equ msubm, 0x7c4
.equ jalmnxti, 0x7ed
.equ pushmcause, 0x7ee
.equ pushmepc, 0x7ef
.equ pushmsubm, 0x7eb


.global disable_mcycle_minstret
.type disable_mcycle_minstret,@function
disable_mcycle_minstret:
    csrsi CSR_MCOUNTINHIBIT, 0x5
	ret

.global enable_mcycle_minstret
.type enable_mcycle_minstret,@function
enable_mcycle_minstret:
    csrci CSR_MCOUNTINHIBIT, 0x5
	ret

.section .trap, "ax"

.macro SAVE_CONTEXT
	sw ra, 0*REGBYTES(sp)
    sw t0, 1*REGBYTES(sp)
    sw t1, 2*REGBYTES(sp)
    sw t2, 3*REGBYTES(sp)
    sw t3, 4*REGBYTES(sp)
    sw t4, 5*REGBYTES(sp)
    sw t5, 6*REGBYTES(sp)
    sw t6, 7*REGBYTES(sp)
    sw a0, 8*REGBYTES(sp)
    sw a1, 9*REGBYTES(sp)
    sw a2, 10*REGBYTES(sp)
    sw a3, 11*REGBYTES(sp)
    sw a4, 12*REGBYTES(sp)
    sw a5, 13*REGBYTES(sp)
    sw a6, 14*REGBYTES(sp)
    sw a7, 15*REGBYTES(sp)
.endm

.macro RESTORE_CONTEXT
	lw ra, 0*REGBYTES(sp)
    lw t0, 1*REGBYTES(sp)
    lw t1, 2*REGBYTES(sp)
    lw t2, 3*REGBYTES(sp)
    lw t3, 4*REGBYTES(sp)
    lw t4, 5*REGBYTES(sp)
    lw t5, 6*REGBYTES(sp)
    lw t6, 7*REGBYTES(sp)
    lw a0, 8*REGBYTES(sp)
    lw a1, 9*REGBYTES(sp)
    lw a2, 10*REGBYTES(sp)
    lw a3, 11*REGBYTES(sp)
    lw a4, 12*REGBYTES(sp)
    lw a5, 13*REGBYTES(sp)
    lw a6, 14*REGBYTES(sp)
    lw a7, 15*REGBYTES(sp)
.endm

.align 6
.global trap_entry
.type trap_entry,@function
trap_entry:
	addi sp, sp, -20*REGBYTES
	SAVE_CONTEXT
	csrr a3, mepc
	sw a3, 16*REGBYTES(sp)
	csrr a2, mstatus
	sw a2, 17*REGBYTES(sp)
	csrr a4, msubm
	sw a4, 18*REGBYTES(sp)
	csrr a0, mcause
	mv a1, sp
	jal ra, _start_trap_rust
	lw a0, 16*REGBYTES(sp)
	csrw mepc, a0
	lw a0, 17*REGBYTES(sp)
	csrw mstatus, a0
	lw a0, 18*REGBYTES(sp)
	csrw msubm, a0
	RESTORE_CONTEXT
	addi sp, sp, 20*REGBYTES
	mret

.align 2
.global irq_entry
.type irq_entry,@function
irq_entry:
	addi sp, sp, -20*REGBYTES
	SAVE_CONTEXT
	csrrwi  zero, pushmcause, 17
	csrrwi  zero, pushmepc, 18
	csrrwi	zero, pushmsubm, 19
	csrrw ra, jalmnxti, ra
	csrc CSR_MSTATUS, MSTATUS_MIE
	lw a0, 19*REGBYTES(sp)
	csrw msubm, a0
	lw a0, 18*REGBYTES(sp)
	csrw mepc, a0
	lw a0, 17*REGBYTES(sp)
	csrw mcause, a0
	RESTORE_CONTEXT
	addi sp, sp, 20*REGBYTES
	mret


