<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.User" %>
<%@ page import="com.example.model.Paper" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.spring.SpringHelper" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login");
        return;
    }

    List<Paper> userPapers = (List<Paper>) request.getAttribute("userPapers");
    List<Paper> recentPapers = (List<Paper>) request.getAttribute("recentPapers");
    List<Paper> papersForReview = (List<Paper>) request.getAttribute("papersForReview");

    Integer submittedCount = (Integer) request.getAttribute("submittedCount");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");
    Integer acceptedCount = (Integer) request.getAttribute("acceptedCount");
    Integer rejectedCount = (Integer) request.getAttribute("rejectedCount");
    Integer totalPapers = (Integer) request.getAttribute("totalPapers");

    if (submittedCount == null) submittedCount = 0;
    if (reviewCount == null) reviewCount = 0;
    if (acceptedCount == null) acceptedCount = 0;
    if (rejectedCount == null) rejectedCount = 0;
    if (totalPapers == null) totalPapers = 0;

    String springGreeting = SpringHelper.trySpringGreeting(currentUser != null ? currentUser.getName() : "Guest");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .welcome-section {
            background: var(--gradient);
            color: white;
            padding: 2rem;
            border-radius: var(--radius-lg);
            margin-bottom: 2rem;
            text-align: center;
        }
        .welcome-title {
            font-size: 2rem;
            margin: 0 0 0.5rem 0;
            font-weight: 700;
        }
        .welcome-subtitle {
            opacity: 0.9;
            font-size: 1.125rem;
            margin: 0;
        }
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        .action-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            text-decoration: none;
            color: var(--text);
            transition: all 0.2s ease;
            display: block;
        }
        .action-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            text-decoration: none;
            color: var(--text);
        }
        .action-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
            display: block;
        }
        .action-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin: 0 0 0.5rem 0;
        }
        .action-description {
            color: var(--text-light);
            margin: 0;
        }
        .recent-papers {
            margin-top: 2rem;
        }
        .paper-item {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .paper-info h4 {
            margin: 0 0 0.25rem 0;
            font-size: 1rem;
        }
        .paper-meta {
            color: var(--text-light);
            font-size: 0.875rem;
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
    <div class="welcome-section">
        <h2 class="welcome-title">Welcome back, <%= currentUser.getName() %>!</h2>
        <p class="welcome-subtitle">You are logged in as a <%= currentUser.getDisplayRole() %></p>
        <% if (springGreeting != null) { %>
            <p style="margin-top:0.75rem;font-size:0.95rem;opacity:0.9;"><%= springGreeting %></p>
        <% } %>
    </div>

    <% String error = (String) request.getAttribute("error");
       String msg = request.getParameter("msg");
       if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>
    <% if (msg != null) { %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <h4>Submitted Papers</h4>
            <div class="value"><%= submittedCount %></div>
        </div>
        <div class="stat-card">
            <h4>Under Review</h4>
            <div class="value"><%= reviewCount %></div>
        </div>
        <div class="stat-card">
            <h4>Accepted Papers</h4>
            <div class="value"><%= acceptedCount %></div>
        </div>
        <div class="stat-card">
            <h4>Rejected Papers</h4>
            <div class="value"><%= rejectedCount %></div>
        </div>
        <% if (currentUser.isFaculty() || currentUser.isAdmin()) { %>
        <div class="stat-card">
            <h4>Total Papers</h4>
            <div class="value"><%= totalPapers %></div>
        </div>
        <% } %>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <% if (currentUser.isStudent()) { %>
            <a href="uploadPaper" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">Submit New Paper</h3>
                <p class="action-description">Upload your research paper for review</p>
            </a>
            <a href="listPapers" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">My Papers</h3>
                <p class="action-description">View and manage your submitted papers</p>
            </a>
        <% } else { %>
            <a href="listPapers?status=submitted" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">Review Papers</h3>
                <p class="action-description">Review submitted papers</p>
            </a>
            <a href="listPapers" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">All Papers</h3>
                <p class="action-description">View all papers in the system</p>
            </a>
            <a href="facultyDashboard" class="action-card">
                <span class="action-icon"></span>
                <h3 class="action-title">Faculty Dashboard</h3>
                <p class="action-description">Advanced management tools</p>
            </a>
        <% } %>
        <a href="listPapers?status=accepted" class="action-card">
            <span class="action-icon"></span>
            <h3 class="action-title">Accepted Papers</h3>
            <p class="action-description">Browse accepted research papers</p>
        </a>
    </div>

    <!-- Recent Papers Section -->
    <% if (recentPapers != null && !recentPapers.isEmpty()) { %>
    <div class="recent-papers">
        <h3>Recent Papers</h3>
        <% for (Paper paper : recentPapers.subList(0, Math.min(5, recentPapers.size()))) { %>
        <div class="paper-item">
            <div class="paper-info">
                <h4><%= paper.getTitle() %></h4>
                <div class="paper-meta">
                    By <%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %> •
                    <%= paper.getFormattedSubmissionDate() %>
                </div>
            </div>
            <span class="<%= paper.getStatusBadgeClass() %>"><%= paper.getStatusDisplayName() %></span>
        </div>
        <% } %>
        <a href="listPapers" class="btn btn-soft">View All Papers</a>
    </div>
    <% } %>

    <!-- Papers for Review (Faculty/Admin only) -->
    <% if ((currentUser.isFaculty() || currentUser.isAdmin()) && papersForReview != null && !papersForReview.isEmpty()) { %>
    <div class="recent-papers">
        <h3>Papers Pending Review (<%= papersForReview.size() %>)</h3>
        <% for (Paper paper : papersForReview.subList(0, Math.min(5, papersForReview.size()))) { %>
        <div class="paper-item">
            <div class="paper-info">
                <h4><%= paper.getTitle() %></h4>
                <div class="paper-meta">
                    By <%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %> •
                    <%= paper.getFormattedSubmissionDate() %>
                </div>
            </div>
            <div>
                <form action="updatePaperStatus" method="post" style="display: inline;">
                    <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                    <input type="hidden" name="status" value="under review">
                    <input type="hidden" name="redirectUrl" value="dashboard">
                    <button type="submit" class="btn btn-small">Start Review</button>
                </form>
            </div>
        </div>
        <% } %>
        <a href="listPapers?status=submitted" class="btn btn-soft">View All Pending Papers</a>
    </div>
    <% } %>
</div>

</body>
</html>
