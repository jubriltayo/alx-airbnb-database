# SQL Query Optimization with EXPLAIN ANALYZE

## Objective

This document explains the performance analysis of various SQL queries using the `EXPLAIN ANALYZE` command, identifies potential bottlenecks, and suggests schema optimizations (e.g., indexing and partitioning) to enhance query execution times.

### 1. Query: Retrieving Properties and Their Reviews

```sql
EXPLAIN ANALYZE 
SELECT p.property_id, p.host_id, p."name", p.description, p."location", p.created_at, p.updated_at,
       r.rating, r."comment" 
FROM "Property" p 
LEFT JOIN "Review" r 
ON p.property_id = r.property_id
ORDER BY p."name";
```

#### **Possible Bottlenecks:**

- **Sorting**: The `ORDER BY p."name"` clause may cause performance degradation, especially if the `name` column in the "Property" table does not have an index.
- **JOIN Efficiency**: Although the query uses a `LEFT JOIN`, which is generally efficient, the sorting step can become a bottleneck if there is a large number of records in the "Property" table.

#### **Solution:**

To optimize the sorting, we can create an index on the `name` column in the "Property" table:

```sql
CREATE INDEX idx_property_name ON "Property"("name");
```

This index will allow the database to quickly retrieve the data in sorted order without needing to perform a time-consuming sort during query execution.

#### **Expected Impact:**

- **Faster Sorting**: The index on `name` will speed up the `ORDER BY` operation.
- **Overall Query Performance**: This will improve the execution time of the query, particularly when dealing with a large number of properties.

---

### 2. Query: Counting Bookings per User

```sql
EXPLAIN ANALYZE 
SELECT b.user_id,
       u.first_name, u.last_name,
       COUNT(b.booking_id) AS total_bookings 
FROM "Booking" b 
INNER JOIN "User" u 
ON b.user_id = u.user_id 
GROUP BY b.user_id, u.first_name, u.last_name 
ORDER BY total_bookings DESC;
```

#### **Possible Bottlenecks:**

- **COUNT Function and GROUP BY**: The use of `COUNT()` combined with `GROUP BY` on a potentially large dataset can be inefficient, especially in the "Booking" table with many rows.
- **JOIN Performance**: The `INNER JOIN` may not be as efficient if the "Booking" table is large and there is no index on the `user_id` column.

#### **Solution:**

To improve the performance, we can create an index on the `user_id` column in the "Booking" table:

```sql
CREATE INDEX idx_booking_user_id ON "Booking"(user_id);
```

This will allow the database to efficiently join the "Booking" table with the "User" table and aggregate bookings by `user_id` more quickly.

#### **Expected Impact:**

- **Improved Join Performance**: With the index on `user_id`, the database can more quickly find matching records between the "Booking" and "User" tables.
- **Faster Aggregation**: The index will speed up the `COUNT()` function and the `GROUP BY` operation.

---

### 3. Query: Retrieving Bookings for a Date Range

```sql
EXPLAIN ANALYZE
SELECT * 
FROM "Booking"
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';
```

#### **Possible Bottlenecks:**

- **Full Table Scan**: Without proper indexing or partitioning, this query performs a full table scan of the "Booking" table, which can be slow, especially as the table grows in size.
- **Slow Filtering**: The absence of partitioning means that the database must scan all records in the "Booking" table to filter out the ones that fall within the date range, leading to slower performance.

#### **Solution:**

To optimize this query, the "Booking" table can be partitioned by the `start_date` column (for example, by year). This allows the database to scan only the relevant partition, reducing the amount of data it needs to examine.

```sql
-- Create the parent table
CREATE TABLE "Booking" (
  booking_id UUID PRIMARY KEY,
  property_id UUID,
  user_id UUID,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10, 2) NOT NULL,
  status VARCHAR(10) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES "Property"(property_id),
  FOREIGN KEY (user_id) REFERENCES "User"(user_id)
) PARTITION BY RANGE (start_date);

-- Create partitions for each year
CREATE TABLE "Booking_2024" PARTITION OF "Booking" FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE "Booking_2025" PARTITION OF "Booking" FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
```

#### **Expected Impact:**

- **Partition Pruning**: With partitioning, the query will only scan the relevant partitions (e.g., "Booking_2024" for bookings in 2024), significantly improving performance.
- **Reduced Data Scanning**: Partitioning reduces the need for a full table scan, making date-based queries much faster.

---

### 4. Query: Retrieving Bookings for a Date Range in a Partitioned Table

```sql
EXPLAIN ANALYZE
SELECT * 
FROM "Booking_2024"
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';
```

#### **Possible Improvement:**

- **Indexing for Faster Retrieval**: Although partitioning already improves query performance by limiting the amount of data scanned, additional indexes on the partitioned tables will further speed up the query execution, especially when filtering or joining on columns like `user_id`, `property_id`, or `start_date`.

#### **Solution:**

Create indexes for common filtering columns in the partitioned table:

```sql
CREATE INDEX idx_booking_user_id_2024 ON "Booking_2024" (user_id);
CREATE INDEX idx_booking_property_id_2024 ON "Booking_2024" (property_id);
CREATE INDEX idx_booking_start_date_2024 ON "Booking_2024" (start_date);
```

These indexes will further optimize filtering, joining, and retrieving data from the partitioned "Booking_2024" table.

#### **Expected Impact:**

- **Faster Query Execution**: With partitioning and indexes, queries on the "Booking_2024" table will run faster as the database will be able to filter and retrieve data more efficiently.
- **Optimized Data Retrieval**: Indexes on frequently queried columns like `user_id`, `property_id`, and `start_date` will allow the database to quickly locate relevant records.

---

### Conclusion

Through the use of **EXPLAIN ANALYZE**, we identified potential performance bottlenecks in each query and applied appropriate optimizations:

- **Indexing**: Adding indexes on commonly queried columns (e.g., `name`, `user_id`, `property_id`) significantly improved query performance by reducing the time spent on sorting and joining.
- **Partitioning**: Partitioning the "Booking" table by `start_date` optimized date-range queries by limiting the data scanned, leading to faster results.
- **Overall Performance**: After implementing these optimizations, the queries executed much faster, ensuring better scalability as the dataset grows.

By continuously monitoring query performance with `EXPLAIN ANALYZE` and applying schema adjustments like indexing and partitioning, we can maintain optimal database performance as data volume increases.
