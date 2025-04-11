

-- Customer Table
CREATE TABLE Customer (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CurrentBalance NUMERIC(10, 2) DEFAULT 0
);

-- Customer Address Table
CREATE TABLE CustomerAddress (
    AddressID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    AddressDetails TEXT NOT NULL,
    Type VARCHAR(20) CHECK (Type IN ('Delivery', 'Payment', 'Both'))
);

-- Credit Card Table
CREATE TABLE CreditCard (
    CardID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    CardNumber VARCHAR(16) NOT NULL,
    ExpiryDate DATE NOT NULL,
    CVV VARCHAR(4) NOT NULL,
    PaymentAddressID INT REFERENCES CustomerAddress(AddressID)
);

-- Staff Table
CREATE TABLE Staff (
    StaffID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Address TEXT,
    Salary NUMERIC(10, 2),
    JobTitle VARCHAR(50)
);

-- Warehouse Table
CREATE TABLE Warehouse (
    WarehouseID SERIAL PRIMARY KEY,
    Address TEXT,
    Capacity INT
);

-- Product Table
CREATE TABLE Product (
    ProductID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(50),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    Size VARCHAR(20),
    Description TEXT,
    Price NUMERIC(10, 2)
);

-- Stock Table
CREATE TABLE Stock (
    StockID SERIAL PRIMARY KEY,
    WarehouseID INT REFERENCES Warehouse(WarehouseID),
    ProductID INT REFERENCES Product(ProductID),
    Quantity INT NOT NULL CHECK (Quantity >= 0)
);

-- Order Table
CREATE TABLE "Order" (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) CHECK (Status IN ('Issued', 'Sent', 'Received')),
    CardID INT REFERENCES CreditCard(CardID)
);

-- OrderItem Table
CREATE TABLE OrderItem (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES "Order"(OrderID),
    ProductID INT REFERENCES Product(ProductID),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    ItemPrice NUMERIC(10, 2) NOT NULL
);

-- DeliveryPlan Table
CREATE TABLE DeliveryPlan (
    DeliveryPlanID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES "Order"(OrderID),
    DeliveryType VARCHAR(20) CHECK (DeliveryType IN ('Standard', 'Express')),
    DeliveryPrice NUMERIC(10, 2),
    ShipDate DATE,
    DeliveryDate DATE
);

-- Indices for performance
CREATE INDEX idx_product_name ON Product(Name);
CREATE INDEX idx_order_customer ON "Order"(CustomerID);
CREATE INDEX idx_stock_product_warehouse ON Stock(ProductID, WarehouseID);
