#include "test_main.h"

void setUp(void) {
}

void tearDown(void) {
}

void resetTest(void);
void resetTest(void)
{
  tearDown();
  setUp();
}

#ifdef GCCCOMPILE
  int main (void) {
#else
  int test_main (void) {
#endif
    UNITY_BEGIN();

    // Add TestRunners here
    readInput_TestRunner();

    return UNITY_END();
  }
