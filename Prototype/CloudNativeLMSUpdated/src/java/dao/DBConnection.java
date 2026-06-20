package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // 🎯 FIX: Pastikan menghala ke lms_db yang sama dengan Servlet awak
    private static final String URL = "jdbc:mysql://localhost:3306/lms_db";
    private static final String USER = "root";
    private static final String PASSWORD = "admin";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}