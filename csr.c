/*
 * csr.c
 *
 *  Created on: 2019Äê9ÔÂ18ÈÕ
 *      Author: athieka@hotmail.com
 */
#include "csr.h"

#define OPCODE_SYSTEM	0x73
#define REG_A0		0x0A
#define CSRRW		0x01
#define CSRRS		0x02
#define CSRRC		0x03
#define OP_RET			0x8082

csr_func csr_make_func(enum CSROP op, uint16_t reg, void *buffer, int size) {
	uint32_t code;
	volatile char *tmp = buffer;
	int cnt = 0;
	if (reg & (~0x0fff)) {
		return NULL;
	}
	if ((uint32_t) tmp & 0x01) {
		if (size < 7) {
			return NULL;
		}
		tmp += 1;
	} else {
		if (size < 6) {
			return NULL;
		}
	}

	switch (op) {
	case csrrw:
		code = OPCODE_SYSTEM | (REG_A0 << 7) | (CSRRW << 12) | (REG_A0 << 15)
				| (reg << 20);
		break;
	case csrrc:
		code = OPCODE_SYSTEM | (REG_A0 << 7) | (CSRRC << 12) | (REG_A0 << 15)
				| (reg << 20);
		break;
	case csrrs:
		code = OPCODE_SYSTEM | (REG_A0 << 7) | (CSRRS << 12) | (REG_A0 << 15)
				| (reg << 20);
		break;
	default:
		return NULL;
	}

	*(uint32_t*) (tmp + cnt) = code;
	cnt += sizeof(uint32_t);
	*(uint16_t*) (tmp + cnt) = (uint16_t) OP_RET;
	asm("FENCE");
	asm("FENCE.I");
	return (csr_func) tmp;
}

uint32_t csr_oper(enum CSROP op, uint16_t reg, uint32_t val) {
	char func_ptr[7];
	csr_func func = csr_make_func(op, reg, func_ptr, sizeof(func_ptr));
	if (func){
		return func(val, func_ptr);
	}else{
		return -1;
	}
}

