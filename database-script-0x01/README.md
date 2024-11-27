# Database Schema Definition

## Objective
This document aims to define the database schema by writing SQL queries to create tables, set constraints, and optimize performance through indexes.

---

### 1. **User Table**
This table stores information about users of the system, including their personal details and role.

```sql
CREATE TABLE User (
  user_id UUID PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  role ENUM('guest', 'host', 'admin') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_id ON User(user_id);
CREATE INDEX idx_email ON User(email);
```

### 2. **Property Table**
This table holds information about properties listed by users (hosts), including details such as location and price.

```sql
CREATE TABLE Property (
  property_id UUID PRIMARY KEY,
  host_id UUID,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  location VARCHAR(255) NOT NULL,
  pricepernight DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (host_id) REFERENCES User(user_id)
);

CREATE INDEX idx_property_id ON Property(property_id);
```

### 3. **Booking Table**
This table records bookings made by users for properties, along with their status and price details.

```sql
CREATE TABLE Booking (
  booking_id UUID PRIMARY KEY,
  property_id UUID,
  user_id UUID,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10, 2) NOT NULL,
  status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES Property(property_id),
  FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE INDEX idx_booking_id ON Booking(booking_id);
CREATE INDEX idx_property_id_on_booking ON Booking(property_id);
```

### 4. **Payment Table**
This table stores payment details for bookings, including the amount and payment method.

```sql
CREATE TABLE Payment (
  payment_id UUID PRIMARY KEY,
  booking_id UUID,
  amount DECIMAL(10, 2) NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE INDEX idx_payment_id ON Payment(payment_id);
CREATE INDEX idx_booking_id_on_payment ON Payment(booking_id);
```

### 5. **Review Table**
This table holds reviews left by users for properties they’ve booked, including ratings and comments.

```sql
CREATE TABLE Review (
  review_id UUID PRIMARY KEY,
  property_id UUID,
  user_id UUID,
  rating INT CHECK (rating >= 1 AND rating <= 5) NOT NULL,
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES Property(property_id),
  FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE INDEX idx_review_id ON Review(review_id);
```

### 6. **Message Table**
This table records messages between users (e.g., between guests and hosts), capturing the sender, recipient, and message content.

```sql
CREATE TABLE Message (
  message_id UUID PRIMARY KEY,
  sender_id UUID,
  recipient_id UUID,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES User(user_id),
  FOREIGN KEY (recipient_id) REFERENCES User(user_id)
);

CREATE INDEX idx_message_id ON Message(message_id);
```

---

## Key Considerations:
1. **Data Types**: Each table uses appropriate data types for the stored information, such as `UUID` for primary keys, `VARCHAR` for strings, and `DECIMAL` for monetary values.
   
2. **Primary Keys**: Each table has a defined primary key (`UUID`), ensuring each row is uniquely identifiable.

3. **Foreign Keys**: Relationships between tables are established through foreign keys, ensuring referential integrity. 
    - `Property` references `User` (host).
    - `Booking` references both `Property` and `User`.
    - `Payment` references `Booking`.
    - `Review` references both `Property` and `User`.
    - `Message` references `User` for both sender and recipient.

4. **Constraints**:
    - `UNIQUE` constraints on the `email` column in the `User` table.
    - `CHECK` constraints on the `rating` column in the `Review` table to ensure values are between 1 and 5.
    - `ENUM` types for user roles, payment methods, and booking status to ensure valid values are used.

5. **Indexes**: Indexes are created on primary keys and other important columns (such as `user_id`, `email`, `property_id`, `payment_id`, and `booking_id`) to improve query performance, especially for join operations.

---

## Conclusion:
This schema ensures data integrity through foreign key constraints, prevents redundancy by enforcing normalization rules, and is optimized for performance with appropriate indexing. Each table and relationship has been designed to meet the application's requirements for managing users, properties, bookings, payments, reviews, and messages efficiently.

