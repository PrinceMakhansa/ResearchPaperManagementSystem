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
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>All Papers - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .filters-section { background: var(--bg-card); border:1px solid var(--border); border-radius: var(--radius-lg); padding:1.25rem; margin-bottom:2rem; }
        .filter-row { display:grid; grid-template-columns:2fr auto; gap:1rem; align-items:end; }
        .status-filter { display:flex; gap:0.5rem; flex-wrap:wrap; margin-top:1rem; }
        .status-filter-btn { padding:0.5rem 1rem; border:1px solid var(--border); background:var(--bg-alt); border-radius:var(--radius); text-decoration:none; color:var(--text); font-size:0.875rem; }
        .status-filter-btn.active, .status-filter-btn:hover { background:var(--primary); color:#fff; border-color:var(--primary); }
        .papers-grid { display:grid; gap:1rem; }
        .paper-card { background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-lg); padding:1rem 1.25rem; }
        .paper-header { display:flex; justify-content:space-between; align-items:flex-start; gap:1rem; }
        .paper-title { margin:0 0 0.5rem 0; font-size:1.1rem; font-weight:600; }
        .paper-meta { font-size:0.75rem; color:var(--text-light); display:flex; gap:0.75rem; flex-wrap:wrap; }
        .paper-abstract { margin:0.75rem 0; font-size:0.875rem; line-height:1.5; }
        .paper-actions { display:flex; gap:0.5rem; flex-wrap:wrap; }
        .empty-state { text-align:center; padding:2.5rem; color:var(--text-light); }
    </style>
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
                <li><a href="allPapers" class="active">All Papers</a></li>
                <li><a href="listPapers">Manage Papers</a></li>
                <li><a href="facultyDashboard">Faculty Dashboard</a></li>
            <% } %>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>
<div class="container">
    <h2 style="margin-top:0;">All Papers</h2>
    <p class="text-muted">Browse all submitted papers. Students have read-only access.</p>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card"><h4>Submitted</h4><div class="value"><%= request.getAttribute("submittedCount") %></div></div>
        <div class="stat-card"><h4>Under Review</h4><div class="value"><%= request.getAttribute("reviewCount") %></div></div>
        <div class="stat-card"><h4>Accepted</h4><div class="value"><%= request.getAttribute("acceptedCount") %></div></div>
        <div class="stat-card"><h4>Rejected</h4><div class="value"><%= request.getAttribute("rejectedCount") %></div></div>
    </div>

    <div class="filters-section">
        <form method="get" action="allPapers" class="filter-row" style="grid-template-columns:1fr auto;">
            <div class="form-row">
                <label for="search">Search Papers</label>
                <input id="search" name="search" type="text" placeholder="Search by title or abstract..." value="<%= searchTerm != null ? searchTerm : "" %>">
            </div>
            <div class="form-row"><button type="submit" class="btn">Search</button></div>
        </form>
    </div>

    <% if (papers == null || papers.isEmpty()) { %>
        <div class="empty-state">
            <h3>No papers found</h3>
            <p>No papers match the current filters.</p>
        </div>
    <% } else { %>
        <div class="papers-grid">
            <% for (Paper p : papers) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div style="flex:1;">
                        <h3 class="paper-title"><%= p.getTitle() %></h3>
                        <div class="paper-meta">
                            <span><%= p.getFormattedSubmissionDate() %></span>
                            <span><%= p.getAuthorName() != null ? p.getAuthorName() : "Unknown" %></span>
                            <span><%= p.getAuthorEmail() != null ? p.getAuthorEmail() : "Unknown" %></span>
                            <% if (p.getFilePath() != null && !p.getFilePath().isEmpty()) { %>
                                <span><%= p.getFileName() %></span>
                            <% } %>
                        </div>
                    </div>
                    <span class="<%= p.getStatusBadgeClass() %>"><%= p.getStatusDisplayName() %></span>
                </div>
                <div class="paper-abstract">
                    <%= p.getShortAbstract(250) %>
                </div>
                <div class="paper-actions">
                    <% if (currentUser.isFaculty() || currentUser.isAdmin()) { %>
                        <% if (p.canBeReviewed()) { %>
                            <% if (Paper.STATUS_SUBMITTED.equals(p.getStatus())) { %>
                                <form action="updatePaperStatus" method="post" style="display:inline;">
                                    <input type="hidden" name="paperId" value="<%= p.getPaperId() %>">
                                    <input type="hidden" name="status" value="under review">
                                    <input type="hidden" name="redirectUrl" value="allPapers">
                                    <button type="submit" class="btn btn-small">Start Review</button>
                                </form>
                            <% } %>
                            <form action="updatePaperStatus" method="post" style="display:inline;">
                                <input type="hidden" name="paperId" value="<%= p.getPaperId() %>">
                                <input type="hidden" name="status" value="accepted">
                                <input type="hidden" name="redirectUrl" value="allPapers">
                                <button type="submit" class="btn btn-success btn-small">Accept</button>
                            </form>
                            <form action="updatePaperStatus" method="post" style="display:inline;">
                                <input type="hidden" name="paperId" value="<%= p.getPaperId() %>">
                                <input type="hidden" name="status" value="rejected">
                                <input type="hidden" name="redirectUrl" value="allPapers">
                                <button type="submit" class="btn btn-danger btn-small" onclick="return confirm('Reject this paper?')">Reject</button>
                            </form>
                        <% } %>
                        <% if (Paper.STATUS_UNDER_REVIEW.equals(p.getStatus())) { %>
                            <form action="updatePaperStatus" method="post" style="display:inline;">
                                <input type="hidden" name="paperId" value="<%= p.getPaperId() %>">
                                <input type="hidden" name="status" value="submitted">
                                <input type="hidden" name="redirectUrl" value="allPapers">
                                <button type="submit" class="btn btn-soft btn-small">Back to Submitted</button>
                            </form>
                        <% } %>
                    <% } else { %>
                        <% if (p.getFilePath() != null && !p.getFilePath().isEmpty()) { %>
                            <a class="btn btn-soft btn-small" target="_blank" href="<%= p.getFilePath() %>">View File</a>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>

    <div style="margin-top:2rem;text-align:center;">
        <a href="dashboard" class="btn btn-soft">Back to Dashboard</a>
    </div>
</div>
<script>
// confirm buttons
document.querySelectorAll('button[onclick*="confirm"]').forEach(function(btn){
  btn.addEventListener('click', function(e){
    var attr = this.getAttribute('onclick') || '';
    var m = attr.match(/'(.*)'/);
    if(!m || !confirm(m[1])){ e.preventDefault(); }
  });
});
</script>
</body>
</html>
