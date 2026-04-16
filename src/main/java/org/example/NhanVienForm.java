package org.example;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

public class NhanVienForm extends JFrame {
    private JTextField txtTenNV, txtSDT;
    private JComboBox<String> cbChucVu;
    private JTable tblNhanVien;
    private DefaultTableModel tableModel;
    private JButton btnThem, btnReload;

    public NhanVienForm() {
        setTitle("Quản Lý Nhân Viên");
        // SỬA: Đảm bảo size đồng bộ 1100x650
        setSize(1100, 650);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel();
        panel.setLayout(null);
        // SỬA: Đổi màu background sang 250, 250, 250 cho giống ThucDonForm
        panel.setBackground(new Color(250, 250, 250));
        setContentPane(panel);

        // Header
        JLabel lblHeader = new JLabel("QUẢN LÝ NHÂN SỰ");
        lblHeader.setFont(new Font("Tahoma", Font.BOLD, 22));
        lblHeader.setForeground(new Color(46, 139, 87));
        lblHeader.setBounds(40, 30, 400, 40);
        panel.add(lblHeader);

        // Nhập liệu - Giữ nguyên tọa độ chuẩn
        int xLabel = 50, xInput = 160, yStart = 100, widthLabel = 100, widthInput = 220, height = 30;

        JLabel lblTen = new JLabel("Họ tên:");
        lblTen.setBounds(xLabel, yStart, widthLabel, height);
        panel.add(lblTen);
        txtTenNV = new JTextField();
        txtTenNV.setBounds(xInput, yStart, widthInput, height);
        panel.add(txtTenNV);

        JLabel lblSDT = new JLabel("Số ĐT:");
        lblSDT.setBounds(xLabel, yStart + 50, widthLabel, height);
        panel.add(lblSDT);
        txtSDT = new JTextField();
        txtSDT.setBounds(xInput, yStart + 50, widthInput, height);
        panel.add(txtSDT);

        JLabel lblRole = new JLabel("Chức vụ:");
        lblRole.setBounds(xLabel, yStart + 100, widthLabel, height);
        panel.add(lblRole);

        String[] roles = {"Phục vụ", "Thu ngân", "Bếp trưởng", "Bếp phó", "Quản lý", "Bartender", "Bảo vệ"};
        cbChucVu = new JComboBox<>(roles);
        cbChucVu.setBounds(xInput, yStart + 100, widthInput, height);
        panel.add(cbChucVu);

        // Nút bấm
        btnThem = createButton("Thêm Nhân Viên", new Color(200, 255, 200));
        btnThem.setBounds(50, 300, 140, 45);
        btnThem.addActionListener(e -> themNhanVien());
        panel.add(btnThem);

        btnReload = createButton("Làm Mới", new Color(220, 240, 255));
        btnReload.setBounds(210, 300, 140, 45);
        btnReload.addActionListener(e -> loadData());
        panel.add(btnReload);

        // Bảng hiển thị - Giữ nguyên kích thước 620x480
        tableModel = new DefaultTableModel(new String[]{"Mã NV", "Họ Tên", "Chức Vụ", "Số Điện Thoại"}, 0);
        tblNhanVien = new JTable(tableModel);
        tblNhanVien.setRowHeight(25);
        JScrollPane scrollPane = new JScrollPane(tblNhanVien);
        scrollPane.setBounds(420, 80, 620, 480);
        panel.add(scrollPane);

        loadData();
    }

    private void loadData() {
        tableModel.setRowCount(0);
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT staff_id, name, role, phone FROM Staff ORDER BY staff_id ASC";
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) {
                tableModel.addRow(new Object[]{
                        rs.getInt("staff_id"),
                        rs.getNString("name"),
                        rs.getNString("role"),
                        rs.getString("phone")
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void themNhanVien() {
        String ten = txtTenNV.getText().trim();
        String sdt = txtSDT.getText().trim();
        String chucVu = (String) cbChucVu.getSelectedItem();

        if (ten.isEmpty() || sdt.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng nhập đầy đủ thông tin!");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "{CALL sp_ThemNhanVien(?, ?, ?)}";
            CallableStatement cst = conn.prepareCall(sql);
            cst.setNString(1, ten);
            cst.setNString(2, chucVu);
            cst.setString(3, sdt);
            cst.execute();

            JOptionPane.showMessageDialog(this, "Đã thêm nhân viên thành công!");
            txtTenNV.setText("");
            txtSDT.setText("");
            cbChucVu.setSelectedIndex(0);
            loadData();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Lỗi: " + e.getMessage());
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
        new NhanVienForm().setVisible(true);
    }
}