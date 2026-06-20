<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // 1. Semakan Keselamatan: Pastikan pengguna telah login
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Ambil laluan gambar profil dinamik
    String avatar = user.getProfilePicture();
    if (avatar == null || avatar.isEmpty()) {
        avatar = "default-avatar.png";
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LMS - My Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
        <style>
            .profile-card-clean {
                background-color: #f3f6ff;
                border: 2px solid #6C63FF;
                border-radius: 12px;
                padding: 28px;
            }
            .info-row {
                margin-bottom: 16px;
                font-size: 15px;
                color: #1a233a;
            }
            .info-row:last-child {
                margin-bottom: 0;
            }
            .info-label {
                font-weight: 600;
                display: inline-block;
                width: 150px;
                color: #495057;
            }
            .info-value {
                font-weight: 400;
                color: #212529;
            }
            .btn-kemaskini {
                color: #2ec4b6;
                font-weight: 500;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: none;
                border: none;
                padding: 0;
                font-size: 16px;
                transition: color 0.2s;
            }
            .btn-kemaskini:hover {
                color: #1d9a8f;
                text-decoration: underline;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <nav class="sidebar">
                <div class="logo">LMS</div>
                <ul class="sidebar-menu p-0">
                    <% if ("instructor".equalsIgnoreCase(user.getRole())) { %>
                    <li><a href="instructorDashboard.jsp"><i class="bi bi-book me-3"></i> Dashboard</a></li>
                    <li><a href="instructorDashboard.jsp"><i class="bi bi-journal-bookmark me-3"></i> Courses</a></li>
                        <% } else { %>
                    <li><a href="studentDashboard.jsp"><i class="bi bi-book me-3"></i> Dashboard</a></li>
                    <li><a href="courses.jsp"><i class="bi bi-journal-bookmark me-3"></i> Courses</a></li>
                        <% } %>
                    <li><a href="profile.jsp" class="active"><i class="bi bi-person me-3"></i> Profile</a></li>
                    <li><a href="LogoutServlet"><i class="bi bi-box-arrow-right me-3"></i> Logout</a></li>
                </ul>
            </nav>

            <main class="main-content">
                <div class="container-fluid py-4">

                    <div class="mb-4">
                        <h2 class="fw-bold m-0">My Profile</h2>
                        <p class="text-muted">Maklumat peribadi dan akaun sistem anda.</p>
                    </div>

                    <% if ("update_success".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                        <i class="bi bi-check-circle-fill me-2"></i> Profil berjaya dikemaskini!
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <% } %>

                    <div class="row g-4">
                        <div class="col-md-3 text-center">
                            <div class="p-1 d-inline-block bg-white shadow-sm" style="border: 3px solid #6C63FF; border-radius: 4px;">
                                <% if ("default-avatar.png".equals(avatar)) { %>
                                <div class="bg-light d-flex align-items-center justify-content-center" style="width: 160px; height: 210px;">
                                    <i class="bi bi-person-fill text-secondary" style="font-size: 5rem;"></i>
                                </div>
                                <% } else {%>
                                <img src="uploads/<%= avatar%>" style="width: 160px; height: 210px; object-fit: cover; border-radius: 2px;" alt="Profile Picture">
                                <% }%>
                            </div>
                        </div>

                        <div class="col-md-9">
                            <div class="profile-card-clean shadow-sm">
                                <div class="info-row">
                                    <span class="info-label">USER ID / ID:</span>
                                    <span class="info-value fw-bold"><%= user.getId()%></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">NAMA PENUH:</span>
                                    <span class="info-value"><%= user.getFullname()%></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">EMAIL:</span>
                                    <span class="info-value" style="text-transform: lowercase;"><%= (user.getEmail() != null) ? user.getEmail() : "Tiada Email Didaftar"%></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">PERANAN (ROLE):</span>
                                    <span class="info-value text-uppercase fw-medium text-primary"><%= user.getRole()%></span>
                                </div>
                            </div>

                            <div class="mt-4 text-end">
                                <button class="btn-kemaskini" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="bi bi-person-bounding-box" style="font-size: 18px;"></i> Kemaskini Profil
                                </button>
                            </div>
                        </div>
                    </div>

                </div>
            </main>
        </div>

        <div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <form action="UpdateProfileServlet" method="POST" enctype="multipart/form-data" class="modal-content" style="border-radius: 16px; border: none;">
                    <div class="modal-header border-0 pt-4 px-4">
                        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-primary me-2"></i>Kemaskini Maklumat</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body px-4 py-2">
                        <!-- Input untuk Username / User ID Pilihan -->
                        

                        <div class="mb-3">
                            <label class="form-label fw-medium text-secondary">Username / User ID *</label>
                            <input type="text" name="id" class="form-control" 
                                   value="<%= user.getId()%>" 
                                   readonly style="border-radius: 10px; padding: 10px; background-color: #e9ecef; cursor: not-allowed;">
                        </div>
                        <!-- Input untuk Nama Penuh -->
                        <div class="mb-3">
                            <label class="form-label fw-medium text-secondary">Nama Penuh *</label>
                            <input type="text" name="fullname" class="form-control" value="<%= user.getFullname()%>" required style="border-radius: 10px; padding: 10px;">
                        </div>
                        <!-- Input untuk Email -->
                        <div class="mb-3">
                            <label class="form-label fw-medium text-secondary">Email Address *</label>
                            <input type="email" name="email" class="form-control" value="<%= (user.getEmail() != null) ? user.getEmail() : ""%>" required style="border-radius: 10px; padding: 10px;">
                        </div>
                        <!-- Input untuk Gambar -->
                        <div class="mb-3">
                            <label class="form-label fw-medium text-secondary">Muat Naik Gambar Profil Baharu</label>
                            <input type="file" name="profilePic" class="form-control" accept="image/*" style="border-radius: 10px; padding: 10px;">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pb-4 px-4 gap-2">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal" style="border-radius: 12px; padding: 10px 20px;">Batal</button>
                        <button type="submit" class="btn btn-primary" style="border-radius: 12px; padding: 10px 24px; background-color: #6C63FF; border-color: #6C63FF;">Simpan Perubahan</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>