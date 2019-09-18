/*
 * csr.h
 *
 *  Created on: 2019Äê9ÔÂ18ÈÕ
 *      Author: athieka@hotmail.com
 */

#ifndef CSR_H_
#define CSR_H_
#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
#include <stdlib.h>
enum CSROP {
	csrrw, csrrs, csrrc,
};

typedef uint32_t (*csr_func)(uint32_t, void*);
csr_func csr_make_func(enum CSROP op, uint16_t reg, void *buffer, int size);
uint32_t csr_oper(enum CSROP op, uint16_t reg, uint32_t val);
#ifdef __cplusplus
}
#endif
#endif /* CSR_H_ */
