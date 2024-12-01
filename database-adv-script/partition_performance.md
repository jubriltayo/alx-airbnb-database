# Performance Improvements with Partitioning on the `Booking` Table

## Objective
The goal of this test was to compare the performance of queries on:
1. A **partitioned table** (`Booking`), which includes all date ranges.
2. A **specific partition** (e.g., `Booking_2024`), which contains data only for a specific year.
3. A **non-partitioned table** (`Booking_without_partition`), for baseline comparison.

## Query Setup
We performed the following queries:

1. **Partitioned Table Query**
   ```sql
   EXPLAIN ANALYZE
   SELECT * 
   FROM "Booking"
   WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';
   ```

2. **Specific Partition Query**
   ```sql
   EXPLAIN ANALYZE
   SELECT * 
   FROM "Booking_2024"
   WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';
   ```

3. **Non-Partitioned Table Query**
   ```sql
   EXPLAIN ANALYZE
   SELECT * 
   FROM "Booking_without_partition"
   WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';
   ```

## Results

### Execution Times
| Query Type                             | Execution Time |
|----------------------------------------|----------------|
| Specific Partition (`Booking_2024`)    | 0.080 ms        |
| Partitioned `Booking` Table            | 0.187 ms        |
| Non-Partitioned `Booking_without_partition` Table | ~1.82 ms        |

### Observations
- **Specific Partition Query** (`Booking_2024`): This query executed **faster** as it directly accessed the relevant partition, bypassing the partition pruning overhead.
- **Partitioned Table Query** (`Booking`): Although the query was on the partitioned table, it required **partition pruning**, which introduced slight overhead.
- **Non-Partitioned Table Query** (`Booking_without_partition`): This query was the **slowest**, as it scanned the entire table, without the benefits of partitioning.

## Conclusion
Querying a **specific partition** provides the **fastest** performance because it directly accesses the relevant data, without needing to perform partition pruning. The **partitioned table** (querying across all partitions) is slightly slower due to the overhead of partition pruning. The **non-partitioned table** is the least efficient, requiring a full table scan.
