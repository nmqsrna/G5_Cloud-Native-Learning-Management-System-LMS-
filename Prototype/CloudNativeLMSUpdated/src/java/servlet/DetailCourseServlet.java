package servlet;

import model.Module; 
import model.User; 
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DetailCourseServlet")
public class DetailCourseServlet extends HttpServlet {
    // 🎯 FIX 1: Ditukar ke lms_db (huruf kecil) supaya sama dengan CreateCourseServlet terbaharu awak
    private final String dbUrl = "jdbc:mysql://localhost:3306/lms_db"; 
    private final String dbUser = "root";
    private final String dbPass = "admin"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    
        String courseId = request.getParameter("id");
        boolean recordFound = false;
        java.util.List<Module> moduleList = new java.util.ArrayList<>(); 
        String dbStatus = "Draft"; 
    
        if (courseId != null && !courseId.isEmpty() && !courseId.equals("0")) {
            String courseQuery = "SELECT * FROM courses WHERE id = ?";
            String modulesQuery = "SELECT * FROM modules WHERE course_id = ? ORDER BY id ASC";
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass)) {
                    
                    // 1. Ambil data maklumat perincian kursus
                    try (PreparedStatement ps = conn.prepareStatement(courseQuery)) {
                        ps.setInt(1, Integer.parseInt(courseId));
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                recordFound = true;
                                request.setAttribute("courseId", courseId);
                                request.setAttribute("title", rs.getString("title")); 
                                request.setAttribute("desc", rs.getString("description"));          
                                request.setAttribute("instructor", rs.getString("instructor"));    
                                request.setAttribute("category", rs.getString("category"));               
                                request.setAttribute("level", rs.getString("level"));                    
                                request.setAttribute("tags", rs.getString("tags"));
                                
                                String statusValue = rs.getString("status");
                                if (statusValue != null) {
                                    dbStatus = statusValue;
                                }
                                request.setAttribute("status", dbStatus);
                            }
                        }
                    }
                    
                    // 2. Ambil senarai fail modul/kurikulum jika ada
                    try (PreparedStatement psModules = conn.prepareStatement(modulesQuery)) {
                        psModules.setInt(1, Integer.parseInt(courseId));
                        try (ResultSet rsModules = psModules.executeQuery()) {
                            while (rsModules.next()) {
                                Module mod = new Module(
                                    rsModules.getInt("id"),
                                    rsModules.getInt("course_id"),
                                    rsModules.getString("module_title"),
                                    rsModules.getString("content_type"),
                                    rsModules.getString("file_path")
                                );
                                moduleList.add(mod);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    
        // 🎯 FIX 2: Jika data tak jumpa dalam DB (Contoh: ID=0 sewaktu tengah buat simulasi draf baru),
        // Kita tak tendang dia balik ke dashboard, sebaliknya kita hantar data draf olok-olok ke JSP supaya skrin tetap keluar!
        if (!recordFound) {
            request.setAttribute("courseId", "0");
            request.setAttribute("title", request.getParameter("courseTitle") != null ? request.getParameter("courseTitle") : "New Course Draft"); 
            request.setAttribute("desc", request.getParameter("courseDesc") != null ? request.getParameter("courseDesc") : "No description provided.");          
            request.setAttribute("instructor", request.getParameter("instructorName") != null ? request.getParameter("instructorName") : "Unknown Instructor");    
            request.setAttribute("category", request.getParameter("courseCategory") != null ? request.getParameter("courseCategory") : "Technology");               
            request.setAttribute("level", request.getParameter("courseLevel") != null ? request.getParameter("courseLevel") : "Beginner");                    
            request.setAttribute("tags", request.getParameter("courseTags") != null ? request.getParameter("courseTags") : "general");
            request.setAttribute("status", "Draft");
        }
    
        // Sekatan keselamatan peranan (Role isolation)
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "student".equalsIgnoreCase(user.getRole())) {
            if (!"Active".equalsIgnoreCase(dbStatus)) {
                response.sendRedirect("courses.jsp?error=UnpublishedAccessDenied");
                return; 
            }
        }
    
        request.setAttribute("moduleList", moduleList);
        request.getRequestDispatcher("detail-course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}