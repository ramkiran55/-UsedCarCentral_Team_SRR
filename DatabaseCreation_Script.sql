CREATE DATABASE UsedCarCentral; -- Ram Kiran Devireddy (radevir)

USE UsedCarCentral;

-- We'll be maintaining two schemas in this project. One will be to test our SQL code and the second one will be our main schema

-- Create schema named test
CREATE SCHEMA test -- Ram Kiran Devireddy (radevir)
GO
-- Create schema real
CREATE SCHEMA real
GO

-- Use schema test
-- Firstly I'm creating a table to just Import the data from our dataset with all the required columns. This table will be our master table from which we'll be deriving the main tables using Normalization.
DROP TABLE test.UsedCarsMasterData;

CREATE TABLE test.UsedCarsMasterData -- Ram Kiran Devireddy (radevir)
(
	ID BIGINT,
	ListingURL NVARCHAR(500),
	City NVARCHAR(50),
	CraigsCityURL NVARCHAR(500),
	Price FLOAT,
	ModelYear SMALLINT,
	Manufacturer NVARCHAR(50),
	CarModel NVARCHAR(50),
	CarCondition NVARCHAR(50),
	CylinderCount NVARCHAR(50),
	FuelType NVARCHAR(50),
	OdometerReading FLOAT,
	CarStatus NVARCHAR(50),
	TransmissionType NVARCHAR(50),
	VehicleIdentificationNum NVARCHAR(50),
	DriveType NVARCHAR(50),
	CarSize NVARCHAR(50),
	CarBodyType NVARCHAR(50),
	CarColor NVARCHAR(50),
	ImageURL NVARCHAR(500),
	CarDescription NVARCHAR(MAX),
	StateCode NVARCHAR(50),
	Latitude FLOAT,
	Longitude FLOAT,
	PostedDate DATETIME
);

CREATE TABLE test.UsedCarsMasterData2 -- Ram Kiran Devireddy (radevir)
(
	ID BIGINT IDENTITY(1000000, 1) PRIMARY KEY,
	ListingURL NVARCHAR(500),
	City NVARCHAR(50),
	CraigsCityURL NVARCHAR(500),
	Price FLOAT,
	ModelYear SMALLINT,
	Manufacturer NVARCHAR(50),
	CarModel NVARCHAR(50),
	CarCondition NVARCHAR(50),
	CylinderCount NVARCHAR(50),
	FuelType NVARCHAR(50),
	OdometerReading FLOAT,
	CarStatus NVARCHAR(50),
	TransmissionType NVARCHAR(50),
	VehicleIdentificationNum NVARCHAR(50),
	DriveType NVARCHAR(50),
	CarSize NVARCHAR(50),
	CarBodyType NVARCHAR(50),
	CarColor NVARCHAR(50),
	ImageURL NVARCHAR(500),
	CarDescription NVARCHAR(MAX),
	StateCode NVARCHAR(50),
	Latitude FLOAT,
	Longitude FLOAT,
	PostedDate DATETIME
);

-- Now I am inserting all the data from the dataset into the above table
-- truncate the table first
TRUNCATE TABLE test.UsedCarsMasterData;
GO

-- import the file
BULK INSERT test.UsedCarsMasterData -- Ram Kiran Devireddy (radevir)
FROM 'D:\IUB\ADT\1_Project_SRR\Dataset\RawData\UsedCars.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	ORDER (
		ID,
		ListingURL,
		City,
		CraigsCityURL,
		Price,
		ModelYear,
		Manufacturer,
		CarModel,
		CarCondition,
		CylinderCount,
		FuelType,
		OdometerReading,
		CarStatus,
		TransmissionType,
		VehicleIdentificationNum,
		DriveType,
		CarSize,
		CarBodyType,
		CarColor,
		ImageURL,
		CarDescription,
		StateCode,
		Latitude,
		Longitude,
		PostedDate
	)
)
GO
;

INSERT INTO test.UsedCarsMasterData2 (ID, ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel, CarCondition, CylinderCount, FuelType, OdometerReading, CarStatus
		, TransmissionType, VehicleIdentificationNum, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription, StateCode, Latitude, Longitude
		,PostedDate)
SELECT ID, ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel, CarCondition, CylinderCount, FuelType, OdometerReading, CarStatus
		, TransmissionType, VehicleIdentificationNum, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription, StateCode, Latitude, Longitude
		,PostedDate
FROM test.UsedCarsMasterData;

-- (10330 rows affected)
select * from test.UsedCarsMasterData;
select DISTINCT(ID) from test.UsedCarsMasterData;

-- Next Step is to Apply Normalization and Dividing into individual meaningfull, non redundant tables.

CREATE TABLE test.CarsMasterData (
    CarID INT IDENTITY(100, 1) PRIMARY KEY ,
    Manufacturer NVARCHAR(50),
    ModelYear SMALLINT,
    CylinderCount NVARCHAR(50),
    FuelType NVARCHAR(50),
    TransmissionType NVARCHAR(50),
    CarSize NVARCHAR(50),
    CarBodyType NVARCHAR(50),
    CarColor NVARCHAR(50),
    VehicleIdentificationNum NVARCHAR(50),
    DriveType NVARCHAR(50)
);

CREATE TABLE test.CarDetails (
    CarDetailID INT IDENTITY(1, 1) PRIMARY KEY,
    CarID INT FOREIGN KEY REFERENCES test.CarsMasterData(CarID),
    CarCondition NVARCHAR(50),
    OdometerReading FLOAT,
    CarStatus NVARCHAR(50),
    ImageURL NVARCHAR(500),
    CarDescription NVARCHAR(MAX)
);

CREATE TABLE test.Locations (
    LocationID INT IDENTITY(1, 1) PRIMARY KEY,
    City NVARCHAR(50),
    StateCode NVARCHAR(50),
    Latitude FLOAT,
    Longitude FLOAT
);

CREATE TABLE test.CarListings (
    ListingID BIGINT IDENTITY(1000000, 1) PRIMARY KEY,
    CarID INT FOREIGN KEY REFERENCES test.CarsMasterData(CarID),
    LocationID INT FOREIGN KEY REFERENCES test.Locations(LocationID),
    Price FLOAT,
    PostedDate DATETIME,
    ListingURL NVARCHAR(500)
);

INSERT INTO test.CarsMasterData (Manufacturer, ModelYear, CylinderCount, FuelType, TransmissionType, CarSize, CarBodyType, CarColor, VehicleIdentificationNum, DriveType)
SELECT Manufacturer, ModelYear, CylinderCount, FuelType, TransmissionType, CarSize, CarBodyType, CarColor, VehicleIdentificationNum, DriveType
FROM test.UsedCarsMasterData;

INSERT INTO test.CarDetails (CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription)
SELECT CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription
FROM test.UsedCarsMasterData;

INSERT INTO test.Locations (City, StateCode, Latitude, Longitude)
SELECT City, StateCode, Latitude, Longitude
FROM (
    SELECT DISTINCT City, StateCode, Latitude, Longitude
    FROM test.UsedCarsMasterData
) as UniqueLocations;

INSERT INTO test.CarListings (CarID, LocationID, Price, PostedDate, ListingURL)
SELECT ID, L.LocationID, Price, CONVERT(DATETIME, PostedDate, 101), ListingURL
FROM test.UsedCarsMasterData U
INNER JOIN test.Locations L ON U.City = L.City AND U.StateCode = L.StateCode
JOIN test.CarsMasterData C ON 
