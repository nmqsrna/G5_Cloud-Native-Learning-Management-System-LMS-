<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="model.User" %>
<%
    // 1. Sekatan Keselamatan: Pastikan pengguna telah login dan merupakan seorang student
    User user = (User)session.getAttribute("user");
    if(user == null || !user.getRole().equals("student")){
        response.sendRedirect("login.jsp");
        return;
    }

    String studentQuery = "SELECT * FROM courses WHERE status = 'Active' ORDER BY id DESC";
    
    // 🎯 CONFIGURATION FIX: Menggunakan database lms_db tulen projek awak
    String dbUrl = "jdbc:mysql://localhost:3306/lms_db";
    String dbUser = "root";
    String dbPass = "admin"; 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student - Available Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="wrapper">
        <nav class="sidebar">
            <div class="logo">LMS</div>
            <ul class="sidebar-menu p-0">
                <li><a href="studentDashboard.jsp"><i class="bi bi-book me-3"></i> Dashboard</a></li>
                <li><a href="courses.jsp" class="active"><i class="bi bi-journal-bookmark me-3"></i> Courses</a></li>
                <li><a href="profile.jsp"><i class="bi bi-person me-3"></i> Profile</a></li>
                <li><a href="LogoutServlet"><i class="bi bi-box-arrow-right me-3"></i> Logout</a></li>
            </ul>
        </nav>
        
        <main class="main-content">
            <div class="container-fluid py-4">
                <div class="mb-4">
                    <h1 class="fw-bold m-0" style="font-size: 32px;">Available Courses</h1>
                    <p class="text-muted">Explore programs published by your instructors and enroll to start learning.</p>
                </div>
                
                <div class="d-flex flex-column gap-3 mt-4">
                    <%
                        boolean hasCourses = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                                 PreparedStatement ps = conn.prepareStatement(studentQuery);
                                 ResultSet rs = ps.executeQuery()) {
                                 
                                while (rs.next()) {
                                    hasCourses = true;
                                    int id = rs.getInt("id");
                                    String title = rs.getString("title");
                                    String instructor = rs.getString("instructor");
                                    String category = rs.getString("category");
                                    String level = rs.getString("level");
                                    
                                    if (instructor == null || instructor.isEmpty()) instructor = "Unknown Instructor";
                    %>
                                    <div class="card border-0 shadow-sm p-3 mb-2" style="border-radius: 16px; background-color: #ffffff;">
                                        <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3 p-2">
                                            <div>
                                                <div class="d-flex align-items-center gap-2 mb-2 flex-wrap">
                                                    <span class="badge bg-success text-white rounded-pill px-2 py-1 fw-medium" style="font-size: 11px;">Active</span>
                                                    <span class="badge bg-light text-secondary border px-2 py-0.5 rounded-pill small" style="font-size: 11px;"><%= level != null && !level.isEmpty() ? level : "All Levels" %></span>
                                                    <span class="text-muted small">&middot;</span>
                                                    <span class="badge bg-light text-primary border px-2 py-0.5 rounded-pill small" style="font-size: 11px;"><%= category != null && !category.isEmpty() ? category : "General" %></span>
                                                </div>
                                                
                                                <h4 class="fw-bold mb-1 text-dark" style="letter-spacing: -0.3px;"><%= title %></h4>
                                                <p class="text-muted small mb-0">Instructed by: <span class="fw-medium text-dark"><%= instructor %></span></p>
                                            </div>
                                            
                                            <div>
                                                <a href="EnrollCourseServlet?courseId=<%= id %>" class="btn btn-primary rounded-pill px-4" style="background-color: #6C63FF; border-color: #6C63FF; font-size: 15px; font-weight: 500; padding: 10px 24px;">
                                                    Enroll Now <i class="bi bi-plus-lg ms-1"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            out.println("<div class='alert alert-danger'>Error generating course catalogs: " + e.getMessage() + "</div>");
                            e.printStackTrace();
                        }
                        if (!hasCourses) {
                    %>
                            <div class="text-center py-5 bg-white border-0 shadow-sm mt-2" style="border-radius: 16px;">
                                <i class="bi bi-journal-x text-muted" style="font-size: 3rem;"></i>
                                <h5 class="text-secondary mt-4 fw-medium">No live modules are available at the moment. Check back later!</h5>
                            </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>