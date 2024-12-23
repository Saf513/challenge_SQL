--creation de database 
create database SaleOrderQuiz;

--activation de database 
use SaleOrderQuiz;

--creation de tableau costumer 
create table Customer(
CustomerID int not null primary key ,
CustomerFirstName varchar(50) not null,
CustomerLastName varchar(50) not null,
CustomerAddress varchar(50) not null,
CustomerCity varchar(50) not null, 
CustomerPostCode char(4) null,
CustomerPhoneNumber char(12) null
);

--creation de tableau employe
CREATE TABLE Employees (
    EmployeeID TINYINT NOT NULL PRIMARY KEY,  
    EmployeeFirstName VARCHAR(50) NOT NULL,  
    EmployeeLastName VARCHAR(50) NOT NULL,   
    EmployeeExtension CHAR(4) NULL          
);


--creation de table Inventory
create table Inventory(
InventoryID tinyint not null primary key,
InventoryName varchar(50)not null,
InventoryDescription varchar(255) not null,
EmployeeExtension char(4) null
);

--creation de tableau sale 
create table Sale(
SaleID tinyint not null primary key auto_increment,
CustomerID int not null,
InventoryID tinyint not null,
EmployeeID   tinyint not null,
SaleDate date not null,
SaleQuantity int not null,
SaleUnitPrice DECIMAL(10, 2) not null,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

--insertion dans le tableau customers
INSERT INTO Customer (CustomerFirstName, CustomerLastName, CustomerAddress, CustomerCity, CustomerPostCode, CustomerPhoneNumber)
VALUES 
    ('safia', 'khoulaid', '123 Main St', 'CityA', '1234', '555-1234'),
    ('ana', 'khoulaid', '456 Elm St', 'CityB', '5678', '555-5678'),
    ('soad', 'reseau', '789 Oak St', 'New York', '9101', '555-9101');

--insertion tableau de inventory
INSERT INTO Inventory (InventoryName, InventoryDescription)
VALUES 
    ('Laptop', 'High-end gaming laptop'),
    ('Smartphone', 'Latest model smartphone'),
    ('Headphones', 'Noise-cancelling headphones');

--insertion employee 
INSERT INTO Employee (EmployeeFirstName, EmployeeLastName, EmployeeExtension)
VALUES 
    ('Michael', 'Scott', '101'),
    ('Jim', 'Halpert', '102'),
    ('Pam', 'Beesly', '103');

 --insertion sale   
INSERT INTO Sale (CustomerID, InventoryID, EmployeeID, SaleDate, SaleQuantity, SaleUnitPrice)
VALUES 
    (1, 1, 1, '2024-01-15', 2, 999.99),
    (2, 2, 2, '2024-01-16', 1, 799.99),
    (3, 3, 3, '2024-01-17', 5, 199.99);

--afficher tout les custumers
SELECT * FROM Customer;

--Lister toutes les ventes avec leurs montants totaux (SaleQuantity * SaleUnitPrice) par ordre décroissant.
SELECT 
SaleID, SaleDate, SaleQuantity, SaleUnitPrice,  (SaleQuantity * SaleUnitPrice) AS TotalAmount
FROM Sale
ORDER BY TotalAmount DESC;

--Afficher tous les employés ayant réalisé au moins une vente, ainsi que le montant total des ventes pour chacun
SELECT 
    Employee.EmployeeFirstName, 
    Employee.EmployeeLastName, 
    SUM(Sale.SaleQuantity * Sale.SaleUnitPrice) AS TotalSales
FROM Employee
JOIN Sale ON Employee.EmployeeID = Sale.EmployeeID
GROUP BY Employee.EmployeeID
HAVING SUM(Sale.SaleQuantity * Sale.SaleUnitPrice) > 0;

--Ajouter une nouvelle colonne CustomerEmail à la table Customer
ALTER TABLE Customer
ADD COLUMN CustomerEmail VARCHAR(100) NULL;

--Mettez à jour la colonne CustomerEmail pour l’un des clients.
UPDATE Customer
SET CustomerEmail = 'john.doe@example.com'
WHERE CustomerID = 1;

--Supprimez un enregistrement client dont la ville (CustomerCity) est "New York".
ALTER TABLE sale
DROP FOREIGN KEY sale_ibfk_1; 

ALTER TABLE sale
ADD CONSTRAINT sale_ibfk_1 FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID) ON DELETE CASCADE;  

DELETE FROM Customer
WHERE CustomerCity = 'New York';

--Écrivez une requête pour afficher toutes les ventes réalisées au cours des 30 derniers jours.
SELECT * FROM Sale
WHERE SaleDate >= CURDATE() - INTERVAL 30 DAY;

--Affichez tous les clients ayant acheté plus de 5 articles en une seule vente.
SELECT DISTINCT Customer.CustomerFirstName, Customer.CustomerLastName
FROM Sale
JOIN Customer ON Sale.CustomerID = Customer.CustomerID
WHERE Sale.SaleQuantity > 5;

--Calculez le revenu total des ventes, regroupé par InventoryName.


SELECT 
    Inventory.InventoryName, 
    SUM(Sale.SaleQuantity * Sale.SaleUnitPrice) AS TotalRevenue
FROM Sale
JOIN Inventory ON Sale.InventoryID = Inventory.InventoryID
GROUP BY Inventory.InventoryID;

--Créez une vue nommée CustomerSalesView pour afficher :
CREATE VIEW CustomerSalesView AS
SELECT 
    Customer.CustomerFirstName, 
    Customer.CustomerLastName, 
    Sale.SaleDate, 
    Inventory.InventoryName, 
    Sale.SaleQuantity, 
    (Sale.SaleQuantity * Sale.SaleUnitPrice) AS TotalAmount
FROM Sale
JOIN Customer ON Sale.CustomerID = Customer.CustomerID
JOIN Inventory ON Sale.InventoryID = Inventory.InventoryID;



--Créez une procédure stockée permettant de récupérer toutes les ventes pour un client spécifique en fonction de son CustomerID.


CREATE PROCEDURE GetSalesByCustomer(IN customerID INT)
BEGIN
    SELECT 
        Sale.SaleID, 
        Sale.SaleDate, 
        Inventory.InventoryName, 
        Sale.SaleQuantity, 
        (Sale.SaleQuantity * Sale.SaleUnitPrice) AS TotalAmount
    FROM Sale
    JOIN Inventory ON Sale.InventoryID = Inventory.InventoryID
    WHERE Sale.CustomerID = customerID;
END 







