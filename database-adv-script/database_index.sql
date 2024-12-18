-- User Table Indexes
CREATE INDEX idx_user_id ON "User"(user_id);  -- Frequently used in JOINs
CREATE INDEX idx_user_email ON "User"(email);  -- Used in WHERE clauses for filtering by email

-- Booking Table Indexes
CREATE INDEX idx_booking_id ON "Booking"(booking_id);  -- Primary identifier for bookings
CREATE INDEX idx_booking_user_id ON "Booking"(user_id);  -- JOIN with User table
CREATE INDEX idx_booking_property_id ON "Booking"(property_id);  -- JOIN with Property table

-- Property Table Indexes
CREATE INDEX idx_property_id ON "Property"(property_id);  -- Primary identifier for properties
CREATE INDEX idx_property_location ON "Property"(location);  -- Used in WHERE clauses for filtering by location
CREATE INDEX idx_property_price ON "Property"(pricepernight);  -- Used in range queries on price
CREATE INDEX idx_property_host_id ON "Property"(host_id);  -- Optimizes JOINs and filtering by owner

-- Composite Index (Optional for complex queries)
CREATE INDEX idx_booking_user_property ON "Booking"(user_id, property_id);  -- Compound filtering


-- EXPLAIN ANALYZE for query performance testing

-- Query 1: Join User and Booking
EXPLAIN ANALYZE
SELECT b.booking_id, u.email
FROM "Booking" b
JOIN "User" u ON b.user_id = u.user_id;

-- Query 2: Filter Property by Location
EXPLAIN ANALYZE
SELECT property_id, name
FROM "Property"
WHERE location = 'New York';

-- Query 3: Join Booking and Property
EXPLAIN ANALYZE
SELECT b.booking_id, p.name
FROM "Booking" b
JOIN "Property" p ON b.property_id = p.property_id;
