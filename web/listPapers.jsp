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
    <style>
        .papers-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .papers-title {
            margin: 0;
            font-size: 2rem;
        }
        .filters-section {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .filter-row {
            display: grid;
            grid-template-columns: 2fr auto; /* search + submit button */
            gap: 1rem;
            align-items: end;
        }
        .papers-grid {
            display: grid;
            gap: 1.5rem;
        }
        .paper-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            transition: all 0.2s ease;
            position: relative;
        }
        .paper-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }
        .paper-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
            gap: 1rem;
        }
        .paper-title {
            margin: 0 0 0.5rem 0;
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text);
        }
        .paper-meta {
            color: var(--text-light);
            font-size: 0.875rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .paper-abstract {
            color: var(--text);
            margin: 1rem 0;
            line-height: 1.6;
        }
        .paper-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .status-filter {
            display: flex;
            gap: 0.5rem;
            margin: 1rem 0;
            flex-wrap: wrap;
        }
        .status-filter-btn {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border);
            background: var(--bg-alt);
            border-radius: var(--radius);
            text-decoration: none;
            color: var(--text);
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }
        .status-filter-btn:hover, .status-filter-btn.active {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
            text-decoration: none;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }
        .empty-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            display: block;
        }
        .search-highlight {
            background-color: var(--warning-light);
            padding: 0.125rem 0.25rem;
            border-radius: 0.25rem;
        }
        @media (max-width: 768px) {
            .filter-row { grid-template-columns: 1fr; }
            .papers-header {
                flex-direction: column;
                align-items: stretch;
            }
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
    <div class="papers-header">
        <div>
            <h2 class="papers-title"><%= currentUser.isStudent() ? "My Papers" : "All Papers" %></h2>
            <p class="text-muted">
                <% if (currentUser.isStudent()) { %>
                    Manage and track your submitted research papers
                <% } else { %>
                    Review and manage all submitted papers
                <% } %>
            </p>
        </div>
        <% if (currentUser.isStudent()) { %>
            <a href="uploadPaper" class="btn">Submit New Paper</a>
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

    <!-- Statistics Summary -->
    <div class="stats-grid">
        <div class="stat-card">
            <h4>Submitted</h4>
            <div class="value"><%= submittedCount %></div>
        </div>
        <div class="stat-card">
            <h4>Under Review</h4>
            <div class="value"><%= reviewCount %></div>
        </div>
        <div class="stat-card">
            <h4>Accepted</h4>
            <div class="value"><%= acceptedCount %></div>
        </div>
        <div class="stat-card">
            <h4>Rejected</h4>
            <div class="value"><%= rejectedCount %></div>
        </div>
    </div>

    <!-- Search and Filter Section -->
    <div class="filters-section">
        <form method="get" action="listPapers" class="filter-row">
            <div class="form-row">
                <label for="search">Search Papers</label>
                <input id="search" type="text" name="search"
                       placeholder="Search by title or abstract..."
                       value="<%= searchTerm != null ? searchTerm : "" %>">
                <input type="hidden" name="status" value="<%= statusFilter != null ? statusFilter : "all" %>">
            </div>
            <div class="form-row">
                <button type="submit" class="btn">Apply Filters</button>
            </div>
        </form>

        <div class="status-filter">
            <a href="listPapers" class="status-filter-btn <%= (statusFilter == null) ? "active" : "" %>">All</a>
            <a href="listPapers?status=submitted" class="status-filter-btn <%= "submitted".equals(statusFilter) ? "active" : "" %>">Submitted</a>
            <a href="listPapers?status=under review" class="status-filter-btn <%= "under review".equals(statusFilter) ? "active" : "" %>">Under Review</a>
            <a href="listPapers?status=accepted" class="status-filter-btn <%= "accepted".equals(statusFilter) ? "active" : "" %>">Accepted</a>
            <a href="listPapers?status=rejected" class="status-filter-btn <%= "rejected".equals(statusFilter) ? "active" : "" %>">Rejected</a>
        </div>
    </div>

    <!-- Papers List -->
    <% if (papers == null || papers.isEmpty()) { %>
        <div class="empty-state">
            <h3>No papers found</h3>
            <p>
                <% if (searchTerm != null && !searchTerm.trim().isEmpty()) { %>
                    No papers match your search criteria "<strong><%= searchTerm %></strong>".
                <% } else if (statusFilter != null && !"all".equals(statusFilter)) { %>
                    No papers with status "<strong><%= statusFilter %></strong>" found.
                <% } else if (currentUser.isStudent()) { %>
                    You haven't submitted any papers yet.
                <% } else { %>
                    No papers have been submitted yet.
                <% } %>
            </p>
            <% if (currentUser.isStudent()) { %>
                <a href="uploadPaper" class="btn">Submit Your First Paper</a>
            <% } %>
        </div>
    <% } else { %>
        <div class="papers-grid">
            <% for (Paper paper : papers) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div style="flex: 1;">
                        <h3 class="paper-title"><%= paper.getTitle() %></h3>
                        <div class="paper-meta">
                            <span><%= paper.getFormattedSubmissionDate() %></span>
                            <% if (!currentUser.isStudent()) { %>
                                <span><%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                                <span><%= paper.getAuthorEmail() != null ? paper.getAuthorEmail() : "Unknown" %></span>
                            <% } %>
                            <% if (paper.getFilePath() != null && !paper.getFilePath().isEmpty()) { %>
                                <span><%= paper.getFileName() %></span>
                            <% } %>
                        </div>
                    </div>
                    <span class="<%= paper.getStatusBadgeClass() %>"><%= paper.getStatusDisplayName() %></span>
                </div>

                <div class="paper-abstract">
                    <%
                    String abstractText = paper.getShortAbstract(300);
                    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                        abstractText = abstractText.replaceAll("(?i)(" + java.util.regex.Pattern.quote(searchTerm) + ")",
                                                              "<span class=\"search-highlight\">$1</span>");
                    }
                    %>
                    <%= abstractText %>
                </div>

                <div class="paper-actions">
                    <% if (currentUser.isFaculty() || currentUser.isAdmin()) { %>
                        <% if (paper.canBeReviewed()) { %>
                            <% if (Paper.STATUS_SUBMITTED.equals(paper.getStatus())) { %>
                                <form action="updatePaperStatus" method="post" style="display: inline;">
                                    <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                                    <input type="hidden" name="status" value="under review">
                                    <input type="hidden" name="redirectUrl" value="listPapers">
                                    <button type="submit" class="btn btn-small">Start Review</button>
                                </form>
                            <% } %>

                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                                <input type="hidden" name="status" value="accepted">
                                <input type="hidden" name="redirectUrl" value="listPapers">
                                <button type="submit" class="btn btn-success btn-small">Accept</button>
                            </form>

                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                                <input type="hidden" name="status" value="rejected">
                                <input type="hidden" name="redirectUrl" value="listPapers">
                                <button type="submit" class="btn btn-danger btn-small"
                                        onclick="return confirm('Are you sure you want to reject this paper?')">Reject</button>
                            </form>
                        <% } %>

                        <% if (Paper.STATUS_UNDER_REVIEW.equals(paper.getStatus())) { %>
                            <form action="updatePaperStatus" method="post" style="display: inline;">
                                <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                                <input type="hidden" name="status" value="submitted">
                                <input type="hidden" name="redirectUrl" value="listPapers">
                                <button type="submit" class="btn btn-soft btn-small">Back to Submitted</button>
                            </form>
                        <% } %>
                    <% } else { %>
                        <% if (paper.getFilePath() != null && !paper.getFilePath().isEmpty()) { %>
                            <a href="<%= paper.getFilePath() %>" target="_blank" class="btn btn-soft btn-small">View File</a>
                        <% } %>
                        <% if (paper.isEditable()) { %>
                            <button class="btn btn-soft btn-small" onclick="alert('Edit functionality coming soon!')">Edit</button>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>

    <div style="margin-top: 2rem; text-align: center;">
        <a href="dashboard" class="btn btn-soft">Back to Dashboard</a>
    </div>
</div>

<script>

document.querySelectorAll('button[onclick*="confirm"]').forEach(function(btn) {
    btn.addEventListener('click', function(e) {
        if (!confirm(this.getAttribute('onclick').match(/'([^']+)'/)[1])) {
            e.preventDefault();
        }
    });
});
</script>

</body>
</html>
