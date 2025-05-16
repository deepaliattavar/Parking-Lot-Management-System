DROP DATABASE IF EXISTS parking_management;
CREATE DATABASE IF NOT EXISTS parking_management;
USE parking_management;

DROP TABLE IF EXISTS vehicle;
CREATE TABLE IF NOT EXISTS vehicle (
vehicle_id int(11) NOT NULL PRIMARY KEY,
vehicle_category_id int(11) NOT NULL,
vehicle_number varchar(15) NOT NULL,
vehicle_owner_id int(11) NOT NULL,
user_id int(11) NOT NULL
);

DROP TABLE IF EXISTS vehicle_category;
CREATE TABLE IF NOT EXISTS vehicle_category (
vehicle_category_id int(11) NOT NULL PRIMARY KEY,
vehicle_category_name varchar(30) NOT NULL
);

DROP TABLE IF EXISTS vehicle_owner;
CREATE TABLE IF NOT EXISTS vehicle_owner (
vehicle_owner_id int(11) NOT NULL PRIMARY KEY,
vehicle_owner_name varchar(30) NOT NULL,
user_id int(11) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS parking_slot;
CREATE TABLE IF NOT EXISTS parking_slot (
parking_slot_id int(11) NOT NULL PRIMARY KEY,
parking_slot_location int(11) NOT NULL,
parking_slot_status int(1) NOT NULL,
user_id int(11) NOT NULL,
vehicle_id int(11) NOT NULL,
booking_id int(11) NOT NULL,
parking_lot_id INT(11) NOT NULL
);

DROP TABLE IF EXISTS booking;
CREATE TABLE IF NOT EXISTS booking (
booking_id int(11) NOT NULL PRIMARY KEY,
vehicle_id int(11) NOT NULL,
booking_status int(1) NOT NULL,
vehicle_owner_id int(11) NOT NULL,
payment_id int(11) NOT NULL
);

DROP TABLE IF EXISTS payment;
CREATE TABLE IF NOT EXISTS payment (
payment_id int(11) NOT NULL PRIMARY KEY,
booking_id int(11) NOT NULL,
amount_due float NOT NULL,
amount_paid float NOT NULL,
remarks varchar(100) NOT NULL,
payment_status int(1) NOT NULL,
vehicle_owner_id int(11) NOT NULL
);

DROP TABLE IF EXISTS user;
CREATE TABLE IF NOT EXISTS user (
user_id int(11) NOT NULL PRIMARY KEY,
username varchar(30) NOT NULL,
password varchar(30) NOT NULL,
fullname varchar(50) NOT NULL,
contact varchar(15) NOT NULL,
email varchar(30) NOT NULL,
user_group_id int(11) NOT NULL,
status int(1) NOT NULL
);

DROP TABLE IF EXISTS user_group;
CREATE TABLE IF NOT EXISTS user_group (
user_group_id int(11) NOT NULL PRIMARY KEY,
group_name varchar(30) NOT NULL,
description varchar(50) NOT NULL,
allow_add int(1) NOT NULL,
allow_edit int(1) NOT NULL,
allow_delete int(1) NOT NULL,
allow_print int(1) NOT NULL,
allow_import int(1) NOT NULL,
allow_export int(1) NOT NULL
);

DROP TABLE IF EXISTS history;
CREATE TABLE IF NOT EXISTS history (
history_id int(11) NOT NULL PRIMARY KEY,
booking_id int(11) NOT NULL
);

DROP TABLE IF EXISTS membership;
CREATE TABLE IF NOT EXISTS membership (
membership_id int(11) NOT NULL PRIMARY KEY,
user_id int(11) NOT NULL,
member_type int(11) NOT NULL,
member_status ENUM('active', 'inactive', 'pending'),
member_start DATE NOT NULL,
member_end DATE NOT NULL,
pricing_id INT(11) NOT NULL
);

DROP TABLE IF EXISTS Parking_lot;
CREATE TABLE IF NOT EXISTS Parking_Lot (
parking_lot_id INT PRIMARY KEY,
address VARCHAR(255) NOT NULL,
zone VARCHAR(100) NOT NULL,
total_slots INT NOT NULL,
available_slots INT NOT NULL
);

DROP TABLE IF EXISTS Pricing;
CREATE TABLE IF NOT EXISTS Pricing (
pricing_id INT PRIMARY KEY,
membership_type VARCHAR(50) NOT NULL,
rate DECIMAL(10, 2) NOT NULL
);

DROP TABLE IF EXISTS Parking_Violation;
CREATE TABLE IF NOT EXISTS Parking_Violation (
violation_id INT PRIMARY KEY,
vehicle_id INT NOT NULL,
violation_type VARCHAR(50) NOT NULL,
date_time DATETIME NOT NULL,
fine_amount DECIMAL(10, 2) NOT NULL
);

DROP TABLE IF EXISTS Security_Incident;
CREATE TABLE IF NOT EXISTS Security_Incident (
incident_id INT PRIMARY KEY,
parking_lot_id INT NOT NULL,
description TEXT NOT NULL,
date_time DATETIME NOT NULL,
reported_by VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS Customer_Feedback;
CREATE TABLE IF NOT EXISTS Customer_Feedback (
feedback_id INT PRIMARY KEY,
user_id INT(11) NOT NULL,
feedback_text TEXT,
rating INT CHECK (rating >= 1 AND rating <= 5)
);

DROP TABLE IF EXISTS employee; 
CREATE TABLE IF NOT EXISTS employee (
employee_id INT(11) NOT NULL PRIMARY KEY,
employee_name VARCHAR(100) NOT NULL,
job_title VARCHAR(100),
hire_date DATE
);

DROP TABLE IF EXISTS Employee_Shift;
CREATE TABLE IF NOT EXISTS Employee_Shift (
shift_id INT PRIMARY KEY,
employee_id INT NOT NULL,
shift_start DATETIME NOT NULL,
shift_end DATETIME NOT NULL
);

DROP TABLE IF EXISTS Charging_Station;
CREATE TABLE IF NOT EXISTS Charging_Station (
station_id INT PRIMARY KEY,
parking_lot_id INT NOT NULL,
status VARCHAR(50) NOT NULL,
charge_rate DECIMAL(10, 2) NOT NULL
);


Show tables;


ALTER TABLE vehicle
ADD CONSTRAINT fk_user_id1 FOREIGN KEY (user_id) REFERENCES user(user_id),
ADD CONSTRAINT fk_vehicle_category_id FOREIGN KEY (vehicle_category_id) REFERENCES vehicle_category(vehicle_category_id),
ADD CONSTRAINT fk_vehicle_owner_id1 FOREIGN KEY (vehicle_owner_id) REFERENCES vehicle_owner(vehicle_owner_id);

ALTER TABLE vehicle_owner 
ADD CONSTRAINT fk_user_id2 FOREIGN KEY (user_id) REFERENCES user(user_id);

ALTER TABLE parking_slot
ADD CONSTRAINT fk_booking_id FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
ADD CONSTRAINT fk_vehicle_id2 FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id),
ADD CONSTRAINT fk_parking_lot_id FOREIGN KEY (parking_lot_id) REFERENCES Parking_Lot(parking_lot_id);

ALTER TABLE booking
ADD CONSTRAINT fk_vehicle_owner_id2 FOREIGN KEY (vehicle_owner_id) REFERENCES vehicle_owner(vehicle_owner_id),
ADD CONSTRAINT fk_payment_id FOREIGN KEY (payment_id) REFERENCES payment(payment_id),
ADD CONSTRAINT fk_vehicle_id3 FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id);

ALTER TABLE payment
ADD CONSTRAINT fk_vehicle_owner_id4 FOREIGN KEY (vehicle_owner_id) REFERENCES vehicle_owner(vehicle_owner_id);

ALTER TABLE user
ADD CONSTRAINT fk_user_group_id FOREIGN KEY (user_group_id) REFERENCES user_group(user_group_id);

ALTER TABLE history
ADD CONSTRAINT fk_booking_id2 FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE membership
ADD CONSTRAINT fk_user_id3 FOREIGN KEY (user_id) REFERENCES user(user_id),
ADD CONSTRAINT fk_pricing_id FOREIGN KEY (pricing_id) REFERENCES Pricing(pricing_id);

ALTER TABLE Parking_Violation
ADD CONSTRAINT fk_vehicle_id4 FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id);

ALTER TABLE Security_Incident
ADD CONSTRAINT parking_lot_id2 FOREIGN KEY (parking_lot_id) REFERENCES Parking_Lot(parking_lot_id);

ALTER TABLE Customer_Feedback
ADD CONSTRAINT user_id4 FOREIGN KEY (user_id) REFERENCES vehicle_owner(user_id);

ALTER TABLE Employee_Shift
ADD CONSTRAINT employee_id FOREIGN KEY (employee_id) REFERENCES employee(employee_id);

ALTER TABLE Charging_Station
ADD CONSTRAINT parking_lot_id3 FOREIGN KEY (parking_lot_id) REFERENCES Parking_Lot(parking_lot_id);


-- Data population
INSERT INTO user_group (user_group_id, group_name, description, allow_add, allow_edit, allow_delete, allow_print, allow_import, allow_export) VALUES 
(1, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(2, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(3, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(4, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(5, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(6, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(7, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(8, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(9, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(10, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(11, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(12, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(13, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(14, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(15, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(16, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(17, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(18, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(19, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(20, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(21, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(22, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(23, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(24, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(25, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(26, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(27, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(28, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(29, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(30, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(31, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(32, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(33, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(34, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(35, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(36, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(37, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(38, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(39, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(40, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(41, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(42, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(43, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(44, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(45, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0),
(46, 'Admin', 'Full access to the system', 1, 1, 1, 1, 1, 1),
(47, 'Operator', 'Limited access for parking operations', 1, 1, 0, 1, 0, 0),
(48, 'Customer', 'Customer access to bookings and payments', 0, 0, 0, 0, 0, 0),
(49, 'Security', 'Handles security incidents and parking violations', 0, 0, 1, 0, 0, 0),
(50, 'Supervisor', 'Can manage operators and security', 1, 1, 1, 1, 0, 0);

INSERT INTO user (user_id, username, password, fullname, contact, email, user_group_id, status) VALUES 
(1, 'admin', 'admin123', 'Admin User', '1234567890', 'admin@example.com', 1, 1),
(2, 'operator1', 'op123', 'John Doe', '0987654321', 'operator1@example.com', 2, 1),
(3, 'customer1', 'cust123', 'Jane Smith', '5678901234', 'jane.smith@example.com', 3, 1),
(4, 'security1', 'sec123', 'Security Officer', '5678905678', 'security1@example.com', 4, 1),
(5, 'customer2', 'cust456', 'Bob Johnson', '3456701234', 'bob.johnson@example.com', 3, 1),
(6, 'operator2', 'op456', 'Emily Davis', '5678902345', 'emily.davis@example.com', 2, 1),
(7, 'supervisor1', 'sup123', 'Alice Brown', '1234509876', 'alice.brown@example.com', 5, 1),
(8, 'operator3', 'op789', 'Charlie Wilson', '2345678901', 'charlie.wilson@example.com', 2, 1),
(9, 'customer3', 'cust789', 'Lily Thomas', '4567890123', 'lily.thomas@example.com', 3, 1),
(10, 'security2', 'sec456', 'Mike Ross', '5671238904', 'security2@example.com', 4, 1),
(11, 'customer4', 'cust890', 'Nina Lopez', '6789012345', 'nina.lopez@example.com', 3, 1),
(12, 'operator4', 'op101', 'Olivia Green', '7890123456', 'olivia.green@example.com', 2, 1),
(13, 'supervisor2', 'sup456', 'Ethan Scott', '8901234567', 'ethan.scott@example.com', 5, 1),
(14, 'customer5', 'cust101', 'Lucas Walker', '9012345678', 'lucas.walker@example.com', 3, 1),
(15, 'security3', 'sec789', 'Emma Baker', '2345678901', 'security3@example.com', 4, 1),
(16, 'operator5', 'op202', 'Sophia Harris', '5678901234', 'sophia.harris@example.com', 2, 1),
(17, 'customer6', 'cust202', 'Jacob Young', '6789012345', 'jacob.young@example.com', 3, 1),
(18, 'security4', 'sec101', 'Ryan Adams', '7890123456', 'ryan.adams@example.com', 4, 1),
(19, 'supervisor3', 'sup789', 'Grace Carter', '8901234567', 'grace.carter@example.com', 5, 1),
(20, 'operator6', 'op303', 'Daniel King', '9012345678', 'daniel.king@example.com', 2, 1),
(21, 'customer7', 'cust303', 'Harper Nelson', '1234567890', 'harper.nelson@example.com', 3, 1),
(22, 'security5', 'sec202', 'Aiden Clark', '0987654321', 'aiden.clark@example.com', 4, 1),
(23, 'operator7', 'op404', 'Ella Hill', '5678901234', 'ella.hill@example.com', 2, 1),
(24, 'supervisor4', 'sup101', 'Liam Moore', '6789012345', 'liam.moore@example.com', 5, 1),
(25, 'customer8', 'cust404', 'Mason Martin', '7890123456', 'mason.martin@example.com', 3, 1),
(26, 'security6', 'sec303', 'Isabella Taylor', '8901234567', 'isabella.taylor@example.com', 4, 1),
(27, 'operator8', 'op505', 'James White', '9012345678', 'james.white@example.com', 2, 1),
(28, 'customer9', 'cust505', 'Amelia Martinez', '1234567890', 'amelia.martinez@example.com', 3, 1),
(29, 'supervisor5', 'sup202', 'Jack Thompson', '0987654321', 'jack.thompson@example.com', 5, 1),
(30, 'security7', 'sec404', 'Lily Garcia', '5678901234', 'lily.garcia@example.com', 4, 1),
(31, 'operator9', 'op606', 'Charlotte Gonzalez', '6789012345', 'charlotte.gonzalez@example.com', 2, 1),
(32, 'customer10', 'cust606', 'Zoe Perez', '7890123456', 'zoe.perez@example.com', 3, 1),
(33, 'security8', 'sec505', 'Ella Roberts', '8901234567', 'ella.roberts@example.com', 4, 1),
(34, 'supervisor6', 'sup303', 'Jackson Turner', '9012345678', 'jackson.turner@example.com', 5, 1),
(35, 'operator10', 'op707', 'Emma Phillips', '1234567890', 'emma.phillips@example.com', 2, 1),
(36, 'customer11', 'cust707', 'Noah Evans', '0987654321', 'noah.evans@example.com', 3, 1),
(37, 'security9', 'sec606', 'Ava Edwards', '5678901234', 'ava.edwards@example.com', 4, 1),
(38, 'supervisor7', 'sup404', 'Mia Collins', '6789012345', 'mia.collins@example.com', 5, 1),
(39, 'customer12', 'cust808', 'Ethan Murphy', '7890123456', 'ethan.murphy@example.com', 3, 1),
(40, 'operator11', 'op808', 'Benjamin Sanders', '8901234567', 'benjamin.sanders@example.com', 2, 1),
(41, 'security10', 'sec707', 'Olivia Cook', '9012345678', 'olivia.cook@example.com', 4, 1),
(42, 'customer13', 'cust909', 'Grace Reed', '1234567890', 'grace.reed@example.com', 3, 1),
(43, 'supervisor8', 'sup505', 'James Bryant', '0987654321', 'james.bryant@example.com', 5, 1),
(44, 'operator12', 'op909', 'Mia Bailey', '5678901234', 'mia.bailey@example.com', 2, 1),
(45, 'customer14', 'cust1010', 'Oliver Rivera', '6789012345', 'oliver.rivera@example.com', 3, 1),
(46, 'security11', 'sec808', 'William Price', '7890123456', 'william.price@example.com', 4, 1),
(47, 'supervisor9', 'sup606', 'Sophia Gray', '8901234567', 'sophia.gray@example.com', 5, 1),
(48, 'customer15', 'cust1111', 'Michael Hughes', '9012345678', 'michael.hughes@example.com', 3, 1),
(49, 'operator13', 'op1010', 'Henry Clark', '1234567890', 'henry.clark@example.com', 2, 1),
(50, 'security12', 'sec909', 'David Adams', '0987654321', 'david.adams@example.com', 4, 1);

INSERT INTO vehicle_category (vehicle_category_id, vehicle_category_name) VALUES 
(1, 'Car'),
(2, 'Motorcycle'),
(3, 'Truck'),
(4, 'Electric Vehicle'),
(5, 'Bicycle'),
(6, 'Scooter'),
(7, 'Bus'),
(8, 'Van'),
(9, 'SUV'),
(10, 'Convertible'),
(11, 'Pickup Truck'),
(12, 'Minivan'),
(13, 'ATV'),
(14, 'Tractor'),
(15, 'Golf Cart');

INSERT INTO vehicle_owner (vehicle_owner_id, vehicle_owner_name, user_id) VALUES 
(1, 'Jane Smith', 3),
(2, 'Bob Johnson', 5),
(3, 'John Doe', 6),
(4, 'Emily Davis', 7),
(5, 'Alice Brown', 8),
(6, 'Charlie Wilson', 9),
(7, 'Lily Thomas', 10),
(8, 'Mike Ross', 11),
(9, 'Nina Lopez', 12),
(10, 'Olivia Green', 13),
(11, 'Ethan Scott', 14),
(12, 'Lucas Walker', 15),
(13, 'Emma Baker', 16),
(14, 'Sophia Harris', 17),
(15, 'Jacob Young', 18),
(16, 'Ryan Adams', 19),
(17, 'Grace Carter', 20),
(18, 'Daniel King', 21),
(19, 'Harper Nelson', 22),
(20, 'Aiden Clark', 23),
(21, 'Ella Hill', 24),
(22, 'Liam Moore', 25),
(23, 'Mason Martin', 26),
(24, 'Isabella Taylor', 27),
(25, 'James White', 28),
(26, 'Amelia Martinez', 29),
(27, 'Jack Thompson', 30),
(28, 'Lily Garcia', 31),
(29, 'Charlotte Gonzalez', 32),
(30, 'Zoe Perez', 33),
(31, 'Ella Roberts', 34),
(32, 'Jackson Turner', 35),
(33, 'Emma Phillips', 36),
(34, 'Noah Evans', 37),
(35, 'Ava Edwards', 38),
(36, 'Mia Collins', 39),
(37, 'Ethan Murphy', 40),
(38, 'Benjamin Sanders', 41),
(39, 'Olivia Cook', 42),
(40, 'Grace Reed', 43),
(41, 'James Bryant', 44),
(42, 'Mia Bailey', 45),
(43, 'Oliver Rivera', 46),
(44, 'William Price', 47),
(45, 'Sophia Gray', 48),
(46, 'Michael Hughes', 49),
(47, 'Henry Clark', 50),
(48, 'David Adams', 1),
(49, 'Sarah Brooks', 2),
(50, 'Liam Ward', 4);

INSERT INTO vehicle (vehicle_id, vehicle_category_id, vehicle_number, vehicle_owner_id, user_id) VALUES 
(1, 1, 'ABC1234', 1, 3),
(2, 2, 'XYZ5678', 2, 5),
(3, 3, 'LMN2345', 3, 6),
(4, 14, 'RST4567', 44, 44),
(5, 1, 'NOP1234', 16, 16),
(6, 8, 'ZAB2345', 38, 38),
(7, 10, 'VWX7890', 10, 10),
(8, 5, 'GHI7890', 5, 5),
(9, 15, 'UVW7890', 45, 45),
(10, 6, 'JKL1234', 6, 6),
(11, 4, 'DEF4567', 4, 4),
(12, 2, 'FGH5678', 22, 22),
(13, 9, 'STU4567', 9, 9),
(14, 8, 'PQR2345', 8, 8),
(15, 5, 'JKL7890', 50, 50),
(16, 3, 'LMN2345', 3, 3),
(17, 6, 'UVW5678', 27, 27),
(18, 1, 'ABC1234', 1, 1),
(19, 2, 'QRS5678', 17, 17),
(20, 13, 'EFG2345', 13, 13),
(21, 15, 'KLM7890', 15, 15),
(22, 11, 'OPQ7890', 25, 25),
(23, 12, 'BCD5678', 12, 12),
(24, 1, 'GHI1234', 31, 31),
(25, 4, 'HIJ4567', 14, 14),
(26, 10, 'RST1234', 26, 26),
(27, 13, 'OPQ2345', 43, 43),
(28, 12, 'FGH7890', 40, 40),
(29, 8, 'LMN4567', 24, 24),
(30, 9, 'CDE4567', 39, 39),
(31, 14, 'XYZ2345', 28, 28),
(32, 7, 'WXY5678', 37, 37),
(33, 15, 'DEF7890', 30, 30),
(34, 9, 'LMN5678', 42, 42),
(35, 3, 'XYZ5678', 2, 2),
(36, 10, 'JKL5678', 32, 32),
(37, 5, 'CDE1234', 21, 21),
(38, 2, 'ABC4567', 29, 29),
(39, 11, 'JKL7890', 12, 12),
(40, 8, 'OPQ5678', 6, 6),
(41, 6, 'UVW1234', 18, 18),
(42, 10, 'MNO4567', 15, 15),
(43, 12, 'WXY1234', 19, 19),
(44, 13, 'NOP7890', 13, 13),
(45, 1, 'XYZ1234', 46, 46),
(46, 14, 'DEF2345', 48, 48),
(47, 11, 'EFG1234', 14, 14),
(48, 3, 'KLM7890', 9, 9),
(49, 7, 'NOP1234', 35, 35),
(50, 4, 'IJK2345', 22, 22);

INSERT INTO Parking_Lot (parking_lot_id, address, zone, total_slots, available_slots) VALUES 
(1, '123 Main St', 'Downtown', 100, 50),
(2, '456 Elm St', 'Suburbs', 200, 150),
(3, '789 Oak Ave', 'City Center', 300, 250),
(4, '101 Pine Blvd', 'Industrial Area', 150, 100),
(5, '202 Maple Dr', 'Downtown', 120, 70),
(6, '303 Birch Rd', 'Suburbs', 180, 120),
(7, '404 Cedar St', 'City Center', 350, 300),
(8, '505 Redwood Blvd', 'Industrial Area', 200, 150),
(9, '606 Spruce St', 'Downtown', 150, 80),
(10, '707 Willow Ln', 'Suburbs', 220, 170),
(11, '808 Palm Dr', 'City Center', 400, 350),
(12, '909 Sequoia St', 'Industrial Area', 250, 200),
(13, '1010 Fir Ave', 'Downtown', 130, 90),
(14, '1111 Chestnut Rd', 'Suburbs', 250, 190),
(15, '1212 Pine Dr', 'City Center', 320, 270),
(16, '1313 Oak St', 'Industrial Area', 180, 140),
(17, '1414 Maple Ave', 'Downtown', 110, 60),
(18, '1515 Birch Blvd', 'Suburbs', 160, 130),
(19, '1616 Cedar Rd', 'City Center', 360, 310),
(20, '1717 Redwood St', 'Industrial Area', 210, 160),
(21, '1818 Spruce Ave', 'Downtown', 140, 100),
(22, '1919 Willow Blvd', 'Suburbs', 230, 180),
(23, '2020 Palm Rd', 'City Center', 380, 330),
(24, '2121 Sequoia Ave', 'Industrial Area', 260, 220),
(25, '2222 Fir Blvd', 'Downtown', 140, 90),
(26, '2323 Chestnut Ave', 'Suburbs', 270, 210),
(27, '2424 Pine Rd', 'City Center', 340, 290),
(28, '2525 Oak Blvd', 'Industrial Area', 220, 180),
(29, '2626 Maple Blvd', 'Downtown', 160, 110),
(30, '2727 Birch Ave', 'Suburbs', 210, 160),
(31, '2828 Cedar Blvd', 'City Center', 330, 280),
(32, '2929 Sequoia Rd', 'Industrial Area', 240, 190),
(33, '3030 Redwood Ave', 'Downtown', 100, 50),
(34, '3131 Palm Blvd', 'Suburbs', 220, 170),
(35, '3232 Fir Rd', 'City Center', 380, 320),
(36, '3333 Chestnut Blvd', 'Industrial Area', 200, 150),
(37, '3434 Pine Blvd', 'Downtown', 160, 120),
(38, '3535 Oak Rd', 'Suburbs', 240, 180),
(39, '3636 Maple Blvd', 'City Center', 350, 300),
(40, '3737 Birch Blvd', 'Industrial Area', 220, 170),
(41, '3838 Cedar Rd', 'Downtown', 180, 140),
(42, '3939 Sequoia Blvd', 'Suburbs', 270, 230),
(43, '4040 Redwood Rd', 'City Center', 400, 350),
(44, '4141 Palm Ave', 'Industrial Area', 210, 170),
(45, '4242 Fir Blvd', 'Downtown', 110, 60),
(46, '4343 Chestnut Rd', 'Suburbs', 250, 210),
(47, '4444 Pine Ave', 'City Center', 340, 290),
(48, '4545 Oak Blvd', 'Industrial Area', 230, 190),
(49, '4646 Maple Rd', 'Downtown', 150, 100),
(50, '4747 Birch Rd', 'Suburbs', 200, 160);

INSERT INTO payment (payment_id, booking_id, amount_due, amount_paid, remarks, payment_status, vehicle_owner_id) VALUES 
(1, 1, 100.00, 100.00, 'Paid in full', 1, 1),
(2, 2, 150.00, 150.00, 'Paid in full', 1, 2),
(3, 3, 200.00, 200.00, 'Paid in full', 1, 3),
(4, 4, 120.00, 120.00, 'Paid in full', 1, 1),
(5, 5, 180.00, 180.00, 'Paid in full', 1, 2),
(6, 6, 250.00, 125.00, 'Paid half', 0, 6),
(7, 7, 300.00, 150.00, 'Paid half', 0, 7),
(8, 8, 130.00, 130.00, 'Paid in full', 1, 8),
(9, 9, 220.00, 220.00, 'Paid in full', 1, 9),
(10, 10, 170.00, 170.00, 'Paid in full', 1, 10),
(11, 11, 190.00, 190.00, 'Paid in full', 1, 11),
(12, 12, 110.00, 110.00, 'Paid in full', 1, 12),
(13, 13, 160.00, 160.00, 'Paid in full', 1, 13),
(14, 14, 250.00, 250.00, 'Paid in full', 1, 14),
(15, 15, 300.00, 150.00, 'Paid half', 0, 15),
(16, 16, 120.00, 120.00, 'Paid in full', 1, 16),
(17, 17, 170.00, 170.00, 'Paid in full', 1, 17),
(18, 18, 190.00, 190.00, 'Paid in full', 1, 18),
(19, 19, 220.00, 220.00, 'Paid in full', 1, 19),
(20, 20, 150.00, 75.00, 'Paid half', 0, 20),
(21, 21, 200.00, 200.00, 'Paid in full', 1, 21),
(22, 22, 180.00, 180.00, 'Paid in full', 1, 22),
(23, 23, 120.00, 60.00, 'Paid half', 0, 23),
(24, 24, 300.00, 150.00, 'Paid half', 0, 24),
(25, 25, 150.00, 150.00, 'Paid in full', 1, 25),
(26, 26, 220.00, 220.00, 'Paid in full', 1, 26),
(27, 27, 160.00, 160.00, 'Paid in full', 1, 27),
(28, 28, 180.00, 90.00, 'Paid half', 0, 28),
(29, 29, 200.00, 100.00, 'Paid half', 0, 29),
(30, 30, 250.00, 125.00, 'Paid half', 0, 30),
(31, 31, 130.00, 130.00, 'Paid in full', 1, 31),
(32, 32, 270.00, 270.00, 'Paid in full', 1, 32),
(33, 33, 180.00, 180.00, 'Paid in full', 1, 33),
(34, 34, 220.00, 110.00, 'Paid half', 0, 34),
(35, 35, 150.00, 150.00, 'Paid in full', 1, 35),
(36, 36, 240.00, 240.00, 'Paid in full', 1, 36),
(37, 37, 200.00, 100.00, 'Paid half', 0, 37),
(38, 38, 250.00, 250.00, 'Paid in full', 1, 38),
(39, 39, 300.00, 150.00, 'Paid half', 0, 39),
(40, 40, 180.00, 180.00, 'Paid in full', 1, 40),
(41, 41, 150.00, 75.00, 'Paid half', 0, 41),
(42, 42, 120.00, 120.00, 'Paid in full', 1, 42),
(43, 43, 220.00, 110.00, 'Paid half', 0, 43),
(44, 44, 200.00, 200.00, 'Paid in full', 1, 44),
(45, 45, 150.00, 150.00, 'Paid in full', 1, 45),
(46, 46, 240.00, 240.00, 'Paid in full', 1, 46),
(47, 47, 180.00, 90.00, 'Paid half', 0, 47),
(48, 48, 200.00, 200.00, 'Paid in full', 1, 48),
(49, 49, 220.00, 220.00, 'Paid in full', 1, 49),
(50, 50, 150.00, 150.00, 'Paid in full', 1, 50);

INSERT INTO booking (booking_id, vehicle_id, booking_status, vehicle_owner_id, payment_id) VALUES 
(1, 5, 0, 5, 5),
(2, 30, 1, 30, 30),
(3, 12, 1, 12, 12),
(4, 37, 0, 37, 37),
(5, 28, 1, 28, 28),
(6, 4, 1, 4, 4),
(7, 14, 0, 14, 14),
(8, 2, 1, 2, 2),
(9, 16, 0, 16, 16),
(10, 49, 1, 49, 49),
(11, 24, 0, 24, 24),
(12, 19, 0, 19, 19),
(13, 3, 1, 3, 3),
(14, 22, 1, 22, 22),
(15, 13, 1, 13, 13),
(16, 33, 1, 33, 33),
(17, 38, 0, 38, 38),
(18, 44, 0, 44, 44),
(19, 47, 0, 47, 47),
(20, 7, 0, 7, 7),
(21, 48, 1, 48, 48),
(22, 41, 0, 41, 41),
(23, 6, 1, 6, 6),
(24, 25, 1, 25, 25),
(25, 9, 1, 9, 9),
(26, 26, 1, 26, 26),
(27, 45, 1, 45, 45),
(28, 36, 1, 36, 36),
(29, 32, 0, 32, 32),
(30, 50, 0, 50, 50),
(31, 35, 0, 35, 35),
(32, 20, 1, 20, 20),
(33, 43, 1, 43, 43),
(34, 10, 1, 10, 10),
(35, 29, 1, 29, 29),
(36, 31, 1, 31, 31),
(37, 23, 1, 23, 23),
(38, 34, 1, 34, 34),
(39, 21, 0, 21, 21),
(40, 27, 0, 27, 27),
(41, 15, 1, 15, 15),
(42, 11, 0, 11, 11),
(43, 18, 1, 18, 18),
(44, 17, 1, 17, 17),
(45, 8, 1, 8, 8),
(46, 40, 1, 40, 40),
(47, 46, 1, 46, 46),
(48, 39, 1, 39, 39),
(49, 42, 1, 42, 42),
(50, 1, 1, 1, 1);

INSERT INTO parking_slot (parking_slot_id, parking_slot_location, parking_slot_status, user_id, vehicle_id, booking_id, parking_lot_id) VALUES 
(1, 101, 0, 3, 1, 1, 1),
(2, 102, 1, 5, 2, 2, 2),
(3, 103, 1, 6, 3, 3, 3),
(4, 104, 0, 3, 1, 4, 1),
(5, 105, 1, 5, 2, 5, 2),
(6, 106, 0, 7, 6, 6, 6),
(7, 107, 1, 8, 7, 7, 7),
(8, 108, 0, 9, 8, 8, 8),
(9, 109, 1, 10, 9, 9, 9),
(10, 110, 0, 11, 10, 10, 10),
(11, 111, 1, 12, 11, 11, 11),
(12, 112, 0, 13, 12, 12, 12),
(13, 113, 1, 14, 13, 13, 13),
(14, 114, 0, 15, 14, 14, 14),
(15, 115, 1, 16, 15, 15, 15),
(16, 116, 0, 17, 16, 16, 16),
(17, 117, 1, 18, 17, 17, 17),
(18, 118, 0, 19, 18, 18, 18),
(19, 119, 1, 20, 19, 19, 19),
(20, 120, 0, 21, 20, 20, 20),
(21, 121, 1, 22, 21, 21, 21),
(22, 122, 0, 23, 22, 22, 22),
(23, 123, 1, 24, 23, 23, 23),
(24, 124, 0, 25, 24, 24, 24),
(25, 125, 1, 26, 25, 25, 25),
(26, 126, 0, 27, 26, 26, 26),
(27, 127, 1, 28, 27, 27, 27),
(28, 128, 0, 29, 28, 28, 28),
(29, 129, 1, 30, 29, 29, 29),
(30, 130, 0, 31, 30, 30, 30),
(31, 131, 1, 32, 31, 31, 31),
(32, 132, 0, 33, 32, 32, 32),
(33, 133, 1, 34, 33, 33, 33),
(34, 134, 0, 35, 34, 34, 34),
(35, 135, 1, 36, 35, 35, 35),
(36, 136, 0, 37, 36, 36, 36),
(37, 137, 1, 38, 37, 37, 37),
(38, 138, 0, 39, 38, 38, 38),
(39, 139, 1, 40, 39, 39, 39),
(40, 140, 0, 41, 40, 40, 40),
(41, 141, 1, 42, 41, 41, 41),
(42, 142, 0, 43, 42, 42, 42),
(43, 143, 1, 44, 43, 43, 43),
(44, 144, 0, 45, 44, 44, 44),
(45, 145, 1, 46, 45, 45, 45),
(46, 146, 0, 47, 46, 46, 46),
(47, 147, 1, 48, 47, 47, 47),
(48, 148, 0, 49, 48, 48, 48),
(49, 149, 1, 50, 49, 49, 49),
(50, 150, 0, 1, 50, 50, 50);

INSERT INTO Pricing (pricing_id, membership_type, rate) VALUES 
(1, 'Basic', 50.00),
(2, 'Premium', 100.00),
(3, 'VIP', 150.00),
(4, 'Corporate', 200.00);

INSERT INTO membership (membership_id, user_id, member_type, member_status, member_start, member_end, pricing_id) VALUES 
(1, 3, 1, 'active', '2023-01-01', '2024-01-01', 1),
(2, 5, 2, 'active', '2023-03-15', '2024-03-15', 2),
(3, 6, 3, 'pending', '2023-10-01', '2024-10-01', 3),
(4, 8, 1, 'active', '2023-02-01', '2024-02-01', 2),
(5, 9, 2, 'inactive', '2022-06-01', '2023-06-01', 4),
(6, 11, 1, 'active', '2023-04-10', '2024-04-10', 1),
(7, 13, 3, 'active', '2023-07-01', '2024-07-01', 3),
(8, 14, 2, 'inactive', '2022-09-01', '2023-09-01', 1),
(9, 16, 1, 'active', '2023-05-20', '2024-05-20', 2),
(10, 18, 3, 'pending', '2023-08-01', '2024-08-01', 4),
(11, 20, 2, 'inactive', '2022-04-01', '2023-04-01', 3),
(12, 22, 1, 'active', '2023-06-01', '2024-06-01', 4),
(13, 24, 3, 'pending', '2023-09-01', '2024-09-01', 2),
(14, 26, 1, 'active', '2023-11-01', '2024-11-01', 3),
(15, 28, 2, 'inactive', '2022-01-01', '2023-01-01', 4),
(16, 30, 3, 'active', '2023-12-01', '2024-12-01', 1),
(17, 32, 1, 'active', '2023-02-15', '2024-02-15', 2),
(18, 34, 2, 'inactive', '2022-05-01', '2023-05-01', 3),
(19, 36, 1, 'active', '2023-01-10', '2024-01-10', 4),
(20, 38, 3, 'pending', '2023-04-01', '2024-04-01', 2),
(21, 40, 1, 'active', '2023-03-25', '2024-03-25', 1),
(22, 42, 2, 'inactive', '2022-07-01', '2023-07-01', 4),
(23, 44, 1, 'active', '2023-09-15', '2024-09-15', 3),
(24, 46, 3, 'pending', '2023-11-01', '2024-11-01', 2),
(25, 48, 2, 'inactive', '2022-12-01', '2023-12-01', 1),
(26, 50, 1, 'active', '2023-06-15', '2024-06-15', 4),
(27, 2, 3, 'pending', '2023-05-01', '2024-05-01', 1),
(28, 4, 1, 'active', '2023-07-01', '2024-07-01', 2),
(29, 6, 2, 'inactive', '2022-03-01', '2023-03-01', 3),
(30, 8, 1, 'active', '2023-02-10', '2024-02-10', 1),
(31, 10, 3, 'pending', '2023-10-10', '2024-10-10', 4),
(32, 12, 1, 'active', '2023-01-20', '2024-01-20', 2),
(33, 14, 2, 'inactive', '2022-08-01', '2023-08-01', 3),
(34, 16, 1, 'active', '2023-04-01', '2024-04-01', 4),
(35, 18, 3, 'pending', '2023-09-05', '2024-09-05', 2),
(36, 20, 1, 'active', '2023-03-01', '2024-03-01', 1),
(37, 22, 2, 'inactive', '2022-10-01', '2023-10-01', 4),
(38, 24, 3, 'pending', '2023-11-01', '2024-11-01', 1),
(39, 26, 1, 'active', '2023-05-10', '2024-05-10', 3),
(40, 28, 2, 'inactive', '2022-02-01', '2023-02-01', 2),
(41, 30, 3, 'pending', '2023-07-01', '2024-07-01', 4),
(42, 32, 1, 'active', '2023-09-01', '2024-09-01', 1),
(43, 34, 2, 'inactive', '2022-11-01', '2023-11-01', 3),
(44, 36, 1, 'active', '2023-08-01', '2024-08-01', 2),
(45, 38, 3, 'pending', '2023-06-20', '2024-06-20', 4),
(46, 40, 1, 'active', '2023-05-01', '2024-05-01', 3),
(47, 42, 2, 'inactive', '2022-04-15', '2023-04-15', 1),
(48, 44, 3, 'pending', '2023-10-15', '2024-10-15', 2),
(49, 46, 1, 'active', '2023-01-30', '2024-01-30', 4),
(50, 48, 2, 'inactive', '2022-09-20', '2023-09-20', 3);

INSERT INTO Parking_Violation (violation_id, vehicle_id, violation_type, date_time, fine_amount) VALUES 
(1, 1, 'Overstay', '2023-01-10 10:00:00', 50.00),
(2, 2, 'Illegal Parking', '2023-02-05 14:30:00', 100.00),
(3, 3, 'Unpaid Parking', '2023-03-20 16:00:00', 75.00),
(4, 4, 'Parking in a Handicap Zone', '2023-04-11 09:45:00', 150.00),
(5, 5, 'No Parking Permit', '2023-05-15 13:20:00', 80.00),
(6, 6, 'Expired Meter', '2023-06-01 11:00:00', 25.00),
(7, 7, 'Blocking Driveway', '2023-06-20 15:45:00', 120.00),
(8, 8, 'Fire Lane Violation', '2023-07-10 08:30:00', 200.00),
(9, 9, 'Unauthorized Area', '2023-08-05 14:00:00', 90.00),
(10, 10, 'Double Parking', '2023-09-15 17:30:00', 60.00),
(11, 1, 'Loading Zone Violation', '2023-10-10 12:00:00', 55.00),
(12, 2, 'Blocking Pedestrian Access', '2023-11-01 09:30:00', 130.00),
(13, 3, 'Exceeding Time Limit', '2023-11-20 16:15:00', 45.00),
(14, 4, 'Improper Parking', '2023-12-01 13:10:00', 70.00),
(15, 5, 'No License Plate', '2024-01-05 15:00:00', 110.00),
(16, 6, 'Parking on Grass', '2024-01-15 10:20:00', 60.00),
(17, 7, 'Unpaid Citation', '2024-02-01 14:30:00', 95.00),
(18, 8, 'Failure to Pay Fee', '2024-02-20 16:45:00', 85.00),
(19, 9, 'Reserved Space Violation', '2024-03-01 11:50:00', 115.00),
(20, 10, 'Blocking Entrance', '2024-03-10 10:00:00', 125.00),
(21, 11, 'Overstay', '2024-03-15 10:30:00', 50.00),
(22, 12, 'Illegal Parking', '2024-03-20 11:45:00', 100.00),
(23, 13, 'Unpaid Parking', '2024-04-05 14:20:00', 75.00),
(24, 14, 'Parking in a Handicap Zone', '2024-04-10 09:15:00', 150.00),
(25, 15, 'No Parking Permit', '2024-04-15 08:00:00', 80.00),
(26, 16, 'Expired Meter', '2024-04-20 12:00:00', 25.00),
(27, 17, 'Blocking Driveway', '2024-05-01 13:30:00', 120.00),
(28, 18, 'Fire Lane Violation', '2024-05-10 14:45:00', 200.00),
(29, 19, 'Unauthorized Area', '2024-05-15 15:50:00', 90.00),
(30, 20, 'Double Parking', '2024-05-20 17:10:00', 60.00),
(31, 21, 'Loading Zone Violation', '2024-06-01 16:00:00', 55.00),
(32, 22, 'Blocking Pedestrian Access', '2024-06-10 08:10:00', 130.00),
(33, 23, 'Exceeding Time Limit', '2024-06-15 09:20:00', 45.00),
(34, 24, 'Improper Parking', '2024-06-20 13:30:00', 70.00),
(35, 25, 'No License Plate', '2024-07-01 10:15:00', 110.00),
(36, 26, 'Parking on Grass', '2024-07-15 12:00:00', 60.00),
(37, 27, 'Unpaid Citation', '2024-08-01 14:45:00', 95.00),
(38, 28, 'Failure to Pay Fee', '2024-08-10 09:10:00', 85.00),
(39, 29, 'Reserved Space Violation', '2024-08-20 16:30:00', 115.00),
(40, 30, 'Blocking Entrance', '2024-09-01 08:30:00', 125.00),
(41, 31, 'Overstay', '2024-09-15 13:45:00', 50.00),
(42, 32, 'Illegal Parking', '2024-10-01 10:10:00', 100.00),
(43, 33, 'Unpaid Parking', '2024-10-10 11:30:00', 75.00),
(44, 34, 'Parking in a Handicap Zone', '2024-10-15 14:50:00', 150.00),
(45, 35, 'No Parking Permit', '2024-10-20 15:25:00', 80.00),
(46, 1, 'Overstay', '2024-10-25 09:00:00', 50.00),
(47, 2, 'Illegal Parking', '2024-10-30 11:15:00', 100.00),
(48, 3, 'Unpaid Parking', '2024-11-05 13:45:00', 75.00),
(49, 4, 'Parking in a Handicap Zone', '2024-11-10 12:10:00', 150.00),
(50, 5, 'No Parking Permit', '2024-11-15 14:25:00', 80.00);

INSERT INTO Security_Incident (incident_id, parking_lot_id, description, date_time, reported_by) VALUES 
(1, 1, 'Suspicious activity near entrance', '2023-01-15 18:30:00', 'John Doe'),
(2, 2, 'Attempted vehicle break-in', '2023-02-12 20:45:00', 'Jane Smith'),
(3, 3, 'Vandalism in parking lot', '2023-03-22 11:10:00', 'Emily Davis'),
(4, 4, 'Unauthorized vehicle in reserved spot', '2023-04-05 14:00:00', 'Michael Brown'),
(5, 5, 'Fight reported between two drivers', '2023-04-20 16:30:00', 'Sarah Wilson'),
(6, 6, 'Loitering near parking area', '2023-05-05 19:20:00', 'Chris Lee'),
(7, 7, 'Suspicious package found', '2023-06-01 09:15:00', 'Laura Kim'),
(8, 8, 'Vehicle fire incident', '2023-06-15 08:45:00', 'Daniel Garcia'),
(9, 9, 'Unauthorized vendor solicitation', '2023-07-10 10:30:00', 'James Scott'),
(10, 10, 'Vehicle hit-and-run reported', '2023-08-02 13:15:00', 'Sophia Turner'),
(11, 11, 'Traffic congestion in parking lot', '2023-08-18 17:45:00', 'Liam Nguyen'),
(12, 12, 'Unauthorized vehicle blocking entrance', '2023-09-01 12:00:00', 'Olivia Davis'),
(13, 13, 'Suspicious individual loitering', '2023-09-15 09:40:00', 'Henry Moore'),
(14, 14, 'Vehicle parked in fire lane', '2023-10-10 14:10:00', 'Anna Peterson'),
(15, 15, 'Overnight parking violation', '2023-10-25 22:30:00', 'George Harris'),
(16, 16, 'Broken security camera', '2023-11-05 11:15:00', 'Emma Martinez'),
(17, 17, 'Harassment report in parking lot', '2023-11-15 15:20:00', 'Noah White'),
(18, 18, 'Unidentified vehicle abandoned', '2023-12-02 07:10:00', 'Ethan Clark'),
(19, 19, 'Obstruction of vehicle exit', '2023-12-10 12:40:00', 'Mia Thompson'),
(20, 20, 'Attempted theft of vehicle parts', '2023-12-20 21:50:00', 'Lily Rodriguez'),
(21, 21, 'Suspicious activity near entrance', '2024-01-10 18:30:00', 'David Green'),
(22, 22, 'Vehicle alarm disturbance', '2024-01-15 20:30:00', 'Zoe Baker'),
(23, 23, 'Aggressive driving in lot', '2024-02-05 14:30:00', 'Aaron Carter'),
(24, 24, 'Unauthorized gathering in parking lot', '2024-02-18 16:00:00', 'Samantha Flores'),
(25, 25, 'Graffiti reported on walls', '2024-02-25 11:20:00', 'Jack Kelly'),
(26, 26, 'Vehicle blocking pedestrian path', '2024-03-05 09:35:00', 'Natalie Rivera'),
(27, 27, 'Verbal altercation near exit', '2024-03-20 13:45:00', 'Mason Torres'),
(28, 28, 'Unattended child reported', '2024-03-30 15:50:00', 'Oliver Hill'),
(29, 29, 'Vehicle with expired registration', '2024-04-10 10:25:00', 'Lucy Morgan'),
(30, 30, 'Unauthorized bicycle parking', '2024-04-20 12:35:00', 'Benjamin Ward'),
(31, 31, 'Drunk driver in parking lot', '2024-05-05 17:30:00', 'Abigail Bailey'),
(32, 32, 'Suspicious noises reported', '2024-05-15 22:10:00', 'Elijah Evans'),
(33, 33, 'Breakdown of vehicle causing obstruction', '2024-05-25 08:20:00', 'Caleb Miller'),
(34, 34, 'Debris in parking space', '2024-06-10 13:55:00', 'Isabella Adams'),
(35, 35, 'Attempted assault', '2024-06-20 19:00:00', 'Amelia Wilson'),
(36, 36, 'Security gate malfunction', '2024-07-02 10:40:00', 'Lucas Gonzalez'),
(37, 37, 'Overcrowding in parking area', '2024-07-10 18:45:00', 'Grace Hall'),
(38, 38, 'Unauthorized street performers', '2024-07-15 11:25:00', 'Madison James'),
(39, 39, 'Vehicle struck by unknown object', '2024-07-25 14:15:00', 'Ava Lewis'),
(40, 40, 'Violation of noise regulations', '2024-08-05 21:05:00', 'Evelyn Ramirez'),
(41, 41, 'Parking dispute between drivers', '2024-08-15 09:30:00', 'Matthew Stewart'),
(42, 42, 'Reported loud music', '2024-08-20 16:40:00', 'Liam Murphy'),
(43, 43, 'Suspicious bag left unattended', '2024-08-25 12:50:00', 'Sofia Black'),
(44, 44, 'Vehicle blocking fire exit', '2024-09-02 10:20:00', 'Samuel Bell'),
(45, 45, 'Skateboarding in parking lot', '2024-09-10 17:15:00', 'Avery Lee'),
(46, 46, 'Attempted vehicle theft', '2024-09-18 23:30:00', 'Charlie Price'),
(47, 47, 'Unauthorized drone activity', '2024-09-25 14:40:00', 'Ellie Young'),
(48, 48, 'Stray animal causing disruption', '2024-10-05 11:30:00', 'Daniel Harris'),
(49, 49, 'Crowd gathering near lot', '2024-10-12 13:45:00', 'Ella Simmons'),
(50, 50, 'Hit-and-run accident reported', '2024-10-20 19:50:00', 'Nolan Fisher');

INSERT INTO Customer_Feedback (feedback_id, user_id, feedback_text, rating) VALUES 
(1, 3, 'Great service, easy to use', 5),
(2, 5, 'Found it difficult to find a spot', 3),
(3, 6, 'Security staff was very helpful', 4),
(4, 7, 'App is user-friendly', 5),
(5, 8, 'Parking lot is too crowded', 2),
(6, 9, 'Satisfied with the parking availability', 4),
(7, 10, 'Long wait times for exit', 2),
(8, 11, 'Convenient location', 5),
(9, 12, 'Customer support could be improved', 3),
(10, 13, 'Pricing is reasonable', 4),
(11, 14, 'Poor lighting in the parking area', 2),
(12, 15, 'Easy to book a spot online', 5),
(13, 16, 'Experienced a delay at the entrance', 3),
(14, 17, 'Parking attendants are friendly', 4),
(15, 18, 'Limited space for larger vehicles', 3),
(16, 19, 'Great experience, will come again', 5),
(17, 20, 'Payment process is confusing', 2),
(18, 21, 'Lot is well-maintained', 4),
(19, 22, 'Encountered issues with the app', 2),
(20, 23, 'Fast and easy booking process', 5),
(21, 24, 'Security measures are effective', 4),
(22, 25, 'Had trouble locating my car', 3),
(23, 26, 'Parking fees are a bit high', 3),
(24, 27, 'Entrance signage could be improved', 3),
(25, 28, 'Easy to navigate within the lot', 5),
(26, 29, 'Experienced a delay at exit', 3),
(27, 30, 'Helpful customer service', 4),
(28, 31, 'Overpriced for the area', 2),
(29, 32, 'App is fast and efficient', 5),
(30, 33, 'More disabled parking spaces needed', 3),
(31, 34, 'Lot could be cleaner', 2),
(32, 35, 'Reliable service, very satisfied', 5),
(33, 36, 'Spaces too tight for large cars', 3),
(34, 37, 'Appreciate the security presence', 4),
(35, 38, 'App crashed while booking', 2),
(36, 39, 'Plenty of parking space available', 4),
(37, 40, 'Better exit signs needed', 3),
(38, 41, 'Would recommend to friends', 5),
(39, 42, 'Pricey, but convenient location', 3),
(40, 43, 'Smooth entry and exit process', 5),
(41, 44, 'Experienced some technical issues', 2),
(42, 45, 'Easy to find a spot', 4),
(43, 46, 'Crowded during peak hours', 3),
(44, 47, 'Excellent service and support', 5),
(45, 48, 'A bit confusing to navigate', 3),
(46, 49, 'Affordable and convenient', 4),
(47, 50, 'Some spots are too narrow', 2),
(48, 1, 'Great overall experience', 5),
(49, 2, 'Takes too long to find a spot', 2),
(50, 4, 'Clean and well-lit parking lot', 4);

INSERT INTO employee (employee_id, employee_name, job_title, hire_date) VALUES 
(1, 'Emily Davis', 'Security Officer', '2023-03-05'),
(2, 'Mark Lee', 'Parking Manager', '2020-09-10'),
(3, 'Anna Thompson', 'Technician', '2021-05-25'),
(4, 'John Doe', 'Customer Service Representative', '2022-07-14'),
(5, 'Sophia Kim', 'Maintenance Worker', '2021-11-23'),
(6, 'Michael Brown', 'Security Supervisor', '2019-12-12'),
(7, 'Sarah Wilson', 'Parking Attendant', '2022-02-18'),
(8, 'David Green', 'IT Specialist', '2020-03-30'),
(9, 'Olivia Johnson', 'Operations Manager', '2018-06-04'),
(10, 'Liam Garcia', 'Technician', '2023-01-15'),
(11, 'Emma Rodriguez', 'Security Officer', '2021-08-09'),
(12, 'James Scott', 'Maintenance Worker', '2020-10-01'),
(13, 'Ava Turner', 'Parking Attendant', '2023-02-20'),
(14, 'Henry Miller', 'Customer Service Representative', '2019-07-26'),
(15, 'Lucas White', 'Technician', '2021-04-22'),
(16, 'Grace Lee', 'Security Supervisor', '2022-01-19'),
(17, 'Benjamin Davis', 'Operations Manager', '2019-05-10'),
(18, 'Zoe Baker', 'IT Specialist', '2023-03-03'),
(19, 'Daniel Thompson', 'Security Officer', '2022-12-01'),
(20, 'Madison Harris', 'Parking Manager', '2018-11-28'),
(21, 'Samuel Clark', 'Maintenance Worker', '2021-09-15'),
(22, 'Ella Lewis', 'Customer Service Representative', '2023-07-13'),
(23, 'Jack Young', 'Technician', '2022-05-11'),
(24, 'Natalie Walker', 'Parking Attendant', '2020-03-20'),
(25, 'Ethan Hall', 'Security Supervisor', '2021-06-17'),
(26, 'Mia Allen', 'IT Specialist', '2022-10-30'),
(27, 'Caleb King', 'Operations Manager', '2023-01-23'),
(28, 'Isabella Wright', 'Security Officer', '2022-08-07'),
(29, 'Alexander Martinez', 'Parking Manager', '2020-05-29'),
(30, 'Charlotte Hernandez', 'Maintenance Worker', '2019-03-14'),
(31, 'Aiden Lopez', 'Technician', '2021-07-12'),
(32, 'Sofia Gonzalez', 'Customer Service Representative', '2020-09-06'),
(33, 'Ryan Perez', 'Security Supervisor', '2023-04-17'),
(34, 'Hannah Green', 'IT Specialist', '2018-02-28'),
(35, 'Evelyn Price', 'Parking Attendant', '2023-05-30'),
(36, 'Dylan Adams', 'Operations Manager', '2020-08-21'),
(37, 'Lily Robinson', 'Technician', '2021-11-04'),
(38, 'Connor Bell', 'Security Officer', '2019-09-16'),
(39, 'Samantha Brooks', 'Parking Manager', '2022-06-18'),
(40, 'Owen Sanders', 'Customer Service Representative', '2023-02-07'),
(41, 'Aria Carter', 'Maintenance Worker', '2020-04-25'),
(42, 'Sebastian Flores', 'Security Supervisor', '2019-12-09'),
(43, 'Harper Reed', 'Operations Manager', '2023-06-11'),
(44, 'Gabriel Murphy', 'Technician', '2021-02-27'),
(45, 'Layla Morgan', 'Security Officer', '2023-08-19'),
(46, 'Nathaniel Rivera', 'Parking Attendant', '2021-10-05'),
(47, 'Scarlett Hayes', 'IT Specialist', '2022-12-15'),
(48, 'Isaac Ramirez', 'Maintenance Worker', '2020-07-02'),
(49, 'Nolan Cox', 'Customer Service Representative', '2022-11-08'),
(50, 'Aurora Long', 'Parking Manager', '2018-01-05');

INSERT INTO Employee_Shift (shift_id, employee_id, shift_start, shift_end) VALUES 
(1, 1, '2023-10-01 08:00:00', '2023-10-01 16:00:00'),
(2, 2, '2023-10-01 09:00:00', '2023-10-01 17:00:00'),
(3, 3, '2023-10-01 10:00:00', '2023-10-01 18:00:00'),
(4, 4, '2023-10-01 11:00:00', '2023-10-01 19:00:00'),
(5, 5, '2023-10-01 12:00:00', '2023-10-01 20:00:00'),
(6, 6, '2023-10-01 13:00:00', '2023-10-01 21:00:00'),
(7, 7, '2023-10-01 14:00:00', '2023-10-01 22:00:00'),
(8, 8, '2023-10-01 15:00:00', '2023-10-01 23:00:00'),
(9, 9, '2023-10-01 16:00:00', '2023-10-01 00:00:00'),
(10, 10, '2023-10-01 17:00:00', '2023-10-01 01:00:00'),
(11, 11, '2023-10-02 08:00:00', '2023-10-02 16:00:00'),
(12, 12, '2023-10-02 09:00:00', '2023-10-02 17:00:00'),
(13, 13, '2023-10-02 10:00:00', '2023-10-02 18:00:00'),
(14, 14, '2023-10-02 11:00:00', '2023-10-02 19:00:00'),
(15, 15, '2023-10-02 12:00:00', '2023-10-02 20:00:00'),
(16, 16, '2023-10-02 13:00:00', '2023-10-02 21:00:00'),
(17, 17, '2023-10-02 14:00:00', '2023-10-02 22:00:00'),
(18, 18, '2023-10-02 15:00:00', '2023-10-02 23:00:00'),
(19, 19, '2023-10-02 16:00:00', '2023-10-02 00:00:00'),
(20, 20, '2023-10-02 17:00:00', '2023-10-02 01:00:00'),
(21, 21, '2023-10-03 08:00:00', '2023-10-03 16:00:00'),
(22, 22, '2023-10-03 09:00:00', '2023-10-03 17:00:00'),
(23, 23, '2023-10-03 10:00:00', '2023-10-03 18:00:00'),
(24, 24, '2023-10-03 11:00:00', '2023-10-03 19:00:00'),
(25, 25, '2023-10-03 12:00:00', '2023-10-03 20:00:00'),
(26, 26, '2023-10-03 13:00:00', '2023-10-03 21:00:00'),
(27, 27, '2023-10-03 14:00:00', '2023-10-03 22:00:00'),
(28, 28, '2023-10-03 15:00:00', '2023-10-03 23:00:00'),
(29, 29, '2023-10-03 16:00:00', '2023-10-03 00:00:00'),
(30, 30, '2023-10-03 17:00:00', '2023-10-03 01:00:00'),
(31, 31, '2023-10-04 08:00:00', '2023-10-04 16:00:00'),
(32, 32, '2023-10-04 09:00:00', '2023-10-04 17:00:00'),
(33, 33, '2023-10-04 10:00:00', '2023-10-04 18:00:00'),
(34, 34, '2023-10-04 11:00:00', '2023-10-04 19:00:00'),
(35, 35, '2023-10-04 12:00:00', '2023-10-04 20:00:00'),
(36, 36, '2023-10-04 13:00:00', '2023-10-04 21:00:00'),
(37, 37, '2023-10-04 14:00:00', '2023-10-04 22:00:00'),
(38, 38, '2023-10-04 15:00:00', '2023-10-04 23:00:00'),
(39, 39, '2023-10-04 16:00:00', '2023-10-04 00:00:00'),
(40, 40, '2023-10-04 17:00:00', '2023-10-04 01:00:00'),
(41, 41, '2023-10-05 08:00:00', '2023-10-05 16:00:00'),
(42, 42, '2023-10-05 09:00:00', '2023-10-05 17:00:00'),
(43, 43, '2023-10-05 10:00:00', '2023-10-05 18:00:00'),
(44, 44, '2023-10-05 11:00:00', '2023-10-05 19:00:00'),
(45, 45, '2023-10-05 12:00:00', '2023-10-05 20:00:00'),
(46, 46, '2023-10-05 13:00:00', '2023-10-05 21:00:00'),
(47, 47, '2023-10-05 14:00:00', '2023-10-05 22:00:00'),
(48, 48, '2023-10-05 15:00:00', '2023-10-05 23:00:00'),
(49, 49, '2023-10-05 16:00:00', '2023-10-05 00:00:00'),
(50, 50, '2023-10-05 17:00:00', '2023-10-05 01:00:00');

INSERT INTO Charging_Station (station_id, parking_lot_id, status, charge_rate) VALUES 
(1, 23, 'Available', 20.00),
(2, 14, 'In Use', 25.00),
(3, 8, 'Under Maintenance', 0.00),
(4, 39, 'Available', 30.00),
(5, 5, 'Available', 22.50),
(6, 12, 'In Use', 18.00),
(7, 41, 'Under Maintenance', 0.00),
(8, 28, 'Available', 27.00),
(9, 11, 'In Use', 23.50),
(10, 1, 'Under Maintenance', 0.00),
(11, 30, 'Available', 19.00),
(12, 17, 'In Use', 24.00),
(13, 9, 'Available', 21.00),
(14, 3, 'In Use', 28.00),
(15, 44, 'Under Maintenance', 0.00),
(16, 18, 'Available', 25.50),
(17, 33, 'In Use', 26.00),
(18, 25, 'Under Maintenance', 0.00),
(19, 37, 'Available', 20.50),
(20, 46, 'In Use', 29.00);


-- Complex queries
-- Query 1: To Fetch Detailed Parking Slot and Booking Information
SELECT 
    parking_slot.parking_slot_id,
    parking_slot.parking_slot_location,
    parking_slot.parking_slot_status,
    Parking_Lot.address AS parking_lot_address,
    Parking_Lot.zone AS parking_zone,
    Parking_Lot.available_slots AS parking_lot_available_slots,
    vehicle.vehicle_number AS vehicle_number,
    vehicle_owner.vehicle_owner_name AS owner_name,
    user.username AS owner_username,
    booking.booking_id,
    booking.booking_status,
    payment.payment_id,
    payment.amount_due,
    payment.amount_paid,
    payment.payment_status,
    CASE 
        WHEN membership.member_status = 'active' THEN 'Member'
        ELSE 'Non-Member'
    END AS membership_status
FROM 
    parking_slot
JOIN 
    booking ON parking_slot.booking_id = booking.booking_id
JOIN 
    vehicle ON booking.vehicle_id = vehicle.vehicle_id
JOIN 
    vehicle_owner ON vehicle.vehicle_owner_id = vehicle_owner.vehicle_owner_id
JOIN 
    user ON vehicle_owner.user_id = user.user_id
JOIN 
    Parking_Lot ON parking_slot.parking_lot_id = Parking_Lot.parking_lot_id
JOIN 
    payment ON booking.payment_id = payment.payment_id
LEFT JOIN 
    membership ON user.user_id = membership.user_id
WHERE 
    parking_slot.parking_slot_status = 1  -- Only occupied parking slots
ORDER BY 
    parking_slot.parking_slot_location ASC;


-- Query 2: To Calculate Revenue and Violations per Parking Lot
SELECT 
    Parking_Lot.parking_lot_id,
    Parking_Lot.address AS parking_lot_address,
    Parking_Lot.zone AS parking_zone,
    COUNT(Parking_Violation.violation_id) AS total_violations,
    SUM(payment.amount_paid) AS total_revenue,
    COUNT(payment.payment_id) AS total_payments,
    ROUND(AVG(payment.amount_paid), 2) AS avg_payment_amount
FROM 
    Parking_Lot
LEFT JOIN 
    parking_slot ON Parking_Lot.parking_lot_id = parking_slot.parking_lot_id
LEFT JOIN 
    booking ON parking_slot.booking_id = booking.booking_id
LEFT JOIN 
    payment ON booking.payment_id = payment.payment_id
LEFT JOIN 
    Parking_Violation ON Parking_Violation.vehicle_id = booking.vehicle_id
GROUP BY 
    Parking_Lot.parking_lot_id, Parking_Lot.address, Parking_Lot.zone
ORDER BY 
    total_revenue DESC;


-- Query 3: Vehicle Owners with the Highest Parking Violations
SELECT 
    vo.vehicle_owner_name,
    vo.user_id,
    COUNT(pv.violation_id) AS total_violations
FROM 
    vehicle_owner vo
JOIN 
    vehicle v ON vo.vehicle_owner_id = v.vehicle_owner_id
LEFT JOIN 
    Parking_Violation pv ON v.vehicle_id = pv.vehicle_id
GROUP BY 
    vo.vehicle_owner_name, vo.user_id
HAVING 
    total_violations > 3  -- Only show owners with more than 3 violations
ORDER BY 
    total_violations DESC;


-- Query 4: Count of Vehicles by Category
SELECT 
    vc.vehicle_category_name,
    COUNT(v.vehicle_id) AS total_vehicles
FROM 
    vehicle v
JOIN 
    vehicle_category vc ON v.vehicle_category_id = vc.vehicle_category_id
GROUP BY 
    vc.vehicle_category_name
ORDER BY 
    total_vehicles DESC;


-- Query 5: Find the least used parking lot
SELECT 
    Parking_Lot.parking_lot_id,
    Parking_Lot.address,
    COUNT(parking_slot.parking_slot_id) AS total_bookings
FROM 
    Parking_Lot
    LEFT JOIN parking_slot ON Parking_Lot.parking_lot_id = parking_slot.parking_lot_id
GROUP BY 
    Parking_Lot.parking_lot_id, Parking_Lot.address
ORDER BY 
    total_bookings ASC
LIMIT 1;


-- Query 6: Find the top 3 vehicle owners with the highest total amount paid, along with their total amount paid
SELECT 
    vehicle_owner.vehicle_owner_name, 
    SUM(payment.amount_paid) AS total_amount_paid
FROM 
    vehicle_owner
    INNER JOIN booking ON vehicle_owner.vehicle_owner_id = booking.vehicle_owner_id
    INNER JOIN payment ON booking.payment_id = payment.payment_id
GROUP BY 
    vehicle_owner.vehicle_owner_name
ORDER BY 
    total_amount_paid DESC
LIMIT 3;    


-- Query 7: To Find Available Parking Slots by Category and Occupancy Status
SELECT vc.vehicle_category_name,
       SUM(CASE WHEN ps.parking_slot_status = 0 THEN 1 ELSE 0 END) AS available_slots,
       SUM(CASE WHEN ps.parking_slot_status = 1 THEN 1 ELSE 0 END) AS occupied_slots
FROM parking_slot ps
JOIN vehicle v ON ps.user_id = v.user_id
JOIN vehicle_category vc ON v.vehicle_category_id = vc.vehicle_category_id
GROUP BY vc.vehicle_category_name;


-- Query 8: To Retrieve Most Frequent Users of Parking Slots
SELECT u.user_id,
       u.username,
       COUNT(ps.parking_slot_id) AS total_parking_events
FROM user u
JOIN vehicle v ON u.user_id = v.user_id
JOIN parking_slot ps ON v.vehicle_id = ps.parking_slot_id
GROUP BY u.user_id, u.username
ORDER BY total_parking_events DESC
LIMIT 10;

    
-- Query 9: For User Behavior and Vehicle Type Analysis
SELECT  
	u.user_id,  
	u.fullname,  
	COUNT(DISTINCT v.vehicle_id) AS owned_vehicles,  
	COUNT(DISTINCT b.booking_id) AS total_bookings,  
	AVG(cf.rating) AS avg_feedback_rating  
FROM  
    user u  
JOIN user_group ug ON u.user_group_id = ug.user_group_id  
LEFT JOIN vehicle_owner vo ON u.user_id = vo.user_id  
LEFT JOIN vehicle v ON vo.vehicle_owner_id = v.vehicle_owner_id  
LEFT JOIN booking b ON vo.vehicle_owner_id = b.vehicle_owner_id  
LEFT JOIN Customer_Feedback cf ON u.user_id = cf.user_id  
WHERE  
    ug.group_name = 'Customer'  
GROUP BY  
    u.user_id  
HAVING  
    total_bookings > 0  
ORDER BY  
    total_bookings DESC, avg_feedback_rating DESC;

    
-- Query 10: Security Incidents with Parking Lot Details
SELECT si.incident_id, si.description, si.date_time, si.reported_by,
       pl.address, pl.zone
FROM Security_Incident si
JOIN Parking_Lot pl ON si.parking_lot_id = pl.parking_lot_id
LIMIT 10;


-- Query 11: Employee Shifts with Performance Metrics
SELECT es.shift_id, es.shift_start, es.shift_end,
       e.employee_name, e.job_title, e.hire_date
FROM Employee_Shift es
JOIN employee e ON es.employee_id = e.employee_id
LIMIT 10;


-- Query 12: Vehicle Owners with Frequent Violations and Their Booking History
-- This query identifies vehicle owners with multiple parking violations and provides their booking history
SELECT 
    vo.vehicle_owner_id,
    vo.vehicle_owner_name,
    COUNT(DISTINCT pv.violation_id) AS violation_count,
    GROUP_CONCAT(DISTINCT pv.violation_type) AS violation_types,
    SUM(pv.fine_amount) AS total_fines,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    AVG(p.amount_paid) AS average_payment
FROM 
    vehicle_owner vo
JOIN 
    vehicle v ON vo.vehicle_owner_id = v.vehicle_owner_id
LEFT JOIN 
    Parking_Violation pv ON v.vehicle_id = pv.vehicle_id
LEFT JOIN 
    booking b ON vo.vehicle_owner_id = b.vehicle_owner_id
LEFT JOIN 
    payment p ON b.payment_id = p.payment_id
GROUP BY 
    vo.vehicle_owner_id, vo.vehicle_owner_name
HAVING 
    violation_count > 1
ORDER BY 
    violation_count DESC, total_fines DESC
LIMIT 10;

    
-- Query 13: Parking Lot Utilization and Revenue Analysis
-- This query analyzes the utilization and revenue of parking lots, including violation data
SELECT 
    pl.parking_lot_id,
    pl.address,
    pl.zone,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    AVG(p.amount_paid) AS average_payment,
    SUM(p.amount_paid) AS total_revenue,
    COUNT(DISTINCT pv.violation_id) AS violation_count,
    SUM(pv.fine_amount) AS total_fines,
    (pl.total_slots - pl.available_slots) / pl.total_slots * 100 AS occupancy_rate,
    AVG(cf.rating) AS average_rating
FROM 
    Parking_Lot pl
LEFT JOIN 
    parking_slot ps ON pl.parking_lot_id = ps.parking_lot_id
LEFT JOIN 
    booking b ON ps.booking_id = b.booking_id
LEFT JOIN 
    payment p ON b.payment_id = p.payment_id
LEFT JOIN 
    vehicle v ON b.vehicle_id = v.vehicle_id
LEFT JOIN 
    Parking_Violation pv ON v.vehicle_id = pv.vehicle_id
LEFT JOIN 
    Customer_Feedback cf ON b.vehicle_owner_id = cf.user_id
GROUP BY 
    pl.parking_lot_id, pl.address, pl.zone, pl.total_slots, pl.available_slots
HAVING 
    total_bookings > 0
ORDER BY 
    total_revenue DESC, occupancy_rate DESC
LIMIT 10;    


-- Stored procedure
-- 1. CalculateMembershipDiscount
/* CalculateMembershipDiscount - This procedure calculates the final membership discount rate 
based on the user's membership status. */
 
DELIMITER //
 
CREATE PROCEDURE CalculateMembershipDiscount(
    IN p_user_id INT,
    OUT p_final_rate DECIMAL(10, 2)
)
-- This procedure calculates the final membership discount rate based on the user's membership status.
-- It checks if the user has an active membership, retrieves the discount based on the membership type, 
-- and applies it to a standard rate. If the user does not have an active membership, the standard rate is applied.
BEGIN
    DECLARE pricing_id INT;
    DECLARE discount_percentage DECIMAL(5, 2);
    DECLARE standard_rate DECIMAL(10, 2);
 
    -- Set the standard price for non-members
    SET standard_rate = 300.00;
 
    -- Check if the user has an active membership
    IF EXISTS (
        SELECT 1
        FROM membership M
        WHERE M.user_id = p_user_id AND M.member_status = 'active'
    ) THEN
        -- Get the pricing_id for the user
        SELECT M.pricing_id
        INTO pricing_id
        FROM membership M
        WHERE M.user_id = p_user_id AND M.member_status = 'active';
 
        -- Set the discount percentage based on pricing_id
        CASE pricing_id
            WHEN 1 THEN SET discount_percentage = 0.30; -- Basic (30% discount)
            WHEN 2 THEN SET discount_percentage = 0.40; -- Premium (40% discount)
            WHEN 3 THEN SET discount_percentage = 0.50; -- VIP (50% discount)
            WHEN 4 THEN SET discount_percentage = 0.60; -- Corporate (60% discount)
            ELSE SET discount_percentage = 0;           -- No discount if no valid pricing_id
        END CASE;
 
        -- Calculate the discounted rate from the standard rate
        SET p_final_rate = standard_rate * (1 - discount_percentage);
 
        -- Return user_id and the final discounted rate directly
        SELECT p_user_id AS user_id, p_final_rate AS final_rate;
 
    ELSE
        -- If no active membership, set the rate to standard price
        SET p_final_rate = standard_rate;
 
        -- Return user_id and the standard rate directly
        SELECT p_user_id AS user_id, p_final_rate AS final_rate;
    END IF;
 
END //
 
DELIMITER ;
 
CALL CalculateMembershipDiscount(3, @final_rate);
 
 
2. CalculateParkingAvailability 
/* CalculateParkingAvailability- This procedure calculates the number of available parking slots, 
filled parking slots, and available charging stations for a given parking lot. */
 
DELIMITER //
 
CREATE PROCEDURE CalculateParkingAvailability( 
    IN ParkingLotID INT, 
    OUT AvailableSlots INT, 
    OUT FilledSlots INT, 
    OUT AvailableChargingStations INT
)
-- This procedure calculates the number of available parking slots, filled parking slots, 
-- and available charging stations for a given parking lot.
BEGIN
 
    -- Get available slots for the specific parking lot
    SELECT available_slots INTO AvailableSlots
    FROM parking_lot
    WHERE parking_lot_id = ParkingLotID;
 
    -- Calculate filled slots for the specific parking lot
    SELECT (total_slots - available_slots) INTO FilledSlots
    FROM parking_lot
    WHERE parking_lot_id = ParkingLotID;
 
    -- Calculate available charging stations for the specific parking lot
    SELECT COUNT(*) INTO AvailableChargingStations
    FROM Charging_Station
    WHERE parking_lot_id = ParkingLotID
      AND status = 'Available';
 
    -- Return the parking lot ID along with the calculated details
    SELECT ParkingLotID AS parking_lot_id, 
           AvailableSlots, 
           FilledSlots, 
           AvailableChargingStations;
 
END//
 
DELIMITER ;
 
CALL CalculateParkingAvailability(30, @AvailableSlots, @FilledSlots, @AvailableChargingStations);
 
 
-- 3. CheckParkingViolations
/* CheckParkingViolations - This stored procedure checks the number of parking violations for a given vehicle. 
If the vehicle has more than 3 violations, it bans the vehicle from parking; otherwise, it returns the count of violations. */
 
DELIMITER //
 
CREATE PROCEDURE CheckParkingViolations(IN vehicle_id_param INT)
BEGIN
    DECLARE violation_count INT;
 
    -- Calculate the number of violations for the given vehicle
    SELECT COUNT(*) INTO violation_count
    FROM parking_violation
    WHERE vehicle_id = vehicle_id_param;  -- Use the correct input parameter name
 
    -- Check if the vehicle has exceeded the violation limit (3 violations)
    IF violation_count > 3 THEN
        -- Vehicle is banned due to excessive violations
        SELECT CONCAT('Vehicle ID ', vehicle_id_param, ' is banned from parking due to ', violation_count, ' excessive violation(s).') AS ban_status;
    ELSE
        -- Vehicle has fewer violations, not banned
        SELECT CONCAT('Vehicle ID ', vehicle_id_param, ' has ', violation_count, ' violation(s) and is not banned.') AS violation_status;
    END IF;
END //
 
DELIMITER ;
 
Call CheckParkingViolations(1);


-- Functions
-- Function 1: To see available Parking slots
DELIMITER //
CREATE FUNCTION AvailableParkingSlots(ParkingLotID INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE TotalSlots INT;
    DECLARE OccupiedSlots INT;
    SELECT total_slots INTO TotalSlots
    FROM Parking_Lot
    WHERE parking_lot_id = ParkingLotID;
    SELECT COUNT(*) INTO OccupiedSlots
    FROM parking_slot
    WHERE parking_lot_id = ParkingLotID
      AND parking_slot_status = 1;
    RETURN TotalSlots - OccupiedSlots;
END//
DELIMITER ;

Select AvailableParkingSlots(1);


-- Function 2: Function to identify the memebership status of a person 
DELIMITER //
CREATE FUNCTION GetMembershipStatus (UserID INT)
RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE Status VARCHAR(20);
    SELECT member_status INTO Status
    FROM membership
    WHERE user_id = UserID;
    RETURN Status;
END//
DELIMITER ;
 
Select GetMembershipStatus(2);


-- Function 3: Function to assign an empty parking slot to a person 
DELIMITER //
CREATE FUNCTION AssignParkingSlot (ParkingLotID INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE AvailableSlot INT;
    SELECT parking_slot_id INTO AvailableSlot
    FROM parking_slot
    WHERE parking_lot_id = ParkingLotID
      AND parking_slot_status = 0 
    LIMIT 1;
  RETURN AvailableSlot;
END//
DELIMITER ;

Select AssignParkingSlot(1);


-- Triggers
-- Trigger1: To prevent duplicate vehicle numbers
DELIMITER $$
CREATE TRIGGER before_vehicle_insert 
BEFORE INSERT ON vehicle FOR EACH ROW 
BEGIN 
IF EXISTS (SELECT 1 FROM vehicle WHERE vehicle_number = NEW.vehicle_number) THEN        
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vehicle number already exists!';     
END IF; 
END$$ 
DELIMITER ;

-- INSERT INTO VEHICLE VALUE (2, 2, 'XYZ5678', 2, 5);


-- Trigger2: Update available parking spaces when when there is a new reservation
DELIMITER //
CREATE TRIGGER UpdateAvailableSpaces
AFTER INSERT ON booking
FOR EACH ROW
BEGIN
  UPDATE Parking_lot
  SET available_slots = available_slots - 1
  WHERE parking_lot_id = (SELECT parking_lot_id FROM parking_slot WHERE booking_id = NEW.booking_id);
END//
DELIMITER ;


-- Trigger3 : Mark the parking space as available when a customer checks out and updates the available spots in the lot
DELIMITER //
CREATE TRIGGER FreeUpSpace
AFTER INSERT ON parking_slot
FOR EACH ROW
BEGIN
  IF NEW.parking_slot_status = 0 THEN
    UPDATE Parking_lot
    SET available_slots = available_slots + 1
    WHERE parking_lot_id = NEW.parking_lot_id;
  END IF;
END//
DELIMITER ;


-- Trigger4: To make sure the user choose a unique username
DELIMITER //
CREATE TRIGGER UniqueUserName
AFTER INSERT ON user
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM user WHERE username = NEW.username) THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Username already exists. Please choose a different username.';
  END IF;
END //
DELIMITER ;
