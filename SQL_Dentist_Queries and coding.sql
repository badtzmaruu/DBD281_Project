USE Dentist
GO

--Queries
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

--Views
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
--triggers
--logins and other objects
