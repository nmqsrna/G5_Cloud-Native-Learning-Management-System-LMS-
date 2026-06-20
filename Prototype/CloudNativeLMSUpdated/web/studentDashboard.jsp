<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="dao.CourseDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%
    // 1. Sekatan Keselamatan
    User user = (User) session.getAttribute("user");
    if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    CourseDAO courseDao = new CourseDAO();
    // Ambil senarai subjek yang didaftar oleh student ini
    List<Course> enrolledCourses = courseDao.getStudentEnrolledCourses(user.getId());
    int myCoursesCount = enrolledCourses.size();

    // 2. 🎯 FIX DINAMIK: Mengira tugasan (assignments) sebenar dari database lms_db
    int totalAssignments = 0;
    int completedAssignments = 0;

    String dbUrl = "jdbc:mysql://localhost:3306/lms_db";
    String dbUser = "root";
    String dbPass = "admin";

    // Jika student ada subjek didaftar, baru kita kira jumlah tugasan dari jadual database
    if (myCoursesCount > 0) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass)) {
                
                // A. Kira tugasan aktif (TUKAR KE setString)
                String sqlAssignments = "SELECT COUNT(a.id) FROM assignments a " +
                                        "JOIN enrollments e ON a.course_id = e.course_id WHERE e.student_id = ?";
                try (PreparedStatement ps1 = conn.prepareStatement(sqlAssignments)) {
                    ps1.setString(1, user.getId()); // TUKAR DARI setInt KE setString
                    try (ResultSet rs1 = ps1.executeQuery()) {
                        if (rs1.next()) {
                            totalAssignments = rs1.getInt(1);
                        }
                    }
                }

                // B. Kira tugasan selesai (TUKAR KE setString)
                String sqlCompleted = "SELECT COUNT(s.id) FROM submissions s WHERE s.student_id = ? AND s.status = 'Submitted'";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlCompleted)) {
                    ps2.setString(1, user.getId()); // TUKAR DARI setInt KE setString
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        if (rs2.next()) {
                            completedAssignments = rs2.getInt(1);
                        }
                    }
                }
            }
        } catch (Exception e) {
            // Jika jadual assignments/submissions belum wujud dalam db, kita biarkan 0 tanpa merosakkan sistem
            totalAssignments = 0;
            completedAssignments = 0;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="wrapper">
        <!-- SIDEBAR -->
        <nav class="sidebar">
            <div class="logo">LMS</div>
            <ul class="sidebar-menu p-0">
                <li><a href="studentDashboard.jsp" class="active"><i class="bi bi-book me-3"></i> Dashboard</a></li>
                <li><a href="courses.jsp"><i class="bi bi-journal-bookmark me-3"></i> Courses</a></li>
                <li><a href="profile.jsp"><i class="bi bi-person me-3"></i> Profile</a></li>
                <li><a href="LogoutServlet"><i class="bi bi-box-arrow-right me-3"></i> Logout</a></li>
            </ul>
        </nav>
        
        <!-- MAIN CONTENT -->
        <main class="main-content">
            <div class="container-fluid py-4">
                <div class="topbar card p-4 mb-4 border-0 shadow-sm" style="border-radius: 18px;">
                    <div class="d-flex justify-content-between align-items-center">
                        <h2 class="fw-bold m-0">Dashboard</h2>
                        <span class="text-muted fw-medium">Welcome Student, <strong class="text-dark"><%= user.getFullname() %></strong></span>
                    </div>
                </div>
                
                <!-- STATS GRID (🎯 FIX: Ikut Reka Bentuk Visual image_1d659e.png) -->
                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card p-4 border-0 shadow-sm" style="border-radius: 16px;">
                            <h1 class="fw-bold text-primary display-4 m-0" style="color: #6C63FF !important;"><%= myCoursesCount %></h1>
                            <p class="text-muted fw-medium mb-0 mt-1">My Courses</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-4 border-0 shadow-sm" style="border-radius: 16px;">
                            <h1 class="fw-bold text-info display-4 m-0"><%= totalAssignments %></h1>
                            <p class="text-muted fw-medium mb-0 mt-1">Assignments</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-4 border-0 shadow-sm" style="border-radius: 16px;">
                            <h1 class="fw-bold text-success display-4 m-0"><%= completedAssignments %></h1>
                            <p class="text-muted fw-medium mb-0 mt-1">Completed</p>
                        </div>
                    </div>
                </div>

                <!-- SENARAI SUBJEK YANG TELAH DIDAFTAR -->
                <div class="card p-4 border-0 shadow-sm" style="border-radius: 18px;">
                    <h3 class="fw-bold mb-4" style="font-size: 20px;"><i class="bi bi-journal-check me-2 text-primary"></i>My Enrolled Curriculum</h3>
                    
                    <div class="d-flex flex-column gap-3">
                        <% if (enrolledCourses.isEmpty()) { %>
                            <div class="text-center py-5 bg-light" style="border-radius: 16px;">
                                <i class="bi bi-emoji-frown text-muted mb-2" style="font-size: 2.5rem;"></i>
                                <h5 class="text-secondary fw-medium m-0">You haven't enrolled in any courses yet. Go to 'Courses' tab to register!</h5>
                            </div>
                        <% } else { 
                            for (Course myCourse : enrolledCourses) { %>
                                <div class="card border border-light shadow-sm p-3" style="border-radius: 16px; background-color: #ffffff;">
                                    <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3 p-1">
                                        <div>
                                            <span class="badge bg-light text-secondary border mb-1" style="font-size: 11px;"><%= myCourse.getCategory() %></span>
                                            <h4 class="fw-bold mb-1 text-dark"><%= myCourse.getTitle() %></h4>
                                            <p class="text-muted small mb-0">Instructed by: <span class="fw-medium text-dark"><%= myCourse.getInstructorName() %></span></p>
                                        </div>
                                        <div>
                                            <!-- Masuk ke pemprosesan pengisian fail tugasan student -->
                                            <a href="DetailCourseServlet?id=<%= myCourse.getId() %>" class="btn btn-primary rounded-pill px-4" style="background-color: #6C63FF; border-color: #6C63FF;">
                                                Enter Classroom <i class="bi bi-arrow-right ms-1"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                        <%  } 
                           } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>