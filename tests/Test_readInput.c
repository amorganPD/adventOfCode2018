#include "test_main.h"

#include "readInput.h"

// 1/3 - Declarations - readInput_getLine
void readInput_getLine_TestRunner(void);
void test_readInput_getLine_tryOneLineExpect13(void);

// 2/3 - Tests - readInput_getLine
void test_readInput_getLine_tryOneLineExpect13(void) {
  char testChar[32];
  TEST_ASSERT(readInput_init());
  readInput_getLine(testChar, 32);
  TEST_ASSERT_EQUAL_STRING("+13\n", testChar);
}

// 3/3 - Test Runner - readInput_getLine
void readInput_getLine_TestRunner(void) {
  RUN_TEST(test_readInput_getLine_tryOneLineExpect13);
}

// Add Test Runner in test_main.c
// Add declaration to test_main.h
void readInput_TestRunner(void) {
  readInput_getLine_TestRunner();
}
