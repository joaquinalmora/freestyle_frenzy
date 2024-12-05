CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;

CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE admin (
    adminId INT IDENTITY PRIMARY KEY,
    firstName VARCHAR(40) NOT NULL,
    lastName VARCHAR(40) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    phoneNumber VARCHAR(20),
    address VARCHAR(50),
    city VARCHAR(40),
    state VARCHAR(20),
    postalCode VARCHAR(20),
    country VARCHAR(40),
    username VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(30) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE() -- Tracks when the admin was added
);


CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO admin (firstName, lastName, email, phoneNumber, address, city, state, postalCode, country, username, password)
VALUES 
('Jacob', 'Damery', 'jacob.damery@gmail.com', '111-222-3333', '123 Admin Lane', 'New York', 'NY', '10001', 'United States', 'jacob', 'Admin123!'),
('Joaquin', 'Almora', 'joaquin.almora@gmail.com', '444-555-6666', '456 Admin Blvd', 'Los Angeles', 'CA', '90001', 'United States', 'joaquin', 'Admin123!');


-- Insert category data
INSERT INTO category(categoryName) VALUES ('Skis');
INSERT INTO category(categoryName) VALUES ('Poles');
INSERT INTO category(categoryName) VALUES ('Helmets');
INSERT INTO category(categoryName) VALUES ('Boots');
INSERT INTO category(categoryName) VALUES ('Bindings');
INSERT INTO category(categoryName) VALUES ('Goggles');
INSERT INTO category(categoryName) VALUES ('Gloves');
INSERT INTO category(categoryName) VALUES ('Headwear');
INSERT INTO category(categoryName) VALUES ('New Releases');

-- Insert product data
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Armada ARV 84 Skis - Junior 2025', 1, 'Designed for tackling powder and launching off any available feature.', 529.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Armada ARV 116 JJ UL Skis 2025', 1, 'Playful, freestyle powder performance made for the backcountry.', 1029.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Armada ARV 84 Skis 2024', 1, 'Entry-level all-mountain freestyle twin purposefully designed to provide everything you require in a freestyle ski without any unnecessary extras.', 349.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Armada Edollo Skis 2025', 1, 'Designed to endure the demands of freestyle skiing.', 829.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Reckoner 102 Skis 2025', 1, 'Playful tool built for whipping cork threes off cat tracks, hitting butters and exploring all over the hill.', 699.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Line Pandora 92 Skis 2025', 1, 'Lightweight, nimble ride, offering an unmatched weight-to-performance ratio to keep you skiing from the first chair to the last call.', 649.99);

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Armada AK Adjustable Poles 2025', 2, 'Versatile, adjustable and has a no-nonsense price point to match.', 159.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Black Diamond Traverse Pole Pro', 2, 'Ready for any day in the backcountry, whether it''s for early-season novelty turns, mid-winter storms, or spring objectives.', 159.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Salomon Hacker Poles', 2, 'This pole helps you make the whole mountain your playground.', 49.99);

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Atomic Revent GT A Visor HD Photo Helmet', 3, 'Offers unparalleled field of vision, a new level of safety and the fit systems optimizes comfort.', 549.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Salomon Brigade Helmet', 3, 'Stylish yet technical.', 169.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Smith Rodeo Mips Helmet', 3, 'Clean, simple and solid wins the day with the Smith Rodeo helmet.', 129.99);

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Atomic Hawx Prime 100 GW Ski Boots 2025', 4, 'All-mountain ski boot with a medium fit and flex.', 499.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('K2 Mindbender 120 BOA Ski Boots 2025', 4, 'Pairs a super lightweight touring construction with the micro-adjustability of a custom fitted boot.', 849.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Lange Shadow 100 MV GW Ski Boots 2025', 4, 'Gives regular skiers the benefits of a smoother and more progressive flex.', 579.99);

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Armada Strive 12 GW Bindings 2025', 5, 'Low center of gravity and a neutral stance in a lightweight, auto GRIPWALK compatible package.', 229.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Atomic Shift 10 MN Bindings 2023', 5, 'Offer the same versatility and seamless touring capabilities as the original model but with a lower DIN setting.', 324.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Marker Duke PT 16 Bindings', 5, 'Completely new hybrid binding for the radical big mountain and backcountry charger.', 949.99);

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Atomic Four Pro Signature ET Goggles', 6, 'Low-key, elegant goggle design that showcase texture and rawness.', 249.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Oakley Flight Tracker Goggles Marmalade', 6, 'Low-key, elegant goggle design that showcase texture and rawness.', 249.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Smith IO Mag XL Goggles', 6, 'Putting on the Smith IO MAG XL goggles is like flipping the switch from regular to extra-widescreen.', 324.99);

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Dakine Leather Sequoia Gore-Tex Mitt', 7, 'Water repellent leather palm for added durability and dexterity in the most heavily-worn area.', 119.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Flylow Super D Glove', 7, 'All-day waterproofing from leather that’s been pre-treated and insulation that doesn’t quit and a wool-blended liner that dries quickly and keeps your hands warm.', 159.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Scott Ultimate Primaloft Mitt', 7, 'It is the perfect glove for resort activities or aprè ski.', 99.99);

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Arc''teryx Bird Head Toque', 8, 'Warm, comfortable toque made from a blend of wool and recycled polyester.', 69.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Arc''teryx Rho Balaclava', 8, 'The perfect head covering for cold days.', 54.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Armada Bachana Beanie', 8, 'The Bachana is a two-tone fold-over beanie featuring a logo at the front.', 29.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Blackstrap The Hood', 8, 'Workhorse for keeping the stoke levels at an all-time high.', 47.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Line Heist Mask Olive', 8, 'Perfect disguise.', 29.99);

-- Insert warehouse data
INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');

-- Insert product inventory data
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 18);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 19);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 10);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 22);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 21.35);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 25);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 30);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 40);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 97);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 31);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', '1', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');
INSERT INTO customers (userid, password) VALUES ('user', 'password');
INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId)
VALUES ('Credit Card', '1234-5678-9012-3456', '2025-12-31', 1);



-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);



CREATE TRIGGER trg_EnsureFuturePaymentExpiryDate
ON paymentmethod
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE paymentExpiryDate <= GETDATE())
    BEGIN
        RAISERROR ('Payment expiry date must be in the future.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_EnsureUniqueCustomerEmail
ON customer
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT email
        FROM customer c
        JOIN inserted i ON c.email = i.email
        WHERE c.customerId <> i.customerId
    )
    BEGIN
        RAISERROR ('Customer email must be unique.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_EnsurePositiveProductPrice
ON product
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE productPrice <= 0)
    BEGIN
        RAISERROR ('Product price must be positive.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


UPDATE Product SET productImageURL = 'img/1.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/6.jpg' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/7.jpg' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/8.jpg' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/9.jpg' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/10.jpg' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'img/11.jpg' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'img/12.jpg' WHERE ProductId = 12;
UPDATE Product SET productImageURL = 'img/13.jpg' WHERE ProductId = 13;
UPDATE Product SET productImageURL = 'img/14.jpg' WHERE ProductId = 14;
UPDATE Product SET productImageURL = 'img/15.jpg' WHERE ProductId = 15;
UPDATE Product SET productImageURL = 'img/16.jpg' WHERE ProductId = 16;
UPDATE Product SET productImageURL = 'img/17.jpg' WHERE ProductId = 17;
UPDATE Product SET productImageURL = 'img/18.jpg' WHERE ProductId = 18;
UPDATE Product SET productImageURL = 'img/19.jpg' WHERE ProductId = 19;
UPDATE Product SET productImageURL = 'img/20.jpg' WHERE ProductId = 20;
UPDATE Product SET productImageURL = 'img/21.jpg' WHERE ProductId = 21;
UPDATE Product SET productImageURL = 'img/22.jpg' WHERE ProductId = 22;
UPDATE Product SET productImageURL = 'img/23.jpg' WHERE ProductId = 23;
UPDATE Product SET productImageURL = 'img/24.jpg' WHERE ProductId = 24;
UPDATE Product SET productImageURL = 'img/25.jpg' WHERE ProductId = 25;
UPDATE Product SET productImageURL = 'img/26.jpg' WHERE ProductId = 26;
UPDATE Product SET productImageURL = 'img/27.jpg' WHERE ProductId = 27;
UPDATE Product SET productImageURL = 'img/28.jpg' WHERE ProductId = 28;
UPDATE Product SET productImageURL = 'img/29.jpg' WHERE ProductId = 29;
