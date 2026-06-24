<!---
    System Monitoring Extension Test Suite
    Tests all functions: GetCPUUsage, GetProcessorInfo, GetMemoryUsage, etc.
--->
<cfset results = {
    passed: 0,
    failed: 0,
    tests: []
}>

<cffunction name="assert" returntype="void">
    <cfargument name="condition" type="boolean" required="true">
    <cfargument name="message" type="string" required="true">
    <cfif NOT arguments.condition>
        <cfset arrayAppend(results.tests, {
            name: arguments.message,
            status: "FAILED",
            message: "Assertion failed"
        })>
        <cfset results.failed++>
        <cfelse>
        <cfset arrayAppend(results.tests, {
            name: arguments.message,
            status: "PASSED",
            message: ""
        })>
        <cfset results.passed++>
    </cfif>
</cffunction>

<cffunction name="assertIsNumeric" returntype="void">
    <cfargument name="value" type="any" required="true">
    <cfargument name="message" type="string" required="true">
    <cfset assert(isNumeric(arguments.value), arguments.message & " (value: " & arguments.value & ")")>
</cffunction>

<cffunction name="assertIsStruct" returntype="void">
    <cfargument name="value" type="any" required="true">
    <cfargument name="message" type="string" required="true">
    <cfset assert(isStruct(arguments.value), arguments.message & " (type: " & getMetadata(arguments.value).getType() & ")")>
</cffunction>

<cffunction name="assertIsArray" returntype="void">
    <cfargument name="value" type="any" required="true">
    <cfargument name="message" type="string" required="true">
    <cfset assert(isArray(arguments.value), arguments.message & " (type: " & getMetadata(arguments.value).getType() & ")")>
</cffunction>

<cffunction name="assertStructHasKey" returntype="void">
    <cfargument name="struct" type="struct" required="true">
    <cfargument name="key" type="string" required="true">
    <cfargument name="message" type="string" required="true">
    <cfset assert(structKeyExists(arguments.struct, arguments.key), arguments.message & " (missing key: " & arguments.key & ")")>
</cffunction>

<cffunction name="assertGreaterThan" returntype="void">
    <cfargument name="value" type="numeric" required="true">
    <cfargument name="threshold" type="numeric" required="true">
    <cfargument name="message" type="string" required="true">
    <cfset assert(arguments.value gt arguments.threshold, arguments.message & " (expected > " & arguments.threshold & ", got " & arguments.value & ")")>
</cffunction>

<cffunction name="assertGreaterThanOrEqual" returntype="void">
    <cfargument name="value" type="numeric" required="true">
    <cfargument name="threshold" type="numeric" required="true">
    <cfargument name="message" type="string" required="true">
    <cfset assert(arguments.value gte arguments.threshold, arguments.message & " (expected >= " & arguments.threshold & ", got " & arguments.value & ")")>
</cffunction>

<!--- ========== TEST: GetCPUUsage ========== --->
<cfset cpuUsage = GetCPUUsage()>
<cfset assertIsNumeric(cpuUsage, "GetCPUUsage should return numeric value")>
<cfset assertGreaterThanOrEqual(cpuUsage, 0, "CPU usage should be >= 0")>
<cfset assert(cpuUsage lte 100, "CPU usage should be <= 100 (got " & cpuUsage & ")")>

<!--- ========== TEST: GetProcessorInfo ========== --->
<cfset procInfo = GetProcessorInfo()>
<cfset assertIsStruct(procInfo, "GetProcessorInfo should return struct")>
<cfset assertStructHasKey(procInfo, "physicalCoreCount", "ProcessorInfo should have physicalCoreCount")>
<cfset assertStructHasKey(procInfo, "logicalCoreCount", "ProcessorInfo should have logicalCoreCount")>
<cfset assertStructHasKey(procInfo, "vendor", "ProcessorInfo should have vendor")>
<cfset assertStructHasKey(procInfo, "name", "ProcessorInfo should have name")>
<cfset assertStructHasKey(procInfo, "currentFrequency", "ProcessorInfo should have currentFrequency")>
<cfset assertStructHasKey(procInfo, "maxFrequency", "ProcessorInfo should have maxFrequency")>
<cfset assertGreaterThan(procInfo.physicalCoreCount, 0, "Physical core count should be > 0")>
<cfset assertGreaterThan(procInfo.logicalCoreCount, 0, "Logical core count should be > 0")>
<cfset assert(procInfo.logicalCoreCount gte procInfo.physicalCoreCount, "Logical cores should be >= physical cores")>

<!--- ========== TEST: GetMemoryUsage ========== --->
<cfset memUsage = GetMemoryUsage()>
<cfset assertIsStruct(memUsage, "GetMemoryUsage should return struct")>
<cfset assertStructHasKey(memUsage, "total", "MemoryUsage should have total")>
<cfset assertStructHasKey(memUsage, "used", "MemoryUsage should have used")>
<cfset assertStructHasKey(memUsage, "available", "MemoryUsage should have available")>
<cfset assertStructHasKey(memUsage, "percent", "MemoryUsage should have percent")>
<cfset assertGreaterThan(memUsage.total, 0, "Total memory should be > 0")>
<cfset assertGreaterThanOrEqual(memUsage.used, 0, "Used memory should be >= 0")>
<cfset assertGreaterThanOrEqual(memUsage.available, 0, "Available memory should be >= 0")>
<cfset assert(memUsage.used lte memUsage.total, "Used should be <= total")>
<cfset assertGreaterThanOrEqual(memUsage.percent, 0, "Percent should be >= 0")>
<cfset assert(memUsage.percent lte 100, "Percent should be <= 100")>

<!--- ========== TEST: GetMemoryMetrics ========== --->
<cfset memMetrics = GetMemoryMetrics()>
<cfset assertIsStruct(memMetrics, "GetMemoryMetrics should return struct")>
<cfset assertStructHasKey(memMetrics, "physical", "MemoryMetrics should have physical")>
<cfset assertStructHasKey(memMetrics, "virtual", "MemoryMetrics should have virtual")>
<cfset assertIsStruct(memMetrics.physical, "Physical memory should be struct")>
<cfset assertStructHasKey(memMetrics.physical, "total", "Physical should have total")>
<cfset assertStructHasKey(memMetrics.physical, "used", "Physical should have used")>
<cfset assertStructHasKey(memMetrics.physical, "available", "Physical should have available")>
<cfset assertGreaterThan(memMetrics.physical.total, 0, "Physical total should be > 0")>

<!--- ========== TEST: GetOSVersion ========== --->
<cfset osVersion = GetOSVersion()>
<cfset assertIsStruct(osVersion, "GetOSVersion should return struct")>
<cfset assertStructHasKey(osVersion, "family", "OSVersion should have family")>
<cfset assertStructHasKey(osVersion, "manufacturer", "OSVersion should have manufacturer")>
<cfset assertStructHasKey(osVersion, "version", "OSVersion should have version")>
<cfset assertStructHasKey(osVersion, "uptime", "OSVersion should have uptime")>
<cfset assertStructHasKey(osVersion, "bootTime", "OSVersion should have bootTime")>
<cfset assertStructHasKey(osVersion, "processCount", "OSVersion should have processCount")>
<cfset assertStructHasKey(osVersion, "threadCount", "OSVersion should have threadCount")>
<cfset assert(len(osVersion.family) gt 0, "OS family should not be empty")>
<cfset assertGreaterThan(osVersion.uptime, 0, "Uptime should be > 0")>

<!--- ========== TEST: GetSystemUptime ========== --->
<cfset uptime = GetSystemUptime()>
<cfset assertIsNumeric(uptime, "GetSystemUptime should return numeric")>
<cfset assertGreaterThan(uptime, 0, "Uptime should be > 0 milliseconds")>

<!--- ========== TEST: GetDiskMetrics ========== --->
<cfset diskMetrics = GetDiskMetrics()>
<cfset assertIsArray(diskMetrics, "GetDiskMetrics should return array")>
<cfset assert(arrayLen(diskMetrics) gt 0, "Should have at least one disk partition")>
<cfset disk = diskMetrics[1]>
<cfset assertIsStruct(disk, "Each disk should be a struct")>
<cfset assertStructHasKey(disk, "name", "Disk should have name")>
<cfset assertStructHasKey(disk, "mount", "Disk should have mount")>
<cfset assertStructHasKey(disk, "total", "Disk should have total")>
<cfset assertStructHasKey(disk, "used", "Disk should have used")>
<cfset assertStructHasKey(disk, "available", "Disk should have available")>
<cfset assertStructHasKey(disk, "percent", "Disk should have percent")>

<!--- ========== TEST: GetDiskUsage ========== --->
<cfset rootDisk = GetDiskUsage("/")>
<cfset assertIsStruct(rootDisk, "GetDiskUsage should return struct")>
<cfset assert(NOT structKeyExists(rootDisk, "error"), "Root disk should be found")>
<cfset assertStructHasKey(rootDisk, "total", "DiskUsage should have total")>
<cfset assertStructHasKey(rootDisk, "used", "DiskUsage should have used")>
<cfset assertStructHasKey(rootDisk, "available", "DiskUsage should have available")>
<cfset assertGreaterThan(rootDisk.total, 0, "Root disk total should be > 0")>

<!--- ========== TEST: GetNetworkInfo ========== --->
<cfset netInfo = GetNetworkInfo()>
<cfset assertIsArray(netInfo, "GetNetworkInfo should return array")>
<cfset assert(arrayLen(netInfo) gt 0, "Should have at least one network interface")>
<cfset net = netInfo[1]>
<cfset assertIsStruct(net, "Each network interface should be a struct")>
<cfset assertStructHasKey(net, "name", "Network should have name")>
<cfset assertStructHasKey(net, "displayName", "Network should have displayName")>
<cfset assertStructHasKey(net, "macaddr", "Network should have macaddr")>
<cfset assertStructHasKey(net, "isUp", "Network should have isUp")>
<cfset assertStructHasKey(net, "bytesRecv", "Network should have bytesRecv")>
<cfset assertStructHasKey(net, "bytesSent", "Network should have bytesSent")>

<!--- ========== TEST: GetSystemInfo ========== --->
<cfset sysInfo = GetSystemInfo()>
<cfset assertIsStruct(sysInfo, "GetSystemInfo should return struct")>
<cfset assertStructHasKey(sysInfo, "cpu", "SystemInfo should have cpu")>
<cfset assertStructHasKey(sysInfo, "memory", "SystemInfo should have memory")>
<cfset assertStructHasKey(sysInfo, "os", "SystemInfo should have os")>
<cfset assertStructHasKey(sysInfo.cpu, "usage", "CPU info should have usage")>
<cfset assertStructHasKey(sysInfo.memory, "physical", "Memory info should have physical")>
<cfset assertStructHasKey(sysInfo.os, "family", "OS info should have family")>

<!--- ========== TEST: GetProcessList ========== --->
<cfset procList = GetProcessList()>
<cfset assertIsArray(procList, "GetProcessList should return array")>
<cfset assert(arrayLen(procList) gt 0, "Should have at least one process")>
<cfset proc = procList[1]>
<cfset assertIsStruct(proc, "Each process should be a struct")>
<cfset assertStructHasKey(proc, "pid", "Process should have pid")>
<cfset assertStructHasKey(proc, "name", "Process should have name")>
<cfset assertStructHasKey(proc, "state", "Process should have state")>
<cfset assertStructHasKey(proc, "memoryUsage", "Process should have memoryUsage")>
<cfset assertGreaterThanOrEqual(proc.pid, 1, "PID should be >= 1")>

<!--- ========== TEST: GetProcessList with limit ========== --->
<cfset procListLimited = GetProcessList(5)>
<cfset assertIsArray(procListLimited, "GetProcessList(5) should return array")>
<cfset assert(arrayLen(procListLimited) lte 5, "Limit should restrict process list to 5 or less")>

<!--- ========== TEST: GetProcessInfo ========== --->
<cfif arrayLen(procList) gt 0>
    <cfset testPID = procList[1].pid>
    <cfset procDetail = GetProcessInfo(testPID)>
    <cfset assertIsStruct(procDetail, "GetProcessInfo should return struct")>
    <cfset assert(NOT structKeyExists(procDetail, "error"), "Should find process with PID " & testPID)>
    <cfset assertStructHasKey(procDetail, "pid", "ProcessInfo should have pid")>
    <cfset assertStructHasKey(procDetail, "name", "ProcessInfo should have name")>
    <cfset assertStructHasKey(procDetail, "state", "ProcessInfo should have state")>
    <cfset assertStructHasKey(procDetail, "memoryUsage", "ProcessInfo should have memoryUsage")>
    <cfset assert(procDetail.pid eq testPID, "ProcessInfo pid should match requested pid")>
</cfif>

<!--- ========== TEST: Invalid PID ========== --->
<cfset invalidProcInfo = GetProcessInfo(999999)>
<cfset assertIsStruct(invalidProcInfo, "GetProcessInfo should return struct even for invalid PID")>
<cfset assert(structKeyExists(invalidProcInfo, "error"), "Should have error message for invalid PID")>

<!--- ========== Print Results ========== --->
<cfdump var="#results#" label="Test Results">

<cfoutput>
<h2>Test Summary</h2>
<p><strong>Total Tests:</strong> #results.passed + results.failed#</p>
<p><strong>Passed:</strong> <span style="color: green;">#results.passed#</span></p>
<p><strong>Failed:</strong> <span style="color: red;">#results.failed#</span></p>

<cfif results.failed eq 0>
    <p style="color: green;"><strong>ALL TESTS PASSED!</strong></p>
<cfelse>
    <p style="color: red;"><strong>#results.failed# TEST(S) FAILED!</strong></p>
</cfif>
</cfoutput>
