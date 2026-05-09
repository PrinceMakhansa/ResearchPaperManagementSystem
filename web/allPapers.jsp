<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.User" %>
<%@ page import="com.example.model.Paper" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login");
        return;
    }
    List<Paper> papers = (List<Paper>) request.getAttribute("papers");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String statusFilter = (String) request.getAttribute("statusFilter");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Papers - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<nav class="site-nav">
    <div class="inner">
        <h1>Research Repository</h1>
        <ul>
            <li><a href="dashboard">Dashboard</a></li>
            <% if (currentUser.isStudent()) { %>
                <li><a href="listPapers">My Papers</a></li>
                <li><a href="allPapers" class="active">All Papers</a></li>
                <li><a href="uploadPaper">Upload Paper</a></li>
            <% } else { %>
                <li><a href="listPapers">Manage Papers</a></li>
                <li><a href="allPapers" class="active">All Papers</a></li>
                <li><a href="facultyDashboard">Faculty Dashboard</a></li>
            <% } %>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<main class="container">
    <div style="margin-bottom: var(--space-6);">
        <h2 style="margin-bottom: var(--space-2);">All Papers</h2>
        <p style="color: var(--color-text-muted); margin: 0;">Browse all submitted research papers</p>
    </div>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <div class="stats-grid" style="margin-bottom: var(--space-6);">
        <div class="stat-card"><div class="label">Submitted</div><div class="value"><%= request.getAttribute("submittedCount") %></div></div>
        <div class="stat-card"><div class="label">Under Review</div><div class="value"><%= request.getAttribute("reviewCount") %></div></div>
        <div class="stat-card"><div class="label">Accepted</div><div class="value"><%= request.getAttribute("acceptedCount") %></div></div>
        <div class="stat-card"><div class="label">Rejected</div><div class="value"><%= request.getAttribute("rejectedCount") %></div></div>
    </div>

    <div class="filters-section">
        <form method="get" action="allPapers" class="filter-row">
            <div class="form-group">
                <label class="form-label" for="search">Search</label>
                <input class="form-input" id="search" name="search" type="text"
                       placeholder="Search by title or abstract..."
                       value="<%= searchTerm != null ? searchTerm : "" %>" />
            </div>
            <div class="form-group">
                <label class="form-label">&nbsp;</label>
                <button type="submit" class="btn btn-primary">Search</button>
            </div>
        </form>
        <div class="status-filter">
            <a href="allPapers" class="<%= (statusFilter == null) ? "active" : "" %>">All</a>
            <a href="allPapers?status=submitted" class="<%= "submitted".equals(statusFilter) ? "active" : "" %>">Submitted</a>
            <a href="allPapers?status=under review" class="<%= "under review".equals(statusFilter) ? "active" : "" %>">Under Review</a>
            <a href="allPapers?status=accepted" class="<%= "accepted".equals(statusFilter) ? "active" : "" %>">Accepted</a>
            <a href="allPapers?status=rejected" class="<%= "rejected".equals(statusFilter) ? "active" : "" %>">Rejected</a>
        </div>
    </div>

    <% if (papers == null || papers.isEmpty()) { %>
        <div class="empty-state">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <h3>No papers found</h3>
            <p>No papers match the current filters.</p>
        </div>
    <% } else { %>
        <div class="paper-list">
            <% for (Paper p : papers) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div style="flex: 1;">
                        <h4 class="paper-title"><%= p.getTitle() %></h4>
                        <div class="paper-meta">
                            <span><%= p.getFormattedSubmissionDate() %></span>
                            <span><%= p.getAuthorName() != null ? p.getAuthorName() : "Unknown" %></span>
                            <% if (p.getFilePath() != null) { %>
                                <span><%= p.getFileName() %></span>
                            <% } %>
                        </div>
                    </div>
                    <span class="badge badge-<%= p.getStatus().replace(" ", "-") %>"><%= p.getStatusDisplayName() %></span>
                </div>
                <p class="paper-abstract"><%= p.getShortAbstract(250) %></p>
                <div class="paper-actions">
                    <% if (currentUser.isFaculty() || currentUser.isAdmin()) { %>
                        <% if (p.canBeReviewed() && Paper.STATUS_SUBMITTED.equals(p.getStatus())) { %>
                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= p.getPaperId() %>">
                                <input type="hidden" name="status" value="under review">
                                <input type="hidden" name="redirectUrl" value="allPapers">
                                <button type="submit" class="btn btn-primary btn-sm">Start Review</button>
                            </form>
                        <% } %>
                        <% if (Paper.STATUS_UNDER_REVIEW.equals(p.getStatus())) { %>
                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= p.getPaperId() %>">
                                <input type="hidden" name="status" value="accepted">
                                <input type="hidden" name="redirectUrl" value="allPapers">
                                <button type="submit" class="btn btn-success btn-sm">Accept</button>
                            </form>
                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= p.getPaperId() %>">
                                <input type="hidden" name="status" value="rejected">
                                <input type="hidden" name="redirectUrl" value="allPapers">
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Reject this paper?')">Reject</button>
                            </form>
                        <% } %>
                    <% } else { %>
                        <% if (p.getFilePath() != null) { %>
                            <a class="btn btn-secondary btn-sm" target="_blank" href="<%= p.getFilePath() %>">View File</a>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>

    <div style="text-align: center; margin-top: var(--space-8);">
        <a href="dashboard" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</main>

</body>
</html>