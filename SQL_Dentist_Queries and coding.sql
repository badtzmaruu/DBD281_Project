USE Dentist
GO

--Queries
	--Find the average revenue per appointment for each employee type:
		SELECT et.TypeName,ROUND(AVG(p.Total), 2) AS AvgRevenuePerAppointment
		FROM Employees e
		INNER JOIN Employee_Types et ON e.Employee_TypeID = et.Employee_TypeID
		INNER JOIN Appointment_Workers aw ON e.Employee_ID = aw.Employee_ID
		INNER JOIN Appointments a ON aw.Appointment_WorkerID = a.Appointment_WorkerID
		INNER JOIN Patient_Treatments pt ON a.PatientTreatment_ID = pt.PatientTreatment_ID
		INNER JOIN Payment p ON pt.PatientTreatment_ID = p.PatientTreatment_ID
		GROUP BY et.TypeName;
	--Find the total number of appointments scheduled for each room on a specific date:
		SELECT r.RoomName, COUNT(*) AS TotalAppointments
		FROM Room_Bookings rb
		INNER JOIN Rooms r ON rb.Room_ID = r.Room_ID
		INNER JOIN Appointments a ON rb.RoomBooking_ID = a.RoomBooking_ID
		WHERE a.Appointment_Date = '2024-03-27'
		GROUP BY r.RoomName;
	-- To show all possible information about all appointments OR use WHERE to find all details about a specific patient:
		SELECT 
		    A.Appointment_ID, A.Appointment_Date, A.Appointment_time, P.Patient_ID,
		    P.Patient_FirstName, P.Patient_LastName, E.Employee_ID, E.Employee_FirstName, 
		    E.Employee_LastName, R.Room_ID, R.RoomName, T.Treatment_ID, T.Treatment, T.Price
		FROM Appointments A
		INNER JOIN Patients P ON A.Patient_ID = P.Patient_ID
		INNER JOIN Appointment_Workers AW ON A.Appointment_WorkerID = AW.Appointment_WorkerID
		INNER JOIN Employees E ON AW.Employee_ID = E.Employee_ID
		INNER JOIN Room_Bookings RB ON A.RoomBooking_ID = RB.RoomBooking_ID
		INNER JOIN Rooms R ON RB.Room_ID = R.Room_ID
		INNER JOIN Patient_Treatments PT ON A.PatientTreatment_ID = PT.PatientTreatment_ID
		INNER JOIN Treatments T ON PT.Treatment_ID = T.Treatment_ID;
		--WHERE P.Patient_ID = 5;
	--Find the total revenue generated from treatments on a specific date:
		SELECT SUM(P.Total) AS Total_Revenue
		FROM Payment P
		INNER JOIN Appointments A ON P.Appointment_WorkerID = A.Appointment_WorkerID
		WHERE A.Appointment_Date = '2024-03-27';

	--Find the top 5 treatments by revenue:
		SELECT TOP 5 T.Treatment, SUM(P.Total) AS Total_Revenue
		FROM Treatments T
		INNER JOIN Payment P ON T.Treatment_ID = P.Treatment_ID
		GROUP BY T.Treatment
		ORDER BY Total_Revenue DESC;

	--Find the total number of patients per city:
		SELECT City, COUNT(*) AS Total_Patients
		FROM Patients
		GROUP BY City;

	--Find the availability of employees:
		SELECT Employee_FirstName, Employee_LastName, Employee_TypeID
		FROM Employees
		WHERE IsAvailable = 'Yes';
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Views
	--View for patient appointments and treatments with employee details:
		CREATE VIEW PatientAppointmentDetails AS
		SELECT a.Appointment_ID, a.Appointment_Date, a.Appointment_time,
			   p.Patient_FirstName, p.Patient_LastName, p.City,
			   t.Treatment, py.Payment_Method
		FROM Appointments a
		INNER JOIN Patients p ON a.Patient_ID = p.Patient_ID
		INNER JOIN Patient_Treatments pt ON a.PatientTreatment_ID = pt.PatientTreatment_ID
		INNER JOIN Treatments t ON pt.Treatment_ID = t.Treatment_ID
		INNER JOIN Payment py ON pt.PatientTreatment_ID = py.PatientTreatment_ID;
		GO
	-- View to look at employee performance like how many patients, revenue and avg duration per patient:
		CREATE VIEW EmployeePerformance 
		AS
		SELECT CONCAT(E.Employee_FirstName,' ' ,E.Employee_LastName) 'EmployeeFullName', COUNT(A.Patient_ID) 'TotalAppointments', 
		       SUM(A.Price) 'TotalRevenue', AVG(RB.Duration) 'AverageDuration'
		FROM Appointments A
		LEFT JOIN Appointment_Workers AW ON A.Appointment_WorkerID = AW.Appointment_WorkerID
		LEFT JOIN Employees E ON AW.Employee_ID = E.Employee_ID
		LEFT JOIN Room_Bookings RB ON A.RoomBooking_ID = RB.RoomBooking_ID
		GROUP BY CONCAT(E.Employee_FirstName,' ' ,E.Employee_LastName);
	GO
	--View for appointments with patient details:
		CREATE VIEW AppointmentDetails AS
		SELECT A.*, P.Patient_FirstName, P.Patient_LastName, P.City
		FROM Appointments A
		INNER JOIN Patients P ON A.Patient_ID = P.Patient_ID;
	GO
	--View for room utilization:
		CREATE VIEW RoomUtilization AS
		SELECT R.Room_ID, R.RoomName, COUNT(RB.RoomBooking_ID) AS Bookings
		FROM Rooms R
		LEFT JOIN Room_Bookings RB ON R.Room_ID = RB.Room_ID
		GROUP BY R.Room_ID, R.RoomName;
	GO
	--View for patient treatments and payments:
		CREATE VIEW PatientPayments AS
		SELECT P.Patient_ID, P.Patient_FirstName, P.Patient_LastName, T.Treatment, Py.Payment_Method, Py.Total
		FROM Patients P
		INNER JOIN Patient_Treatments PT ON P.Patient_ID = PT.Patient_ID
		INNER JOIN Treatments T ON PT.Treatment_ID = T.Treatment_ID
		INNER JOIN Payment Py ON PT.PatientTreatment_ID = Py.PatientTreatment_ID;
	GO
	--View for appointment statuses:
		CREATE VIEW AppointmentStatus AS
		SELECT Patient_ID, Status, COUNT(*) AS Status_Count
		FROM Appointments
		GROUP BY Patient_ID, Status;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Stored procedures
	GO
	-- Parameterized query to find a patient by their ID, also prevents SQL injection:
		CREATE PROCEDURE GetPatientByID @PatientID INT
		AS
		BEGIN
		    SELECT *
		    FROM Patients
		    WHERE Patient_ID = @PatientID;
		END;
		-- EXECUTE GetPatientByID @PatientID = 1;

	-- Stored procedure to update patient information
		CREATE PROCEDURE UpdatePatientInfo
			@PatientID INT,
			@NewCity VARCHAR(50)
		AS
		BEGIN
			UPDATE Patients
			SET City = @NewCity
			WHERE Patient_ID = @PatientID;
		END;
		-- Execute UpdatePatientInfo stored procedure
		EXEC UpdatePatientInfo @PatientID = 123, @NewCity = 'New York';
		-- Replace 123 with the actual Patient_ID and 'New York' with the new city value

	-- Stored procedure to calculate total revenue for a specific date range
		CREATE PROCEDURE CalculateRevenue
			@StartDate DATE,
			@EndDate DATE
		AS
		BEGIN
			SELECT SUM(p.Total) AS TotalRevenue
			FROM Payment p
			WHERE p.Payment_Date BETWEEN @StartDate AND @EndDate;
		END;

		-- Execute CalculateRevenue stored procedure
			DECLARE @StartDate DATE = '2024-01-01';
			DECLARE @EndDate DATE = '2024-12-31';
			EXEC CalculateRevenue @StartDate, @EndDate;

	-- Stored procedure to delete a patient and all related records
		CREATE PROCEDURE DeletePatientCascade
			@PatientID INT
		AS
		BEGIN
			DELETE FROM Appointments WHERE Patient_ID = @PatientID;
			DELETE FROM Patients WHERE Patient_ID = @PatientID;
		END;

		-- Execute DeletePatientCascade stored procedure
		EXEC DeletePatientCascade @PatientID = 123;
		-- Replace 123 with the actual Patient_ID to be deleted
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--triggers
	-- Trigger to log patient deletions
		CREATE TRIGGER LogPatientDeletions
		ON Patients
		INSTEAD OF DELETE
		AS
		BEGIN
			INSERT INTO DeletedPatientsLog (PatientID, DeletionDate)
			SELECT Patient_ID, GETDATE()
			FROM deleted;
    
			DELETE FROM Patients WHERE Patient_ID IN (SELECT Patient_ID FROM deleted);
		END;

	-- Trigger to enforce unique emails for patients
		CREATE TRIGGER EnforceUniqueEmail
		ON Patients
		AFTER INSERT, UPDATE
		AS
		BEGIN
			IF EXISTS (SELECT 1 FROM inserted GROUP BY Email HAVING COUNT(*) > 1)
			BEGIN
				RAISERROR ('Email must be unique.', 16, 1);
				ROLLBACK TRANSACTION;
			END;
		END;

--logins and other objects
	
