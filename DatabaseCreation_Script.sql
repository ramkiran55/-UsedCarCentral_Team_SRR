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
	URL NVARCHAR(500),
	City NVARCHAR(50),
	CraigsCityURL NVARCHAR(500),
	Price INT,
	ModelYear SMALLINT,
	Manufacturer NVARCHAR(50),
	CarModel NVARCHAR(50),
	CarCondition NVARCHAR(50),
	CylinderCount NVARCHAR(50),
	FuelType NVARCHAR(50),
	OdometerReading INT,
	CarStatus NVARCHAR(50),
	GearType NVARCHAR(50),
	VehicleIdentificationNum NVARCHAR(50),
	DriveType NVARCHAR(50),
	CarSize NVARCHAR(50),
	CarBodyType NVARCHAR(50),
	PaintColor NVARCHAR(50),
	ImageURL NVARCHAR(500),
	CarDescription NVARCHAR(MAX),
	StateID NVARCHAR(50),
	Latitude FLOAT,
	Logitude FLOAT,
	PostingDate NVARCHAR(50)
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
		URL,
		Region,
		RegionUrl,
		Price,
		ModelYear,
		CarMake,
		CarModel,
		CarCondition,
		NumCylinders,
		FuelType,
		OdometerReading,
		TitleStatus,
		TransmissionType,
		VehicleIdentificationNum,
		DriveType,
		CarSize,
		CarBodyType,
		PaintColor,
		ImageURL,
		CarDescription,
		StateID,
		Latitude,
		Logitude,
		PostingDate
	)
)
GO
;

-- (10330 rows affected)
select * from test.UsedCarsMasterData;
select DISTINCT(CarCondition) from test.UsedCarsMasterData;

-- Next Step is to Apply Normalization and Dividing into individual meaningfull, non redundant tables.

select ID,
		Region, 
		CarState,
		Latitude,
		Logitude 
from test.UsedCarsMasterData;