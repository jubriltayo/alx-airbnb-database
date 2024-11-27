CREATE TABLE "User" (
  "user_id" uuid PRIMARY KEY,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password_hash" varchar NOT NULL,
  "phone_number" varchar,
  "role" enum(guest,host,admin) NOT NULL,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Property" (
  "property_id" uuid PRIMARY KEY,
  "host_id" uuid,
  "name" varchar NOT NULL,
  "description" text NOT NULL,
  "location" varchar NOT NULL,
  "pricepernight" decimal NOT NULL,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Booking" (
  "booking_id" uuid PRIMARY KEY,
  "property_id" uuid,
  "user_id" uuid,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "total_price" decimal NOT NULL,
  "status" enum(pending,confirmed,canceled) NOT NULL,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Payment" (
  "payment_id" uuid PRIMARY KEY,
  "booking_id" uuid,
  "amount" decimal NOT NULL,
  "payment_date" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "payment_method" enum(credit_card,paypal,stripe) NOT NULL
);

CREATE TABLE "Review" (
  "review_id" uuid PRIMARY KEY,
  "property_id" uuid,
  "user_id" uuid,
  "rating" integer NOT NULL,
  "comment" text NOT NULL,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Message" (
  "message_id" uuid PRIMARY KEY,
  "sender_id" uuid,
  "recipient_id" uuid,
  "message_body" text NOT NULL,
  "sent_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE INDEX ON "User" ("user_id");

CREATE INDEX ON "User" ("email");

CREATE INDEX ON "Property" ("property_id");

CREATE INDEX ON "Booking" ("booking_id");

CREATE INDEX ON "Booking" ("property_id");

CREATE INDEX ON "Payment" ("payment_id");

CREATE INDEX ON "Payment" ("booking_id");

CREATE INDEX ON "Review" ("review_id");

CREATE INDEX ON "Message" ("message_id");

COMMENT ON TABLE "Review" IS 'rating >= 1 AND rating <= 5';

ALTER TABLE "Property" ADD FOREIGN KEY ("host_id") REFERENCES "User" ("user_id");

ALTER TABLE "Booking" ADD FOREIGN KEY ("property_id") REFERENCES "Property" ("property_id");

ALTER TABLE "Booking" ADD FOREIGN KEY ("user_id") REFERENCES "User" ("user_id");

ALTER TABLE "Payment" ADD FOREIGN KEY ("booking_id") REFERENCES "Booking" ("booking_id");

ALTER TABLE "Review" ADD FOREIGN KEY ("property_id") REFERENCES "Property" ("property_id");

ALTER TABLE "Review" ADD FOREIGN KEY ("user_id") REFERENCES "User" ("user_id");

ALTER TABLE "Message" ADD FOREIGN KEY ("sender_id") REFERENCES "User" ("user_id");

ALTER TABLE "Message" ADD FOREIGN KEY ("recipient_id") REFERENCES "User" ("user_id");

