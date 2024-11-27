-- Insert sample Users
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES 
  (UUID(), 'John', 'Doe', 'john.doe@example.com', 'hashed_password_1', '123-456-7890', 'host', CURRENT_TIMESTAMP),
  (UUID(), 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_password_2', '987-654-3210', 'guest', CURRENT_TIMESTAMP),
  (UUID(), 'Alice', 'Johnson', 'alice.johnson@example.com', 'hashed_password_3', '555-111-2222', 'guest', CURRENT_TIMESTAMP),
  (UUID(), 'Bob', 'Williams', 'bob.williams@example.com', 'hashed_password_4', NULL, 'admin', CURRENT_TIMESTAMP);

-- Insert sample Properties
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES 
  (UUID(), (SELECT user_id FROM User WHERE email = 'john.doe@example.com'), 'Cozy Apartment', 'A small cozy apartment in downtown', 'New York, NY', 100.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (UUID(), (SELECT user_id FROM User WHERE email = 'john.doe@example.com'), 'Beach House', 'A beautiful house by the beach', 'Miami, FL', 250.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (UUID(), (SELECT user_id FROM User WHERE email = 'jane.smith@example.com'), 'Mountain Retreat', 'A secluded cabin in the mountains', 'Aspen, CO', 150.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert sample Bookings
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
VALUES
  (UUID(), (SELECT property_id FROM Property WHERE name = 'Cozy Apartment'), (SELECT user_id FROM User WHERE email = 'alice.johnson@example.com'), '2024-12-01', '2024-12-05', 500.00, 'confirmed', CURRENT_TIMESTAMP),
  (UUID(), (SELECT property_id FROM Property WHERE name = 'Beach House'), (SELECT user_id FROM User WHERE email = 'bob.williams@example.com'), '2024-12-15', '2024-12-20', 1250.00, 'pending', CURRENT_TIMESTAMP),
  (UUID(), (SELECT property_id FROM Property WHERE name = 'Mountain Retreat'), (SELECT user_id FROM User WHERE email = 'jane.smith@example.com'), '2024-12-10', '2024-12-12', 450.00, 'confirmed', CURRENT_TIMESTAMP);

-- Insert sample Payments
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method)
VALUES
  (UUID(), (SELECT booking_id FROM Booking WHERE property_id = (SELECT property_id FROM Property WHERE name = 'Cozy Apartment')), 500.00, CURRENT_TIMESTAMP, 'credit_card'),
  (UUID(), (SELECT booking_id FROM Booking WHERE property_id = (SELECT property_id FROM Property WHERE name = 'Beach House')), 1250.00, CURRENT_TIMESTAMP, 'paypal'),
  (UUID(), (SELECT booking_id FROM Booking WHERE property_id = (SELECT property_id FROM Property WHERE name = 'Mountain Retreat')), 450.00, CURRENT_TIMESTAMP, 'stripe');

-- Insert sample Reviews
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at)
VALUES
  (UUID(), (SELECT property_id FROM Property WHERE name = 'Cozy Apartment'), (SELECT user_id FROM User WHERE email = 'alice.johnson@example.com'), 4, 'Great place! Very cozy and well-located.', CURRENT_TIMESTAMP),
  (UUID(), (SELECT property_id FROM Property WHERE name = 'Beach House'), (SELECT user_id FROM User WHERE email = 'bob.williams@example.com'), 5, 'The beach house was amazing. Highly recommend!', CURRENT_TIMESTAMP),
  (UUID(), (SELECT property_id FROM Property WHERE name = 'Mountain Retreat'), (SELECT user_id FROM User WHERE email = 'jane.smith@example.com'), 3, 'Nice cabin, but it was a bit far from town.', CURRENT_TIMESTAMP);

-- Insert sample Messages
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES
  (UUID(), (SELECT user_id FROM User WHERE email = 'alice.johnson@example.com'), (SELECT user_id FROM User WHERE email = 'john.doe@example.com'), 'Hi, I would like to book your apartment for a few days in December.', CURRENT_TIMESTAMP),
  (UUID(), (SELECT user_id FROM User WHERE email = 'bob.williams@example.com'), (SELECT user_id FROM User WHERE email = 'john.doe@example.com'), 'Is the beach house still available for booking?', CURRENT_TIMESTAMP),
  (UUID(), (SELECT user_id FROM User WHERE email = 'jane.smith@example.com'), (SELECT user_id FROM User WHERE email = 'john.doe@example.com'), 'Can you confirm if the mountain retreat has heating?', CURRENT_TIMESTAMP);
