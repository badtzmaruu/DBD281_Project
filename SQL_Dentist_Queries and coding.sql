USE Dentist
GO

--Queries
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
	--View for appointments with patient details:
		CREATE VIEW AppointmentDetails AS
		SELECT A.*, P.Patient_FirstName, P.Patient_LastName, P.City
		FROM Appointments A
		INNER JOIN Patients P ON A.Patient_ID = P.Patient_ID;
	--View for room utilization:
		CREATE VIEW RoomUtilization AS
		SELECT R.Room_ID, R.RoomName, COUNT(RB.RoomBooking_ID) AS Bookings
		FROM Rooms R
		LEFT JOIN Room_Bookings RB ON R.Room_ID = RB.Room_ID
		GROUP BY R.Room_ID, R.RoomName;
	--View for patient treatments and payments:
		CREATE VIEW PatientPayments AS
		SELECT P.Patient_ID, P.Patient_FirstName, P.Patient_LastName, T.Treatment, Py.Payment_Method, Py.Total
		FROM Patients P
		INNER JOIN Patient_Treatments PT ON P.Patient_ID = PT.Patient_ID
		INNER JOIN Treatments T ON PT.Treatment_ID = T.Treatment_ID
		INNER JOIN Payment Py ON PT.PatientTreatment_ID = Py.PatientTreatment_ID;
	--View for appointment statuses:
		CREATE VIEW AppointmentStatus AS
		SELECT Patient_ID, Status, COUNT(*) AS Status_Count
		FROM Appointments
		GROUP BY Patient_ID, Status;
--Stored procedures
--triggers
--logins and other objects
