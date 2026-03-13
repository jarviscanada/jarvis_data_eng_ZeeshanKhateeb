Linux Cluster Monitoring Agent
Introduction

The Linux Cluster Monitoring Agent is a lightweight monitoring solution designed to collect, store, and analyze system-level metrics from Linux hosts in a cluster environment. The primary goal of this project is to help system administrators and engineering teams monitor host resource usage and hardware specifications in a centralized PostgreSQL database.

This project collects static host information such as CPU architecture and memory size, as well as dynamic usage metrics including memory availability, CPU utilization, disk I/O, and disk space. The monitoring agent is implemented using Bash scripts and scheduled using cron to capture usage data at regular intervals.

The system is containerized using Docker for database management and follows GitFlow best practices for version control. This project is intended for Linux environments and is suitable for learning system monitoring, automation, and basic data engineering concepts.

Technologies used:
Bash, Linux CLI tools, Docker, PostgreSQL, Git, GitHub, cron

Quick Start
# 1. Start PostgreSQL using Docker
./linux_sql/scripts/psql_docker.sh start

# 2. Initialize database tables
psql -h localhost -p 5432 -U postgres -d host_agent -f linux_sql/sql/ddl.sql

# 3. Insert host hardware information (run once per host)
./linux_sql/scripts/host_info.sh localhost 5432 host_agent postgres password

# 4. Insert host usage data (manual run)
./linux_sql/scripts/host_usage.sh localhost 5432 host_agent postgres password

# 5. Set up cron job to collect usage data every minute
crontab -e

Implementation

The project is implemented in incremental stages following the SDLC process. PostgreSQL is provisioned inside a Docker container and serves as the centralized datastore. Bash scripts are used to collect system metrics through standard Linux commands such as lscpu, vmstat, and df.

Static host data is collected once and stored in the database, while usage data is captured every minute using cron scheduling. Git feature branches are used for development, and changes are merged into develop and main according to Jarvis workflow requirements.

Architecture

The system consists of multiple Linux hosts running monitoring agents and a centralized PostgreSQL database hosted in a Docker container.

Each Linux host runs Bash scripts to collect metrics

PostgreSQL stores all collected data

Cron schedules recurring data collection

Architecture diagram is stored in the assets/ directory

Scripts
psql_docker.sh

Manages the PostgreSQL Docker container.
Supports start and stop commands for database lifecycle management.

host_info.sh

Collects static hardware information:

Hostname

CPU count and architecture

CPU model and frequency

L2 cache size

Total memory

UTC timestamp

Runs once per host and inserts data into host_info.

host_usage.sh

Collects dynamic usage metrics:

Memory free

CPU idle and kernel usage

Disk I/O

Disk available

UTC timestamp

Designed to be executed every minute via cron.

queries.sql

Contains SQL queries used to answer business questions such as:

Average memory usage over time

Resource utilization trends per host

Database Modeling
host_info
Column Name	Description
id	Unique host identifier (PK)
hostname	Fully qualified hostname
cpu_number	Number of CPUs
cpu_architecture	CPU architecture
cpu_model	CPU model name
cpu_mhz	CPU frequency
l2_cache	L2 cache size
total_mem	Total memory (KB)
timestamp	Record creation time (UTC)
host_usage
Column Name	Description
timestamp	Usage collection time (UTC)
host_id	Foreign key referencing host_info
memory_free	Free memory (MB)
cpu_idle	CPU idle percentage
cpu_kernel	CPU kernel usage percentage
disk_io	Disk I/O operations
disk_available	Available disk space (MB)
Test

Each Bash script was tested incrementally:

Syntax validated using bash -n

Manual execution verified successful inserts (INSERT 0 1)

Database queries confirmed data persistence

Cron execution verified via /tmp/host_usage.log

All tests were performed in a Rocky Linux environment.

Deployment

PostgreSQL deployed using Docker

Scripts deployed via GitHub repository

Automation achieved using cron

Monitoring agent runs continuously without manual intervention

Improvements

Add alerting mechanisms for threshold breaches

Support multiple databases or cloud-hosted PostgreSQL

Add visualization layer using Grafana or similar tools
