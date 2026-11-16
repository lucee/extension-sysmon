# Lucee System Monitoring Extension

Comprehensive system monitoring extension providing CPU, memory, disk, network, and OS metrics using the OSHI library.

## Features

- **CPU Metrics** - Usage, core count, frequency, temperature
- **Memory Metrics** - RAM, swap, virtual memory statistics  
- **Disk Metrics** - Partition space, I/O statistics
- **Network Metrics** - Interface information and traffic statistics
- **OS Information** - Version, uptime, boot time
- **Process Information** - List running processes with CPU/memory usage
- **Backward Compatibility** - Includes GetCPUUsage() for compatibility when removed from core

## Functions

### System Information
```cfml
GetSystemInfo()          // Complete system snapshot
GetOSVersion()           // Operating system details
GetSystemUptime()        // System uptime in milliseconds
```

### CPU Metrics
```cfml
GetCPUUsage()            // CPU usage percentage (backward compatible)
GetProcessorInfo()       // Processor details (cores, speed, vendor)
```

### Memory Metrics
```cfml
GetMemoryUsage()         // RAM usage (total, used, available, percent)
GetMemoryMetrics()       // Detailed memory info (including swap)
```

### Disk & Storage
```cfml
GetDiskUsage(path)       // Disk space for mount point
GetDiskMetrics()         // All partitions with I/O statistics
```

### Network
```cfml
GetNetworkInfo()         // Network interfaces and traffic statistics
```

### Processes
```cfml
GetProcessList()         // All running processes
GetProcessInfo(pid)      // Details for specific process
```

## Building

```bash
mvn package
```

This generates the extension file (`.lex`) in the target directory.

## Installation

1. Build the extension using Maven
2. In the Lucee Admin Console, go to **Extensions** > **Install**
3. Upload the generated `.lex` file

## About

- **Name:** System Monitoring Extension
- **Version:** 1.0.0.0-RC
- **Repository:** https://github.com/lucee/extension-sysmon
- **License:** LGPL 2.1

## Development

The extension uses:
- **OSHI** (6.6.1) - Operating System and Hardware Information library
- **Java 17+**
- **Maven** for building

See the [Lucee Maven-based Extensions Guide](https://raw.githubusercontent.com/lucee/lucee-docs/refs/heads/master/docs/recipes/maven-based-extensions.md) for more details.

## Versioning and releases

Works like Lucee core (LDEV-6516): every code change gets its own version number. The version is not edited by hand.
`pom.xml` uses a CI-friendly `${revision}` built from `extension.version.base`, a build number and
`extension.version.qualifier` (`-SNAPSHOT`).

* **Every push to `main`** (a merged PR or a direct commit) takes the highest existing build of the base, from the git tags,
  Maven Central and the Central snapshot repository, adds 1, builds, tests, publishes that version (e.g. `1.0.0.N-SNAPSHOT`)
  to the [Central snapshot repository](https://central.sonatype.com/repository/maven-snapshots/) and creates the tag `1.0.0.N`.
* Pushes run one after another (workflow concurrency queue), so two quick merges get two different numbers.
* PR builds, forks and runs without the deploy secrets build and test `1.0.0.0-SNAPSHOT` and never use up a number.
* **Release candidate or final release:** run the workflow by hand (Actions > Java CI > Run workflow), choose the branch
  `main`, tick `deploy` and pick `RC`, `BETA`, `ALPHA` or `release` as qualifier. That publishes the current code once with the
  next build number (e.g. `1.0.0.N-RC` or `1.0.0.N`) to Maven Central and creates a GitHub release with the `.lex` files,
  without a commit; the pom keeps `-SNAPSHOT`.
* To start a new line change `extension.version.base`.
