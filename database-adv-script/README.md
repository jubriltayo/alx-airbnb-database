# SQL Joins Mastery

## Objective
The objective of this exercise is to master SQL joins by writing complex queries using various types of joins. The goal is to practice how to retrieve data from multiple related tables using **INNER JOIN**, **LEFT JOIN**, and **FULL OUTER JOIN**.

---

## Tasks

### 1. **INNER JOIN**: Retrieve all bookings and the respective users who made those bookings.
This query demonstrates how to retrieve data from two related tables — `Booking` and `User` — using an **INNER JOIN**. The result will show all bookings along with the details of the users who made them.

#### SQL Query:
```sql
SELECT b.booking_id, b.property_id, b.start_date, b.end_date, b.total_price, b.status, b.created_at, u.user_id, u.first_name, u.last_name, u.email
FROM "Booking" b
INNER JOIN "User" u 
ON b.user_id = u.user_id;
```

---

### 2. **LEFT JOIN**: Retrieve all properties and their reviews, including properties that have no reviews.
This query uses a **LEFT JOIN** to get all properties along with their reviews, ensuring that properties with no reviews are also included in the result. A **LEFT JOIN** ensures that rows from the `Property` table are returned even if no matching rows are found in the `Review` table.

#### SQL Query:
```sql
SELECT p.property_id, p.host_id, p."name", p.description, p."location", p.created_at, p.updated_at, r.rating, r."comment"
FROM "Property" p
LEFT JOIN "Review" r 
ON p.property_id = r.property_id;
```

---

### 3. **FULL OUTER JOIN**: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
This query demonstrates how to use a **FULL OUTER JOIN** to retrieve all users and all bookings, ensuring that you get users with no bookings and bookings without a user. This join type returns all rows from both tables, with `NULL` in places where there is no match.

#### SQL Query:
```sql
SELECT u.user_id, u.first_name, u.last_name, u.email, 
       b.booking_id, b.property_id, b.start_date, b.end_date, b.total_price, b.status
FROM "User" u
FULL OUTER JOIN "Booking" b 
ON u.user_id = b.user_id;
```

---

## Conclusion
By completing these tasks, I have learned how to use **INNER JOIN**, **LEFT JOIN**, and **FULL OUTER JOIN** to query data from multiple tables, mastering the different join types to handle various use cases of related data.


