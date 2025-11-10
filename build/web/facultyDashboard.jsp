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
    List<Paper> allPapers = (List<Paper>) request.getAttribute("allPapers");

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
    <style>
        .dashboard-header {
            background: var(--gradient);
            color: white;
            padding: 2rem;
            border-radius: var(--radius-lg);
            margin-bottom: 2rem;
            text-align: center;
        }
        .dashboard-title {
            font-size: 2rem;
            margin: 0 0 0.5rem 0;
            font-weight: 700;
        }
        .dashboard-subtitle {
            opacity: 0.9;
            font-size: 1.125rem;
            margin: 0;
        }
        .review-section {
            margin: 2rem 0;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
            color: var(--text);
        }
        .paper-list {
            display: grid;
            gap: 1rem;
        }
        .paper-item {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s ease;
        }
        .paper-item:hover {
            box-shadow: var(--shadow);
        }
        .paper-info {
            flex: 1;
        }
        .paper-title {
            font-weight: 600;
            margin: 0 0 0.25rem 0;
            font-size: 1.125rem;
        }
        .paper-meta {
            color: var(--text-light);
            font-size: 0.875rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .paper-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
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
            text-align: center;
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
        .priority-badge {
            background: var(--danger-light);
            color: var(--danger);
            padding: 0.25rem 0.5rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .workload-summary {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            margin-bottom: 2rem;
        }
        .workload-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .workload-items {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
        }
        .workload-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .workload-count {
            font-weight: 600;
            color: var(--primary);
        }
    </style>
</head>
<body>
<nav class="site-nav">
    <div class="inner">
        <h1>Research Repository</h1>
        <ul>
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="listPapers">All Papers (Manage)</a></li>
            <li><a href="allPapers">All Papers (View)</a></li>
            <li><a href="facultyDashboard">Faculty Dashboard</a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <div class="dashboard-header">
        <h2 class="dashboard-title">Faculty Dashboard</h2>
        <p class="dashboard-subtitle">Welcome back, <%= currentUser.getName() %>! Manage and review research papers.</p>
    </div>

    <% String error = (String) request.getAttribute("error");
       String msg = request.getParameter("msg");
       if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>
    <% if (msg != null) { %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <!-- Overall Statistics -->
    <div class="stats-grid">
        <div class="stat-card">
            <h4>Total Papers</h4>
            <div class="value"><%= totalPapers %></div>
        </div>
        <div class="stat-card">
            <h4>Pending Review</h4>
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

    <!-- Workload Summary -->
    <div class="workload-summary">
        <div class="workload-title">Current Workload</div>
        <div class="workload-items">
            <div class="workload-item">
                <span class="workload-count"><%= submittedCount %></span>
                <span>papers awaiting review</span>
            </div>
            <div class="workload-item">
                <span class="workload-count"><%= reviewCount %></span>
                <span>papers in review process</span>
            </div>
            <div class="workload-item">
                <span class="workload-count"><%= totalPapers > 0 ? Math.round((acceptedCount * 100.0) / totalPapers) : 0 %>%</span>
                <span>acceptance rate</span>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <a href="listPapers?status=submitted" class="action-card">
            <span class="action-icon"></span>
            <h3 class="action-title">Review Pending Papers</h3>
            <p class="action-description"><%= submittedCount %> papers awaiting review</p>
        </a>
        <a href="listPapers?status=under review" class="action-card">
            <span class="action-icon"></span>
            <h3 class="action-title">Papers Under Review</h3>
            <p class="action-description"><%= reviewCount %> papers in progress</p>
        </a>
        <a href="listPapers?status=accepted" class="action-card">
            <span class="action-icon"></span>
            <h3 class="action-title">Accepted Papers</h3>
            <p class="action-description"><%= acceptedCount %> papers approved</p>
        </a>
        <a href="listPapers" class="action-card">
            <span class="action-icon"></span>
            <h3 class="action-title">All Papers</h3>
            <p class="action-description">Complete overview of submissions</p>
        </a>
    </div>

    <!-- Papers Pending Review -->
    <% if (papersForReview != null && !papersForReview.isEmpty()) { %>
    <div class="review-section">
        <div class="section-header">
            <h3 class="section-title">Papers Pending Review (<%= papersForReview.size() %>)</h3>
            <% if (papersForReview.size() > 5) { %>
                <a href="listPapers?status=submitted" class="btn btn-soft btn-small">View All</a>
            <% } %>
        </div>

        <div class="paper-list">
            <% for (Paper paper : papersForReview.subList(0, Math.min(5, papersForReview.size()))) { %>
            <div class="paper-item">
                <div class="paper-info">
                    <div class="paper-title">
                        <%= paper.getTitle() %>
                        <%
                        // Calculate days since submission
                        long daysSinceSubmission = (System.currentTimeMillis() - paper.getSubmissionDate().getTime()) / (1000 * 60 * 60 * 24);
                        if (daysSinceSubmission > 7) {
                        %>
                            <span class="priority-badge">Priority</span>
                        <% } %>
                    </div>
                    <div class="paper-meta">
                        <span>Submitted <%= paper.getFormattedSubmissionDate() %></span>
                        <span><%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                        <span><%= paper.getAuthorEmail() != null ? paper.getAuthorEmail() : "Unknown" %></span>
                        <% if (daysSinceSubmission > 0) { %>
                            <span><%= daysSinceSubmission %> days ago</span>
                        <% } %>
                    </div>
                </div>
                <div class="paper-actions">
                    <form action="updatePaperStatus" method="post" style="display: inline;">
                        <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                        <input type="hidden" name="status" value="under review">
                        <input type="hidden" name="redirectUrl" value="facultyDashboard">
                        <button type="submit" class="btn btn-small">Start Review</button>
                    </form>
                    <a href="listPapers#paper-<%= paper.getPaperId() %>" class="btn btn-soft btn-small">View Details</a>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- Papers Under Review -->
    <% if (papersUnderReview != null && !papersUnderReview.isEmpty()) { %>
    <div class="review-section">
        <div class="section-header">
            <h3 class="section-title">Papers Under Review (<%= papersUnderReview.size() %>)</h3>
            <% if (papersUnderReview.size() > 3) { %>
                <a href="listPapers?status=under review" class="btn btn-soft btn-small">View All</a>
            <% } %>
        </div>

        <div class="paper-list">
            <% for (Paper paper : papersUnderReview.subList(0, Math.min(3, papersUnderReview.size()))) { %>
            <div class="paper-item">
                <div class="paper-info">
                    <div class="paper-title"><%= paper.getTitle() %></div>
                    <div class="paper-meta">
                        <span><%= paper.getFormattedSubmissionDate() %></span>
                        <span><%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                        <span>Currently under review</span>
                    </div>
                </div>
                <div class="paper-actions">
                    <form action="updatePaperStatus" method="post" style="display: inline;">
                        <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                        <input type="hidden" name="status" value="accepted">
                        <input type="hidden" name="redirectUrl" value="facultyDashboard">
                        <button type="submit" class="btn btn-success btn-small">Accept</button>
                    </form>
                    <form action="updatePaperStatus" method="post" style="display: inline;">
                        <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                        <input type="hidden" name="status" value="rejected">
                        <input type="hidden" name="redirectUrl" value="facultyDashboard">
                        <button type="submit" class="btn btn-danger btn-small"
                                onclick="return confirm('Are you sure you want to reject this paper?')">Reject</button>
                    </form>
                    <form action="updatePaperStatus" method="post" style="display: inline;">
                        <input type="hidden" name="paperId" value="<%= paper.getPaperId() %>">
                        <input type="hidden" name="status" value="submitted">
                        <input type="hidden" name="redirectUrl" value="facultyDashboard">
                        <button type="submit" class="btn btn-soft btn-small">Back to Queue</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- Recently Accepted Papers -->
    <% if (recentlyAccepted != null && !recentlyAccepted.isEmpty()) { %>
    <div class="review-section">
        <div class="section-header">
            <h3 class="section-title">Recently Accepted Papers</h3>
            <a href="listPapers?status=accepted" class="btn btn-soft btn-small">View All</a>
        </div>

        <div class="paper-list">
            <% for (Paper paper : recentlyAccepted) { %>
            <div class="paper-item">
                <div class="paper-info">
                    <div class="paper-title"><%= paper.getTitle() %></div>
                    <div class="paper-meta">
                        <span><%= paper.getFormattedSubmissionDate() %></span>
                        <span><%= paper.getAuthorName() != null ? paper.getAuthorName() : "Unknown" %></span>
                        <span>Accepted</span>
                    </div>
                </div>
                <div class="paper-actions">
                    <a href="listPapers#paper-<%= paper.getPaperId() %>" class="btn btn-soft btn-small">View Details</a>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- Empty State -->
    <% if ((papersForReview == null || papersForReview.isEmpty()) &&
           (papersUnderReview == null || papersUnderReview.isEmpty()) &&
           totalPapers == 0) { %>
    <div class="review-section" style="text-align: center; padding: 3rem; color: var(--text-light);">
        <h3>No Papers to Review</h3>
        <p>No papers have been submitted yet. Check back later for new submissions.</p>
        <a href="listPapers" class="btn btn-soft">View All Papers</a>
    </div>
    <% } %>
</div>

<script>
// Auto-refresh every 5 minutes to show new submissions
setTimeout(function() {
    window.location.reload();
}, 5 * 60 * 1000);

// Confirm reject actions
document.querySelectorAll('button[onclick*="confirm"]').forEach(function(btn) {
    btn.addEventListener('click', function(e) {
        if (!confirm('Are you sure you want to reject this paper?')) {
            e.preventDefault();
        }
    });
});
</script>

</body>
</html>
