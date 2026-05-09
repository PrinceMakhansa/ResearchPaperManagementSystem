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

    Integer submittedCount = (Integer) request.getAttribute("submittedCount");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");
    Integer acceptedCount = (Integer) request.getAttribute("acceptedCount");
    Integer rejectedCount = (Integer) request.getAttribute("rejectedCount");

    if (submittedCount == null) submittedCount = 0;
    if (reviewCount == null) reviewCount = 0;
    if (acceptedCount == null) acceptedCount = 0;
    if (rejectedCount == null) rejectedCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= currentUser.isStudent() ? "My Papers" : "All Papers" %> - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<nav class="site-nav">
    <div class="inner">
        <h1>Research Repository</h1>
        <ul>
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="listPapers" class="active"><%= currentUser.isStudent() ? "My Papers" : "All Papers" %></a></li>
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
    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: var(--space-6); flex-wrap: wrap; gap: var(--space-4);">
        <div>
            <h2 style="margin-bottom: var(--space-2);"><%= currentUser.isStudent() ? "My Papers" : "All Papers" %></h2>
            <p style="color: var(--color-text-muted); margin: 0;">
                <%= currentUser.isStudent() ? "Manage your submissions" : "Review and manage all papers" %>
            </p>
        </div>
        <% if (currentUser.isStudent()) { %>
            <a href="uploadPaper" class="btn btn-primary">Submit New Paper</a>
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

    <div class="stats-grid" style="margin-bottom: var(--space-6);">
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
    </div>

    <div class="filters-section">
        <form method="get" action="listPapers" class="filter-row">
            <div class="form-group">
                <label class="form-label" for="search">Search</label>
                <input class="form-input" id="search" type="text" name="search"
                       placeholder="Search by title or abstract..."
                       value="<%= searchTerm != null ? searchTerm : "" %>" />
            </div>
            <div class="form-group">
                <label class="form-label">&nbsp;</label>
                <button type="submit" class="btn btn-primary">Search</button>
            </div>
        </form>

        <div class="status-filter">
            <a href="listPapers" class="<%= (statusFilter == null) ? "active" : "" %>">All</a>
            <a href="listPapers?status=submitted" class="<%= "submitted".equals(statusFilter) ? "active" : "" %>">Submitted</a>
            <a href="listPapers?status=under review" class="<%= "under review".equals(statusFilter) ? "active" : "" %>">Under Review</a>
            <a href="listPapers?status=accepted" class="<%= "accepted".equals(statusFilter) ? "active" : "" %>">Accepted</a>
            <a href="listPapers?status=rejected" class="<%= "rejected".equals(statusFilter) ? "active" : "" %>">Rejected</a>
        </div>
    </div>

    <% if (papers == null || papers.isEmpty()) { %>
        <div class="empty-state">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <h3>No papers found</h3>
            <p>
                <% if (searchTerm != null && !searchTerm.trim().isEmpty()) { %>
                    No results for "<%= searchTerm %>"
                <% } else if (currentUser.isStudent()) { %>
                    You haven't submitted any papers yet.
                <% } else { %>
                    No papers have been submitted yet.
                <% } %>
            </p>
            <% if (currentUser.isStudent()) { %>
                <a href="uploadPaper" class="btn btn-primary" style="margin-top: var(--space-4);">Submit Your First Paper</a>
            <% } %>
        </div>
    <% } else { %>
        <div class="paper-list">
            <% for (Paper paper : papers) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div style="flex: 1;">
                        <h4 class="paper-title"><%= paper.getTitle() %></h4>
                        <div class="paper-meta">
                            <span><%= paper.getFormattedSubmissionDate() %></span>
                            <% if (!currentUser.isStudent() && paper.getAuthorName() != null) { %>
                                <span><%= paper.getAuthorName() %></span>
                            <% } %>
                            <% if (paper.getFilePath() != null) { %>
                                <span><%= paper.getFileName() %></span>
                            <% } %>
                        </div>
                    </div>
                    <span class="badge badge-<%= paper.getStatus().replace(" ", "-") %>"><%= paper.getStatusDisplayName() %></span>
                </div>

                <p class="paper-abstract"><%= paper.getShortAbstract(300) %></p>

                <div class="paper-actions">
                    <% if (currentUser.isFaculty() || currentUser.isAdmin()) { %>
                        <% if (paper.canBeReviewed() && Paper.STATUS_SUBMITTED.equals(paper.getStatus())) { %>
                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                                <input type="hidden" name="status" value="under review">
                                <input type="hidden" name="redirectUrl" value="listPapers">
                                <button type="submit" class="btn btn-primary btn-sm">Start Review</button>
                            </form>
                        <% } %>

                        <% if (Paper.STATUS_UNDER_REVIEW.equals(paper.getStatus())) { %>
                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                                <input type="hidden" name="status" value="accepted">
                                <input type="hidden" name="redirectUrl" value="listPapers">
                                <button type="submit" class="btn btn-success btn-sm">Accept</button>
                            </form>
                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                                <input type="hidden" name="status" value="rejected">
                                <input type="hidden" name="redirectUrl" value="listPapers">
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Reject this paper?')">Reject</button>
                            </form>
                        <% } %>
                    <% } else { %>
                        <% if (paper.getFilePath() != null) { %>
                            <a href="<%= paper.getFilePath() %>" target="_blank" class="btn btn-secondary btn-sm">View File</a>
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