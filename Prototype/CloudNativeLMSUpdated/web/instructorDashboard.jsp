<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="model.User" %>
<%
    // 1. Sekatan Keselamatan: Pastikan pengguna telah login dan merupakan seorang instructor
    User user = (User)session.getAttribute("user");
    if(user == null || !user.getRole().equals("instructor")){
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Tangkap penapis status dari parameter URL (Default kepada 'All')
    String activeFilter = request.getParameter("statusFilter");
    if (activeFilter == null || activeFilter.trim().isEmpty()) {
        activeFilter = "All";
    }

    // 3. Bina query SQL dinamik untuk senarai kad kursus di bawah (🎯 FIX: Tapis ikut instructor)
    String baseQuery = "SELECT * FROM courses WHERE instructor = ?";
    if (!"All".equals(activeFilter)) {
        baseQuery += " AND status = ?";
    }
    
    // 4. Konfigurasi pangkalan data terbaharu projek awak (🎯 FIX: Ditukar ke lms_db)
    String dbUrl = "jdbc:mysql://localhost:3306/lms_db";
    String dbUser = "root";
    String dbPass = "admin"; 

    // 5. LOGIK DINAMIK: Mengira jumlah statistik sebenar daripada Database
    int totalCourses = 0;
    int totalStudents = 0;
    int totalAssignments = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass)) {
            
            // A. Kira jumlah "Courses Teaching" untuk instructor ini (🎯 FIX: Guna lajur instructor)
            String sqlCourses = "SELECT COUNT(*) FROM courses WHERE instructor = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(sqlCourses)) {
                ps1.setString(1, user.getFullname());
                try (ResultSet rs1 = ps1.executeQuery()) {
                    if (rs1.next()) {
                        totalCourses = rs1.getInt(1);
                    }
                }
            }

            // B. Kira jumlah "Students" yang mendaftar di bawah semua kursus milik instructor ini
            String sqlStudents = "SELECT COUNT(DISTINCT e.student_id) FROM enrollments e " +
                                 "JOIN courses c ON e.course_id = c.id WHERE c.instructor = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(sqlStudents)) {
                ps2.setString(1, user.getFullname());
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        totalStudents = rs2.getInt(1);
                    }
                }
            }

            // C. Kira jumlah "Assignments" yang dicipta di bawah semua kursus milik instructor ini
            String sqlAssignments = "SELECT COUNT(a.id) FROM assignments a " +
                                    "JOIN courses c ON a.course_id = c.id WHERE c.instructor = ?";
            try (PreparedStatement ps3 = conn.prepareStatement(sqlAssignments)) {
                ps3.setString(1, user.getFullname());
                try (ResultSet rs3 = ps3.executeQuery()) {
                    if (rs3.next()) {
                        totalAssignments = rs3.getInt(1);
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Dashboard - Courses</title>
    
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
                <li><a href="instructorDashboard.jsp" class="active">Dashboard</a></li>
                <li><a href="instructorDashboard.jsp">Courses</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="LogoutServlet">Logout</a></li>
            </ul>
        </nav>
        
        <main class="main-content">
            <div class="container-fluid py-4">
                <div class="topbar">
                    <h2>Instructor Dashboard</h2>
                    <span>Welcome, <%= user.getFullname() %></span>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <h3><%= totalCourses %></h3>
                        <p>Courses Teaching</p>
                    </div>
                    <div class="stat-card">
                        <h3><%= totalStudents %></h3>
                        <p>Students</p>
                    </div>
                    <div class="stat-card">
                        <h3><%= totalAssignments %></h3>
                        <p>Assignments</p>
                    </div>
                    <div class="stat-card">
                        <h3>95%</h3> <p>Course Completion</p>
                    </div>
                </div>

                <div class="card p-4 mb-4">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                        <div class="text-muted">
                            <span class="fs-6 fw-medium text-secondary">Viewing: <strong class="text-primary"><%= activeFilter %></strong> Courses</span>
                        </div>
                        
                        <div class="d-flex flex-column flex-sm-row align-items-stretch align-items-sm-center gap-3">
                            <div class="dropdown">
                                <button class="btn btn-light dropdown-toggle border d-flex align-items-center justify-content-between gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="border-radius: 12px; padding: 12px 18px; background: #ffffff;">
                                    <i class="bi bi-funnel text-muted"></i> Filter: <%= activeFilter %>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                                    <li><a class="dropdown-item <%= "All".equals(activeFilter) ? "active fw-semibold" : "" %>" href="instructorDashboard.jsp?statusFilter=All">All Courses</a></li>
                                    <li><a class="dropdown-item <%= "Draft".equals(activeFilter) ? "active fw-semibold" : "" %>" href="instructorDashboard.jsp?statusFilter=Draft">Drafts</a></li>
                                    <li><a class="dropdown-item <%= "Active".equals(activeFilter) ? "active fw-semibold" : "" %>" href="instructorDashboard.jsp?statusFilter=Active">Active</a></li>
                                    <li><a class="dropdown-item <%= "Archived".equals(activeFilter) ? "active fw-semibold" : "" %>" href="instructorDashboard.jsp?statusFilter=Archived">Archived</a></li>
                                </ul>
                            </div>
                            
                            <form action="create-course.jsp" method="GET" class="d-inline">
                                <button type="submit" class="btn btn-primary d-inline-flex align-items-center justify-content-center gap-2" style="background-color: #6C63FF; border-color: #6C63FF; padding: 12px 24px; color: white; position: relative; z-index: 999; min-width: 160px; font-weight: 600; border-radius: 12px;">
                                    <i class="bi bi-plus-lg"></i> New Course
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="d-flex flex-column gap-3 mt-4">
                        <%
                            boolean hasRecords = false;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                                     PreparedStatement ps = conn.prepareStatement(baseQuery)) {
                                    
                                    // 🎯 FIX MAPPING: Set nama penuh pengajar untuk carian parameter pertama
                                    ps.setString(1, user.getFullname());
                                    
                                    if (!"All".equals(activeFilter)) {
                                        ps.setString(2, activeFilter);
                                    }
                                    
                                    try (ResultSet rs = ps.executeQuery()) {
                                        while (rs.next()) {
                                            hasRecords = true;
                                            int id = rs.getInt("id");
                                            String title = rs.getString("title");
                                            
                                            // 🎯 FIX SINKRON: Tukar daripada "instructorName" kepada lajur "instructor" tulen
                                            String instructorName = rs.getString("instructor");
                                            String category = rs.getString("category");
                                            String level = rs.getString("level");
                                            String status = rs.getString("status");
                                            if (status == null) status = "Draft";
                        %>
                                            <div class="card border border-light shadow-sm p-3 mb-2" style="border-radius: 16px; background-color: #ffffff;">
                                                <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3 p-2">
                                                    <div>
                                                        <div class="d-flex align-items-center gap-2 mb-2 flex-wrap">
                                                            <% if ("Active".equalsIgnoreCase(status)) { %>
                                                                <span class="badge bg-success text-white rounded-pill px-2 py-1 fw-medium" style="font-size: 11px;">Active</span>
                                                            <% } else if ("Archived".equalsIgnoreCase(status)) { %>
                                                                <span class="badge bg-warning text-dark rounded-pill px-2 py-1 fw-medium" style="font-size: 11px;">Archived</span>
                                                            <% } else { %>
                                                                <span class="badge bg-secondary text-white rounded-pill px-2 py-1 fw-medium" style="font-size: 11px;">Draft</span>
                                                            <% } %>
                                                            <span class="text-muted small"><%= level != null ? level : "All Levels" %></span>
                                                            <span class="text-muted small">&middot;</span>
                                                            <span class="text-muted small"><%= category != null ? category : "General" %></span>
                                                        </div>
                                                        <h4 class="fw-bold mb-1 text-dark"><%= title %></h4>
                                                        <p class="text-muted small mb-0">Instructed by: <span class="fw-medium text-dark"><%= instructorName != null ? instructorName : "Unknown" %></span></p>
                                                    </div>
                                                    <div>
                                                        <a href="DetailCourseServlet?id=<%= id %>" class="btn btn-primary rounded-pill px-4" style="background-color: #6C63FF; border-color: #6C63FF;">
                                                            View Course <i class="bi bi-arrow-right ms-1"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                        <%
                                        }
                                    }
                                }
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Database Error: " + e.getMessage() + "</div>");
                            }
                            
                            if (!hasRecords) {
                        %>
                                <div class="text-center py-5 bg-light mt-2" style="border-radius: 16px;">
                                    <i class="bi bi-folder-x text-muted mb-3" style="font-size: 2.5rem;"></i>
                                    <h5 class="text-secondary fw-medium">No courses found matching the filter.</h5>
                                </div>
                        <% 
                            } 
                        %>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>