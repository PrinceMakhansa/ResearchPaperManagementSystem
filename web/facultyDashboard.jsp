<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.User" %>
<%@ page import="com.example.model.Paper" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || (!currentUser.isFaculty() && !currentUser.isAdmin())) {
        response.sendRedirect("login");
        return;
    }

    List<Paper> papersForReview = (List<Paper>) request.getAttribute("papersForReview");
    List<Paper> papersUnderReview = (List<Paper>) request.getAttribute("papersUnderReview");
    List<Paper> recentlyAccepted = (List<Paper>) request.getAttribute("recentlyAccepted");

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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<nav class="site-nav">
    <div class="inner">
        <h1>Research Repository</h1>
        <ul>
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="listPapers">All Papers</a></li>
            <li><a href="facultyDashboard" class="active">Faculty Dashboard</a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<main class="container">
    <div style="margin-bottom: var(--space-8);">
        <h2 style="margin-bottom: var(--space-2);">Faculty Dashboard</h2>
        <p style="margin: 0; color: var(--color-text-muted);">Welcome back, <strong><%= currentUser.getName() %></strong></p>
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
            <div class="label">Total Papers</div>
            <div class="value"><%= totalPapers %></div>
        </div>
        <div class="stat-card">
            <div class="label">Pending Review</div>
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
        <div class="stat-card">
            <div class="label">Acceptance Rate</div>
            <div class="value"><%= totalPapers > 0 ? Math.round((acceptedCount * 100.0) / totalPapers) : 0 %>%</div>
        </div>
    </div>

    <div class="quick-actions">
        <a href="listPapers?status=submitted" class="action-card">
            <div class="action-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                </svg>
            </div>
            <div class="action-content">
                <h3>Review Pending</h3>
                <p><%= submittedCount %> papers awaiting review</p>
            </div>
        </a>
        <a href="listPapers?status=under review" class="action-card">
            <div class="action-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
            </div>
            <div class="action-content">
                <h3>In Progress</h3>
                <p><%= reviewCount %> papers under review</p>
            </div>
        </a>
        <a href="listPapers?status=accepted" class="action-card">
            <div class="action-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
            </div>
            <div class="action-content">
                <h3>Accepted Papers</h3>
                <p><%= acceptedCount %> approved papers</p>
            </div>
        </a>
    </div>

    <% if (papersForReview != null && !papersForReview.isEmpty()) { %>
    <div style="margin-top: var(--space-8);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-4);">
            <h3 style="margin: 0;">Pending Review (<%= papersForReview.size() %>)</h3>
            <% if (papersForReview.size() > 5) { %>
                <a href="listPapers?status=submitted" class="btn btn-secondary btn-sm">View All</a>
            <% } %>
        </div>
        <div class="paper-list">
            <% for (Paper paper : papersForReview.subList(0, Math.min(5, papersForReview.size()))) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div style="flex: 1;">
                        <h4 class="paper-title"><%= paper.getTitle() %></h4>
                        <div class="paper-meta">
                            <span>By <%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                            <span><%= paper.getFormattedSubmissionDate() %></span>
                            <% if (paper.getAuthorEmail() != null) { %>
                                <span><%= paper.getAuthorEmail() %></span>
                            <% } %>
                        </div>
                    </div>
                    <form action="updatePaperStatus" method="post" style="display: inline;">
                        <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                        <input type="hidden" name="status" value="under review">
                        <input type="hidden" name="redirectUrl" value="facultyDashboard">
                        <button type="submit" class="btn btn-primary btn-sm">Start Review</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <% if (papersUnderReview != null && !papersUnderReview.isEmpty()) { %>
    <div style="margin-top: var(--space-8);">
        <h3 style="margin-bottom: var(--space-4);">Under Review (<%= papersUnderReview.size() %>)</h3>
        <div class="paper-list">
            <% for (Paper paper : papersUnderReview.subList(0, Math.min(5, papersUnderReview.size()))) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div style="flex: 1;">
                        <h4 class="paper-title"><%= paper.getTitle() %></h4>
                        <div class="paper-meta">
                            <span>By <%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                            <span><%= paper.getFormattedSubmissionDate() %></span>
                        </div>
                    </div>
                    <div class="paper-actions">
                        <form action="updatePaperStatus" method="post" style="display: inline;">
                            <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                            <input type="hidden" name="status" value="accepted">
                            <input type="hidden" name="redirectUrl" value="facultyDashboard">
                            <button type="submit" class="btn btn-success btn-sm">Accept</button>
                        </form>
                        <form action="updatePaperStatus" method="post" style="display: inline;">
                            <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                            <input type="hidden" name="status" value="rejected">
                            <input type="hidden" name="redirectUrl" value="facultyDashboard">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Reject this paper?')">Reject</button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <% if (recentlyAccepted != null && !recentlyAccepted.isEmpty()) { %>
    <div style="margin-top: var(--space-8);">
        <h3 style="margin-bottom: var(--space-4);">Recently Accepted</h3>
        <div class="paper-list">
            <% for (Paper paper : recentlyAccepted) { %>
            <div class="paper-card">
                <div class="paper-header">
                    <div style="flex: 1;">
                        <h4 class="paper-title"><%= paper.getTitle() %></h4>
                        <div class="paper-meta">
                            <span>By <%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                            <span><%= paper.getFormattedSubmissionDate() %></span>
                        </div>
                    </div>
                    <span class="badge badge-accepted">Accepted</span>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <% if ((papersForReview == null || papersForReview.isEmpty()) &&
           (papersUnderReview == null || papersUnderReview.isEmpty()) &&
           totalPapers == 0) { %>
    <div class="empty-state">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <h3>No Papers to Review</h3>
        <p>No papers have been submitted yet. Check back later.</p>
    </div>
    <% } %>
</main>

</body>
</html>