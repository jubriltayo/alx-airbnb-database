-- A query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause
SELECT b.user_id,
	   u.first_name, u.last_name,
	   COUNT(b.booking_id) AS total_bookings 
FROM "Booking" b 
INNER JOIN "User" u 
ON b.user_id = u.user_id 
GROUP BY b.user_id, u.first_name, u.last_name 
ORDER BY total_bookings DESC;


-- A query to rank properties based on the total number of bookings they have received
SELECT p.property_id, p."name" AS property_name, 
	   COUNT(b.booking_id) AS total_bookings,
	   ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number 
FROM "Property" p 
LEFT JOIN "Booking" b 
ON p.property_id = b.property_id 
GROUP BY p.property_id, p."name"
ORDER BY row_number;
