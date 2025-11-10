<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .profile-header {
            background: var(--gradient);
            color: white;
            padding: 2rem;
            border-radius: var(--radius-lg);
            margin-bottom: 2rem;
            text-align: center;
        }
        .profile-avatar {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 1rem;
        }
        .profile-name {
            font-size: 1.5rem;
            margin: 0 0 0.5rem 0;
            font-weight: 600;
        }
        .profile-role {
            opacity: 0.9;
            font-size: 1rem;
        }
        .profile-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin: 2rem 0;
        }
        .info-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
        }
        .info-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin: 0 0 1rem 0;
            color: var(--text);
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border);
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 500;
            color: var(--text-light);
        }
        .info-value {
            color: var(--text);
        }
    </style>
</head>
<body>
<nav class="site-nav">
    <div class="inner">
        <h1>Research Repository</h1>
        <ul>
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="listPapers"><%= currentUser.isStudent() ? "My Papers" : "All Papers" %></a></li>
            <% if (currentUser.isStudent()) { %>
                <li><a href="allPapers">All Papers</a></li>
                <li><a href="uploadPaper">Upload Paper</a></li>
            <% } %>
            <% if (currentUser.isFaculty() || currentUser.isAdmin()) { %>
                <li><a href="facultyDashboard">Faculty Dashboard</a></li>
            <% } %>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <div class="profile-header">
        <div class="profile-avatar">
            <%= currentUser.isStudent() ? "S" : currentUser.isFaculty() ? "F" : "A" %>
        </div>
        <h2 class="profile-name"><%= currentUser.getName() %></h2>
        <p class="profile-role"><%= currentUser.getDisplayRole() %></p>
    </div>

    <div class="profile-info">
        <div class="info-card">
            <h3 class="info-title">Personal Information</h3>
            <div class="info-item">
                <span class="info-label">Full Name:</span>
                <span class="info-value"><%= currentUser.getName() %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Email Address:</span>
                <span class="info-value"><%= currentUser.getEmail() %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Role:</span>
                <span class="info-value"><%= currentUser.getDisplayRole() %></span>
            </div>
            <div class="info-item">
                <span class="info-label">User ID:</span>
                <span class="info-value">#<%= currentUser.getUserId() %></span>
            </div>
        </div>

        <div class="info-card">
            <h3 class="info-title">Account Details</h3>
            <div class="info-item">
                <span class="info-label">Account Created:</span>
                <span class="info-value">
                    <%= currentUser.getCreatedAt() != null ?
                        new java.text.SimpleDateFormat("MMM dd, yyyy").format(currentUser.getCreatedAt()) :
                        "Unknown" %>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">Account Type:</span>
                <span class="info-value">
                    <%= currentUser.isStudent() ? "Student Account" :
                        currentUser.isFaculty() ? "Faculty Account" : "Admin Account" %>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">Status:</span>
                <span class="info-value" style="color: var(--success);">Active</span>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions" style="margin-top: 2rem;">
        <% if (currentUser.isStudent()) { %>
            <a href="uploadPaper" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">Upload New Paper</h3>
                <p class="action-description">Submit a new research paper for review</p>
            </a>
            <a href="listPapers" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">My Papers</h3>
                <p class="action-description">View and manage your submissions</p>
            </a>
        <% } else { %>
            <a href="listPapers?status=submitted" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">Review Papers</h3>
                <p class="action-description">Review submitted papers</p>
            </a>
            <a href="facultyDashboard" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">Faculty Dashboard</h3>
                <p class="action-description">Advanced management tools</p>
            </a>
        <% } %>
        <div class="action-card" onclick="alert('Settings functionality coming soon!')" style="cursor: pointer;">
            <span class="action-icon"></span>
            <h3 class="action-title">Account Settings</h3>
            <p class="action-description">Manage your account preferences</p>
        </div>
        <a href="logout" class="action-card" style="border-color: var(--danger); color: var(--danger);">
            <span class="action-icon"></span>
            <h3 class="action-title">Sign Out</h3>
            <p class="action-description">Log out of your account</p>
        </a>
    </div>

    <div style="margin-top: 2rem; text-align: center;">
        <a href="dashboard" class="btn btn-soft">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
