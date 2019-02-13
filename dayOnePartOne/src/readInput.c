#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>

static FILE *filePtr;

bool readInput_init(void) {
  filePtr = fopen("dayOnePartOne\\input.txt", "rb");
  if (filePtr != NULL) {
    rewind(filePtr);
    return true;
  }
  return false;
}

bool readInput_getLine(char *output, uint32_t maxCount) {
  return fgets(output, maxCount, filePtr) != 0;
}
bool readInput_readNextChar(char *output) {
  return fread(output, 1, 1, filePtr) != 0;
}

void readInput_close(void) {
  fclose(filePtr);
}
