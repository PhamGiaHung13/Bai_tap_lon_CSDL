package org.example;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

public class ThucDonForm extends JFrame {
    private JTextField txtTenMon, txtGia;
    private JComboBox<String> cbLoaiMon;
    private JTable tblThucDon;
    private DefaultTableModel tableModel;
    private JButton btnThem, btnReload;

    public ThucDonForm() {
        setTitle("Quản Lý Thực Đơn Nhà Hàng");
        setSize(1100, 650);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel();
        panel.setLayout(null);
        panel.setBackground(new Color(250, 250, 250));
        setContentPane(panel);

        // Header
        JLabel lblHeader = new JLabel("QUẢN LÝ THỰC ĐƠN");
        lblHeader.setFont(new Font("Tahoma", Font.BOLD, 22));
        lblHeader.setForeground(new Color(0, 102, 204));
        lblHeader.setBounds(40, 30, 400, 40);
        panel.add(lblHeader);

        // Nhập liệu
        int xLabel = 50, xInput = 160, yStart = 100, widthLabel = 100, widthInput = 220, height = 30;

        JLabel lblTen = new JLabel("Tên món:");
        lblTen.setBounds(xLabel, yStart, widthLabel, height);
        panel.add(lblTen);
        txtTenMon = new JTextField();
        txtTenMon.setBounds(xInput, yStart, widthInput, height);
        panel.add(txtTenMon);

        JLabel lblGia = new JLabel("Giá tiền:");
        lblGia.setBounds(xLabel, yStart + 50, widthLabel, height);
        panel.add(lblGia);
        txtGia = new JTextField();
        txtGia.setBounds(xInput, yStart + 50, widthInput, height);
        panel.add(txtGia);

        JLabel lblLoai = new JLabel("Loại món:");
        lblLoai.setBounds(xLabel, yStart + 100, widthLabel, height);
        panel.add(lblLoai);
        cbLoaiMon = new JComboBox<>();
        cbLoaiMon.setBounds(xInput, yStart + 100, widthInput, height);
        panel.add(cbLoaiMon);

        // Các nút chức năng
        btnThem = createStyledButton("Thêm Món", new Color(200, 255, 200));
        btnThem.setBounds(50, 300, 140, 45);
        btnThem.addActionListener(e -> themMonAn());
        panel.add(btnThem);

        btnReload = createStyledButton("Làm Mới", new Color(220, 240, 255));
        btnReload.setBounds(210, 300, 140, 45);
        btnReload.addActionListener(e -> {
            loadData();
            loadCategories();
        });
        panel.add(btnReload);

        // Bảng hiển thị - Đồng bộ vị trí với NhanVienForm
        tableModel = new DefaultTableModel(new String[]{"ID", "Tên Món", "Giá (VNĐ)", "Phân Loại"}, 0);
        tblThucDon = new JTable(tableModel);
        tblThucDon.setRowHeight(25);
        JScrollPane scrollPane = new JScrollPane(tblThucDon);
        scrollPane.setBounds(420, 80, 620, 480);
        panel.add(scrollPane);

        loadCategories();
        loadData();
    }

    private void loadCategories() {
        cbLoaiMon.removeAllItems();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT DISTINCT category FROM MenuItems WHERE category IS NOT NULL";
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) {
                cbLoaiMon.addItem(rs.getNString("category"));
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void loadData() {
        tableModel.setRowCount(0);
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT menu_id, name, price, category FROM MenuItems ORDER BY menu_id ASC";
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) {
                tableModel.addRow(new Object[]{
                        rs.getInt("menu_id"),
                        rs.getNString("name"),
                        String.format("%,.0f", rs.getDouble("price")),
                        rs.getNString("category")
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void themMonAn() {
        String ten = txtTenMon.getText().trim();
        String giaStr = txtGia.getText().trim();
        String loai = (String) cbLoaiMon.getSelectedItem();

        if (ten.isEmpty() || giaStr.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng nhập đủ tên và giá!");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "{CALL sp_ThemMonAn(?, ?, ?)}";
            CallableStatement cst = conn.prepareCall(sql);
            cst.setNString(1, ten);
            cst.setDouble(2, Double.parseDouble(giaStr));
            cst.setNString(3, loai);
            cst.execute();

            JOptionPane.showMessageDialog(this, "Thêm món thành công!");
            txtTenMon.setText("");
            txtGia.setText("");
            if(cbLoaiMon.getItemCount() > 0) cbLoaiMon.setSelectedIndex(0);
            loadData();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Lỗi: " + e.getMessage());
        }
    }

    private JButton createStyledButton(String text, Color color) {
        JButton btn = new JButton(text);
        btn.setBackground(color);
        btn.setFont(new Font("Tahoma", Font.BOLD, 13));
        btn.setFocusPainted(false);
        return btn;
    }

    public static void main(String[] args) {
        try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch (Exception e) {}
        new ThucDonForm().setVisible(true);
    }
}