<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--gradient);
            padding: 2rem;
        }
        .login-card {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 3rem;
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 450px;
            border: 1px solid var(--border);
        }
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .login-title {
            font-size: 2rem;
            font-weight: 700;
            margin: 0 0 0.5rem 0;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .login-subtitle {
            color: var(--text-light);
            margin: 0;
        }
        .login-form {
            display: grid;
            gap: 1.5rem;
        }
        .form-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border);
        }
        .demo-accounts {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            margin-top: 1.5rem;
            font-size: 0.875rem;
        }
        .demo-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text);
        }
        .demo-item {
            display: flex;
            justify-content: space-between;
            margin: 0.25rem 0;
            color: var(--text-light);
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <div class="login-header">
            <h1 class="login-title">Research Repository</h1>
            <p class="login-subtitle">Welcome back! Please sign in to your account.</p>
        </div>

        <%
        String error = request.getParameter("error");
        String msg = request.getParameter("msg");
        if (error != null) {
        %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>

        <% if (msg != null) { %>
            <div class="alert alert-success">
                <%= msg %>
            </div>
        <% } %>

        <form action="login" method="post" class="login-form">
            <div class="form-row">
                <label for="email">Email Address</label>
                <input id="email" type="email" name="email" required
                       placeholder="Enter your email address"
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" />
            </div>
            <div class="form-row">
                <label for="password">Password</label>
                <input id="password" type="password" name="password" required
                       placeholder="Enter your password" />
            </div>
            <div class="form-row">
                <button type="submit" class="btn btn-large">
                    Sign In
                </button>
            </div>
        </form>

        <div class="form-footer">
            <p>Don't have an account? <a href="register"><strong>Create one here</strong></a></p>
        </div>

        <div class="demo-accounts">
            <div class="demo-title">Demo Accounts:</div>
            <div class="demo-item">
                <span>Student:</span>
                <span>student@test.com / password</span>
            </div>
            <div class="demo-item">
                <span>Faculty:</span>
                <span>faculty@test.com / password</span>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Auto-focus email field
    document.getElementById('email').focus();

    // Demo account quick fill
    document.querySelectorAll('.demo-item').forEach(function(item) {
        item.style.cursor = 'pointer';
        item.addEventListener('click', function() {
            const text = this.textContent;
            if (text.includes('student@test.com')) {
                document.getElementById('email').value = 'student@test.com';
                document.getElementById('password').value = 'password';
            } else if (text.includes('faculty@test.com')) {
                document.getElementById('email').value = 'faculty@test.com';
                document.getElementById('password').value = 'password';
            }
        });
    });
});
</script>

</body>
</html>
