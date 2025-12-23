#include <stdint.h>

// 1. Define the base address of your new GPIO IP
// Use 'volatile' to prevent the compiler from optimizing out these memory accesses.
#define GPIO_BASE 0x20000000
#define GPIO_REG  (*((volatile uint32_t *)GPIO_BASE))

// Helper function to print to UART (assuming an existing UART driver/address)
void print_string(char *str);

int main() {
    uint32_t write_val = 0xDEADBEEF;
    uint32_t read_val  = 0;

    // 2. Write a value to the GPIO register
    // This tests the "Write Logic" of your IP[cite: 33, 48].
    GPIO_REG = write_val;

    // 3. Read back the value from the same register
    // This tests the "Readback Logic" and Address Decoding[cite: 35, 49].
    read_val = GPIO_REG;

    // 4. Validation Check
    // If the read value matches the written value, the IP and integration are correct[cite: 52, 53].
    if (read_val == write_val) {
        print_string("GPIO Test Passed!\n");
    } else {
        print_string("GPIO Test Failed!\n");
    }

    while(1); // Keep the CPU from crashing after the test
    return 0;
}
