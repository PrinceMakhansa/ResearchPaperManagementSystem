<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .register-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--gradient);
            padding: 2rem;
        }
        .register-card {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            padding: 3rem;
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 500px;
            border: 1px solid var(--border);
        }
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .register-title {
            font-size: 2rem;
            font-weight: 700;
            margin: 0 0 0.5rem 0;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .register-subtitle {
            color: var(--text-light);
            margin: 0;
        }
        .register-form {
            display: grid;
            gap: 1.5rem;
        }
        .form-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border);
        }
        .role-selection {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        .role-option {
            padding: 1rem;
            border: 2px solid var(--border);
            border-radius: var(--radius);
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            background: var(--bg-alt);
        }
        .role-option:hover {
            border-color: var(--primary);
        }
        .role-option.selected {
            border-color: var(--primary);
            background: var(--primary-light);
        }
        .role-option input[type="radio"] {
            display: none;
        }
        .password-strength {
            margin-top: 0.5rem;
            font-size: 0.875rem;
        }
        .strength-weak { color: var(--danger); }
        .strength-medium { color: var(--warning); }
        .strength-strong { color: var(--success); }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-card">
        <div class="register-header">
            <h1 class="register-title">Research Repository</h1>
            <p class="register-subtitle">Create your account to get started</p>
        </div>

        <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
        %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>

        <form action="register" method="post" class="register-form" id="registerForm">
            <div class="form-row">
                <label for="name">Full Name</label>
                <input id="name" type="text" name="name" required
                       placeholder="Enter your full name"
                       value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" />
            </div>

            <div class="form-row">
                <label for="email">Email Address</label>
                <input id="email" type="email" name="email" required
                       placeholder="Enter your email address"
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" />
            </div>

            <div class="form-row">
                <label for="password">Password</label>
                <input id="password" type="password" name="password" required
                       placeholder="Create a strong password" />
                <div class="password-strength" id="passwordStrength"></div>
            </div>

            <div class="form-row">
                <label for="confirmPassword">Confirm Password</label>
                <input id="confirmPassword" type="password" name="confirmPassword" required
                       placeholder="Confirm your password" />
            </div>

            <div class="form-row">
                <label>Select Your Role</label>
                <div class="role-selection">
                    <label class="role-option" for="student">
                        <input type="radio" id="student" name="role" value="student"
                               <%= "student".equals(request.getAttribute("role")) ? "checked" : "" %>>
                        <strong>Student</strong>
                        <p>Submit and track your research papers</p>
                    </label>
                    <label class="role-option" for="faculty">
                        <input type="radio" id="faculty" name="role" value="faculty"
                               <%= "faculty".equals(request.getAttribute("role")) ? "checked" : "" %>>
                        <strong>Faculty</strong>
                        <p>Review and manage submitted papers</p>
                    </label>
                </div>
            </div>

            <div class="form-row">
                <button type="submit" class="btn btn-large">
                    Create Account
                </button>
            </div>
        </form>

        <div class="form-footer">
            <p>Already have an account? <a href="login"><strong>Sign in here</strong></a></p>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Auto-focus name field
    document.getElementById('name').focus();

    // Role selection
    document.querySelectorAll('.role-option').forEach(function(option) {
        option.addEventListener('click', function() {
            document.querySelectorAll('.role-option').forEach(opt => opt.classList.remove('selected'));
            this.classList.add('selected');
            this.querySelector('input[type="radio"]').checked = true;
        });
    });

    // Set initial selection
    const checkedRole = document.querySelector('input[name="role"]:checked');
    if (checkedRole) {
        checkedRole.closest('.role-option').classList.add('selected');
    }

    // Password strength indicator
    const passwordField = document.getElementById('password');
    const strengthIndicator = document.getElementById('passwordStrength');

    passwordField.addEventListener('input', function() {
        const password = this.value;
        const strength = calculatePasswordStrength(password);

        strengthIndicator.className = 'password-strength ' + strength.class;
        strengthIndicator.textContent = strength.text;
    });

    // Password confirmation validation
    const confirmPasswordField = document.getElementById('confirmPassword');
    confirmPasswordField.addEventListener('input', function() {
        const password = passwordField.value;
        const confirmPassword = this.value;

        if (confirmPassword && password !== confirmPassword) {
            this.setCustomValidity('Passwords do not match');
        } else {
            this.setCustomValidity('');
        }
    });

    // Form validation
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = passwordField.value;
        const confirmPassword = confirmPasswordField.value;
        const role = document.querySelector('input[name="role"]:checked');

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match');
            return false;
        }

        if (!role) {
            e.preventDefault();
            alert('Please select your role');
            return false;
        }

        if (password.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long');
            return false;
        }
    });
});

function calculatePasswordStrength(password) {
    let score = 0;

    if (password.length >= 8) score++;
    if (password.match(/[a-z]/)) score++;
    if (password.match(/[A-Z]/)) score++;
    if (password.match(/[0-9]/)) score++;
    if (password.match(/[^a-zA-Z0-9]/)) score++;

    if (score < 2) {
        return { class: 'strength-weak', text: 'Weak password' };
    } else if (score < 4) {
        return { class: 'strength-medium', text: 'Medium strength' };
    } else {
        return { class: 'strength-strong', text: 'Strong password' };
    }
}
</script>

</body>
</html>
