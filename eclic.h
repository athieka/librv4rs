/*
 * eclic.h
 *
 *  Created on: 2019��9��18��
 *      Author: athieka
 */

#ifndef ECLIC_H_
#define ECLIC_H_
#ifdef __cplusplus
extern "C" {
#endif
void enable_mcycle_minstret();
void disable_mcycle_minstret();
void trap_entry();
void irq_entry();

#ifdef __cplusplus
}
#endif
#endif /* ECLIC_H_ */
