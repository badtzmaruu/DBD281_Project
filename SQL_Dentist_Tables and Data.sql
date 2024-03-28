-- Create the Dentist database.
--Execute first and then upload tables.
CREATE DATABASE Dentist;
GO
-- Switch to Dentist database
USE Dentist;
GO
-- Create Employee_Types table
CREATE TABLE Employee_Types(
    Employee_TypeID INT NOT NULL,
    TypeName VARCHAR(50),
    PRIMARY KEY (Employee_TypeID)
);

-- Create Employees table
CREATE TABLE Employees(
    Employee_ID INT NOT NULL,
    Employee_FirstName VARCHAR(50),
    Employee_LastName VARCHAR(50),
    Employee_TypeID INT,
    IsAvailable VARCHAR(10),
    PRIMARY KEY (Employee_ID),
    FOREIGN KEY (Employee_TypeID) REFERENCES Employee_Types (Employee_TypeID)
);

-- Create Patients table
CREATE TABLE Patients(
    Patient_ID INT NOT NULL,
    Personal_ID INT,
    Patient_FirstName VARCHAR(50),
    Patient_LastName VARCHAR(50),
    Patient_DOB DATE,
    City VARCHAR(20),
    ZipCode INT,
    Phone BIGINT,
    Email VARCHAR(100),
    Remarks VARCHAR(200),
    Street VARCHAR(100),
    PRIMARY KEY (Patient_ID)
);
-- Modify the Patients table to use BIGINT for the Phone column
/*ALTER TABLE Dentist.dbo.Patients
ALTER COLUMN Phone BIGINT;*/
-- Create Rooms table
CREATE TABLE Rooms(
    Room_ID INT NOT NULL,
    RoomName VARCHAR(10),
    PRIMARY KEY (Room_ID)
);

-- Create Room_Breaks table
CREATE TABLE Room_Breaks(
    Room_BreakID INT NOT NULL,
    Room_ID INT,
    Schedule VARCHAR(100),
    PRIMARY KEY (Room_BreakID),
    FOREIGN KEY (Room_ID) REFERENCES Rooms (Room_ID)
);

-- Create Room_Bookings table
CREATE TABLE Room_Bookings(
    RoomBooking_ID INT NOT NULL,
    Room_ID INT,
    Patient_ID INT,
    Duration FLOAT,
    Status VARCHAR(20),
    DateStart DATE,
    DateEnd DATE,
    PRIMARY KEY (RoomBooking_ID),
    FOREIGN KEY (Room_ID) REFERENCES Rooms (Room_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patients (Patient_ID)
);

-- Create Appointment_Workers table
CREATE TABLE Appointment_Workers(
    Appointment_WorkerID INT NOT NULL,
    Appointment_ID INT,
    Employee_ID INT,
    PRIMARY KEY (Appointment_WorkerID),
    FOREIGN KEY (Employee_ID) REFERENCES Employees (Employee_ID)
);

-- Create Treatments table
CREATE TABLE Treatments(
    Treatment_ID INT NOT NULL,
    Treatment VARCHAR(200),
    Price NUMERIC (8,2),
    PRIMARY KEY (Treatment_ID)
);

-- Create Patient_Treatments table
CREATE TABLE Patient_Treatments(
    PatientTreatment_ID INT NOT NULL,
    Treatment_ID INT,
    Patient_ID INT,
    PRIMARY KEY (PatientTreatment_ID),
    FOREIGN KEY (Treatment_ID) REFERENCES Treatments (Treatment_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patients (Patient_ID)
);

-- Create Appointments table
CREATE TABLE Appointments(
    Appointment_ID INT NOT NULL,
    Patient_ID INT,
    Appointment_WorkerID INT,
    RoomBooking_ID INT,
    PatientTreatment_ID INT,
    Price NUMERIC(8,2),
    Diagnosis VARCHAR(200),
    Status VARCHAR(20),
    Appointment_Date DATE,
    Appointment_time VARCHAR(10),
    Next_Appointment VARCHAR(10),
    PRIMARY KEY (Appointment_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patients (Patient_ID),
    FOREIGN KEY (PatientTreatment_ID) REFERENCES Patient_Treatments (PatientTreatment_ID),
    FOREIGN KEY (Appointment_WorkerID) REFERENCES Appointment_Workers (Appointment_WorkerID),
    FOREIGN KEY (RoomBooking_ID) REFERENCES Room_Bookings (RoomBooking_ID)
);

-- Create Payment table
CREATE TABLE Payment(
    Payment_ID INT NOT NULL,
    PatientTreatment_ID INT,
    Treatment_ID INT,
    Appointment_WorkerID INT,
    Payment_Method VARCHAR(25),
    Payment_Date DATE,
    Employee_ID INT,
    Total DECIMAL (10, 2),
    PRIMARY KEY (Payment_ID),
    FOREIGN KEY (PatientTreatment_ID) REFERENCES Patient_Treatments (PatientTreatment_ID),
    FOREIGN KEY (Treatment_ID) REFERENCES Treatments (Treatment_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employees (Employee_ID)
);
GO
--------------------------------------------------------------------------------------------------------------------------
--Add data into tables:
-- Insert records into Employee_Types table
INSERT INTO Dentist.dbo.Employee_Types (Employee_TypeID, TypeName)
VALUES
    (1, 'Dentist'),
    (2, 'Dental Hygienist'),
    (3, 'Dental Assistant'),
    (4, 'Receptionist'),
    (5, 'Orthodontist'),
    (6, 'Oral Surgeon'),
    (7, 'Endodontist'),
    (8, 'Periodontist'),
    (9, 'Prosthodontist'),
    (10, 'Orthodontic Technician'),
    (11, 'Dental Lab Technician'),
    (12, 'Radiographer'),
    (13, 'Administrative Assistant'),
    (14, 'Practice Manager'),
    (15, 'IT Support');

-- Insert records into Employees table
INSERT INTO Dentist.dbo.Employees (Employee_ID, Employee_FirstName, Employee_LastName, Employee_TypeID, IsAvailable)
VALUES
    (1, 'John', 'Doe', 1, 'Yes'),
    (2, 'Jane', 'Smith', 2, 'Yes'),
    (3, 'Michael', 'Johnson', 3, 'Yes'),
    (4, 'Emily', 'Brown', 4, 'Yes'),
    (5, 'David', 'Williams', 5, 'Yes'),
    (6, 'Sarah', 'Jones', 6, 'Yes'),
    (7, 'Robert', 'Miller', 7, 'Yes'),
    (8, 'Jessica', 'Davis', 8, 'Yes'),
    (9, 'Daniel', 'Garcia', 9, 'Yes'),
    (10, 'Lisa', 'Rodriguez', 10, 'Yes'),
    (11, 'Steven', 'Martinez', 11, 'Yes'),
    (12, 'Patricia', 'Hernandez', 12, 'Yes'),
    (13, 'Christopher', 'Lopez', 13, 'Yes'),
    (14, 'Mary', 'Gonzalez', 14, 'Yes'),
    (15, 'Matthew', 'Wilson', 15, 'Yes');

-- Insert records into Patients table
INSERT INTO Dentist.dbo.Patients (Patient_ID, Personal_ID, Patient_FirstName, Patient_LastName, Patient_DOB, City, ZipCode, Phone, Email, Remarks, Street)
VALUES
    (1, 123456789, 'Alice', 'Johnson', '1990-05-15', 'New York', 10001, 1234567890, 'alice@example.com', 'Regular checkup', '123 Main St'),
    (2, 234567890, 'Bob', 'Smith', '1985-08-20', 'Los Angeles', 90001, 2345678901, 'bob@example.com', 'Toothache', '456 Oak Ave'),
    (3, 345678901, 'Carol', 'Williams', '1978-12-10', 'Chicago', 60601, 3456789012, 'carol@example.com', 'Teeth cleaning', '789 Elm St'),
    (4, 456789012, 'David', 'Brown', '1995-03-25', 'Houston', 77001, 4567890123, 'david@example.com', 'Braces consultation', '101 Pine St'),
    (5, 567890123, 'Emma', 'Jones', '1980-09-05', 'Phoenix', 85001, 5678901234, 'emma@example.com', 'Tooth extraction', '202 Maple St'),
    (6, 678901234, 'Frank', 'Martinez', '1992-11-30', 'Philadelphia', 19101, 6789012345, 'frank@example.com', 'Root canal treatment', '303 Cedar St'),
    (7, 789012345, 'Grace', 'Garcia', '1970-04-12', 'San Antonio', 78201, 7890123456, 'grace@example.com', 'Dental implants', '404 Pine St'),
    (8, 890123456, 'Henry', 'Hernandez', '1988-07-18', 'San Diego', 92101, 8901234567, 'henry@example.com', 'Tooth whitening', '505 Elm St'),
    (9, 901234567, 'Ivy', 'Lopez', '1965-01-08', 'Dallas', 75201, 9012345678, 'ivy@example.com', 'Gum disease treatment', '606 Oak St'),
    (10, 123456789, 'Jack', 'Miller', '1998-06-20', 'San Francisco', 94101, 1234567890, 'jack@example.com', 'Wisdom teeth removal', '707 Maple St'),
    (11, 234567890, 'Kate', 'Rodriguez', '1976-02-15', 'Austin', 73301, 2345678901, 'kate@example.com', 'Orthodontic treatment', '808 Cedar St'),
    (12, 345678901, 'Liam', 'Gonzalez', '1982-10-30', 'Seattle', 98101, 3456789012, 'liam@example.com', 'Dental crown', '909 Pine St'),
    (13, 456789012, 'Mia', 'Wilson', '1990-07-05', 'Denver', 80201, 4567890123, 'mia@example.com', 'Dentures fitting', '1010 Elm St'),
    (14, 567890123, 'Noah', 'Taylor', '1972-09-18', 'Washington', 20001, 5678901234, 'noah@example.com', 'Dental fillings', '1111 Oak St'),
    (15, 678901234, 'Olivia', 'Brown', '1987-04-22', 'Miami', 33101, 6789012345, 'olivia@example.com', 'Oral surgery consultation', '1212 Maple St');

-- Insert records into Rooms table
INSERT INTO Rooms (Room_ID, RoomName)
VALUES
    (1, 'Room A'),
    (2, 'Room B'),
    (3, 'Room C'),
    (4, 'Room D'),
    (5, 'Room E'),
    (6, 'Room F'),
    (7, 'Room G'),
    (8, 'Room H'),
    (9, 'Room I'),
    (10, 'Room J'),
    (11, 'Room K'),
    (12, 'Room L'),
    (13, 'Room M'),
    (14, 'Room N'),
    (15, 'Room O');

-- Insert records into Room_Breaks table
INSERT INTO Room_Breaks (Room_BreakID, Room_ID, Schedule)
VALUES
    (1, 1, 'Morning: 10:00 AM - 10:15 AM'),
    (2, 1, 'Afternoon: 3:00 PM - 3:15 PM'),
    (3, 2, 'Morning: 11:00 AM - 11:15 AM'),
    (4, 2, 'Afternoon: 4:00 PM - 4:15 PM'),
    (5, 3, 'Morning: 9:00 AM - 9:15 AM'),
    (6, 3, 'Afternoon: 2:00 PM - 2:15 PM'),
    (7, 4, 'Morning: 10:30 AM - 10:45 AM'),
    (8, 4, 'Afternoon: 3:30 PM - 3:45 PM'),
    (9, 5, 'Morning: 8:30 AM - 8:45 AM'),
    (10, 5, 'Afternoon: 1:30 PM - 1:45 PM'),
    (11, 6, 'Morning: 11:30 AM - 11:45 AM'),
    (12, 6, 'Afternoon: 4:30 PM - 4:45 PM'),
    (13, 7, 'Morning: 9:30 AM - 9:45 AM'),
    (14, 7, 'Afternoon: 2:30 PM - 2:45 PM'),
    (15, 8, 'Morning: 10:15 AM - 10:30 AM');

-- Insert records into Room_Bookings table
INSERT INTO Room_Bookings (RoomBooking_ID, Room_ID, Patient_ID, Duration, Status, DateStart, DateEnd)
VALUES
    (1, 1, 1, 1.5, 'Scheduled', '2024-03-27', '2024-03-27'),
    (2, 2, 2, 2.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (3, 3, 3, 1.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (4, 4, 4, 1.5, 'Scheduled', '2024-03-27', '2024-03-27'),
    (5, 5, 5, 2.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (6, 6, 6, 1.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (7, 7, 7, 1.5, 'Scheduled', '2024-03-27', '2024-03-27'),
    (8, 8, 8, 2.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (9, 9, 9, 1.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (10, 10, 10, 1.5, 'Scheduled', '2024-03-27', '2024-03-27'),
    (11, 11, 11, 2.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (12, 12, 12, 1.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (13, 13, 13, 1.5, 'Scheduled', '2024-03-27', '2024-03-27'),
    (14, 14, 14, 2.0, 'Scheduled', '2024-03-27', '2024-03-27'),
    (15, 15, 15, 1.0, 'Scheduled', '2024-03-27', '2024-03-27');

-- Insert records into Appointment_Workers table
INSERT INTO Appointment_Workers (Appointment_WorkerID, Appointment_ID, Employee_ID)
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5),
    (6, 6, 6),
    (7, 7, 7),
    (8, 8, 8),
    (9, 9, 9),
    (10, 10, 10),
    (11, 11, 11),
    (12, 12, 12),
    (13, 13, 13),
    (14, 14, 14),
    (15, 15, 15);

-- Insert records into Treatments table
INSERT INTO Treatments (Treatment_ID, Treatment, Price)
VALUES
    (1, 'Regular checkup', 100.00),
    (2, 'Toothache treatment', 150.00),
    (3, 'Teeth cleaning', 120.00),
    (4, 'Braces consultation', 200.00),
    (5, 'Tooth extraction', 180.00),
    (6, 'Root canal treatment', 250.00),
    (7, 'Dental implants', 800.00),
    (8, 'Tooth whitening', 150.00),
    (9, 'Gum disease treatment', 300.00),
    (10, 'Wisdom teeth removal', 400.00),
    (11, 'Orthodontic treatment', 600.00),
    (12, 'Dental crown', 350.00),
    (13, 'Dentures fitting', 700.00),
    (14, 'Dental fillings', 120.00),
    (15, 'Oral surgery consultation', 300.00);

-- Insert records into Patient_Treatments table
INSERT INTO Patient_Treatments (PatientTreatment_ID, Treatment_ID, Patient_ID)
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5),
    (6, 6, 6),
    (7, 7, 7),
    (8, 8, 8),
    (9, 9, 9),
    (10, 10, 10),
    (11, 11, 11),
    (12, 12, 12),
    (13, 13, 13),
    (14, 14, 14),
    (15, 15, 15);

-- Insert records into Appointments table
INSERT INTO Appointments (
    Appointment_ID,
    Patient_ID,
    Appointment_WorkerID,
    RoomBooking_ID,
    PatientTreatment_ID,
    Price,
    Diagnosis,
    Status,
    Appointment_Date,
    Appointment_time,
    Next_Appointment
)
VALUES
    (1, 1, 1, 1, 1, 100.00, 'Routine checkup', 'Scheduled', '2024-03-27', '10:00 AM', '2024-04-27'),
    (2, 2, 2, 2, 2, 150.00, 'Toothache', 'Scheduled', '2024-03-27', '11:00 AM', '2024-04-27'),
    (3, 3, 3, 3, 3, 120.00, 'Teeth cleaning', 'Scheduled', '2024-03-27', '09:00 AM', '2024-04-27'),
    (4, 4, 4, 4, 4, 200.00, 'Braces consultation', 'Scheduled', '2024-03-27', '10:30 AM', '2024-04-27'),
    (5, 5, 5, 5, 5, 180.00, 'Tooth extraction', 'Scheduled', '2024-03-27', '08:30 AM', '2024-04-27'),
    (6, 6, 6, 6, 6, 250.00, 'Root canal treatment', 'Scheduled', '2024-03-27', '11:30 AM', '2024-04-27'),
    (7, 7, 7, 7, 7, 800.00, 'Dental implants', 'Scheduled', '2024-03-27', '09:30 AM', '2024-04-27'),
    (8, 8, 8, 8, 8, 150.00, 'Tooth whitening', 'Scheduled', '2024-03-27', '10:15 AM', '2024-04-27'),
    (9, 9, 9, 9, 9, 300.00, 'Gum disease treatment', 'Scheduled', '2024-03-27', '08:45 AM', '2024-04-27'),
    (10, 10, 10, 10, 10, 400.00, 'Wisdom teeth removal', 'Scheduled', '2024-03-27', '01:30 PM', '2024-04-27'),
    (11, 11, 11, 11, 11, 600.00, 'Orthodontic treatment', 'Scheduled', '2024-03-27', '02:15 PM', '2024-04-27'),
    (12, 12, 12, 12, 12, 350.00, 'Dental crown', 'Scheduled', '2024-03-27', '04:30 PM', '2024-04-27'),
    (13, 13, 13, 13, 13, 700.00, 'Dentures fitting', 'Scheduled', '2024-03-27', '02:45 PM', '2024-04-27'),
    (14, 14, 14, 14, 14, 120.00, 'Dental fillings', 'Scheduled', '2024-03-27', '03:45 PM', '2024-04-27'),
    (15, 15, 15, 15, 15, 300.00, 'Oral surgery consultation', 'Scheduled', '2024-03-27', '04:45 PM', '2024-04-27');

-- Insert records into Payment table
INSERT INTO Payment (Payment_ID, PatientTreatment_ID, Treatment_ID, Appointment_WorkerID, Payment_Method, Payment_Date, Employee_ID, Total)
VALUES
(1, 1, 1, 1, 'Credit Card', '2024-03-27', 1, 100.00),
(2, 2, 2, 2, 'Cash', '2024-03-27', 2, 150.00),
(3, 3, 3, 3, 'Credit Card', '2024-03-27', 3, 120.00),
(4, 4, 4, 4, 'Cash', '2024-03-27', 4, 200.00),
(5, 5, 5, 5, 'Credit Card', '2024-03-27', 5, 180.00),
(6, 6, 6, 6, 'Cash', '2024-03-27', 6, 250.00),
(7, 7, 7, 7, 'Credit Card', '2024-03-27', 7, 800.00),
(8, 8, 8, 8, 'Cash', '2024-03-27', 8, 150.00),
(9, 9, 9, 9, 'Credit Card', '2024-03-27', 9, 300.00),
(10, 10, 10, 10, 'Cash', '2024-03-27', 10, 400.00),
(11, 11, 11, 11, 'Credit Card', '2024-03-27', 11, 600.00),
(12, 12, 12, 12, 'Cash', '2024-03-27', 12, 350.00),
(13, 13, 13, 13, 'Credit Card', '2024-03-27', 13, 700.00),
(14, 14, 14, 14, 'Cash', '2024-03-27', 14, 120.00),
(15, 15, 15, 15, 'Credit Card', '2024-03-27', 15, 300.00);
GO
----------------------------------------------------------------------------------------------------------------------------
-- Indexes
CREATE INDEX idx_Patients_Phone ON Patients (Phone);
CREATE INDEX idx_Appointments_AppointmentDate ON Appointments (Appointment_Date);

-- Constraints
ALTER TABLE Employees
ADD CONSTRAINT CHK_IsAvailable CHECK (IsAvailable IN ('Yes', 'No'));

/*ALTER TABLE Patients
ADD CONSTRAINT UQ_Patients_PersonalID UNIQUE (Personal_ID);*/


/*SELECT Personal_ID, COUNT(*)
FROM Patients
GROUP BY Personal_ID
HAVING COUNT(*) > 1;*/
