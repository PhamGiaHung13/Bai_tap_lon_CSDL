package org.example;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;
import java.util.Vector;

public class BaoCao extends JFrame {
    private JTabbedPane tabbedPane;

    public BaoCao() {
        setTitle("FILE 4: HỆ THỐNG BÁO CÁO (MANAGER DASHBOARD)");
        setSize(1100, 650);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("Tahoma", Font.BOLD, 12));

        // --- SẮP XẾP ĐÚNG THỨ TỰ TỪ 1 ĐẾN 9 THEO FILE SQL ---

        // 1. Xem tất cả đơn hàng + Bàn + Nhân viên
        tabbedPane.addTab("1. Xem tất cả đơn hàng", createReportPanel("SELECT * FROM v_TatCaDonHang"));

        // 2. Xem chi tiết từng đơn
        tabbedPane.addTab("2. Chi tiết từng đơn", createReportPanel(
                "SELECT OD.order_id AS [Mã Đơn], M.name AS [Tên Món], OD.quantity AS [Số Lượng], " +
                        "FORMAT(OD.price, 'N0') + ' đ' AS [Đơn Giá], FORMAT(OD.quantity * OD.price, 'N0') + ' đ' AS [Thành Tiền], " +
                        "ISNULL(B.payment_method, N'Chưa trả tiền') AS [Phương Thức Thanh Toán] " +
                        "FROM OrderDetails OD JOIN MenuItems M ON OD.menu_id = M.menu_id " +
                        "LEFT JOIN Bills B ON OD.order_id = B.order_id"));

        // 3. Doanh thu theo ngày
        tabbedPane.addTab("3. Doanh thu theo ngày", createReportPanel(
                "SELECT CAST(payment_date AS DATE) AS [Ngày], COUNT(bill_id) AS [Số Hóa Đơn], " +
                        "FORMAT(SUM(total_amount), 'N0') + ' đ' AS [Tổng Doanh Thu] " +
                        "FROM Bills GROUP BY CAST(payment_date AS DATE)"));

        // 4. Món bán chạy nhất
        tabbedPane.addTab("4. Món bán chạy nhất", createReportPanel(
                "SELECT TOP 1 WITH TIES M.name AS [Món Bán Chạy], SUM(OD.quantity) AS [Tổng Số Lượng Bán] " +
                        "FROM OrderDetails OD JOIN MenuItems M ON OD.menu_id = M.menu_id " +
                        "GROUP BY M.name ORDER BY [Tổng Số Lượng Bán] DESC"));

        // 5. Tổng tiền từng đơn
        tabbedPane.addTab("5. Tổng tiền từng đơn", createReportPanel(
                "SELECT order_id AS [Mã Đơn], FORMAT(SUM(quantity * price), 'N0') + ' đ' AS [Tổng Tiền Đơn Hàng] " +
                        "FROM OrderDetails GROUP BY order_id"));

        // 6. Trạng thái các bàn
        tabbedPane.addTab("6. Trạng thái các bàn", createReportPanel(
                "SELECT table_name AS [Tên Bàn], CASE WHEN status = 'Occupied' THEN N'Đang có khách' " +
                        "WHEN status = 'Available' THEN N'Bàn trống' ELSE status END AS [Trạng Thái Hiện Tại] FROM Tables"));

        // 7. Nhân viên phục vụ nhiều đơn nhất
        tabbedPane.addTab("7. NV xuất sắc", createReportPanel(
                "SELECT TOP 1 WITH TIES S.name AS [Nhân Viên Xuất Sắc], COUNT(O.order_id) AS [Số Đơn Đã Phục Vụ] " +
                        "FROM Orders O JOIN Staff S ON O.staff_id = S.staff_id GROUP BY S.name ORDER BY [Số Đơn Đã Phục Vụ] DESC"));

        // 8. Danh sách thực đơn (Menu) theo loại
        tabbedPane.addTab("8. Danh sách thực đơn", createReportPanel(
                "SELECT category AS [Loại], name AS [Tên Món], FORMAT(price, 'N0') + ' đ' AS [Giá Niêm Yết] " +
                        "FROM MenuItems ORDER BY category"));

        // 9. Danh sách nhân viên đang làm việc
        tabbedPane.addTab("9. Danh sách nhân viên", createReportPanel(
                "SELECT staff_id AS [Mã NV], name AS [Họ Tên], role AS [Chức Vụ], phone AS [Số Điện Thoại] FROM Staff"));

        add(tabbedPane);
    }

    private JPanel createReportPanel(String sqlQuery) {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(new Color(250, 250, 250));

        DefaultTableModel model = new DefaultTableModel() {
            @Override
            public boolean isCellEditable(int row, int column) { return false; } // Không cho sửa trực tiếp trên báo cáo
        };

        JTable table = new JTable(model);
        table.setRowHeight(30);
        table.getTableHeader().setFont(new Font("Tahoma", Font.BOLD, 12));

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sqlQuery)) {

            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();

            for (int i = 1; i <= columnCount; i++) {
                model.addColumn(rsmd.getColumnLabel(i));
            }

            while (rs.next()) {
                Vector<Object> row = new Vector<>();
                for (int i = 1; i <= columnCount; i++) {
                    row.add(rs.getObject(i));
                }
                model.addRow(row);
            }
        } catch (SQLException e) {
            model.addColumn("Trạng thái");
            model.addRow(new Object[]{"Lỗi hoặc chưa có dữ liệu: " + e.getMessage()});
        }

        panel.add(new JScrollPane(table), BorderLayout.CENTER);

        JButton btnReload = new JButton("Làm mới báo cáo");
        btnReload.setFont(new Font("Tahoma", Font.BOLD, 12));
        btnReload.addActionListener(e -> {
            int index = tabbedPane.getSelectedIndex();
            tabbedPane.setComponentAt(index, createReportPanel(sqlQuery));
        });
        panel.add(btnReload, BorderLayout.SOUTH);

        return panel;
    }

    public static void main(String[] args) {
        try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch (Exception e) {}
        new BaoCao().setVisible(true);
    }
}