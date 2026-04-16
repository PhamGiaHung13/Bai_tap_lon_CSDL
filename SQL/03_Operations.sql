-- FILE 3: NGHIỆP VỤ NHÀ HÀNG (STORED PROCEDURES)

USE QuanLyNhaHang;
GO

-- 1. MỞ BÀN MỚI
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_MoBanMoi')
    DROP PROCEDURE sp_MoBanMoi;
GO

CREATE PROCEDURE sp_MoBanMoi
    @MaBan INT,
    @MaNV INT,
    @MaKH INT = NULL 
AS
BEGIN
    SET NOCOUNT ON;
    -- KIỂM TRA: Nhân viên có phải là 'Phục vụ' không?
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE staff_id = @MaNV AND role = N'Phục vụ')
    BEGIN
        PRINT N'Lỗi: Nhân viên mã ' + CAST(@MaNV AS VARCHAR) + N' không có nhiệm vụ Phục vụ bàn!';
        RETURN;
    END

    -- KIỂM TRA: Nếu bàn đang có khách (Occupied) thì không cho phép mở thêm đơn mới
    IF EXISTS (SELECT 1 FROM Tables WHERE table_id = @MaBan AND status = 'Occupied')
    BEGIN
        PRINT N'Lỗi: Bàn số ' + CAST(@MaBan AS VARCHAR) + N' hiện đang có khách. Vui lòng thanh toán hoặc chọn bàn khác!';
        RETURN;
    END

    -- Nếu bàn trống, tiến hành tạo đơn hàng mới
    INSERT INTO Orders (table_id, staff_id, customer_id, order_date, is_paid)
    VALUES (@MaBan, @MaNV, @MaKH, GETDATE(), 0);
    DECLARE @NewOrderId INT = SCOPE_IDENTITY();
    
    INSERT INTO Bills (order_id, total_amount, payment_method)
    VALUES (@NewOrderId, 0, N'Chưa thanh toán');
    
    PRINT N'>>> Đã mở bàn số ' + CAST(@MaBan AS VARCHAR) + N' thành công! MÃ ĐƠN MỚI LÀ: ' + CAST(@NewOrderId AS VARCHAR);
END;
GO

-- 2.GỌI MÓN (THÊM MÓN VÀO ĐƠN)
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_GoiMon')
    DROP PROCEDURE sp_GoiMon;
GO

CREATE PROCEDURE sp_GoiMon
    @MaDon INT,
    @MaMon INT,
    @SoLuong INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @GiaHienTai DECIMAL(18,2);
    SELECT @GiaHienTai = price FROM MenuItems WHERE menu_id = @MaMon;

    IF @GiaHienTai IS NULL
    BEGIN
        PRINT N'Lỗi: Mã món ăn không tồn tại!';
        RETURN;
    END

    INSERT INTO OrderDetails (order_id, menu_id, quantity, price)
    VALUES (@MaDon, @MaMon, @SoLuong, @GiaHienTai);
    
    PRINT N'>>> Đã thêm món vào đơn hàng số ' + CAST(@MaDon AS VARCHAR);
END;
GO

-- 3. THANH TOÁN
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThanhToan')
    DROP PROCEDURE sp_ThanhToan;
GO

CREATE PROCEDURE sp_ThanhToan
    @MaDon INT,
    @PhuongThuc NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TongTien DECIMAL(18,2);
    SELECT @TongTien = ISNULL(SUM(quantity * price), 0) 
    FROM OrderDetails 
    WHERE order_id = @MaDon;

    -- Cập nhật trạng thái trả tiền
    UPDATE Orders 
    SET is_paid = 1 
    WHERE order_id = @MaDon;

    -- Cập nhật phương thức thanh toán, ngày giờ và chốt tổng tiền
    UPDATE Bills
    SET payment_method = @PhuongThuc,
        payment_date = GETDATE(),
        total_amount = @TongTien
    WHERE order_id = @MaDon;

    PRINT N'>>> Đã thanh toán xong đơn hàng số ' + CAST(@MaDon AS VARCHAR) + N'. Tổng tiền: ' + FORMAT(@TongTien, 'N0') + ' đ';
END;
GO

-- 4. THÊM NHÂN VIÊN MỚI
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThemNhanVien') DROP PROCEDURE sp_ThemNhanVien;
GO

CREATE PROCEDURE sp_ThemNhanVien
    @TenNV NVARCHAR(100), @ChucVu NVARCHAR(50), @SDT VARCHAR(15)
AS
BEGIN
    INSERT INTO Staff (name, role, phone) VALUES (@TenNV, @ChucVu, @SDT);
    PRINT N'>>> Đã thêm nhân viên: ' + @TenNV;
END;
GO

-- 5. THÊM MÓN ĂN MỚI
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThemMonAn') DROP PROCEDURE sp_ThemMonAn;
GO

CREATE PROCEDURE sp_ThemMonAn
    @TenMon NVARCHAR(100), @Gia DECIMAL(18,2), @Loai NVARCHAR(50)
AS
BEGIN
    IF @Gia < 0 BEGIN PRINT N'Lỗi: Giá không hợp lệ!'; RETURN; END
    INSERT INTO MenuItems (name, price, category) VALUES (@TenMon, @Gia, @Loai);
    PRINT N'>>> Đã thêm món: ' + @TenMon;
END;
GO

-- 6. THÊM KHÁCH HÀNG MỚI
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThemKhachHang') DROP PROCEDURE sp_ThemKhachHang;
GO

CREATE PROCEDURE sp_ThemKhachHang
    @TenKH NVARCHAR(100), @SDT VARCHAR(15)
AS
BEGIN
    INSERT INTO Customers (name, phone) VALUES (@TenKH, @SDT);
    PRINT N'>>> Đã thêm khách hàng: ' + @TenKH;
END;
GO

-- 7. XÓA MÓN KHỎI ĐƠN HÀNG (HỦY MÓN)
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_HuyMon') DROP PROCEDURE sp_HuyMon;
GO

CREATE PROCEDURE sp_HuyMon
    @MaDon INT,
    @MaMon INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Chỉ cho phép xóa khi đơn hàng chưa thanh toán
    IF EXISTS (SELECT 1 FROM Orders WHERE order_id = @MaDon AND is_paid = 1)
    BEGIN
        PRINT N'Lỗi: Đơn hàng đã thanh toán, không thể xóa món!';
        RETURN;
    END

    DELETE FROM OrderDetails WHERE order_id = @MaDon AND menu_id = @MaMon;
    PRINT N'>>> Đã xóa món ăn khỏi đơn hàng số ' + CAST(@MaDon AS VARCHAR);
END;
GO

-- 8. HỦY TOÀN BỘ ĐƠN HÀNG
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_HuyDonHang') DROP PROCEDURE sp_HuyDonHang;
GO

CREATE PROCEDURE sp_HuyDonHang
    @MaDon INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra trạng thái
    IF EXISTS (SELECT 1 FROM Orders WHERE order_id = @MaDon AND is_paid = 1)
    BEGIN
        PRINT N'Lỗi: Đơn hàng đã thanh toán, không thể hủy!';
        RETURN;
    END

    -- Phải xóa theo thứ tự để không bị lỗi khóa ngoại (Foreign Key)
    DELETE FROM OrderDetails WHERE order_id = @MaDon;
    DELETE FROM Bills WHERE order_id = @MaDon;
    DELETE FROM Orders WHERE order_id = @MaDon;

    PRINT N'>>> Đã hủy toàn bộ đơn hàng số ' + CAST(@MaDon AS VARCHAR);
END;
GO