<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User)session.getAttribute("user");
    if(user == null || !user.getRole().equals("instructor")){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS - Create Course</title>
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
                <li><a href="instructorDashboard.jsp" class="active"><i class="bi bi-book me-3"></i> Dashboard</a></li>
                <li><a href="profile.jsp"><i class="bi bi-person me-3"></i> Profile</a></li>
            </ul>
        </nav>
        <main class="main-content">
            <div class="container-fluid py-4">
                <div class="mb-3" style="max-width: 850px; margin: 0 auto;">
                    <a href="instructorDashboard.jsp" class="text-secondary"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
                </div>
                
                <div class="card p-5" style="max-width: 850px; margin: 0 auto; border-radius: 18px;">
                    <h3 class="fw-bold mb-4">Create New Course</h3>
                    <form action="CreateCourseServlet" method="POST">
                        <div class="form-group mb-4">
                            <label class="form-label" for="courseTitle">Course Title *</label>
                            <input type="text" id="courseTitle" name="courseTitle" class="form-control" required placeholder="e.g. Intro to Web Development">
                        </div>
                        <div class="form-group mb-4">
                            <label class="form-label" for="courseDesc">Description</label>
                            <textarea id="courseDesc" name="courseDesc" class="form-control" rows="4" style="resize: none;"></textarea>
                        </div>
                        <div class="form-group mb-4">
                            <label class="form-label" for="instructorName">Instructor Name</label>
                            <input type="text" id="instructorName" name="instructorName" class="form-control" value="<%= user.getFullname() %>">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="form-label">Category</label>
                                <select name="courseCategory" class="form-control">
                                    <option value="Technology">Technology</option>
                                    <option value="Business">Business</option>
                                    <option value="Design">Design</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-4">
                                <label class="form-label">Level</label>
                                <select name="courseLevel" class="form-control">
                                    <option value="Beginner">Beginner</option>
                                    <option value="Intermediate">Intermediate</option>
                                    <option value="Advanced">Advanced</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group mb-4">
                            <label class="form-label" for="courseDesc">Description</label>
                            <!-- 🎯 PASTIKAN name="courseDesc" -->
                            <textarea id="courseDesc" name="courseDesc" class="form-control" rows="4" 
                                      placeholder="What will students learn in this course?" style="resize: none;"></textarea>
                        </div>
                        <div class="d-flex justify-content-end gap-3">
                            <a href="instructorDashboard.jsp" class="btn btn-light border">Cancel</a>
                            <button type="submit" class="btn btn-primary" style="background-color: #6C63FF;">Create Course</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>