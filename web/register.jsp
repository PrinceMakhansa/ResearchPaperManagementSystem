<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .auth-form { display: grid; gap: var(--space-5); }
        .role-cards { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4); }
        .role-card {
            padding: var(--space-4);
            border: 2px solid var(--color-border);
            border-radius: var(--radius);
            cursor: pointer;
            text-align: center;
            transition: all 0.15s ease;
        }
        .role-card:hover { border-color: var(--color-primary); }
        .role-card.selected { border-color: var(--color-primary); background: var(--color-primary-light); }
        .role-card input { display: none; }
        .role-card h4 { margin-bottom: var(--space-1); }
        .role-card p { font-size: var(--text-sm); color: var(--color-text-muted); margin: 0; }
        .strength-bar { height: 4px; border-radius: 2px; margin-top: var(--space-2); background: var(--color-border); }
        .strength-bar span { display: block; height: 100%; border-radius: 2px; width: 0; transition: all 0.3s ease; }
        .strength-weak span { width: 33%; background: var(--color-danger); }
        .strength-medium span { width: 66%; background: var(--color-warning); }
        .strength-strong span { width: 100%; background: var(--color-success); }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <h1>Create Account</h1>
            <p>Join the Research Repository</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <form action="register" method="post" class="auth-form" id="registerForm">
            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input class="form-input" id="name" type="text" name="name" required
                       placeholder="Enter your full name"
                       value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" />
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input class="form-input" id="email" type="email" name="email" required
                       placeholder="Enter your email"
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" />
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input class="form-input" id="password" type="password" name="password" required
                       placeholder="Create a strong password" />
                <div class="strength-bar" id="strengthBar"><span></span></div>
                <small id="strengthText" style="color: var(--color-text-muted); margin-top: var(--space-1);"></small>
            </div>

            <div class="form-group">
                <label class="form-label" for="confirmPassword">Confirm Password</label>
                <input class="form-input" id="confirmPassword" type="password" name="confirmPassword" required
                       placeholder="Confirm your password" />
            </div>

            <div class="form-group">
                <label class="form-label">Select Your Role</label>
                <div class="role-cards">
                    <label class="role-card" for="student">
                        <input type="radio" id="student" name="role" value="student"
                               <%= "student".equals(request.getAttribute("role")) ? "checked" : "" %>>
                        <h4>Student</h4>
                        <p>Submit & track papers</p>
                    </label>
                    <label class="role-card" for="faculty">
                        <input type="radio" id="faculty" name="role" value="faculty"
                               <%= "faculty".equals(request.getAttribute("role")) ? "checked" : "" %>>
                        <h4>Faculty</h4>
                        <p>Review & manage papers</p>
                    </label>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">Create Account</button>
        </form>

        <div class="auth-footer">
            <p style="margin: 0;">Already have an account? <a href="login"><strong>Sign in</strong></a></p>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Auto-focus name field
    document.getElementById('name').focus();

    // Role selection styling
    document.querySelectorAll('.role-card').forEach(function(card) {
        card.addEventListener('click', function() {
            document.querySelectorAll('.role-card').forEach(c => c.classList.remove('selected'));
            this.classList.add('selected');
        });
    });

    // Set initial selection
    const checked = document.querySelector('input[name="role"]:checked');
    if (checked) checked.closest('.role-card').classList.add('selected');

    // Password strength
    const passwordField = document.getElementById('password');
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');

    passwordField.addEventListener('input', function() {
        const password = this.value;
        let score = 0;
        if (password.length >= 8) score++;
        if (/[a-z]/.test(password)) score++;
        if (/[A-Z]/.test(password)) score++;
        if (/[0-9]/.test(password)) score++;
        if (/[^a-zA-Z0-9]/.test(password)) score++;

        strengthBar.className = 'strength-bar';
        if (score < 3) {
            strengthBar.classList.add('strength-weak');
            strengthText.textContent = 'Weak';
            strengthText.style.color = 'var(--color-danger)';
        } else if (score < 5) {
            strengthBar.classList.add('strength-medium');
            strengthText.textContent = 'Medium';
            strengthText.style.color = 'var(--color-warning)';
        } else {
            strengthBar.classList.add('strength-strong');
            strengthText.textContent = 'Strong';
            strengthText.style.color = 'var(--color-success)';
        }
    });

    // Form validation
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirm = document.getElementById('confirmPassword').value;

        if (password !== confirm) {
            e.preventDefault();
            alert('Passwords do not match');
        } else if (!document.querySelector('input[name="role"]:checked')) {
            e.preventDefault();
            alert('Please select a role');
        } else if (password.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters');
        }
    });
});
</script>

</body>
</html>