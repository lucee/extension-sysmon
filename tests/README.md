# System Monitoring Extension - Test Suite

This directory contains comprehensive test suites for the System Monitoring Extension.

## Test Files

### CFML Tests
- **`cfml/TestSysmon.cfm`** - CFML integration tests for all extension functions

### Java Tests  
- **`java/src/org/lucee/extension/sysmon/test/SysmonFunctionsTest.java`** - JUnit 5 unit tests for Java implementations

## Running CFML Tests

To run CFML tests:

1. Build the extension:
   ```bash
   mvn package
   ```

2. Install the extension in your Lucee instance

3. Navigate to `tests/cfml/TestSysmon.cfm` in your browser

The test will output a summary of all test results with pass/fail status.

## Running Java Tests

To run Java unit tests:

```bash
cd source/java
mvn test
```

Or run specific test class:

```bash
mvn test -Dtest=SysmonFunctionsTest
```

## Test Coverage

### GetCPUUsage
- ✓ Returns numeric value
- ✓ Value is between 0 and 100

### GetProcessorInfo
- ✓ Returns struct with all required keys
- ✓ Physical core count > 0
- ✓ Logical core count > 0
- ✓ Logical cores >= physical cores

### GetMemoryUsage
- ✓ Returns struct with all required keys
- ✓ Total > 0
- ✓ Used >= 0
- ✓ Available >= 0
- ✓ Percent between 0-100
- ✓ Used <= total

### GetMemoryMetrics
- ✓ Returns struct with physical and virtual memory
- ✓ Physical memory has all required fields
- ✓ Virtual memory has all required fields

### GetOSVersion
- ✓ Returns struct with OS information
- ✓ All required keys present
- ✓ Uptime > 0
- ✓ Family is not empty

### GetSystemUptime
- ✓ Returns numeric milliseconds
- ✓ Uptime > 0

### GetDiskMetrics
- ✓ Returns array of partitions
- ✓ At least one partition
- ✓ Each partition has all required fields

### GetDiskUsage
- ✓ Returns struct for mount point
- ✓ Root partition found
- ✓ Total disk space > 0

### GetNetworkInfo
- ✓ Returns array of interfaces
- ✓ At least one interface
- ✓ Each interface has all required fields

### GetSystemInfo
- ✓ Returns struct with CPU, memory, and OS sections
- ✓ All subsections have required fields

### GetProcessList
- ✓ Returns array of processes
- ✓ At least one process
- ✓ Each process has required fields
- ✓ With limit parameter, returns <= limit processes

### GetProcessInfo
- ✓ Returns struct for valid PID
- ✓ Returns error message for invalid PID
- ✓ PID in result matches requested PID

## Expected Test Results

All tests should PASS when running against a Lucee instance with the sysmon extension installed.

## Troubleshooting

If tests fail:

1. Ensure the extension is properly installed in Lucee
2. Check that the extension has all 12 functions registered
3. Verify system has available CPU, memory, disk, and network information
4. Check Lucee logs for any errors during function calls

## Adding New Tests

When adding new functions to the extension:

1. Add corresponding test in CFML (`TestSysmon.cfm`)
2. Add corresponding test in Java (`SysmonFunctionsTest.java`)
3. Document test coverage in this README
4. Ensure both test suites pass before committing
