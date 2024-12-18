-- Create User Table
CREATE TABLE "User" (
  user_id UUID PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  role VARCHAR(10) CHECK (role IN ('guest', 'host', 'admin')) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Property Table
CREATE TABLE "Property" (
  property_id UUID PRIMARY KEY,
  host_id UUID,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  location VARCHAR(255) NOT NULL,
  pricepernight DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (host_id) REFERENCES "User"(user_id)
);

-- Create Booking Table
CREATE TABLE "Booking" (
  booking_id UUID,
  property_id UUID,
  user_id UUID,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10, 2) NOT NULL,
  status VARCHAR(10) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id, start_date),
  FOREIGN KEY (property_id) REFERENCES "Property"(property_id),
  FOREIGN KEY (user_id) REFERENCES "User"(user_id)
) PARTITION BY RANGE (start_date);

-- Create Payment Table
CREATE TABLE "Payment" (
  payment_id UUID PRIMARY KEY,
  booking_id UUID,
  start_date DATE NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  payment_method VARCHAR(15) CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')) NOT NULL,
  FOREIGN KEY (booking_id, start_date) REFERENCES "Booking"(booking_id, start_date)
);

-- Create Review Table
CREATE TABLE "Review" (
  review_id UUID PRIMARY KEY,
  property_id UUID,
  user_id UUID,
  rating INT CHECK (rating >= 1 AND rating <= 5) NOT NULL,
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES "Property"(property_id),
  FOREIGN KEY (user_id) REFERENCES "User"(user_id)
);

-- Create Message Table
CREATE TABLE "Message" (
  message_id UUID PRIMARY KEY,
  sender_id UUID,
  recipient_id UUID,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES "User"(user_id),
  FOREIGN KEY (recipient_id) REFERENCES "User"(user_id)
);

-- Indexing for User Table
CREATE INDEX idx_user_id ON "User"(user_id);
CREATE INDEX idx_email ON "User"(email);

-- Indexing for Property Table
CREATE INDEX idx_property_id ON "Property"(property_id);

-- Indexing for Booking Table
CREATE INDEX idx_booking_id ON "Booking"(booking_id);
CREATE INDEX idx_property_id_on_booking ON "Booking"(property_id);

-- Indexing for Payment Table
CREATE INDEX idx_payment_id ON "Payment"(payment_id);
CREATE INDEX idx_booking_id_on_payment ON "Payment"(booking_id);

-- Indexing for Review Table
CREATE INDEX idx_review_id ON "Review"(review_id);

-- Indexing for Message Table
CREATE INDEX idx_message_id ON "Message"(message_id);


-- Create Partition for Bookings for Different date ranges
CREATE TABLE "Booking_2023" PARTITION OF "Booking"
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE "Booking_2024" PARTITION OF "Booking"
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE "Booking_2025" PARTITION OF "Booking"
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
