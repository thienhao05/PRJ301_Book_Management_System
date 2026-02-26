-- =========================================
-- DROP & CREATE DATABASE
-- =========================================
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'BookstoreDB')
BEGIN
    ALTER DATABASE BookstoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BookstoreDB;
END
GO

CREATE DATABASE BookstoreDB;
GO

USE BookstoreDB;
GO

-- =========================================
-- USERS
-- =========================================
CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(MAX),
    role NVARCHAR(20) DEFAULT 'USER',
    status NVARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE()
);

-- =========================================
-- CATEGORIES
-- =========================================
CREATE TABLE Categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    status NVARCHAR(20) DEFAULT 'ACTIVE'
);

-- =========================================
-- PUBLISHERS
-- =========================================
CREATE TABLE Publishers (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX)
);

-- =========================================
-- BOOKS
-- =========================================
CREATE TABLE Books (
    id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    author NVARCHAR(150),
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2),
    stock INT DEFAULT 0,
    image_url NVARCHAR(255),
    category_id INT,
    publisher_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'ACTIVE',

    FOREIGN KEY (category_id) REFERENCES Categories(id),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(id)
);

-- =========================================
-- CART
-- =========================================
CREATE TABLE Carts (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- =========================================
-- CART ITEMS
-- =========================================
CREATE TABLE CartItems (
    id INT PRIMARY KEY IDENTITY(1,1),
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,

    FOREIGN KEY (cart_id) REFERENCES Carts(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

-- =========================================
-- WISHLIST
-- =========================================
CREATE TABLE Wishlists (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

-- =========================================
-- DISCOUNTS
-- =========================================
CREATE TABLE Discounts (
    id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(50) UNIQUE NOT NULL,
    description NVARCHAR(MAX),
    discount_percent INT,
    discount_amount DECIMAL(10,2),
    min_order_value DECIMAL(12,2),
    start_date DATETIME,
    end_date DATETIME,
    status NVARCHAR(20) DEFAULT 'ACTIVE'
);

-- =========================================
-- ORDERS
-- =========================================
CREATE TABLE Orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12,2) NOT NULL,
    shipping_address NVARCHAR(MAX) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    payment_method NVARCHAR(20) DEFAULT 'COD',
    payment_status NVARCHAR(20) DEFAULT 'UNPAID',
    status NVARCHAR(30) DEFAULT 'PENDING',

    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- =========================================
-- ORDER DETAILS
-- =========================================
CREATE TABLE OrderDetails (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,

    FOREIGN KEY (order_id) REFERENCES Orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

-- =========================================
-- ORDER DISCOUNTS
-- =========================================
CREATE TABLE OrderDiscounts (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    discount_id INT NOT NULL,
    discount_value DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES Orders(id) ON DELETE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES Discounts(id)
);

-- =========================================
-- PAYMENTS
-- =========================================
CREATE TABLE Payments (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    payment_method NVARCHAR(50),
    transaction_code NVARCHAR(100),
    amount DECIMAL(12,2),
    payment_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'PENDING',

    FOREIGN KEY (order_id) REFERENCES Orders(id) ON DELETE CASCADE
);

-- =========================================
-- REVIEWS
-- =========================================
CREATE TABLE Reviews (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    book_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

-- =========================================
-- INDEXES: ko cần quan tâm cái này
-- =========================================
CREATE INDEX idx_book_title ON Books(title);
CREATE INDEX idx_book_price ON Books(price);
CREATE INDEX idx_order_user ON Orders(user_id);

-- SeedData
GO
-- =========================
-- 50 USERS (real names)
-- =========================
INSERT INTO Users (full_name,email,password,phone,address,role) VALUES
('James Anderson','james.anderson@gmail.com','123456','0909000001','New York, USA','ADMIN'),
('Emily Johnson','emily.johnson@gmail.com','123456','0909000002','London, UK','USER'),
('Michael Smith','michael.smith@gmail.com','123456','0909000003','Toronto, Canada','USER'),
('Sophia Brown','sophia.brown@gmail.com','123456','0909000004','Sydney, Australia','USER'),
('Daniel Martinez','daniel.martinez@gmail.com','123456','0909000005','Madrid, Spain','USER'),
('Olivia Garcia','olivia.garcia@gmail.com','123456','0909000006','Barcelona, Spain','USER'),
('William Davis','william.davis@gmail.com','123456','0909000007','Chicago, USA','USER'),
('Isabella Rodriguez','isabella.rodriguez@gmail.com','123456','0909000008','Mexico City, Mexico','USER'),
('Benjamin Wilson','benjamin.wilson@gmail.com','123456','0909000009','Berlin, Germany','USER'),
('Charlotte Moore','charlotte.moore@gmail.com','123456','0909000010','Paris, France','USER'),
('Lucas Taylor','lucas.taylor@gmail.com','123456','0909000011','Rome, Italy','USER'),
('Amelia Thomas','amelia.thomas@gmail.com','123456','0909000012','Lisbon, Portugal','USER'),
('Henry Lee','henry.lee@gmail.com','123456','0909000013','Seoul, Korea','USER'),
('Mia Walker','mia.walker@gmail.com','123456','0909000014','Tokyo, Japan','USER'),
('Alexander Hall','alex.hall@gmail.com','123456','0909000015','Bangkok, Thailand','USER'),
('Harper Allen','harper.allen@gmail.com','123456','0909000016','Singapore','USER'),
('Ethan Young','ethan.young@gmail.com','123456','0909000017','Kuala Lumpur, Malaysia','USER'),
('Ava Hernandez','ava.hernandez@gmail.com','123456','0909000018','Dubai, UAE','USER'),
('Noah King','noah.king@gmail.com','123456','0909000019','Los Angeles, USA','USER'),
('Liam Wright','liam.wright@gmail.com','123456','0909000020','Boston, USA','USER'),
('Emma Scott','emma.scott@gmail.com','123456','0909000021','Dublin, Ireland','USER'),
('Jacob Green','jacob.green@gmail.com','123456','0909000022','Vienna, Austria','USER'),
('Abigail Adams','abigail.adams@gmail.com','123456','0909000023','Brussels, Belgium','USER'),
('Matthew Baker','matthew.baker@gmail.com','123456','0909000024','Prague, Czech','USER'),
('Ella Nelson','ella.nelson@gmail.com','123456','0909000025','Warsaw, Poland','USER'),
('David Carter','david.carter@gmail.com','123456','0909000026','Helsinki, Finland','USER'),
('Grace Mitchell','grace.mitchell@gmail.com','123456','0909000027','Oslo, Norway','USER'),
('Joseph Perez','joseph.perez@gmail.com','123456','0909000028','Stockholm, Sweden','USER'),
('Chloe Roberts','chloe.roberts@gmail.com','123456','0909000029','Copenhagen, Denmark','USER'),
('Samuel Turner','samuel.turner@gmail.com','123456','0909000030','Athens, Greece','USER'),
('Lily Phillips','lily.phillips@gmail.com','123456','0909000031','Zurich, Switzerland','USER'),
('Logan Campbell','logan.campbell@gmail.com','123456','0909000032','Budapest, Hungary','USER'),
('Zoe Parker','zoe.parker@gmail.com','123456','0909000033','Istanbul, Turkey','USER'),
('Jackson Evans','jackson.evans@gmail.com','123456','0909000034','Jakarta, Indonesia','USER'),
('Victoria Edwards','victoria.edwards@gmail.com','123456','0909000035','Manila, Philippines','USER'),
('Sebastian Collins','sebastian.collins@gmail.com','123456','0909000036','Mumbai, India','USER'),
('Aria Stewart','aria.stewart@gmail.com','123456','0909000037','New Delhi, India','USER'),
('Gabriel Sanchez','gabriel.sanchez@gmail.com','123456','0909000038','Santiago, Chile','USER'),
('Scarlett Morris','scarlett.morris@gmail.com','123456','0909000039','Lima, Peru','USER'),
('Anthony Rogers','anthony.rogers@gmail.com','123456','0909000040','Cape Town, SA','USER'),
('Hannah Reed','hannah.reed@gmail.com','123456','0909000041','Auckland, NZ','USER'),
('Nathan Cook','nathan.cook@gmail.com','123456','0909000042','Melbourne, AU','USER'),
('Layla Morgan','layla.morgan@gmail.com','123456','0909000043','Brisbane, AU','USER'),
('Christopher Bell','christopher.bell@gmail.com','123456','0909000044','Houston, USA','USER'),
('Penelope Murphy','penelope.murphy@gmail.com','123456','0909000045','Dallas, USA','USER'),
('Andrew Bailey','andrew.bailey@gmail.com','123456','0909000046','Seattle, USA','USER'),
('Natalie Rivera','natalie.rivera@gmail.com','123456','0909000047','San Diego, USA','USER'),
('Isaac Cooper','isaac.cooper@gmail.com','123456','0909000048','Montreal, Canada','USER'),
('Audrey Richardson','audrey.richardson@gmail.com','123456','0909000049','Ottawa, Canada','USER'),
('Julian Cox','julian.cox@gmail.com','123456','0909000050','Vancouver, Canada','USER');
GO

INSERT INTO Categories (name, description) VALUES
('Fiction', 'Novels and literary fiction'),
('Science Fiction', 'Sci-fi, futuristic and dystopian works'),
('Fantasy', 'Magic, mythology and fantasy worlds'),
('Mystery & Thriller', 'Crime, suspense and detective stories'),
('Romance', 'Love stories and romantic fiction'),
('Historical Fiction', 'Stories set in historical settings'),
('Horror', 'Supernatural and psychological horror'),
('Biography', 'Life stories of notable people'),
('Autobiography', 'Self-written life stories'),
('Self-Help', 'Personal development and motivation'),
('Psychology', 'Human behavior and mental processes'),
('Philosophy', 'Philosophical thoughts and theories'),
('Business & Economics', 'Business, finance and economics'),
('Marketing & Sales', 'Marketing strategies and sales techniques'),
('Leadership', 'Leadership and management skills'),
('Entrepreneurship', 'Startups and entrepreneurship'),
('Investing', 'Stock market and investment strategies'),
('Technology', 'General technology books'),
('Programming', 'Coding and software development'),
('Artificial Intelligence', 'AI and machine learning'),
('Cybersecurity', 'Information security and hacking'),
('Data Science', 'Data analysis and big data'),
('Mathematics', 'Pure and applied mathematics'),
('Physics', 'Physics and cosmology'),
('Chemistry', 'Chemistry and material science'),
('Biology', 'Biological sciences'),
('Medicine', 'Medical knowledge and healthcare'),
('Health & Fitness', 'Health, nutrition and exercise'),
('Cooking', 'Recipes and culinary arts'),
('Travel', 'Travel guides and experiences'),
('Art & Design', 'Art, drawing and graphic design'),
('Photography', 'Photography techniques'),
('Music', 'Music theory and history'),
('Education', 'Teaching and learning resources'),
('Language Learning', 'Learning foreign languages'),
('Children', 'Books for children'),
('Young Adult', 'Teen fiction and YA novels'),
('Comics', 'Comics and graphic novels'),
('Manga', 'Japanese manga'),
('Religion', 'Religious texts and studies'),
('Spirituality', 'Spiritual growth and mindfulness'),
('Law', 'Legal studies and references'),
('Politics', 'Political science and analysis'),
('Sociology', 'Social sciences'),
('Environment', 'Environmental studies'),
('History', 'World and regional history'),
('Geography', 'Geographical studies'),
('Engineering', 'Engineering disciplines'),
('Architecture', 'Architecture and urban design'),
('Poetry', 'Poetry collections');
GO


INSERT INTO Publishers (name, description) VALUES
('Penguin Random House','Global publishing company headquartered in New York'),
('HarperCollins','One of the world''s largest publishing companies'),
('Simon & Schuster','Major American publishing company'),
('Hachette Livre','French publishing company and one of the largest worldwide'),
('Macmillan Publishers','International publishing company'),
('Scholastic','Publisher known for children''s books and education'),
('Pearson','Educational publishing and assessment services'),
('Oxford University Press','Department of the University of Oxford'),
('Cambridge University Press','Publishing business of the University of Cambridge'),
('Wiley','Academic and professional publishing'),
('Springer Nature','Global academic publishing company'),
('Elsevier','Information analytics and scientific publisher'),
('Bloomsbury Publishing','UK publishing house known for Harry Potter'),
('Random House UK','UK division of Penguin Random House'),
('Tor Books','Publisher specializing in science fiction and fantasy'),
('Vintage Books','Imprint of Penguin Random House'),
('Bantam Books','American publishing house'),
('Little, Brown and Company','American publishing company'),
('Faber & Faber','Independent publishing house based in London'),
('Pan Macmillan','UK publishing company'),
('Kodansha','Major Japanese publishing company'),
('Shueisha','Japanese publisher of manga and novels'),
('Shogakukan','Japanese publisher of manga and textbooks'),
('Square Enix Books','Publisher of manga and game-related books'),
('VIZ Media','American manga and anime publisher'),
('DC Comics','American comic book publisher'),
('Marvel Comics','American comic book publisher'),
('Dark Horse Comics','American comic publisher'),
('Image Comics','Comic book publisher'),
('IDW Publishing','Comic and graphic novel publisher'),
('Chronicle Books','Independent publisher based in San Francisco'),
('Workman Publishing','Independent publisher'),
('Cengage Learning','Educational content provider'),
('McGraw-Hill Education','Educational publishing company'),
('Routledge','Academic publisher'),
('SAGE Publications','Academic and educational publisher'),
('MIT Press','University press of MIT'),
('Princeton University Press','University press of Princeton University'),
('Yale University Press','University press of Yale University'),
('Stanford University Press','University press of Stanford'),
('Taschen','Art book publisher'),
('Abrams Books','Art and illustrated book publisher'),
('Phaidon Press','Art and architecture publisher'),
('DK Publishing','Illustrated reference books publisher'),
('Lonely Planet','Travel guide book publisher'),
('National Geographic Books','Publisher of science and travel books'),
('O''Reilly Media','Technology and programming publisher'),
('No Starch Press','Programming and tech books publisher'),
('Apress','Technology and developer-focused publisher'),
('Packt Publishing','IT and software development publisher');
GO


INSERT INTO Books (title, author, description, price, original_price, stock, image_url, category_id, publisher_id) VALUES
('The Silent Patient','Alex Michaelides','Psychological thriller novel',185000,220000,40,'book1.jpg',4,1),
('Atomic Habits','James Clear','Guide to building good habits',210000,250000,35,'book2.jpg',10,2),
('The Midnight Library','Matt Haig','Fantasy fiction novel',195000,230000,30,'book3.jpg',3,3),
('Deep Work','Cal Newport','Focus and productivity guide',200000,240000,28,'book4.jpg',10,4),
('Clean Code','Robert C. Martin','Software craftsmanship guide',320000,380000,25,'book5.jpg',19,5),
('The Lean Startup','Eric Ries','Startup methodology book',260000,300000,22,'book6.jpg',16,6),
('Thinking, Fast and Slow','Daniel Kahneman','Psychology and decision making',240000,280000,18,'book7.jpg',11,7),
('Sapiens','Yuval Noah Harari','History of humankind',230000,270000,26,'book8.jpg',46,8),
('Rich Dad Poor Dad','Robert Kiyosaki','Personal finance book',190000,230000,33,'book9.jpg',17,9),
('Harry Potter and the Sorcerer''s Stone','J.K. Rowling','Fantasy adventure novel',180000,220000,50,'book10.jpg',3,10),

('The Hobbit','J.R.R. Tolkien','Classic fantasy novel',210000,250000,20,'book11.jpg',3,11),
('The Pragmatic Programmer','Andrew Hunt','Programming best practices',340000,400000,15,'book12.jpg',19,12),
('Dune','Frank Herbert','Epic science fiction novel',220000,260000,19,'book13.jpg',2,13),
('The Power of Now','Eckhart Tolle','Spiritual self-help book',175000,210000,27,'book14.jpg',41,14),
('1984','George Orwell','Dystopian political novel',160000,190000,42,'book15.jpg',43,15),
('The Psychology of Money','Morgan Housel','Financial mindset book',200000,240000,29,'book16.jpg',17,16),
('Zero to One','Peter Thiel','Startup philosophy',215000,250000,23,'book17.jpg',16,17),
('The Alchemist','Paulo Coelho','Philosophical fiction novel',170000,200000,34,'book18.jpg',1,18),
('To Kill a Mockingbird','Harper Lee','Classic American novel',165000,200000,31,'book19.jpg',1,19),
('The Art of War','Sun Tzu','Ancient military strategy',150000,180000,45,'book20.jpg',12,20),

('Cracking the Coding Interview','Gayle McDowell','Technical interview guide',350000,420000,14,'book21.jpg',19,21),
('The Subtle Art of Not Giving a F*ck','Mark Manson','Self improvement book',195000,230000,36,'book22.jpg',10,22),
('Educated','Tara Westover','Memoir',180000,220000,17,'book23.jpg',9,23),
('The Da Vinci Code','Dan Brown','Mystery thriller novel',175000,210000,25,'book24.jpg',4,24),
('The Girl on the Train','Paula Hawkins','Thriller novel',168000,200000,21,'book25.jpg',4,25),
('A Brief History of Time','Stephen Hawking','Cosmology book',230000,270000,16,'book26.jpg',24,26),
('The Design of Everyday Things','Don Norman','Design principles book',240000,280000,20,'book27.jpg',31,27),
('The Name of the Wind','Patrick Rothfuss','Epic fantasy novel',210000,250000,18,'book28.jpg',3,28),
('Gone Girl','Gillian Flynn','Psychological thriller',175000,210000,24,'book29.jpg',4,29),
('The Catcher in the Rye','J.D. Salinger','Classic coming-of-age novel',155000,185000,32,'book30.jpg',1,30),

('The Shining','Stephen King','Horror novel',180000,220000,26,'book31.jpg',7,31),
('The Road','Cormac McCarthy','Post-apocalyptic fiction',165000,195000,22,'book32.jpg',2,32),
('Good to Great','Jim Collins','Business leadership book',250000,300000,19,'book33.jpg',15,33),
('Steve Jobs','Walter Isaacson','Biography of Steve Jobs',260000,300000,15,'book34.jpg',8,34),
('The Martian','Andy Weir','Science fiction survival story',205000,240000,23,'book35.jpg',2,35),
('Thinking in Java','Bruce Eckel','Java programming book',330000,380000,12,'book36.jpg',19,36),
('The Intelligent Investor','Benjamin Graham','Investment classic',275000,320000,14,'book37.jpg',17,37),
('Start with Why','Simon Sinek','Leadership and motivation',220000,260000,20,'book38.jpg',15,38),
('The Hunger Games','Suzanne Collins','Young adult dystopian novel',190000,230000,28,'book39.jpg',37,39),
('Dracula','Bram Stoker','Classic gothic horror novel',150000,180000,35,'book40.jpg',7,40),

('The Little Prince','Antoine de Saint-Exupéry','Children''s philosophical tale',140000,170000,40,'book41.jpg',36,41),
('Sherlock Holmes: The Complete Collection','Arthur Conan Doyle','Detective stories',300000,350000,13,'book42.jpg',4,42),
('Meditations','Marcus Aurelius','Stoic philosophy',160000,190000,29,'book43.jpg',12,43),
('The Kite Runner','Khaled Hosseini','Historical fiction novel',175000,210000,24,'book44.jpg',6,44),
('Brave New World','Aldous Huxley','Dystopian fiction novel',165000,200000,27,'book45.jpg',2,45),
('The 4-Hour Workweek','Timothy Ferriss','Lifestyle design book',210000,250000,21,'book46.jpg',16,46),
('The Theory of Everything','Stephen Hawking','Physics exploration book',230000,270000,16,'book47.jpg',24,47),
('Norwegian Wood','Haruki Murakami','Romantic fiction novel',185000,220000,30,'book48.jpg',5,48),
('The Fault in Our Stars','John Green','Young adult romance novel',175000,210000,33,'book49.jpg',37,49),
('The Lord of the Rings','J.R.R. Tolkien','Epic high fantasy novel',450000,520000,12,'book50.jpg',3,50);
GO

INSERT INTO Orders (user_id, total_amount, shipping_address, phone, payment_method, payment_status, status) VALUES
(1,185000,'New York, USA','0909000001','BANK','PAID','COMPLETED'),
(2,420000,'London, UK','0909000002','COD','UNPAID','PENDING'),
(3,195000,'Toronto, Canada','0909000003','BANK','PAID','COMPLETED'),
(4,400000,'Sydney, Australia','0909000004','COD','UNPAID','PENDING'),
(5,320000,'Madrid, Spain','0909000005','BANK','PAID','COMPLETED'),
(6,260000,'Barcelona, Spain','0909000006','BANK','PAID','COMPLETED'),
(7,240000,'Chicago, USA','0909000007','COD','UNPAID','PENDING'),
(8,230000,'Berlin, Germany','0909000008','BANK','PAID','COMPLETED'),
(9,190000,'Paris, France','0909000009','BANK','PAID','COMPLETED'),
(10,180000,'Rome, Italy','0909000010','COD','UNPAID','PENDING'),

(11,210000,'Lisbon, Portugal','0909000011','BANK','PAID','COMPLETED'),
(12,340000,'Seoul, Korea','0909000012','BANK','PAID','COMPLETED'),
(13,220000,'Tokyo, Japan','0909000013','COD','UNPAID','PENDING'),
(14,175000,'Bangkok, Thailand','0909000014','BANK','PAID','COMPLETED'),
(15,160000,'Singapore','0909000015','BANK','PAID','COMPLETED'),
(16,200000,'Kuala Lumpur','0909000016','COD','UNPAID','PENDING'),
(17,215000,'Dubai, UAE','0909000017','BANK','PAID','COMPLETED'),
(18,170000,'Los Angeles, USA','0909000018','BANK','PAID','COMPLETED'),
(19,165000,'Boston, USA','0909000019','COD','UNPAID','PENDING'),
(20,150000,'Dublin, Ireland','0909000020','BANK','PAID','COMPLETED'),

(21,350000,'Vienna, Austria','0909000021','BANK','PAID','COMPLETED'),
(22,195000,'Brussels, Belgium','0909000022','COD','UNPAID','PENDING'),
(23,180000,'Prague, Czech','0909000023','BANK','PAID','COMPLETED'),
(24,175000,'Warsaw, Poland','0909000024','BANK','PAID','COMPLETED'),
(25,168000,'Helsinki, Finland','0909000025','COD','UNPAID','PENDING'),
(26,230000,'Oslo, Norway','0909000026','BANK','PAID','COMPLETED'),
(27,240000,'Stockholm, Sweden','0909000027','BANK','PAID','COMPLETED'),
(28,210000,'Copenhagen, Denmark','0909000028','COD','UNPAID','PENDING'),
(29,175000,'Athens, Greece','0909000029','BANK','PAID','COMPLETED'),
(30,155000,'Zurich, Switzerland','0909000030','BANK','PAID','COMPLETED'),

(31,180000,'Budapest, Hungary','0909000031','COD','UNPAID','PENDING'),
(32,165000,'Istanbul, Turkey','0909000032','BANK','PAID','COMPLETED'),
(33,250000,'Jakarta, Indonesia','0909000033','BANK','PAID','COMPLETED'),
(34,260000,'Manila, Philippines','0909000034','COD','UNPAID','PENDING'),
(35,205000,'Mumbai, India','0909000035','BANK','PAID','COMPLETED'),
(36,330000,'New Delhi, India','0909000036','BANK','PAID','COMPLETED'),
(37,275000,'Santiago, Chile','0909000037','COD','UNPAID','PENDING'),
(38,220000,'Lima, Peru','0909000038','BANK','PAID','COMPLETED'),
(39,190000,'Cape Town','0909000039','BANK','PAID','COMPLETED'),
(40,150000,'Auckland','0909000040','COD','UNPAID','PENDING'),

(41,140000,'Melbourne','0909000041','BANK','PAID','COMPLETED'),
(42,300000,'Houston, USA','0909000042','BANK','PAID','COMPLETED'),
(43,160000,'Dallas, USA','0909000043','COD','UNPAID','PENDING'),
(44,175000,'Seattle, USA','0909000044','BANK','PAID','COMPLETED'),
(45,165000,'San Diego, USA','0909000045','BANK','PAID','COMPLETED'),
(46,210000,'Montreal, Canada','0909000046','COD','UNPAID','PENDING'),
(47,230000,'Ottawa, Canada','0909000047','BANK','PAID','COMPLETED'),
(48,185000,'Vancouver, Canada','0909000048','BANK','PAID','COMPLETED'),
(49,175000,'Boston, USA','0909000049','COD','UNPAID','PENDING'),
(50,450000,'New York, USA','0909000050','BANK','PAID','COMPLETED');
GO

INSERT INTO OrderDetails (order_id, book_id, price, quantity) VALUES
(1,1,185000,1),(2,2,210000,2),(3,3,195000,1),(4,4,200000,2),
(5,5,320000,1),(6,6,260000,1),(7,7,240000,1),(8,8,230000,1),
(9,9,190000,1),(10,10,180000,1),

(11,11,210000,1),(12,12,340000,1),(13,13,220000,1),(14,14,175000,1),
(15,15,160000,1),(16,16,200000,1),(17,17,215000,1),(18,18,170000,1),
(19,19,165000,1),(20,20,150000,1),

(21,21,350000,1),(22,22,195000,1),(23,23,180000,1),(24,24,175000,1),
(25,25,168000,1),(26,26,230000,1),(27,27,240000,1),(28,28,210000,1),
(29,29,175000,1),(30,30,155000,1),

(31,31,180000,1),(32,32,165000,1),(33,33,250000,1),(34,34,260000,1),
(35,35,205000,1),(36,36,330000,1),(37,37,275000,1),(38,38,220000,1),
(39,39,190000,1),(40,40,150000,1),

(41,41,140000,1),(42,42,300000,1),(43,43,160000,1),(44,44,175000,1),
(45,45,165000,1),(46,46,210000,1),(47,47,230000,1),(48,48,185000,1),
(49,49,175000,1),(50,50,450000,1);
GO


INSERT INTO Payments (order_id, payment_method, transaction_code, amount, status) VALUES
(1,'BANK','TXN0001',185000,'COMPLETED'),
(3,'BANK','TXN0003',195000,'COMPLETED'),
(5,'BANK','TXN0005',320000,'COMPLETED'),
(6,'BANK','TXN0006',260000,'COMPLETED'),
(8,'BANK','TXN0008',230000,'COMPLETED'),
(9,'BANK','TXN0009',190000,'COMPLETED'),
(11,'BANK','TXN0011',210000,'COMPLETED'),
(12,'BANK','TXN0012',340000,'COMPLETED'),
(14,'BANK','TXN0014',175000,'COMPLETED'),
(15,'BANK','TXN0015',160000,'COMPLETED'),
(17,'BANK','TXN0017',215000,'COMPLETED'),
(18,'BANK','TXN0018',170000,'COMPLETED'),
(20,'BANK','TXN0020',150000,'COMPLETED'),
(21,'BANK','TXN0021',350000,'COMPLETED'),
(23,'BANK','TXN0023',180000,'COMPLETED'),
(24,'BANK','TXN0024',175000,'COMPLETED'),
(26,'BANK','TXN0026',230000,'COMPLETED'),
(27,'BANK','TXN0027',240000,'COMPLETED'),
(29,'BANK','TXN0029',175000,'COMPLETED'),
(30,'BANK','TXN0030',155000,'COMPLETED'),
(32,'BANK','TXN0032',165000,'COMPLETED'),
(33,'BANK','TXN0033',250000,'COMPLETED'),
(35,'BANK','TXN0035',205000,'COMPLETED'),
(36,'BANK','TXN0036',330000,'COMPLETED'),
(38,'BANK','TXN0038',220000,'COMPLETED'),
(39,'BANK','TXN0039',190000,'COMPLETED'),
(41,'BANK','TXN0041',140000,'COMPLETED'),
(42,'BANK','TXN0042',300000,'COMPLETED'),
(44,'BANK','TXN0044',175000,'COMPLETED'),
(45,'BANK','TXN0045',165000,'COMPLETED'),
(47,'BANK','TXN0047',230000,'COMPLETED'),
(48,'BANK','TXN0048',185000,'COMPLETED'),
(50,'BANK','TXN0050',450000,'COMPLETED');
GO

INSERT INTO Reviews (user_id, book_id, rating, comment, created_at) VALUES
(1,1,5,N'Sách rất hay, nội dung dễ hiểu và áp dụng được ngay.','2026-01-06'),
(2,2,4,N'Kiến thức cập nhật, trình bày rõ ràng.','2026-01-07'),
(3,3,5,N'Đọc xong thấy mở mang tư duy rất nhiều.','2026-01-08'),
(4,4,3,N'Nội dung ổn nhưng hơi dài dòng ở vài chương.','2026-01-09'),
(5,5,5,N'Rất đáng tiền, sẽ mua thêm các đầu sách khác.','2026-01-10'),
(6,6,4,N'Ví dụ minh họa thực tế, dễ tiếp cận.','2026-01-11'),
(7,7,5,N'Sách in đẹp, giấy tốt, nội dung chất lượng.','2026-01-12'),
(8,8,2,N'Chưa thực sự phù hợp với nhu cầu của mình.','2026-01-13'),
(9,9,5,N'Tác giả viết rất cuốn hút.','2026-01-14'),
(10,10,4,N'Đọc khá hay, có thể tham khảo thêm bản nâng cao.','2026-01-15'),

(11,11,5,N'Giải thích chi tiết, dễ hiểu.','2026-01-16'),
(12,12,4,N'Nội dung súc tích, phù hợp người mới.','2026-01-17'),
(13,13,5,N'Đọc một mạch không dừng được.','2026-01-18'),
(14,14,3,N'Tạm ổn, chưa thực sự xuất sắc.','2026-01-19'),
(15,15,5,N'Giúp mình cải thiện kỹ năng rõ rệt.','2026-01-20'),
(16,16,4,N'Phù hợp cho sinh viên và người đi làm.','2026-01-21'),
(17,17,5,N'Thực sự đáng đọc.','2026-01-22'),
(18,18,1,N'Nội dung không như kỳ vọng.','2026-01-23'),
(19,19,5,N'Chất lượng vượt mong đợi.','2026-01-24'),
(20,20,4,N'Có nhiều insight thú vị.','2026-01-25'),

(21,21,5,N'Áp dụng được ngay vào công việc.','2026-01-26'),
(22,22,4,N'Sách trình bày logic, dễ theo dõi.','2026-01-27'),
(23,23,5,N'Nội dung truyền cảm hứng.','2026-01-28'),
(24,24,2,N'Hơi khó hiểu với người mới bắt đầu.','2026-01-29'),
(25,25,5,N'Đọc xong muốn đọc lại lần nữa.','2026-01-30'),
(26,26,4,N'Tài liệu tham khảo tốt.','2026-02-01'),
(27,27,5,N'Phần ví dụ rất sát thực tế.','2026-02-02'),
(28,28,3,N'Khá ổn nhưng cần cập nhật thêm.','2026-02-03'),
(29,29,5,N'Rất thích phong cách viết của tác giả.','2026-02-04'),
(30,30,4,N'Đáng để đọc và suy ngẫm.','2026-02-05'),

(31,31,5,N'Mình đã giới thiệu cho bạn bè cùng đọc.','2026-02-06'),
(32,32,4,N'Nội dung thực tế, không lan man.','2026-02-07'),
(33,33,5,N'Rất phù hợp với người đang tìm hướng đi mới.','2026-02-08'),
(34,34,3,N'Đọc được nhưng chưa thật sự nổi bật.','2026-02-09'),
(35,35,5,N'Sách mang lại nhiều giá trị.','2026-02-10'),
(36,36,4,N'Phần cuối hơi vội nhưng tổng thể ổn.','2026-02-11'),
(37,37,5,N'Thực sự đáng để đầu tư thời gian.','2026-02-12'),
(38,38,2,N'Nội dung hơi khó tiếp cận.','2026-02-13'),
(39,39,5,N'Giúp mình thay đổi cách nhìn vấn đề.','2026-02-14'),
(40,40,4,N'Sách chất lượng, giao hàng nhanh.','2026-02-15'),

(41,41,5,N'Đọc xong thấy rất thỏa mãn.','2026-02-16'),
(42,42,4,N'Khá bổ ích.','2026-02-17'),
(43,43,5,N'Nội dung sâu sắc và thực tế.','2026-02-18'),
(44,44,3,N'Bình thường, không quá đặc biệt.','2026-02-19'),
(45,45,5,N'Rất thích cuốn này.','2026-02-20'),
(46,46,4,N'Thích hợp để làm tài liệu tham khảo.','2026-02-21'),
(47,47,5,N'Sẽ ủng hộ thêm các đầu sách khác.','2026-02-22'),
(48,48,2,N'Không hợp gu đọc của mình.','2026-02-23'),
(49,49,5,N'Nội dung rất truyền động lực.','2026-02-24'),
(50,50,4,N'Đáng mua và trải nghiệm.','2026-02-25');

INSERT INTO Carts (user_id, created_at) VALUES
(1,'2026-02-01'),
(2,'2026-02-01'),
(3,'2026-02-02'),
(4,'2026-02-02'),
(5,'2026-02-03'),
(6,'2026-02-03'),
(7,'2026-02-04'),
(8,'2026-02-04'),
(9,'2026-02-05'),
(10,'2026-02-05'),

(11,'2026-02-06'),
(12,'2026-02-06'),
(13,'2026-02-07'),
(14,'2026-02-07'),
(15,'2026-02-08'),
(16,'2026-02-08'),
(17,'2026-02-09'),
(18,'2026-02-09'),
(19,'2026-02-10'),
(20,'2026-02-10'),

(21,'2026-02-11'),
(22,'2026-02-11'),
(23,'2026-02-12'),
(24,'2026-02-12'),
(25,'2026-02-13'),
(26,'2026-02-13'),
(27,'2026-02-14'),
(28,'2026-02-14'),
(29,'2026-02-15'),
(30,'2026-02-15'),

(31,'2026-02-16'),
(32,'2026-02-16'),
(33,'2026-02-17'),
(34,'2026-02-17'),
(35,'2026-02-18'),
(36,'2026-02-18'),
(37,'2026-02-19'),
(38,'2026-02-19'),
(39,'2026-02-20'),
(40,'2026-02-20'),

(41,'2026-02-21'),
(42,'2026-02-21'),
(43,'2026-02-22'),
(44,'2026-02-22'),
(45,'2026-02-23'),
(46,'2026-02-23'),
(47,'2026-02-24'),
(48,'2026-02-24'),
(49,'2026-02-25'),
(50,'2026-02-25');


INSERT INTO CartItems (cart_id, book_id, quantity) VALUES
(1,5,1),(1,12,2),
(2,8,1),
(3,3,1),(3,15,2),
(4,7,1),
(5,20,1),(5,9,1),(5,2,2),
(6,11,1),
(7,14,2),
(8,22,1),(8,6,1),
(9,9,1),
(10,18,2),(10,4,1),

(11,1,1),(11,25,1),
(12,13,2),
(13,30,1),
(14,16,1),(14,8,2),
(15,40,1),
(16,21,2),
(17,44,1),
(18,5,1),(18,28,1),
(19,19,2),
(20,50,1),

(21,22,1),(21,7,1),
(22,10,2),
(23,27,1),
(24,29,1),(24,6,1),
(25,35,2),
(26,41,1),
(27,13,1),(27,3,1),
(28,4,2),
(29,37,1),
(30,48,1),(30,15,2),

(31,11,1),
(32,17,1),(32,23,1),
(33,26,2),
(34,42,1),
(35,45,1),(35,2,1),
(36,38,2),
(37,34,1),
(38,18,1),
(39,24,2),
(40,14,1),(40,30,1),

(41,31,1),
(42,23,2),
(43,39,1),
(44,28,1),(44,9,1),
(45,46,2),
(46,32,1),
(47,36,1),(47,12,1),
(48,47,2),
(49,49,1),
(50,43,1),(50,20,1);

INSERT INTO Discounts
(code, description, discount_percent, discount_amount, min_order_value, start_date, end_date, status)
VALUES
('WELCOME10',N'Giảm 10% cho khách hàng mới',10,NULL,100000,'2026-01-01','2026-12-31',1),
('FREESHIP50',N'Giảm 50.000đ cho đơn từ 300k',NULL,50000,300000,'2026-01-01','2026-06-30',1),
('STUDENT15',N'Giảm 15% cho sinh viên',15,NULL,150000,'2026-01-01','2026-12-31',1),
('SPRING20',N'Khuyến mãi mùa xuân 20%',20,NULL,200000,'2026-03-01','2026-05-31',1),
('BOOKLOVER5',N'Giảm 5% toàn bộ sách',5,NULL,0,'2026-01-01','2026-12-31',1),

('FLASH30',N'Flash sale giảm 30%',30,NULL,500000,'2026-04-01','2026-04-10',1),
('NEWUSER50K',N'Tặng 50k cho người dùng mới',NULL,50000,200000,'2026-01-01','2026-12-31',1),
('VIP25',N'Giảm 25% cho khách VIP',25,NULL,400000,'2026-01-01','2026-12-31',1),
('SUMMER15',N'Ưu đãi mùa hè 15%',15,NULL,250000,'2026-06-01','2026-08-31',1),
('BACK2SCHOOL',N'Giảm 20% mùa tựu trường',20,NULL,300000,'2026-08-01','2026-09-15',1),

('BLACKFRIDAY',N'Siêu sale Black Friday 40%',40,NULL,500000,'2026-11-20','2026-11-30',1),
('CYBERMONDAY',N'Giảm 35% Cyber Monday',35,NULL,400000,'2026-11-28','2026-12-02',1),
('HOLIDAY10',N'Giảm 10% dịp lễ cuối năm',10,NULL,100000,'2026-12-01','2026-12-31',1),
('MEGADEAL',N'Giảm trực tiếp 100.000đ',NULL,100000,600000,'2026-07-01','2026-07-07',1),
('LIMITED5K',N'Giảm 5.000đ không giới hạn đơn',NULL,5000,0,'2026-01-01','2026-12-31',1);

INSERT INTO OrderDiscounts (order_id, discount_id, discount_value) VALUES
(1,1,20000),
(2,2,50000),
(3,3,45000),
(4,5,15000),
(5,1,30000),

(6,7,50000),
(7,8,120000),
(8,4,60000),
(9,10,75000),
(10,5,10000),

(11,6,150000),
(12,3,30000),
(13,1,25000),
(14,9,50000),
(15,14,100000),

(16,2,50000),
(17,4,80000),
(18,5,12000),
(19,7,50000),
(20,1,40000);

INSERT INTO Wishlists (user_id, book_id)
VALUES
(1, 3),
(1, 5),
(2, 1),
(3, 4),
(4, 2);

-- DROP TABLE   drop table Teachers

-- drop table students

--  drop table Enrollments

--  drop table courses