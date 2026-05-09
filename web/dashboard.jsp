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
</head>
<body>
<nav class="site-nav">
    <div class="inner">
        <h1>Research Repository</h1>
        <ul>
            <li><a href="dashboard" class="active">Dashboard</a></li>
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

<main class="container">
    <div style="margin-bottom: var(--space-8);">
        <h2 style="margin-bottom: var(--space-2);">Welcome back, <%= currentUser.getName() %></h2>
        <p style="margin: 0;">Logged in as <strong><%= currentUser.getDisplayRole() %></strong></p>
        <% if (springGreeting != null) { %>
            <p style="margin-top: var(--space-2); font-size: var(--text-sm); color: var(--color-text-muted);"><%= springGreeting %></p>
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

    <div class="stats-grid">
        <div class="stat-card">
            <div class="label">Submitted</div>
            <div class="value"><%= submittedCount %></div>
        </div>
        <div class="stat-card">
            <div class="label">Under Review</div>
            <div class="value"><%= reviewCount %></div>
        </div>
        <div class="stat-card">
            <div class="label">Accepted</div>
            <div class="value"><%= acceptedCount %></div>
        </div>
        <div class="stat-card">
            <div class="label">Rejected</div>
            <div class="value"><%= rejectedCount %></div>
        </div>
        <% if (currentUser.isFaculty() || currentUser.isAdmin()) { %>
        <div class="stat-card">
            <div class="label">Total Papers</div>
            <div class="value"><%= totalPapers %></div>
        </div>
        <% } %>
    </div>

    <h3 style="margin-bottom: var(--space-4);">Quick Actions</h3>
    <div class="quick-actions">
        <% if (currentUser.isStudent()) { %>
            <a href="uploadPaper" class="action-card">
                <div class="action-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" />
                    </svg>
                </div>
                <div class="action-content">
                    <h3>Submit New Paper</h3>
                    <p>Upload your research paper for review</p>
                </div>
            </a>
            <a href="listPapers" class="action-card">
                <div class="action-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                </div>
                <div class="action-content">
                    <h3>My Papers</h3>
                    <p>View and manage your submissions</p>
                </div>
            </a>
        <% } else { %>
            <a href="listPapers?status=submitted" class="action-card">
                <div class="action-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                    </svg>
                </div>
                <div class="action-content">
                    <h3>Review Papers</h3>
                    <p>Review submitted papers</p>
                </div>
            </a>
            <a href="facultyDashboard" class="action-card">
                <div class="action-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zm10 0a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zm10 0a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
                    </svg>
                </div>
                <div class="action-content">
                    <h3>Faculty Dashboard</h3>
                    <p>Advanced management tools</p>
                </div>
            </a>
        <% } %>
        <a href="listPapers?status=accepted" class="action-card">
            <div class="action-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
            </div>
            <div class="action-content">
                <h3>Accepted Papers</h3>
                <p>Browse accepted research papers</p>
            </div>
        </a>
    </div>

    <% if (recentPapers != null && !recentPapers.isEmpty()) { %>
    <div style="margin-top: var(--space-8);">
        <h3 style="margin-bottom: var(--space-4);">Recent Papers</h3>
        <div class="paper-list">
            <% for (Paper paper : recentPapers.subList(0, Math.min(5, recentPapers.size()))) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div>
                        <h4 class="paper-title"><%= paper.getTitle() %></h4>
                        <div class="paper-meta">
                            <span>By <%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                            <span><%= paper.getFormattedSubmissionDate() %></span>
                        </div>
                    </div>
                    <span class="badge badge-<%= paper.getStatus().replace(" ", "-") %>"><%= paper.getStatusDisplayName() %></span>
                </div>
            </div>
            <% } %>
        </div>
        <a href="listPapers" class="btn btn-secondary" style="margin-top: var(--space-4);">View All Papers</a>
    </div>
    <% } %>

    <% if ((currentUser.isFaculty() || currentUser.isAdmin()) && papersForReview != null && !papersForReview.isEmpty()) { %>
    <div style="margin-top: var(--space-8);">
        <h3 style="margin-bottom: var(--space-4);">Papers Pending Review (<%= papersForReview.size() %>)</h3>
        <div class="paper-list">
            <% for (Paper paper : papersForReview.subList(0, Math.min(5, papersForReview.size()))) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div>
                        <h4 class="paper-title"><%= paper.getTitle() %></h4>
                        <div class="paper-meta">
                            <span>By <%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                            <span><%= paper.getFormattedSubmissionDate() %></span>
                        </div>
                    </div>
                    <form action="updatePaperStatus" method="post" style="display: inline;">
                        <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                        <input type="hidden" name="status" value="under review">
                        <input type="hidden" name="redirectUrl" value="dashboard">
                        <button type="submit" class="btn btn-primary btn-sm">Start Review</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
        <a href="listPapers?status=submitted" class="btn btn-secondary" style="margin-top: var(--space-4);">View All Pending</a>
    </div>
    <% } %>
</main>

</body>
</html>