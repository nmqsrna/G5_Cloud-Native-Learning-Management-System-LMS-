<%@ page import="model.User" %>

<%
User user = (User)session.getAttribute("user");

if(user == null || !user.getRole().equals("admin")){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>

<head>

<title>Admin Dashboard</title>

<link rel="stylesheet" href="css/style.css">

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet">

</head>

<body>

<div class="wrapper">

    <div class="sidebar">

        <div class="logo">
            LMS
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="adminDashboard.jsp">
                    Dashboard
                </a>
            </li>
            <li>
                <a href="instructorDashboard.jsp">
                    Courses
                </a>
            </li>
            <li>
                <a href="profile.jsp">
                    Profile
                </a>
            </li>
            <li>
                <a href="LogoutServlet">
                    Logout
                </a>
            </li>
        </ul>

    </div>

    <div class="main-content">

        <div class="topbar">

            <h2>Admin Dashboard</h2>

            <span>
                Welcome, <%= user.getFullname() %>
            </span>

        </div>

        <div class="stats-grid">

            <div class="stat-card">
                <h3>120</h3>
                <p>Total Students</p>
            </div>

            <div class="stat-card">
                <h3>15</h3>
                <p>Total Instructors</p>
            </div>

            <div class="stat-card">
                <h3>20</h3>
                <p>Total Courses</p>
            </div>

            <div class="stat-card">
                <h3>350</h3>
                <p>Total Enrollments</p>
            </div>

        </div>

        <div class="card">

            <h3>System Overview</h3>

            <br>

            <p>
                Welcome to LMS Admin Panel.
                You can manage users, instructors,
                courses and monitor system activities.
            </p>

        </div>

    </div>

</div>

</body>

</html>