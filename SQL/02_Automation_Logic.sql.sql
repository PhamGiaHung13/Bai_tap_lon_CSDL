-- FILE 2: BỘ KÍCH HOẠT TỰ ĐỘNG (AUTOMATION LOGIC)

USE QuanLyNhaHang;
GO


-- 1. TRIGGER: TỰ ĐỘNG CẬP NHẬT TRẠNG THÁI BÀN
-- is_paid=0 -> Bàn thành 'Occupied' (Có khách).
-- is_paid=1 -> Bàn thành 'Available' (Trống).

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_UpdateTableStatus')
    DROP TRIGGER trg_UpdateTableStatus;
GO

CREATE TRIGGER trg_UpdateTableStatus ON Orders AFTER INSERT, UPDATE AS 
BEGIN
    SET NOCOUNT ON;

    -- Khách mới vào bàn
    UPDATE Tables
    SET status = 'Occupied'
    FROM Tables T
    INNER JOIN inserted I ON T.table_id = I.table_id
    WHERE I.is_paid = 0;

    -- Khách thanh toán xong
    UPDATE Tables
    SET status = 'Available'
    FROM Tables T
    INNER JOIN inserted I ON T.table_id = I.table_id
    WHERE I.is_paid = 1;
    
    PRINT N'Hệ thống: Trạng thái bàn đã được cập nhật tự động.';
END;
GO


-- 2. TRIGGER: TỰ ĐỘNG TÍNH TỔNG TIỀN HÓA ĐƠN
-- Mỗi khi thêm/sửa/xóa món trong OrderDetails, tổng tiền trong bảng Bills
-- sẽ tự động cộng dồn lại theo công thức: SUM(quantity * price).

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_AutoUpdateBillTotal')
    DROP TRIGGER trg_AutoUpdateBillTotal;
GO

CREATE TRIGGER trg_AutoUpdateBillTotal ON OrderDetails AFTER INSERT, UPDATE, DELETE AS 
BEGIN
    SET NOCOUNT ON;
    UPDATE Bills
    SET total_amount = (
        SELECT ISNULL(SUM(quantity * price), 0)
        FROM OrderDetails
        WHERE OrderDetails.order_id = Bills.order_id
    )
    WHERE order_id IN (
        SELECT order_id FROM inserted
        UNION
        SELECT order_id FROM deleted
    );

    PRINT N'Hệ thống: Tổng tiền hóa đơn đã được tính toán lại.';
END;
GO