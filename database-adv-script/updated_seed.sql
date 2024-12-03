-- Enable pgcrypto extension for UUID generation
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert sample Users
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES 
  (gen_random_uuid(), 'John', 'Doe', 'john.doe@example.com', 'hashed_password_1', '123-456-7890', 'host', CURRENT_TIMESTAMP),
  (gen_random_uuid(), 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_password_2', '987-654-3210', 'guest', CURRENT_TIMESTAMP),
  (gen_random_uuid(), 'Alice', 'Johnson', 'alice.johnson@example.com', 'hashed_password_3', '555-111-2222', 'guest', CURRENT_TIMESTAMP),
  (gen_random_uuid(), 'Bob', 'Williams', 'bob.williams@example.com', 'hashed_password_4', NULL, 'admin', CURRENT_TIMESTAMP);

-- Insert sample Properties
INSERT INTO "Property" (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
SELECT gen_random_uuid(), u.user_id, 'Cozy Apartment', 'A small cozy apartment in downtown', 'New York, NY', 100.00::NUMERIC, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "User" u WHERE u.email = 'john.doe@example.com'
UNION ALL
SELECT gen_random_uuid(), u.user_id, 'Beach House', 'A beautiful house by the beach', 'Miami, FL', 250.00::NUMERIC, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "User" u WHERE u.email = 'john.doe@example.com'
UNION ALL
SELECT gen_random_uuid(), u.user_id, 'Mountain Retreat', 'A secluded cabin in the mountains', 'Aspen, CO', 150.00::NUMERIC, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "User" u WHERE u.email = 'jane.smith@example.com';

-- Insert sample Bookings with varied start dates for 2023, 2024, and 2025
INSERT INTO "Booking" (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
SELECT gen_random_uuid(), p.property_id, u.user_id, '2023-05-10'::DATE, '2023-05-15'::DATE, 500.00::NUMERIC, 'confirmed', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Cozy Apartment' AND u.email = 'alice.johnson@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2023-06-01'::DATE, '2023-06-07'::DATE, 1250.00::NUMERIC, 'pending', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Beach House' AND u.email = 'bob.williams@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2023-07-20'::DATE, '2023-07-25'::DATE, 450.00::NUMERIC, 'confirmed', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Mountain Retreat' AND u.email = 'jane.smith@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2024-12-01'::DATE, '2024-12-05'::DATE, 500.00::NUMERIC, 'confirmed', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Cozy Apartment' AND u.email = 'alice.johnson@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2024-12-15'::DATE, '2024-12-20'::DATE, 1250.00::NUMERIC, 'pending', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Beach House' AND u.email = 'bob.williams@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2024-12-10'::DATE, '2024-12-12'::DATE, 450.00::NUMERIC, 'confirmed', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Mountain Retreat' AND u.email = 'jane.smith@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-01-05'::DATE, '2025-01-10'::DATE, 500.00::NUMERIC, 'pending', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Cozy Apartment' AND u.email = 'alice.johnson@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-02-20'::DATE, '2025-02-22'::DATE, 1250.00::NUMERIC, 'confirmed', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Beach House' AND u.email = 'bob.williams@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-03-01'::DATE, '2025-03-05'::DATE, 450.00::NUMERIC, 'confirmed', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Mountain Retreat' AND u.email = 'jane.smith@example.com';

-- Insert sample Payments with start_date included
INSERT INTO "Payment" (payment_id, booking_id, start_date, amount, payment_date, payment_method)
SELECT gen_random_uuid(), b.booking_id, b.start_date, 500.00::NUMERIC, CURRENT_TIMESTAMP, 'credit_card' -- Added b.start_date
FROM "Booking" b 
JOIN "Property" p ON b.property_id = p.property_id 
WHERE p.name = 'Cozy Apartment'
UNION ALL
SELECT gen_random_uuid(), b.booking_id, b.start_date, 1250.00::NUMERIC, CURRENT_TIMESTAMP, 'paypal' -- Added b.start_date
FROM "Booking" b 
JOIN "Property" p ON b.property_id = p.property_id 
WHERE p.name = 'Beach House'
UNION ALL
SELECT gen_random_uuid(), b.booking_id, b.start_date, 450.00::NUMERIC, CURRENT_TIMESTAMP, 'stripe' -- Added b.start_date
FROM "Booking" b 
JOIN "Property" p ON b.property_id = p.property_id 
WHERE p.name = 'Mountain Retreat';


-- Insert sample Reviews
INSERT INTO "Review" (review_id, property_id, user_id, rating, comment, created_at)
SELECT gen_random_uuid(), p.property_id, u.user_id, 4, 'Great place! Very cozy and well-located.', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Cozy Apartment' AND u.email = 'alice.johnson@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, 5, 'The beach house was amazing. Highly recommend!', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Beach House' AND u.email = 'bob.williams@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, 3, 'Nice cabin, but it was a bit far from town.', CURRENT_TIMESTAMP
FROM "Property" p JOIN "User" u ON p.name = 'Mountain Retreat' AND u.email = 'jane.smith@example.com';

-- Insert sample Messages
INSERT INTO "Message" (message_id, sender_id, recipient_id, message_body, sent_at)
SELECT gen_random_uuid(), s.user_id, r.user_id, 'Hi, I would like to book your apartment for a few days in December.', CURRENT_TIMESTAMP
FROM "User" s JOIN "User" r ON s.email = 'alice.johnson@example.com' AND r.email = 'john.doe@example.com'
UNION ALL
SELECT gen_random_uuid(), s.user_id, r.user_id, 'Is the beach house still available for booking?', CURRENT_TIMESTAMP
FROM "User" s JOIN "User" r ON s.email = 'bob.williams@example.com' AND r.email = 'john.doe@example.com'
UNION ALL
SELECT gen_random_uuid(), s.user_id, r.user_id, 'Can you confirm if the mountain retreat has heating?', CURRENT_TIMESTAMP
FROM "User" s JOIN "User" r ON s.email = 'jane.smith@example.com' AND r.email = 'john.doe@example.com';
