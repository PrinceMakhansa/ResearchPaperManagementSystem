<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .auth-form { display: grid; gap: var(--space-5); }
        .auth-actions { display: flex; flex-direction: column; gap: var(--space-3); }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <h1>Research Repository</h1>
            <p>Sign in to your account</p>
        </div>

        <% String error = request.getParameter("error");
           String msg = request.getParameter("msg");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        <% if (msg != null) { %>
            <div class="alert alert-success"><%= msg %></div>
        <% } %>

        <form action="login" method="post" class="auth-form">
            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input class="form-input" id="email" type="email" name="email" required
                       placeholder="Enter your email"
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" />
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input class="form-input" id="password" type="password" name="password" required
                       placeholder="Enter your password" />
            </div>

            <div class="auth-actions">
                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">Sign In</button>
            </div>
        </form>

        <div class="auth-footer">
            <p style="margin: 0;">Don't have an account? <a href="register"><strong>Create one</strong></a></p>
        </div>

        <div class="demo-box">
            <h4>Demo Accounts</h4>
            <div class="demo-item">
                <span>Student:</span>
                <span style="font-family: var(--font-mono);">student@test.com / password</span>
            </div>
            <div class="demo-item">
                <span>Faculty:</span>
                <span style="font-family: var(--font-mono);">faculty@test.com / password</span>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('email').focus();
});
</script>

</body>
</html>