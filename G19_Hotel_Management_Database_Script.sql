DROP TABLE "GuestPhones";
DROP TABLE "GuestEmails";
DROP TABLE "BookingRooms";
DROP TABLE "BookingGuests";
DROP TABLE "StaffRooms";
DROP TABLE "StaffPhones";
DROP TABLE "StaffEmails";
DROP TABLE "Supplies";
DROP TABLE "Bill";
DROP TABLE "Order";
DROP TABLE "DiningReservation";
DROP TABLE "Room";
DROP TABLE "RoomType";
DROP TABLE "Booking";
DROP TABLE "Staff";
DROP TABLE "Hotel";
DROP TABLE "Guest";

alter session set nls_language='ENGLISH';
alter session set nls_date_format='DD-MON-YYYY';

CREATE TABLE "Hotel"
(
    hotelID         NUMBER(10) NOT NULL,
    name            VARCHAR2(30),
    phone           NUMBER(12) UNIQUE,
    email           VARCHAR2(50),
    country         VARCHAR2(20),
    city            VARCHAR2(20),
    street          VARCHAR2(20),
    postCode        NUMBER(5),
    PRIMARY KEY (hotelID)
);

CREATE TABLE "Guest"
(
    guestID         NUMBER(10) NOT NULL,
    firstName       VARCHAR2(15),
    lastName        VARCHAR2(15),
    dateOfBirth     date,
    country         VARCHAR2(20),
    city            VARCHAR2(20),
    street          VARCHAR2(20),
    postCode        NUMBER(5),
    PRIMARY KEY (guestID)
);

CREATE TABLE "GuestPhones"
(
    guestID         NUMBER(10) NOT NULL,
    phone           NUMBER(12) NOT NULL,
    PRIMARY KEY (guestID, phone),
    FOREIGN KEY (guestID) REFERENCES "Guest"(guestID) ON DELETE CASCADE 
);

CREATE TABLE "GuestEmails"
(
    guestID         NUMBER(10) NOT NULL,
    email           VARCHAR2(50) NOT NULL,
    PRIMARY KEY (guestID, email),
    FOREIGN KEY (guestID) REFERENCES "Guest"(guestID) ON DELETE CASCADE
);

CREATE TABLE "RoomType"
(
    roomTypeID      NUMBER(10) NOT NULL,
    name            VARCHAR2(50), 
    capacity        NUMBER(8),
    description     VARCHAR2(255),
    pricePerDay     NUMBER(10, 2),
    PRIMARY KEY (roomTypeID)
);

CREATE TABLE "Room"
(
    roomID          NUMBER(10) NOT NULL,
    hotelID         NUMBER(10) NOT NULL,
    roomTypeID      NUMBER(10) NOT NULL,
    status          VARCHAR2(20),
    PRIMARY KEY (roomID),
    FOREIGN KEY (hotelID) REFERENCES "Hotel"(hotelID) ON DELETE CASCADE,
    FOREIGN KEY (roomTypeID) REFERENCES "RoomType"(roomTypeID) ON DELETE CASCADE
);

CREATE TABLE "Booking"
(   
    bookingID       NUMBER(10) NOT NULL,
    checkinDate     DATE,
    checkoutDate    DATE,
    bookingDate     DATE,
    status          VARCHAR2(20),
    PRIMARY KEY (bookingID)
);

CREATE TABLE "BookingRooms"
(
    bookingID       NUMBER(10) NOT NULL,
    roomID          NUMBER(10) NOT NULL,
    PRIMARY KEY (bookingID, roomID),
    FOREIGN KEY (bookingID) REFERENCES "Booking"(bookingID) ON DELETE CASCADE,
    FOREIGN KEY (roomID) REFERENCES "Room"(roomID) ON DELETE CASCADE
);

CREATE TABLE "BookingGuests"
(
    bookingID       NUMBER(10) NOT NULL,
    guestID         NUMBER(10) NOT NULL,
    PRIMARY KEY (bookingID, guestID),
    FOREIGN KEY (bookingID) REFERENCES "Booking"(bookingID) ON DELETE CASCADE,
    FOREIGN KEY (guestID) REFERENCES "Guest"(guestID) ON DELETE CASCADE
);

CREATE TABLE "Staff"
(
    staffID         NUMBER(10) NOT NULL,
    hotelID         NUMBER(10) NOT NULL,
    firstName       VARCHAR2(15),
    lastName        VARCHAR2(15),
    salary          NUMBER(10, 2),
    position        VARCHAR2(25),
    dateOfBirth     DATE,
    hireDate        DATE,
    country         VARCHAR2(20),
    city            VARCHAR2(20),
    street          VARCHAR2(20),
    postCode        NUMBER(5),
    FOREIGN KEY (hotelID) REFERENCES "Hotel"(hotelID) ON DELETE CASCADE,
    PRIMARY KEY (staffID)
);

CREATE TABLE "StaffRooms"
(
    staffID         NUMBER(10) NOT NULL,
    roomID          NUMBER(10) NOT NULL,
    FOREIGN KEY (staffID) REFERENCES "Staff"(staffID) ON DELETE CASCADE,
    FOREIGN KEY (roomID) REFERENCES "Room"(roomID) ON DELETE CASCADE,
    PRIMARY KEY (staffID, roomID)
);

CREATE TABLE "StaffPhones"
(
    staffID         NUMBER(10) NOT NULL,
    phone           NUMBER(12) NOT NULL,
    FOREIGN KEY (staffID) REFERENCES "Staff"(staffID) ON DELETE CASCADE,
    PRIMARY KEY (staffID, phone)
);

CREATE TABLE "StaffEmails"
(
    staffID         NUMBER(10) NOT NULL,
    email           VARCHAR2(50) NOT NULL,
    FOREIGN KEY (staffID) REFERENCES "Staff"(staffID) ON DELETE CASCADE,
    PRIMARY KEY (staffID, email)
);

CREATE TABLE "Supplies"
(
    supplyID        NUMBER(10) NOT NULL,
    hotelID         NUMBER(10) NOT NULL,
    name            VARCHAR2(50),
    status          VARCHAR2(4),
    FOREIGN KEY (hotelID) REFERENCES "Hotel"(hotelID) ON DELETE CASCADE,
    PRIMARY KEY (supplyID)
);

CREATE TABLE "Bill"
(
    billID          NUMBER(10) NOT NULL,
    bookingID       NUMBER(10) NOT NULL,
    charge          NUMBER(10,2),
    billDate        DATE,
    FOREIGN KEY (bookingID) REFERENCES "Booking"(bookingID) ON DELETE CASCADE,
    PRIMARY KEY (billID)  
);

CREATE TABLE "Order"
(
    orderID         NUMBER(10) NOT NULL,
    guestID         NUMBER(10) NOT NULL,
    billID          NUMBER(10) NOT NULL,
    name            VARCHAR2(50),
    cost            NUMBER(10,2),
    orderDate       DATE,
    FOREIGN KEY (guestID) REFERENCES "Guest"(guestID) ON DELETE CASCADE,
    PRIMARY KEY (orderID)
);

CREATE TABLE "DiningReservation"
(
    reservationID       NUMBER(10) NOT NULL,
    guestID             NUMBER(10) NOT NULL,
    guestNumber         NUMBER(10),
    type                VARCHAR2(20),
    reservationTime     timestamp,
    serviceTime         timestamp,
    FOREIGN KEY (guestID) REFERENCES "Guest"(guestID) ON DELETE CASCADE,
    PRIMARY KEY (reservationID)
);

ALTER TABLE "DiningReservation" add constraint dining_reservation_acceptance_constraint CHECK (reservationTime < serviceTime);
ALTER TABLE "Booking" add constraint booking_checkin_date_checkout_date_constraint CHECK (checkinDate < checkoutDate);
ALTER TABLE "Booking" add constraint booking_booking_date_checkin_date_constraint CHECK (bookingDate < checkinDate);

--- Create Hotels
INSERT  INTO "Hotel" VALUES(1, 'EGE INCISI', 01234567890, 'egeincisi@gmail.com', 'turkey', 'mugla', 'marmaris', 48700);
INSERT  INTO "Hotel" VALUES(2, 'FOCA SUITS', 02345678901, 'focasuits@gmail.com', 'turkey', 'izmir', 'foca', 35680);


--- Create Guests
INSERT INTO "Guest" VALUES(1,'Asli', 'Sütçüoğlu', '12-SEP-1976', 'USA', 'NewYork', 'StreetA', 10012);
INSERT INTO "Guest" VALUES(2,'Cem', 'Onaran', '20-JAN-1972', 'USA', 'NewYork', 'StreetA', 10012);
INSERT INTO "Guest" VALUES(3,'Fatoş', 'Akin', '05-OCT-1965', 'France', 'Bordeaux', 'StreetB', 33300);
INSERT INTO "Guest" VALUES(4,'Tanriverdi', 'Ekşioğullari', '13-DEC-1984', 'France', 'Lyon', 'StreetC', 69006);
INSERT INTO "Guest" VALUES(5,'Şahika', 'Koçarslanli', '06-AUG-1973', 'Turkey', 'Istanbul', 'NisantasiCaddesi', 34360);
INSERT INTO "Guest" VALUES(6,'Şehsuvar', 'Kementoğlu', '23-MAR-1974', 'Russia', 'StPetersburg', 'StreetD', 88502);
INSERT INTO "Guest" VALUES(7,'Victoria', 'Henesey', '16-JUL-1979', 'Italia', 'Milano', 'StreetE', 20026);
INSERT INTO "Guest" VALUES(8,'Bülent', 'Onaran', '17-MAY-1952', 'Belgium', 'Brussels', 'StreetF', 01110);


---Creating GuestPhones
INSERT INTO "GuestPhones" VALUES(1, 905070000011);
INSERT INTO "GuestPhones" VALUES(2, 905320000022);
INSERT INTO "GuestPhones" VALUES(3, 905410000033);
INSERT INTO "GuestPhones" VALUES(4, 905340000044);
INSERT INTO "GuestPhones" VALUES(5, 905060000055);
INSERT INTO "GuestPhones" VALUES(6, 905310000066);
INSERT INTO "GuestPhones" VALUES(7, 905320000077);
INSERT INTO "GuestPhones" VALUES(8, 905340000088);
INSERT INTO "GuestPhones" VALUES(6, 905060000666);


---Creating GuestEmails
INSERT INTO "GuestEmails" VALUES(1, 'aslisutc@gmail.com');
INSERT INTO "GuestEmails" VALUES(2, 'cemnrn@gmail.com');
INSERT INTO "GuestEmails" VALUES(3, 'fatos@gmail.com');
INSERT INTO "GuestEmails" VALUES(4, 'tanrvrdeksi@gmail.com');
INSERT INTO "GuestEmails" VALUES(5, 'sahikakoc@gmail.com');
INSERT INTO "GuestEmails" VALUES(6, 'sesukemento@gmail.com');
INSERT INTO "GuestEmails" VALUES(7, 'victoriahnsy@gmail.com');
INSERT INTO "GuestEmails" VALUES(8, 'diplomatbulent@gmail.com');
INSERT INTO "GuestEmails" VALUES(1, 'asliii@hotmail.com');
INSERT INTO "GuestEmails" VALUES(2, 'cemnonaran33@hotmail.com');
INSERT INTO "GuestEmails" VALUES(3, 'akinfatos@hotmail.com');

---Creating RoomType
INSERT INTO "RoomType" VALUES(01, 'st1', 2, 'standart room for 2', 1000);
INSERT INTO "RoomType" VALUES(02, 'st2', 3, 'standart room for 3', 1500);
INSERT INTO "RoomType" VALUES(03, 'fam', 4, 'family room for 4', 2000);
INSERT INTO "RoomType" VALUES(05, 'suit2', 2, 'suit room for 2', 3000);
INSERT INTO "RoomType" VALUES(06, 'suit3', 3, 'suit room for 3', 4500);
INSERT INTO "RoomType" VALUES(07, 'suit4', 4, 'suit room for 4', 6000);
INSERT INTO "RoomType" VALUES(08, 'honeym1', 2, 'honeymoon room for 2', 5000);
INSERT INTO "RoomType" VALUES(09, 'honeym2', 2, 'honeymoon suit room for 2', 9000);


---Creating Room
INSERT INTO "Room" VALUES(101, 1, 01, 'available');			
INSERT INTO "Room" VALUES(102, 1, 02, 'available');
INSERT INTO "Room" VALUES(103, 1, 02, 'available');
INSERT INTO "Room" VALUES(104, 1, 07, 'available');
INSERT INTO "Room" VALUES(105, 1, 03, 'available');
INSERT INTO "Room" VALUES(106, 1, 08, 'available');
INSERT INTO "Room" VALUES(107, 1, 06, 'available');
INSERT INTO "Room" VALUES(108, 1, 05, 'available');
INSERT INTO "Room" VALUES(109, 1, 05, 'available');
INSERT INTO "Room" VALUES(110, 1, 09, 'available');

INSERT INTO "Room" VALUES(201, 2, 01, 'available');
INSERT INTO "Room" VALUES(202, 2, 01, 'available');
INSERT INTO "Room" VALUES(203, 2, 05, 'available');
INSERT INTO "Room" VALUES(204, 2, 07, 'available');
INSERT INTO "Room" VALUES(205, 2, 05, 'available');
INSERT INTO "Room" VALUES(206, 2, 08, 'available');
INSERT INTO "Room" VALUES(207, 2, 03, 'available');
INSERT INTO "Room" VALUES(208, 2, 06, 'available');
INSERT INTO "Room" VALUES(209, 2, 02, 'available');
INSERT INTO "Room" VALUES(210, 2, 09, 'available');


---Creating Booking
INSERT INTO "Booking" VALUES(1, '06-JAN-2017', '16-JAN-2017', '24-DEC-2016', 'approved');
INSERT INTO "Booking" VALUES(2, '03-JAN-2017', '16-JAN-2017', '21-DEC-2016', 'approved');
INSERT INTO "Booking" VALUES(3, '06-JAN-2017', '10-JAN-2017', '22-DEC-2016', 'approved');
INSERT INTO "Booking" VALUES(4, '12-JUN-2014', '12-JUL-2014', '04-APR-2014', 'approved');
INSERT INTO "Booking" VALUES(5, '20-JUN-2014', '02-JUL-2014', '15-MAY-2014', 'approved');
INSERT INTO "Booking" VALUES(6, '10-JUL-2014', '17-JUL-2014', '30-JUN-2014', 'approved');


---Creating BookingRooms
INSERT INTO "BookingRooms" VALUES(1, 101);
INSERT INTO "BookingRooms" VALUES(2, 105);
INSERT INTO "BookingRooms" VALUES(3, 103);
INSERT INTO "BookingRooms" VALUES(4, 203);
INSERT INTO "BookingRooms" VALUES(5, 202);
INSERT INTO "BookingRooms" VALUES(6, 205);


---Creating BookingGuests
INSERT INTO "BookingGuests" VALUES(1, 1);
INSERT INTO "BookingGuests" VALUES(1, 2);
INSERT INTO "BookingGuests" VALUES(2, 4);
INSERT INTO "BookingGuests" VALUES(3, 6);
INSERT INTO "BookingGuests" VALUES(4, 8);
INSERT INTO "BookingGuests" VALUES(5, 7);
INSERT INTO "BookingGuests" VALUES(6, 5);

---Creating Staff
INSERT  INTO "Staff" VALUES(01, 1,'Gaffur', 'Aksoy', 15000, 'Housekeeper', '06-JUN-1974', '03-JUN-2005', 'Turkey', 'Istanbul','NisantasiCaddesi', 34360);
INSERT  INTO "Staff" VALUES(02, 1, 'Hediye', 'Aksoy', 15000, 'Security', '14-FEB-1954', '09-APR-2002', 'Turkey', 'Istanbul', 'NisantasiCaddesi', 34360);
INSERT  INTO "Staff" VALUES(03, 1, 'Dursun', 'Tepe', 25000, 'Receptionist', '10-DEC-1973', '12-JAN-2002', 'Turkey', 'Trabzon', 'Of', 61530);
INSERT  INTO "Staff" VALUES(04, 2, 'Bora', 'Alsancak', 20000, 'Housekeeper', '03-JUN-1986', '22-NOV-2008', 'Turkey', 'İzmir', 'Karsiyaka', 35600);
INSERT  INTO "Staff" VALUES(05, 2, 'Deniz', 'Alsancak', 20000, 'Receptionist', '16-OCT-1981', '22-NOV-2008', 'Turkey', 'İzmir', 'Karsiyaka', 35600);
INSERT  INTO "Staff" VALUES(06, 2, 'Katya', 'Ünal', 17000,  'Receptionist', '14-MAY-1986', '02-NOV-2005', 'Turkey', 'İzmir', 'Aliağa', 35800);
INSERT  INTO "Staff" VALUES(07, 2, 'Serbest', 'Mermer', 15000, 'Security', '28-JUN-1983', '13-SEP-2008', 'Ukraine', 'Odessa', 'Kodyma', 66000);
INSERT  INTO "Staff" VALUES(08, 2, 'Zafer', 'Mermer', 15000, 'Housekeeper', '29-DEC-1985', '13-SEP-2008', 'Ukraine', 'Odessa', 'Kodyma', 66000);

---Creating StaffRooms
INSERT INTO "StaffRooms" VALUES(01, 101);
INSERT INTO "StaffRooms" VALUES(01, 102);
INSERT INTO "StaffRooms" VALUES(01, 103);
INSERT INTO "StaffRooms" VALUES(01, 104);
INSERT INTO "StaffRooms" VALUES(01, 105);
INSERT INTO "StaffRooms" VALUES(01, 106);
INSERT INTO "StaffRooms" VALUES(01, 107);
INSERT INTO "StaffRooms" VALUES(01, 108);
INSERT INTO "StaffRooms" VALUES(01, 109);
INSERT INTO "StaffRooms" VALUES(01, 110);
INSERT INTO "StaffRooms" VALUES(04, 201);
INSERT INTO "StaffRooms" VALUES(04, 202);
INSERT INTO "StaffRooms" VALUES(04, 203);
INSERT INTO "StaffRooms" VALUES(04, 204);
INSERT INTO "StaffRooms" VALUES(04, 205);
INSERT INTO "StaffRooms" VALUES(08, 206);
INSERT INTO "StaffRooms" VALUES(08, 207);
INSERT INTO "StaffRooms" VALUES(08, 208);
INSERT INTO "StaffRooms" VALUES(08, 209);
INSERT INTO "StaffRooms" VALUES(08, 210);


---Creating StaffPhones
INSERT INTO "StaffPhones" VALUES(01, 905160283550);
INSERT INTO "StaffPhones" VALUES(02, 905160283550);
INSERT INTO "StaffPhones" VALUES(03, 905410000001);
INSERT INTO "StaffPhones" VALUES(04, 905413300001);
INSERT INTO "StaffPhones" VALUES(05, 905413322001);
INSERT INTO "StaffPhones" VALUES(06, 905413300013);
INSERT INTO "StaffPhones" VALUES(07, 905413300555);
INSERT INTO "StaffPhones" VALUES(08, 905413770555);

---Creating StaffEmails
INSERT INTO "StaffEmails" VALUES(01, 'gaffurksu@gmail.com');
INSERT INTO "StaffEmails" VALUES(02, 'hediyeksu@gmail.com');
INSERT INTO "StaffEmails" VALUES(03, 'dursun@gmail.com');
INSERT INTO "StaffEmails" VALUES(04, 'boralsnck@gmail.com');
INSERT INTO "StaffEmails" VALUES(05, 'denizlsnck@gmail.com');
INSERT INTO "StaffEmails" VALUES(06, 'katiaunal@gmail.com');
INSERT INTO "StaffEmails" VALUES(06, 'katiadimitri@mail.ru');
INSERT INTO "StaffEmails" VALUES(07, 'mermerserbest@gmail.com');
INSERT INTO "StaffEmails" VALUES(08, 'mermerzafer@gmail.com');

---Creating Supplies
INSERT INTO "Supplies" VALUES(1, 1, 'toiletries', '20%');
INSERT INTO "Supplies" VALUES(2, 2, 'cleaning equipment', '38%');
INSERT INTO "Supplies" VALUES(3, 2, 'toiletries', '12%');
INSERT INTO "Supplies" VALUES(4, 1, 'shampoo', '45%');
INSERT INTO "Supplies" VALUES(5, 1, 'food', '30%');

---Creating Bill
INSERT INTO "Bill" VALUES(1, 5, 10000, '02-JUL-2014');		
INSERT INTO "Bill" VALUES(2, 1, 5500, '16-JAN-2017');		
INSERT INTO "Bill" VALUES(3, 4, 6250, '12-JUL-2014');		
INSERT INTO "Bill" VALUES(4, 3, 7500, '10-JAN-2017');		
INSERT INTO "Bill" VALUES(5, 6, 3035, '17-JUL-2014');		
INSERT INTO "Bill" VALUES(6, 2, 8200, '16-JAN-2017');		


---Creating Order
INSERT INTO "Order" VALUES(1, 8, 3, 'fruit juice', 20, '19-JUN-2014');
INSERT INTO "Order" VALUES(2, 4, 6, 'sandwich', 75, '13-JAN-2017');
INSERT INTO "Order" VALUES(3, 7, 1, 'water', 20, '23-JUN-2014');
INSERT INTO "Order" VALUES(4, 8, 3, 'sandwich', 75, '1-JUL-2014');
INSERT INTO "Order" VALUES(5, 1, 2, 'dessert', 35, '16-JAN-2017');
INSERT INTO "Order" VALUES(6, 5, 5, 'drink', 100, '11-JUL-2014');


---Creating DiningReservation				
INSERT INTO "DiningReservation" VALUES(1, 1, 2, 'Breakfast', TO_TIMESTAMP('2023-02-18 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-02-18 08:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO "DiningReservation" VALUES(2, 4, 3, 'Dinner', TO_TIMESTAMP('2023-01-10 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-01-10 20:00:00', 'YYYY-MM-DD HH24:MI:SS'));


