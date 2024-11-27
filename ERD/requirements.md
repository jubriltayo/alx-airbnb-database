# Database Design

This document outlines the schema for the AirBnB database (a property rental application), including the tables, relationships, and constraints.

## Tables Overview

### User Table
The `User` table stores details about application users. Each user has a unique identifier and role (e.g., guest, host, or admin).

```dbml
Table User {
  user_id uuid [primary key]
  first_name varchar [not null]
  last_name varchar [not null]
  email varchar [unique, not null]
  password_hash varchar [not null]
  phone_number varchar [null]
  role enum('guest', 'host', 'admin') [not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]

  indexes {
    user_id
    email
  }
}
```

---

### Property Table
The `Property` table stores information about properties listed by hosts.

```dbml
Table Property {
  property_id uuid [primary key]
  host_id uuid [ref: > User.user_id]
  name varchar [not null]
  description text [not null]
  location varchar [not null]
  pricepernight decimal [not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]
  updated_at timestamp [default: `CURRENT_TIMESTAMP`]

  indexes {
    property_id
  }
}
```

---

### Booking Table
The `Booking` table manages reservations made by users for properties.

```dbml
Table Booking {
  booking_id uuid [primary key]
  property_id uuid [ref: > Property.property_id]
  user_id uuid [ref: > User.user_id]
  start_date date [not null]
  end_date date [not null]
  total_price decimal [not null]
  status enum('pending', 'confirmed', 'canceled') [not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]

  indexes {
    booking_id
    property_id
  }
}
```

---

### Payment Table
The `Payment` table tracks payment details for bookings.

```dbml
Table Payment {
  payment_id uuid [primary key]
  booking_id uuid [ref: > Booking.booking_id]
  amount decimal [not null]
  payment_date timestamp [default: `CURRENT_TIMESTAMP`]
  payment_method enum('credit_card', 'paypal', 'stripe') [not null]

  indexes {
    payment_id
    booking_id
  }
}
```

---

### Review Table
The `Review` table contains reviews left by users for properties, including ratings and comments.

```dbml
Table Review {
  review_id uuid [primary key]
  property_id uuid [ref: > Property.property_id]
  user_id uuid [ref: > User.user_id]
  rating integer [not null]
  comment text [not null]
  created_at timestamp [default: `CURRENT_TIMESTAMP`]

  indexes {
    review_id
  }
}

Note: 'rating >= 1 AND rating <= 5'
```

---

### Message Table
The `Message` table handles communication between users, such as hosts and guests.

```dbml
Table Message {
  message_id uuid [primary key]
  sender_id uuid [ref: <> User.user_id]
  recipient_id uuid [ref: <> User.user_id]
  message_body text [not null]
  sent_at timestamp [default: `CURRENT_TIMESTAMP`]

  indexes {
    message_id
  }
}
```

---

## Notes on Constraints
1. **User Table**:  
   - Each `email` must be unique, and a `role` is required.
   
2. **Property Table**:  
   - `host_id` is a foreign key referencing `User(user_id)`.

3. **Booking Table**:  
   - `property_id` references `Property(property_id)` and `user_id` references `User(user_id)`.
   - `status` is an enum with possible values: *pending*, *confirmed*, *canceled*.

4. **Payment Table**:  
   - `booking_id` references `Booking(booking_id)`.
   - `payment_method` is an enum with possible values: *credit_card*, *paypal*, *stripe*.

5. **Review Table**:  
   - `property_id` references `Property(property_id)` and `user_id` references `User(user_id)`.
   - `rating` should be between 1 and 5 (enforced in application or database logic).

6. **Message Table**:  
   - Both `sender_id` and `recipient_id` reference `User(user_id)`.

---

## Relationships
1. **User ↔ Property**:  
   One-to-many relationship. A user with the `host` role can list multiple properties.

2. **User ↔ Booking**:  
   One-to-many relationship. A user can book multiple properties.

3. **Property ↔ Booking**:  
   One-to-many relationship. A property can have multiple bookings.

4. **Booking ↔ Payment**:  
   One-to-one relationship. Each booking has one payment.

5. **Property ↔ Review**:  
   One-to-many relationship. A property can have multiple reviews.

6. **User ↔ Message**:  
   Many-to-many relationship (via sender and recipient).
