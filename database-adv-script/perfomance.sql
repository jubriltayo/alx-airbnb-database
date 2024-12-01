-- Initial query to retrieve all bookings with user details, property details, and payment details
SELECT b.booking_id, b.start_date, b.end_date, b.total_price AS booking_total_price, b.status AS booking_status, b.created_at AS booking_created_at,
	   u.user_id, u.first_name, u.last_name, u.email AS user_email, u.phone_number AS user_phone,
	   p.property_id, p.name AS property_name, p.description AS property_description, p.location AS property_location, p.pricepernight AS property_price, p.created_at AS property_created_at, p.updated_at AS property_updated_at,
	   pay.payment_id, pay.amount AS payment_amount, pay.payment_date, pay.payment_method
FROM "Booking" b
INNER JOIN "User" u ON b.user_id = u.user_id
INNER JOIN "Property" p ON b.property_id = p.property_id
LEFT JOIN "Payment" pay ON b.booking_id = pay.booking_id;

-- Analysis
EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.total_price AS booking_total_price, b.status AS booking_status, b.created_at AS booking_created_at,
	   u.user_id, u.first_name, u.last_name, u.email AS user_email, u.phone_number AS user_phone,
	   p.property_id, p.name AS property_name, p.description AS property_description, p.location AS property_location, p.pricepernight AS property_price, p.created_at AS property_created_at, p.updated_at AS property_updated_at,
	   pay.payment_id, pay.amount AS payment_amount, pay.payment_date, pay.payment_method
FROM "Booking" b
INNER JOIN "User" u ON b.user_id = u.user_id
INNER JOIN "Property" p ON b.property_id = p.property_id
LEFT JOIN "Payment" pay ON b.booking_id = pay.booking_id;


-- Optimized query
EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.total_price AS booking_total_price, b.status AS booking_status, b.created_at AS booking_created_at,
	   u.user_id, u.first_name, u.last_name, u.email AS user_email, u.phone_number AS user_phone,
	   p.property_id, p.name AS property_name, p.description AS property_description, p.location AS property_location, p.pricepernight AS property_price, p.created_at AS property_created_at, p.updated_at AS property_updated_at,
	   pay.payment_id, pay.amount AS payment_amount, pay.payment_date, pay.payment_method
FROM "Booking" b
INNER JOIN "User" u ON b.user_id = u.user_id
INNER JOIN "Property" p ON b.property_id = p.property_id
LEFT JOIN "Payment" pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed'
AND p.pricepernight > 100
AND u.email LIKE '%@example.com';
