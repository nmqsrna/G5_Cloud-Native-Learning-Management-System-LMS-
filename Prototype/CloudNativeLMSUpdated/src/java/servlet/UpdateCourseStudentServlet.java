package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateCourseStatusServlet")
public class UpdateCourseStudentServlet extends HttpServlet {
    private final String dbUrl = "jdbc:mysql://localhost:3306/lms_db"; // 🎯 FIX: lms_db
    private final String dbUser = "root";
    private final String dbPass = "admin"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseId = request.getParameter("id");
        String currentStatus = request.getParameter("currentStatus");
        String nextStatus = "Draft";

        if (currentStatus != null) {
            switch (currentStatus.trim()) {
                case "Draft": nextStatus = "Active"; break;
                case "Active": nextStatus = "Archived"; break;
                case "Archived": nextStatus = "Active"; break;
            }
        }

        if (courseId != null && !courseId.isEmpty()) {
            String query = "UPDATE courses SET status = ? WHERE id = ?";
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                     PreparedStatement ps = conn.prepareStatement(query)) {
                    
                    ps.setString(1, nextStatus);
                    ps.setInt(2, Integer.parseInt(courseId));
                    ps.executeUpdate();
                    
                    System.out.println(">>> LMS STATUS CHANGED: Course " + courseId + " is now " + nextStatus);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // Muat semula halaman butiran kursus
        response.sendRedirect("DetailCourseServlet?id=" + courseId);
    }
}