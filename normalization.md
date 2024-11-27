# Database Normalization Steps for 3NF

## Objective: Apply normalization principles to ensure the database is in Third Normal Form (3NF).

### Step 1: First Normal Form (1NF)
- All tables have atomic values and no repeating groups.
- All attributes are single-valued, and no arrays or lists exist.

### Step 2: Second Normal Form (2NF)
- All non-key attributes are fully functionally dependent on the entire primary key.
- No partial dependencies exist where non-key attributes depend only on part of the primary key.

### Step 3: Third Normal Form (3NF)
- No transitive dependencies exist, meaning non-key attributes do not depend on other non-key attributes.
- All attributes depend directly on the primary key.

### Conclusion:
- The schema is already in **3NF** and does not require further normalization.
- Foreign key constraints and relationships are correctly defined, ensuring referential integrity.
