-- FILE 1: THIẾT KẾ CẤU TRÚC VÀ KHỞI TẠO DỮ LIỆU

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'QuanLyNhaHang')
BEGIN
    ALTER DATABASE QuanLyNhaHang SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QuanLyNhaHang;
END
GO

CREATE DATABASE QuanLyNhaHang;
GO
USE QuanLyNhaHang;
GO

-- 1. TẠO BẢNG
CREATE TABLE Tables (
    table_id INT IDENTITY(1,1) PRIMARY KEY,
    table_name NVARCHAR(50) NOT NULL,
    status NVARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Reserved')));

CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    role NVARCHAR(50),
    phone VARCHAR(15));

CREATE TABLE Customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100));

CREATE TABLE MenuItems (
    menu_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(18, 2) NOT NULL CHECK (price >= 0),
    category NVARCHAR(50));

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    table_id INT FOREIGN KEY REFERENCES Tables(table_id),
    staff_id INT FOREIGN KEY REFERENCES Staff(staff_id),
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATETIME DEFAULT GETDATE(),
    is_paid BIT DEFAULT 0);

CREATE TABLE OrderDetails (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    menu_id INT FOREIGN KEY REFERENCES MenuItems(menu_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(18, 2) NOT NULL);

CREATE TABLE Bills (
    bill_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT UNIQUE FOREIGN KEY REFERENCES Orders(order_id),
    total_amount DECIMAL(18, 2) DEFAULT 0,
    payment_method NVARCHAR(50),
    payment_date DATETIME DEFAULT GETDATE());

CREATE TABLE StaffShifts (
    shift_id INT IDENTITY(1,1) PRIMARY KEY,
    staff_id INT NOT NULL FOREIGN KEY REFERENCES Staff(staff_id),
    start_time DATETIME,
    end_time DATETIME);
GO



-- 2. NẠP DỮ LIỆU MẪU 

SET IDENTITY_INSERT [dbo].[Bills] OFF;
SET IDENTITY_INSERT [dbo].[Orders] OFF;
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF;
SET IDENTITY_INSERT [dbo].[StaffShifts] OFF;


-- Bàn ăn
SET IDENTITY_INSERT [dbo].[Tables] ON 
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (1, N'Bàn số 1', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (2, N'Bàn số 2', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (3, N'Bàn VIP 01', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (4, N'Bàn VIP 02', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (5, N'Bàn sân vườn 01', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (6, N'Bàn sân vườn 02', N'Available')

INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (7, N'Bàn số 3', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (8, N'Bàn số 4', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (9, N'Bàn VIP 02', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (10, N'Bàn VIP 03', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (11, N'Bàn sân vườn 03', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (12, N'Bàn sân vườn 04', N'Available')

INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (13, N'Bàn số 5', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (14, N'Bàn số 6', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (15, N'Bàn VIP 05', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (16, N'Bàn VIP 06', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (17, N'Bàn sân vườn 05', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (18, N'Bàn sân vườn 06', N'Available')

SET IDENTITY_INSERT [dbo].[Tables] OFF
GO

-- Nhân viên
SET IDENTITY_INSERT [dbo].[Staff] ON 
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (1, N'Trần Thị Bình', N'Phục vụ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (2, N'Lê Văn Cường', N'Thu ngân')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (3, N'Nguyễn Thị Hoa', N'Phục vụ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (4, N'Đặng Hùng Dũng', N'Bếp phó')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (5, N'Vũ Hải Yến', N'Quản lý')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (6, N'Trương Công Thành', N'Bếp phó')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (7, N'Nguyễn Bảo Ngọc', N'Phục vụ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (8, N'Lý Hải Đăng', N'Bảo vệ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (9, N'Nguyễn Đình Khải', N'Quản lý')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (10, N'Nguyễn Thị Linh', N'Bartender')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (11, N'Phạm Gia Hưng', N'Bếp trưởng')
SET IDENTITY_INSERT [dbo].[Staff] OFF
GO

-- Khách hàng
SET IDENTITY_INSERT [dbo].[Customers] ON 
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (1, N'Nguyễn Văn An', N'0901234567', N'an@gmail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (2, N'Lê Minh Tâm', N'0912345678', N'tam.le@hotail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (3, N'Phạm Mỹ Linh', N'0988776655', N'linh.pham@gmail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (4, N'Hoàng Gia Bảo', N'0971122334', N'bao.hoang@yahoo.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (5, N'Trần Thanh Hải', N'0945112233', N'hai.tran@gmail.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (6, N'Đặng Thu Thảo', N'0966889900', N'thao.dang@outlook.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (7, N'Bùi Quang Huy', N'0355443322', N'huyquang@vnn.vn');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (8, N'Vũ Phương Mai', N'0333998877', N'maivu.phuong@gmail.com');

INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (9, N'Lò Hoàng Hải', N'0111111111', N'hailo@gmail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (10, N'Nguyễn Việt Tuấn', N'0222222222', N'Tuanngu@hotail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (11, N'Từ Hoàng Thanh', N'0333333333', N'TuThanh@gmail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (12, N'Nguyễn Minh Triết', N'0992345678', N'triet.nguyen@gmail.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (13, N'Lê Thị Mai Chi', N'0987654321', N'maichi.le@hotmail.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (14, N'Phạm Hồng Đăng', N'0905112233', N'dangpham@yahoo.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (15, N'Ngô Bảo Châu', N'0944556677', N'chaungo.math@edu.vn');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (16, N'Trịnh Kim Chi', N'0322114455', N'kimchi.trinh@outlook.com');

INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (17, N'Lý Hoàng Nam', N'0909123456', N'nam.lyhoang@icloud.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (18, N'Võ Thị Sáu', N'0933445566', N'sauvo.77@gmail.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (19, N'Đỗ Hùng Dũng', N'0911222333', N'dungdo.captain@vff.vn');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (20, N'Nguyễn Thúc Thùy Tiên', N'0977888999', N'thuytien.ng@missgrand.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (21, N'Phan Mạnh Quỳnh', N'0388776655', N'quynhphan.music@gmail.com');

INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (22, N'Đặng Văn Lâm', N'0911000111', N'lam.dang@vnff.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (23, N'Nguyễn Quang Hải', N'0911000222', N'hai.con@pau.fr');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (24, N'Đoàn Văn Hậu', N'0911000333', N'hau.doan@hanoi.vn');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (25, N'Nguyễn Tiến Linh', N'0911000444', N'linh.tien@bd.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (26, N'Quế Ngọc Hải', N'0911000555', N'hai.que@slna.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (27, N'Nguyễn Văn Toàn', N'0911000666', N'toan.vato@korea.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (28, N'Nguyễn Công Phượng', N'0911000777', N'phuong.cp10@japan.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (29, N'Bùi Tiến Dũng', N'0911000888', N'dung.bui@viettel.vn');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (30, N'Phan Văn Đức', N'0911000999', N'duc.phan@slna.com');
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (31, N'Hồ Tấn Tài', N'0911000123', N'tai.ho@ca.com');
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO

-- Thực đơn
SET IDENTITY_INSERT [dbo].[MenuItems] ON 
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (1, N'Phở Bò', CAST(55000.00 AS Decimal(18, 2)), N'Món chính')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (2, N'Cà phê', CAST(25000.00 AS Decimal(18, 2)), N'Đồ uống')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (3, N'Bún Chả Hà Nội', CAST(65000.00 AS Decimal(18, 2)), N'Món Chính')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (4, N'Gỏi Cuốn', CAST(30000.00 AS Decimal(18, 2)), N'Khai vị')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (5, N'Chả Giò', CAST(45000.00 AS Decimal(18, 2)), N'Khai vị')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (6, N'Trà Đào Cam Sả', CAST(35000.00 AS Decimal(18, 2)), N'Đồ uống')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (7, N'Bánh Flan', CAST(20000.00 AS Decimal(18, 2)), N'Tráng miệng')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (8, N'Khoai Tây Chiên', CAST(35000.00 AS Decimal(18, 2)), N'Ăn vặt')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (9, N'Ngô Chiên Bơ', CAST(30000.00 AS Decimal(18, 2)), N'Ăn vặt')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (10, N'Mực Khô Nướng', CAST(120000.00 AS Decimal(18, 2)), N'Đồ nhắm')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (11, N'Lẩu Thái Hải Sản', CAST(350000.00 AS Decimal(18, 2)), N'Lẩu')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (12, N'Kem Trái Dừa', CAST(45000.00 AS Decimal(18, 2)), N'Tráng miệng')

INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (13, N'Bún Đậu Mắm Tôm', CAST(75000.00 AS Decimal(18, 2)), N'Món chính');
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (14, N'Cơm Tấm Sườn Bì', CAST(45000.00 AS Decimal(18, 2)), N'Món chính');
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (15, N'Nước Ép Dưa Hấu', CAST(30000.00 AS Decimal(18, 2)), N'Đồ uống');
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (16, N'Súp Tóc Tiên', CAST(35000.00 AS Decimal(18, 2)), N'Khai vị');
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (17, N'Bò Kho Bánh Mì', CAST(60000.00 AS Decimal(18, 2)), N'Món chính');
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (18, N'Chè Khúc Bạch', CAST(25000.00 AS Decimal(18, 2)), N'Tráng miệng');
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (19, N'Chân Gà Sả Tắc', CAST(65000.00 AS Decimal(18, 2)), N'Ăn vặt');
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (20, N'Lẩu Nấm Chay', CAST(280000.00 AS Decimal(18, 2)), N'Lẩu');
SET IDENTITY_INSERT [dbo].[MenuItems] OFF
GO

-- Đơn hàng mẫu 
SET IDENTITY_INSERT [dbo].[Orders] ON 
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (1, 1, 1, 1, CAST(N'2026-04-02T10:38:14.077' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (2, 3, 3, 2, CAST(N'2026-04-02T10:43:40.760' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (3, 4, 4, 3, CAST(N'2026-04-02T11:30:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (4, 2, 1, 4, CAST(N'2026-04-02T12:15:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (5, 5, 2, 5, CAST(N'2026-04-02T18:00:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (6, 6, 3, 6, CAST(N'2026-04-02T19:00:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (7, 1, 1, 7, CAST(N'2026-04-02T20:30:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (8, 8, 2, 8, CAST(N'2026-04-02T21:00:00.000' AS DateTime), 1)



INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (9, 2, 1, 9, CAST(N'2026-04-22T08:30:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (10, 3, 2, 10, CAST(N'2026-04-22T09:15:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (11, 5, 3, 11, CAST(N'2026-04-22T10:00:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (12, 1, 1, 12, CAST(N'2026-04-22T11:45:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (13, 4, 4, 13, CAST(N'2026-04-22T12:30:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (14, 6, 2, 14, CAST(N'2026-04-22T13:00:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (15, 7, 3, 15, CAST(N'2026-04-22T17:20:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (16, 2, 1, 16, CAST(N'2026-04-22T18:00:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (17, 8, 4, 17, CAST(N'2026-04-22T18:45:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (18, 9, 2, 18, CAST(N'2026-04-22T19:30:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (19, 3, 3, 19, CAST(N'2026-04-22T20:00:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (20, 10, 1, 20, CAST(N'2026-04-22T20:30:00' AS DateTime), 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (21, 5, 2, 21, CAST(N'2026-04-22T21:15:00' AS DateTime), 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (22, 1, 1, 22, '2026-04-22T10:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (23, 2, 2, 23, '2026-04-22T11:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (24, 3, 3, 24, '2026-04-22T12:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (25, 4, 1, 25, '2026-04-22T13:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (26, 5, 2, 26, '2026-04-22T14:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (27, 6, 3, 27, '2026-04-22T15:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (28, 7, 1, 28, '2026-04-22T16:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (29, 8, 2, 29, '2026-04-22T17:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (30, 9, 3, 30, '2026-04-22T18:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (31, 10, 1, 31, '2026-04-22T19:00:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (32, 1, 1, 22, '2026-04-20T10:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (33, 2, 2, 23, '2026-04-20T14:20:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (34, 3, 3, 24, '2026-04-20T19:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (35, 4, 1, 25, '2026-04-21T08:15:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (36, 5, 2, 26, '2026-04-21T12:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (37, 6, 3, 27, '2026-04-21T18:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (38, 7, 1, 28, '2026-04-19T09:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (39, 8, 2, 29, '2026-04-19T12:45:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (40, 9, 3, 30, '2026-04-19T17:10:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (41, 10, 1, 31, '2026-04-22T20:00:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (42, 1, 1, 9, '2026-04-15T08:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (43, 5, 2, 12, '2026-04-15T12:00:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (44, 2, 3, 15, '2026-04-16T18:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (45, 4, 1, 18, '2026-04-16T19:45:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (46, 3, 2, 21, '2026-04-17T07:15:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (47, 8, 4, 10, '2026-04-17T11:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (48, 1, 1, 14, '2026-04-17T20:00:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (49, 6, 3, 11, '2026-04-18T09:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (50, 2, 2, 19, '2026-04-18T13:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (51, 7, 1, 20, '2026-04-18T18:30:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (52, 2, 1, 3, '2026-04-03T11:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (53, 4, 2, 5, '2026-04-04T18:45:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (54, 1, 3, 7, '2026-04-05T08:15:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (55, 6, 4, 10, '2026-04-06T12:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (56, 3, 1, 12, '2026-04-07T19:20:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (57, 5, 2, 15, '2026-04-08T13:10:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (58, 8, 3, 18, '2026-04-09T10:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (59, 1, 1, 2, '2026-04-10T17:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (60, 2, 2, 4, '2026-04-10T19:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (61, 9, 3, 20, '2026-04-10T21:15:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (62, 1, 1, 3, '2026-04-03T11:15:00', 1); 
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (63, 3, 2, 8, '2026-04-03T12:30:00', 1); 
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (64, 5, 3, 11, '2026-04-03T15:00:00', 1); 
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (65, 2, 1, 15, '2026-04-03T18:45:00', 1); 
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (66, 8, 4, 22, '2026-04-03T20:00:00', 1); 

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (67, 1, 1, 4, '2026-04-04T07:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (68, 2, 2, 9, '2026-04-04T12:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (69, 5, 3, 13, '2026-04-04T18:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (70, 10, 1, 25, '2026-04-04T20:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (71, 3, 2, 1, '2026-04-04T21:15:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (72, 4, 3, 10, '2026-04-05T09:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (73, 6, 1, 16, '2026-04-05T11:45:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (74, 1, 2, 2, '2026-04-05T12:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (75, 8, 3, 30, '2026-04-05T19:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (76, 2, 4, 21, '2026-04-05T20:45:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (77, 1, 1, 5, '2026-04-06T12:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (78, 3, 2, 6, '2026-04-06T12:15:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (79, 5, 3, 7, '2026-04-06T12:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (80, 2, 1, 11, '2026-04-06T18:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (81, 4, 2, 14, '2026-04-06T19:30:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (82, 2, 1, 15, '2026-04-08T08:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (83, 5, 2, 22, '2026-04-08T12:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (84, 1, 3, 3, '2026-04-08T18:15:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (85, 4, 1, 19, '2026-04-08T19:45:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (86, 7, 2, 8, '2026-04-08T20:30:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (87, 3, 3, 27, '2026-04-09T11:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (88, 6, 4, 31, '2026-04-09T13:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (89, 1, 1, 14, '2026-04-09T17:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (90, 2, 2, 23, '2026-04-09T19:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (91, 9, 3, 10, '2026-04-09T21:00:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (92, 10, 1, 2, '2026-04-10T12:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (93, 5, 2, 25, '2026-04-10T18:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (94, 1, 3, 11, '2026-04-10T19:15:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (95, 3, 1, 17, '2026-04-10T20:45:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (96, 2, 2, 9, '2026-04-10T22:00:00', 1);

INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (97, 10, 1, 2, '2026-04-11T12:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (98, 5, 2, 25, '2026-04-12T18:30:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (99, 1, 3, 11, '2026-04-13T19:15:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (100, 3, 1, 17, '2026-04-14T20:45:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (101, 2, 2, 9, '2026-04-15T22:00:00', 1);
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (102, 2, 1, 4, CAST(N'2026-04-16T12:15:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (103, 5, 2, 5, CAST(N'2026-04-17T18:00:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (104, 6, 3, 6, CAST(N'2026-04-18T19:00:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (105, 1, 1, 7, CAST(N'2026-04-19T20:30:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (106, 8, 2, 8, CAST(N'2026-04-20T21:00:00.000' AS DateTime), 1)


SET IDENTITY_INSERT [dbo].[Orders] OFF
GO

-- Chi tiết đơn hàng mẫu
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (1, 1, 1, 2, CAST(55000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (2, 2, 3, 1, CAST(65000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (3, 2, 6, 2, CAST(35000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (4, 3, 11, 1, CAST(350000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (5, 3, 1, 4, CAST(55000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (6, 3, 4, 5, CAST(25000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (7, 4, 5, 1, CAST(65000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (8, 4, 8, 1, CAST(35000.00 AS Decimal(18, 2)))

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (9, 5, 2, 2, CAST(75000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (10, 6, 4, 3, CAST(45000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (11, 7, 1, 1, CAST(55000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (12, 8, 10, 1, CAST(120000.00 AS Decimal(18, 2)))

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (13, 9, 13, 1, 75000.00);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (14, 9, 6, 1, 35000.00);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (15, 10, 14, 1, 45000.00);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (16, 10, 2, 1, 25000.00);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (17, 11, 1, 2, 55000.00);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (18, 12, 11, 1, 350000.00);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (19, 13, 4, 3, 30000.00);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (20, 14, 17, 1, 60000.00);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (21, 14, 15, 1, 30000.00);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (22, 15, 19, 2, 65000.00); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (23, 16, 10, 1, 120000.00); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (24, 17, 8, 2, 35000.00); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (25, 18, 18, 3, 25000.00); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (26, 19, 20, 1, 280000.00); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (27, 20, 12, 2, 45000.00); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (28, 21, 7, 5, 20000.00);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (29, 22, 1, 1, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (30, 23, 2, 2, 25000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (31, 24, 3, 1, 65000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (32, 25, 11, 1, 350000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (33, 26, 13, 1, 75000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (34, 27, 14, 2, 45000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (35, 28, 17, 1, 60000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (36, 29, 19, 1, 65000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (37, 30, 20, 1, 280000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (38, 31, 15, 3, 30000); 

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (39, 32, 2, 1, 25000);   
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (40, 33, 1, 2, 55000);   
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (41, 34, 11, 1, 350000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (42, 35, 13, 1, 75000);  
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (43, 36, 2, 2, 25000);  
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (44, 37, 14, 1, 45000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (45, 38, 10, 1, 120000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (46, 39, 6, 2, 35000);  
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (47, 40, 17, 1, 60000);  
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (48, 41, 20, 1, 280000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (49, 42, 3, 1, 65000);   
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (50, 43, 11, 1, 350000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (51, 44, 2, 2, 25000);  
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (52, 45, 14, 1, 45000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (53, 46, 1, 2, 55000);  
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (54, 47, 13, 1, 75000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (55, 48, 17, 1, 60000); 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (56, 49, 10, 1, 120000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (57, 50, 6, 2, 35000);   
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (58, 51, 20, 1, 280000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (59, 52, 1, 1, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (60, 52, 2, 1, 25000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (61, 53, 14, 2, 45000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (62, 54, 6, 2, 35000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (63, 55, 11, 1, 350000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (64, 55, 15, 2, 30000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (65, 56, 10, 1, 120000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (66, 57, 1, 2, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (67, 58, 14, 1, 45000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (68, 59, 11, 1, 350000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (69, 60, 10, 2, 120000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (70, 61, 2, 3, 25000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (71, 62, 6, 4, 35000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (72, 63, 13, 2, 75000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (73, 64, 1, 1, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (74, 64, 2, 1, 25000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (75, 65, 20, 1, 280000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (76, 66, 17, 1, 60000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (77, 67, 1, 1, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (78, 68, 1, 1, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (79, 69, 1, 1, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (80, 70, 14, 1, 45000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (81, 71, 10, 1, 120000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (82, 72, 2, 1, 25000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (83, 73, 1, 2, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (84, 74, 11, 1, 350000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (85, 75, 6, 2, 35000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (86, 76, 17, 1, 60000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (87, 77, 14, 2, 45000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (88, 78, 13, 1, 75000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (89, 79, 3, 1, 65000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (90, 80, 20, 1, 280000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (91, 81, 10, 1, 120000);

INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (92, 82, 1, 3, 55000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (93, 83, 11, 2, 350000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (94, 83, 6, 5, 35000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (95, 84, 10, 2, 120000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (96, 85, 20, 1, 280000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (97, 85, 2, 4, 25000);
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (98, 86, 17, 1, 60000);


SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
GO

-- Hóa đơn mẫu
SET IDENTITY_INSERT [dbo].[Bills] ON 
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (1, 1, CAST(110000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-02T10:38:14.077' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (2, 2, CAST(135000.00 AS Decimal(18, 2)), N'Chuyển khoản', CAST(N'2026-04-02T10:43:40.760' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (3, 3, CAST(695000.00 AS Decimal(18, 2)), N'Thẻ VISA', CAST(N'2026-04-02T13:00:00.000' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (4, 4, CAST(100000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-02T10:50:02.607' AS DateTime))

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (5, 5, CAST(150000.00 AS Decimal(18, 2)), N'MoMo', CAST(N'2026-04-17T18:45:00.000' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (6, 6, CAST(135000.00 AS Decimal(18, 2)), N'Chuyển khoản', CAST(N'2026-04-17T19:30:00.000' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (7, 7, CAST(55000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-17T20:50:00.000' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (8, 8, CAST(120000.00 AS Decimal(18, 2)), N'Thẻ VISA', CAST(N'2026-04-17T21:30:00.000' AS DateTime))

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (9, 9, CAST(110000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-22T09:00:00' AS DateTime));
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (10, 10, CAST(70000.00 AS Decimal(18, 2)), N'Chuyển khoản', CAST(N'2026-04-22T10:00:00' AS DateTime));
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (11, 11, CAST(110000.00 AS Decimal(18, 2)), N'MoMo', CAST(N'2026-04-22T10:45:00' AS DateTime));
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (12, 12, CAST(350000.00 AS Decimal(18, 2)), N'Thẻ VISA', CAST(N'2026-04-22T12:30:00' AS DateTime));
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (13, 13, CAST(90000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-22T13:15:00' AS DateTime));
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (14, 14, CAST(90000.00 AS Decimal(18, 2)), N'Chuyển khoản', CAST(N'2026-04-22T13:45:00' AS DateTime));
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (15, 15, CAST(130000.00 AS Decimal(18, 2)), N'ZaloPay', CAST(N'2026-04-22T18:00:00' AS DateTime)); 
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (16, 16, CAST(120000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-22T18:45:00' AS DateTime)); 
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (17, 17, CAST(70000.00 AS Decimal(18, 2)), N'MoMo', CAST(N'2026-04-22T19:15:00' AS DateTime)); 
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (18, 18, CAST(75000.00 AS Decimal(18, 2)), N'Thẻ VISA', CAST(N'2026-04-22T20:15:00' AS DateTime)); 
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (19, 19, CAST(280000.00 AS Decimal(18, 2)), N'Chuyển khoản', CAST(N'2026-04-22T21:00:00' AS DateTime));
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (20, 20, CAST(90000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-22T21:15:00' AS DateTime)); 
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (21, 21, CAST(100000.00 AS Decimal(18, 2)), N'MoMo', CAST(N'2026-04-22T22:00:00' AS DateTime)); 

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (22, 22, 55000, N'Tiền mặt', '2026-04-22T10:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (23, 23, 50000, N'Chuyển khoản', '2026-04-22T11:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (24, 24, 65000, N'MoMo', '2026-04-22T12:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (25, 25, 350000, N'Thẻ VISA', '2026-04-22T13:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (26, 26, 75000, N'ZaloPay', '2026-04-22T14:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (27, 27, 90000, N'Tiền mặt', '2026-04-22T15:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (28, 28, 60000, N'MoMo', '2026-04-22T16:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (29, 29, 65000, N'Chuyển khoản', '2026-04-22T17:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (30, 30, 280000, N'Thẻ VISA', '2026-04-22T18:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (31, 31, 90000, N'Tiền mặt', '2026-04-22T19:45:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (32, 97, 55000, N'Tiền mặt', '2026-04-20T11:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (33, 98, 50000, N'Chuyển khoản', '2026-04-20T14:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (34, 99, 65000, N'MoMo', '2026-04-20T19:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (35, 100, 350000, N'Thẻ VISA', '2026-04-21T09:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (36, 101, 75000, N'ZaloPay', '2026-04-21T12:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (37, 102, 90000, N'Tiền mặt', '2026-04-21T19:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (38, 103, 60000, N'MoMo', '2026-04-22T09:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (39, 104, 65000, N'Chuyển khoản', '2026-04-22T13:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (40, 105, 280000, N'Thẻ VISA', '2026-04-22T17:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (41, 106, 90000, N'Tiền mặt', '2026-04-22T20:30:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (42, 32, 25000, N'Tiền mặt', '2026-04-15T08:50:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (43, 33, 110000, N'MoMo', '2026-04-15T12:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (44, 34, 350000, N'Thẻ VISA', '2026-04-16T20:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (45, 35, 75000, N'Chuyển khoản', '2026-04-16T20:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (46, 36, 50000, N'MoMo', '2026-04-17T07:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (47, 37, 45000, N'Tiền mặt', '2026-04-17T12:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (48, 38, 120000, N'ZaloPay', '2026-04-17T21:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (49, 39, 70000, N'Chuyển khoản', '2026-04-18T09:45:00');



INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (50, 50, 70000, N'Chuyển khoản', '2026-04-10T19:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (51, 51, 280000, N'Tiền mặt', '2026-04-10T22:00:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (52, 52, 80000, N'Tiền mặt', '2026-04-03T11:50:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (53, 53, 90000, N'Chuyển khoản', '2026-04-03T13:10:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (54, 54, 70000, N'MoMo', '2026-04-03T15:20:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (55, 55, 410000, N'Thẻ VISA', '2026-04-03T20:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (56, 56, 120000, N'Tiền mặt', '2026-04-03T20:45:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (57, 57, 110000, N'Tiền mặt', '2026-04-04T08:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (58, 58, 45000, N'Chuyển khoản', '2026-04-04T12:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (59, 59, 350000, N'Thẻ VISA', '2026-04-04T19:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (60, 60, 240000, N'MoMo', '2026-04-04T20:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (61, 61, 75000, N'Tiền mặt', '2026-04-04T22:00:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (62, 62, 140000, N'ZaloPay', '2026-04-05T09:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (63, 63, 150000, N'Tiền mặt', '2026-04-05T12:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (64, 64, 80000, N'Chuyển khoản', '2026-04-05T13:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (65, 65, 280000, N'Thẻ VISA', '2026-04-05T20:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (66, 66, 60000, N'MoMo', '2026-04-05T21:15:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (67, 67, 55000, N'Tiền mặt', '2026-04-06T12:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (68, 68, 55000, N'Chuyển khoản', '2026-04-06T12:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (69, 69, 55000, N'Tiền mặt', '2026-04-06T13:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (70, 70, 45000, N'MoMo', '2026-04-06T18:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (71, 71, 120000, N'Thẻ VISA', '2026-04-06T20:15:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (72, 72, 25000, N'Tiền mặt', '2026-04-08T08:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (73, 73, 110000, N'Chuyển khoản', '2026-04-08T13:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (74, 74, 350000, N'Thẻ VISA', '2026-04-08T19:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (75, 75, 70000, N'MoMo', '2026-04-08T20:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (76, 76, 60000, N'Tiền mặt', '2026-04-08T21:00:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (77, 77, 90000, N'Tiền mặt', '2026-04-09T11:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (78, 78, 75000, N'ZaloPay', '2026-04-09T13:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (79, 79, 65000, N'Tiền mặt', '2026-04-09T18:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (80, 80, 280000, N'Thẻ VISA', '2026-04-09T20:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (81, 81, 120000, N'Chuyển khoản', '2026-04-09T21:45:00');

INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (82, 82, 165000, N'Tiền mặt', '2026-04-10T12:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (83, 83, 875000, N'Thẻ VISA', '2026-04-10T20:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (84, 84, 240000, N'MoMo', '2026-04-10T20:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (85, 85, 380000, N'Chuyển khoản', '2026-04-10T22:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (86, 86, 60000, N'Tiền mặt', '2026-04-10T22:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (87, 40, 60000, N'Tiền mặt', '2026-04-18T13:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (88, 41, 280000, N'Thẻ VISA', '2026-04-18T20:00:00');


INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (89, 42, 65000, N'Tiền mặt', '2026-04-03T12:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (90, 43, 350000, N'Thẻ VISA', '2026-04-04T20:00:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (91, 44, 50000, N'MoMo', '2026-04-05T08:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (92, 45, 45000, N'Chuyển khoản', '2026-04-06T12:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (93, 46, 110000, N'Tiền mặt', '2026-04-07T20:15:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (94, 47, 75000, N'ZaloPay', '2026-04-08T13:45:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (95, 48, 60000, N'MoMo', '2026-04-09T10:30:00');
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (96, 49, 120000, N'Thẻ VISA', '2026-04-10T18:00:00');

GO

-- Ca làm việc

SET IDENTITY_INSERT [dbo].[StaffShifts] ON 
INSERT [dbo].[StaffShifts] ([shift_id], [staff_id], [start_time], [end_time]) VALUES (1, 1, CAST(N'2026-04-02T07:00:00.000' AS DateTime), CAST(N'2026-04-02T14:00:00.000' AS DateTime))
INSERT [dbo].[StaffShifts] ([shift_id], [staff_id], [start_time], [end_time]) VALUES (2, 2, CAST(N'2026-04-02T14:00:00.000' AS DateTime), CAST(N'2026-04-02T22:00:00.000' AS DateTime))
INSERT [dbo].[StaffShifts] ([shift_id], [staff_id], [start_time], [end_time]) VALUES (3, 3, CAST(N'2026-04-02T07:00:00.000' AS DateTime), CAST(N'2026-04-02T14:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[StaffShifts] OFF
GO


PRINT N'>>> Đã khởi tạo cấu trúc và nạp dữ liệu mẫu thành công! <<<';
GO