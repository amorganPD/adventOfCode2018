#ifndef _READINPUT_H
#define _READINPUT_H

#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>

bool readInput_init(void);
bool readInput_getLine(char *output, uint32_t maxCount);
bool readInput_readNextChar(char *output);
void readInput_close(void);

#endif // _READINPUT_H
