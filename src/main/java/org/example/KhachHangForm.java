package org.example;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

public class KhachHangForm extends JFrame {
    private JTextField txtTenKH, txtSDT, txtEmail;
    private JTable tblKhachHang;
    private DefaultTableModel tableModel;
    private JButton btnThem, btnReload;

    public KhachHangForm() {
        setTitle("Quản Lý Khách Hàng");
        setSize(1100, 650);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel();
        panel.setLayout(null);
        panel.setBackground(new Color(250, 250, 250));
        setContentPane(panel);

        // Header
        JLabel lblHeader = new JLabel("QUẢN LÝ KHÁCH HÀNG");
        lblHeader.setFont(new Font("Tahoma", Font.BOLD, 22));
        lblHeader.setForeground(new Color(70, 130, 180));
        lblHeader.setBounds(40, 30, 400, 40);
        panel.add(lblHeader);

        // Nhập liệu - Tọa độ đồng bộ
        int xLabel = 50, xInput = 160, yStart = 100, widthLabel = 110, widthInput = 220, height = 30;

        JLabel lblTen = new JLabel("Tên khách:");
        lblTen.setBounds(xLabel, yStart, widthLabel, height);
        panel.add(lblTen);
        txtTenKH = new JTextField();
        txtTenKH.setBounds(xInput, yStart, widthInput, height);
        panel.add(txtTenKH);

        JLabel lblSDT = new JLabel("Số điện thoại:");
        lblSDT.setBounds(xLabel, yStart + 50, widthLabel, height);
        panel.add(lblSDT);
        txtSDT = new JTextField();
        txtSDT.setBounds(xInput, yStart + 50, widthInput, height);
        panel.add(txtSDT);

        JLabel lblEmail = new JLabel("Email:");
        lblEmail.setBounds(xLabel, yStart + 100, widthLabel, height);
        panel.add(lblEmail);
        txtEmail = new JTextField();
        txtEmail.setBounds(xInput, yStart + 100, widthInput, height);
        panel.add(txtEmail);

        // Nút bấm
        btnThem = createButton("Thêm Khách", new Color(200, 255, 200));
        btnThem.setBounds(50, 300, 150, 45);
        btnThem.addActionListener(e -> themKhachHang());
        panel.add(btnThem);

        btnReload = createButton("Làm Mới", new Color(220, 240, 255));
        btnReload.setBounds(220, 300, 140, 45);
        btnReload.addActionListener(e -> loadData());
        panel.add(btnReload);

        // Bảng hiển thị
        tableModel = new DefaultTableModel(new String[]{"ID", "Họ Tên", "SĐT", "Email"}, 0);
        tblKhachHang = new JTable(tableModel);
        tblKhachHang.setRowHeight(25);
        JScrollPane scrollPane = new JScrollPane(tblKhachHang);
        scrollPane.setBounds(420, 80, 620, 480);
        panel.add(scrollPane);

        loadData();
    }

    private void loadData() {
        tableModel.setRowCount(0);
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT customer_id, name, phone, email FROM Customers ORDER BY customer_id ASC";
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) {
                tableModel.addRow(new Object[]{
                        rs.getInt("customer_id"),
                        rs.getNString("name"),
                        rs.getString("phone"),
                        rs.getString("email")
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void themKhachHang() {
        String ten = txtTenKH.getText().trim();
        String sdt = txtSDT.getText().trim();
        String email = txtEmail.getText().trim();

        if (ten.isEmpty() || sdt.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng nhập tên và SĐT!");
            return;
        }

        // Vì SQL KHÔNG CÓ Procedure, t dùng INSERT trực tiếp
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO Customers (name, phone, email) VALUES (?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setNString(1, ten);
            pstmt.setString(2, sdt);
            pstmt.setString(3, email.isEmpty() ? null : email);

            pstmt.executeUpdate();

            JOptionPane.showMessageDialog(this, "Đã thêm khách hàng thành công!");
            txtTenKH.setText("");
            txtSDT.setText("");
            txtEmail.setText("");
            loadData();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Lỗi SQL: " + e.getMessage());
        }
    }

    private JButton createButton(String text, Color color) {
        JButton btn = new JButton(text);
        btn.setBackground(color);
        btn.setFont(new Font("Tahoma", Font.BOLD, 13));
        btn.setFocusPainted(false);
        return btn;
    }

    public static void main(String[] args) {
        try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch (Exception e) {}
        new KhachHangForm().setVisible(true);
    }
}