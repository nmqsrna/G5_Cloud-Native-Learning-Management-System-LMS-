<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Module" %>
<%
    // 1. Semakan Keselamatan: Pastikan pengguna telah login
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Ambil data kursus dinamik yang dihantar oleh DetailCourseServlet
    boolean editMode = "true".equals(request.getParameter("edit"));
    String courseId = (String) request.getAttribute("courseId");
    String title = (String) request.getAttribute("title");
    String desc = (String) request.getAttribute("desc");
    String instructor = (String) request.getAttribute("instructor");
    String category = (String) request.getAttribute("category");
    String level = (String) request.getAttribute("level");
    String tags = (String) request.getAttribute("tags");
    String status = (String) request.getAttribute("status");
    
    if (status == null) status = "Draft";
    if (title == null) title = "";
    if (desc == null) desc = "";
    if (instructor == null) instructor = "";
    if (category == null) category = "";
    if (level == null) level = "";
    if (tags == null) tags = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS - Course Details</title>
    
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
                <% if("instructor".equalsIgnoreCase(user.getRole())) { %>
                    <li><a href="instructorDashboard.jsp" class="active"><i class="bi bi-book me-3"></i> Dashboard</a></li>
                    <li><a href="instructorDashboard.jsp"><i class="bi bi-journal-bookmark me-3"></i> Courses</a></li>
                <% } else { %>
                    <li><a href="studentDashboard.jsp" class="active"><i class="bi bi-book me-3"></i> Dashboard</a></li>
                    <li><a href="courses.jsp"><i class="bi bi-journal-bookmark me-3"></i> Courses</a></li>
                <% } %>
                <li><a href="profile.jsp"><i class="bi bi-person me-3"></i> Profile</a></li>
                <li><a href="LogoutServlet"><i class="bi bi-box-arrow-right me-3"></i> Logout</a></li>
            </ul>
        </nav>
        
        <main class="main-content">
            <div class="container-fluid py-4">
                
                <div class="mb-4">
                    <% if("instructor".equalsIgnoreCase(user.getRole())) { %>
                        <a href="instructorDashboard.jsp" class="text-secondary text-decoration-none fw-medium d-inline-flex align-items-center gap-2">
                            <i class="bi bi-arrow-left"></i> Back
                        </a>
                    <% } else { %>
                        <a href="studentDashboard.jsp" class="text-secondary text-decoration-none fw-medium d-inline-flex align-items-center gap-2">
                            <i class="bi bi-arrow-left"></i> Back
                        </a>
                    <% } %>
                </div>
                
                <% if (!editMode) { %>
                <div class="card p-4 mb-4" style="border-radius: 18px;">
                    <div class="row align-items-center g-3">
                        <div class="col-md-7">
                            <div class="d-flex align-items-center gap-2 mb-2 flex-wrap">
                                <% if ("Active".equalsIgnoreCase(status)) { %>
                                    <span class="badge bg-success text-white rounded-pill px-3 py-1">Active</span>
                                <% } else if ("Archived".equalsIgnoreCase(status)) { %>
                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-1">Archived</span>
                                <% } else { %>
                                    <span class="badge bg-secondary text-white rounded-pill px-3 py-1">Draft</span>
                                <% } %>
                                <span class="text-muted small"><%= level.isEmpty() ? "All Levels" : level %> &middot; <%= category.isEmpty() ? "General" : category %></span>
                            </div>
                            <h2 class="fw-bold mb-1"><%= title %></h2>
                            <p class="text-muted mb-3">By <span class="fw-medium text-dark"><%= instructor.isEmpty() ? "Unknown Instructor" : instructor %></span></p>
                            <p class="fs-6 text-secondary"><%= desc.isEmpty() ? "No description provided." : desc %></p>
                            
                            <div class="d-flex gap-2 flex-wrap mt-2">
                                <% if (!tags.trim().isEmpty()) {
                                    for (String tag : tags.split(",")) {
                                        if (!tag.trim().isEmpty()) { %>
                                            <span class="badge bg-light text-secondary border px-2 py-1" style="font-size: 12px;">#<%= tag.trim().toLowerCase() %></span>
                                <%      }
                                    }
                                } %>
                            </div>
                        </div>
                        
                        <% if ("instructor".equalsIgnoreCase(user.getRole())) { %>
                            <div class="col-md-5 d-flex gap-2 justify-content-md-end align-self-start pt-md-2 flex-wrap">
                                <a href="DetailCourseServlet?id=<%= courseId %>&edit=true" class="btn btn-light border d-flex align-items-center gap-2" style="border-radius: 12px; background: #fff; padding: 10px 16px; font-weight: 500;">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                
                                <a href="DeleteCourseServlet?id=<%= courseId %>" class="btn btn-outline-danger d-flex align-items-center gap-2" onclick="return confirm('Adakah anda pasti mahu memadam kursus ini secara kekal? Semua modul di dalamnya akan hilang.');" style="border-radius: 12px; padding: 10px 16px; font-weight: 500;">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                                
                                <% if ("Draft".equalsIgnoreCase(status)) { %>
                                    <a href="UpdateCourseStatusServlet?id=<%= courseId %>&currentStatus=Draft" class="btn btn-success d-flex align-items-center gap-2" style="border-radius: 12px; padding: 10px 16px; font-weight: 500;">
                                        <i class="bi bi-globe"></i> Publish
                                    </a>
                                <% } else if ("Active".equalsIgnoreCase(status)) { %>
                                    <a href="UpdateCourseStatusServlet?id=<%= courseId %>&currentStatus=Active" class="btn btn-warning d-flex align-items-center gap-2" style="border-radius: 12px; padding: 10px 16px; font-weight: 500; color: white;">
                                        <i class="bi bi-archive"></i> Archive
                                    </a>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
                <% } else { %>
                
                <form action="EditCourseServlet" method="POST" class="card p-4 mb-4" style="border-radius: 18px;">
                    <input type="hidden" name="courseId" value="<%= courseId %>">
                    <h4 class="fw-bold mb-4 text-dark"><i class="bi bi-pencil-square me-2"></i>Edit Course Information</h4>
                    
                    <div class="form-group mb-3">
                        <label class="form-label fw-medium text-secondary">Course Title *</label>
                        <input type="text" name="courseTitle" class="form-control" value="<%= title %>" required style="border-radius: 10px; padding: 10px;">
                    </div>
                    
                    <div class="form-group mb-3">
                        <label class="form-label fw-medium text-secondary">Description</label>
                        <textarea name="courseDesc" class="form-control" rows="4" style="resize: none; border-radius: 10px; padding: 10px;"><%= desc %></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium text-secondary">Category</label>
                            <select name="courseCategory" class="form-select" style="border-radius: 10px; padding: 10px;">
                                <option value="Technology" <%= "Technology".equalsIgnoreCase(category) ? "selected" : "" %>>Technology</option>
                                <option value="Business" <%= "Business".equalsIgnoreCase(category) ? "selected" : "" %>>Business</option>
                                <option value="Design" <%= "Design".equalsIgnoreCase(category) ? "selected" : "" %>>Design</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-medium text-secondary">Level</label>
                            <select name="courseLevel" class="form-select" style="border-radius: 10px; padding: 10px;">
                                <option value="Beginner" <%= "Beginner".equalsIgnoreCase(level) ? "selected" : "" %>>Beginner</option>
                                <option value="Intermediate" <%= "Intermediate".equalsIgnoreCase(level) ? "selected" : "" %>>Intermediate</option>
                                <option value="Advanced" <%= "Advanced".equalsIgnoreCase(level) ? "selected" : "" %>>Advanced</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group mb-3">
                        <label class="form-label fw-medium text-secondary">Tags (Separate with commas)</label>
                        <input type="text" name="courseTags" class="form-control" value="<%= tags %>" style="border-radius: 10px; padding: 10px;">
                    </div>
                    
                    <input type="hidden" name="instructorName" value="<%= instructor %>">
                    
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="DetailCourseServlet?id=<%= courseId %>" class="btn btn-light border" style="border-radius: 12px; padding: 10px 20px;">Cancel</a>
                        <button type="submit" class="btn btn-primary" style="border-radius: 12px; padding: 10px 24px; background-color: #6C63FF; border-color: #6C63FF;">Save Changes</button>
                    </div>
                </form>
                <% } %>

                <%
                    java.util.List<Module> modules = (java.util.List<Module>) request.getAttribute("moduleList");
                    int moduleCount = (modules != null) ? modules.size() : 0;
                %>
                <div class="d-flex justify-content-between align-items-center mb-4 mt-4">
                    <h3 class="fw-bold m-0" style="font-size: 22px;">Curriculum (<%= moduleCount %> Modules)</h3>
                    
                    <%-- 🎯 FIX SEKATAN ROLE: Butang Add Module hanya keluar untuk instructor sahaja --%><% if ("instructor".equalsIgnoreCase(user.getRole())) { %>
                        <button class="btn btn-primary btn-sm d-inline-flex align-items-center gap-2" style="border-radius: 10px; background-color: #6C63FF; border-color: #6C63FF; padding: 10px 16px;" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                            <i class="bi bi-plus-lg"></i> Add Module
                        </button>
                    <% } %>
                </div>

                <% if (moduleCount == 0) { %>
                    <div class="text-center p-5 bg-white border-0 shadow-sm" style="border-radius: 16px;">
                        <i class="bi bi-folder-x text-muted mb-2" style="font-size: 2.5rem;"></i>
                        <h5 class="text-secondary fw-medium m-0">No files or learning resources have been uploaded yet.</h5>
                    </div>
                <% } else { %>
                    <div class="d-flex flex-column gap-2">
                        <% for (Module mod : modules) { %>
                            <div class="card p-3 border-0 shadow-sm d-flex justify-content-between align-items-center flex-row mb-2" style="border-radius: 16px; background-color: #ffffff;">
                                <div>
                                    <h6 class="fw-bold m-0 text-dark" style="font-size: 16px;"><%= mod.getModuleTitle() %></h6>
                                    <span class="badge bg-light text-secondary mt-1 small" style="font-size: 11px;"><%= mod.getContentType() %></span>
                                </div>
                                <a href="<%= request.getContextPath() %>/<%= mod.getFilePath() %>" target="_blank" class="btn btn-sm btn-outline-secondary px-3" style="border-radius: 10px;">
                                    Open Material <i class="bi bi-box-arrow-up-right ms-1"></i>
                                </a>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <% if ("instructor".equalsIgnoreCase(user.getRole())) { %>
    <div class="modal fade" id="addModuleModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="AddModuleServlet" method="POST" enctype="multipart/form-data" class="modal-content" style="border-radius: 16px; border: none;">
                <div class="modal-header border-0 pt-4 px-4">
                    <h5 class="modal-title fw-bold text-secondary"><i class="bi bi-cloud-upload-fill text-primary me-2"></i>Add New Resource File</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body px-4 py-2">
                    <input type="hidden" name="courseId" value="<%= courseId %>">
                    <div class="mb-3">
                        <label class="form-label fw-medium text-secondary">Module Title *</label>
                        <input type="text" name="moduleTitle" class="form-control" placeholder="e.g., Chapter 1: Introduction" required style="border-radius: 10px; padding: 10px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium text-secondary">Material Format *</label>
                        <select name="contentType" class="form-select" style="border-radius: 10px; padding: 10px;">
                            <option value="PDF">PDF File</option>
                            <option value="VIDEO">Video Lecture</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium text-secondary">Select File *</label>
                        <input type="file" name="moduleFile" class="form-control" required style="border-radius: 10px; padding: 10px;">
                    </div>
                </div>
                <div class="modal-footer border-0 pb-4 px-4 gap-2">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal" style="border-radius: 12px; padding: 10px 20px;">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="border-radius: 12px; padding: 10px 24px; background-color: #6C63FF; border-color: #6C63FF;">Save Document</button>
                </div>
            </form>
        </div>
    </div>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>