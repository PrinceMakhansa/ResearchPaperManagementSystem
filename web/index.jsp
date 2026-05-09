<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Research Repository - Academic Paper Management</title>
    <link rel="stylesheet" href="css/styles.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible:wght@400;700&family=Crimson+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --color-primary: #2563EB;
            --color-primary-hover: #1d4ed8;
            --color-primary-light: #dbeafe;
            --color-accent: #059669;
            --color-accent-hover: #047857;
            --color-bg: #f8fafc;
            --color-foreground: #0f172a;
            --color-muted: #f1f5fd;
            --color-border: #e4ecfc;
            --font-heading: 'Crimson Pro', Georgia, serif;
            --font-body: 'Atkinson Hyperlegible', -apple-system, sans-serif;
            --radius: 0.75rem;
            --radius-lg: 1rem;
            --shadow: 0 1px 3px rgba(0, 0, 0, 0.08), 0 4px 6px -1px rgba(0, 0, 0, 0.04);
            --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.08), 0 8px 24px -4px rgba(0, 0, 0, 0.06);
            --transition: 0.2s ease;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        html { scroll-behavior: smooth; }

        body {
            font-family: var(--font-body);
            background: var(--color-bg);
            color: var(--color-foreground);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
        }

        h1, h2, h3, h4 { font-family: var(--font-heading); font-weight: 600; line-height: 1.25; }

        /* Navigation */
        .nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--color-border);
            z-index: 100;
            padding: 0 1.5rem;
        }

        .nav-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 72px;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-family: var(--font-heading);
            font-size: 1.375rem;
            font-weight: 700;
            color: var(--color-foreground);
            text-decoration: none;
            cursor: pointer;
        }

        .nav-brand svg { width: 32px; height: 32px; color: var(--color-primary); }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-link {
            padding: 0.5rem 1rem;
            font-size: 0.9375rem;
            font-weight: 500;
            color: #64748b;
            text-decoration: none;
            border-radius: var(--radius);
            transition: var(--transition);
            cursor: pointer;
        }

        .nav-link:hover { color: var(--color-foreground); background: var(--color-muted); }

        .nav-btn {
            padding: 0.625rem 1.25rem;
            font-size: 0.9375rem;
            font-weight: 600;
            border-radius: var(--radius);
            transition: var(--transition);
            cursor: pointer;
            text-decoration: none;
        }

        .nav-btn-outline {
            color: var(--color-foreground);
            border: 1px solid var(--color-border);
            background: transparent;
        }
        .nav-btn-outline:hover {
            background: var(--color-muted);
            color: var(--color-foreground);
            border-color: var(--color-border);
        }

        .nav-btn-primary {
            background: var(--color-primary);
            color: white;
            border: 1px solid var(--color-primary);
        }
        .nav-btn-primary:hover {
            background: var(--color-primary-hover);
            color: white;
        }

        /* Hero Section */
        .hero {
            padding: 10rem 1.5rem 6rem;
            text-align: center;
            background: linear-gradient(180deg, #ffffff 0%, var(--color-bg) 100%);
        }

        .hero-inner {
            max-width: 720px;
            margin: 0 auto;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.375rem 0.875rem;
            background: var(--color-primary-light);
            color: var(--color-primary);
            font-size: 0.8125rem;
            font-weight: 600;
            border-radius: 9999px;
            margin-bottom: 1.5rem;
        }

        .hero h1 {
            font-size: clamp(2.5rem, 5vw, 3.75rem);
            font-weight: 700;
            color: var(--color-foreground);
            margin-bottom: 1.25rem;
            letter-spacing: -0.02em;
        }

        .hero-subtitle {
            font-size: 1.125rem;
            color: #64748b;
            max-width: 560px;
            margin: 0 auto 2.5rem;
            line-height: 1.7;
        }

        .hero-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .hero-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.875rem 1.75rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: var(--radius);
            text-decoration: none;
            transition: var(--transition);
            cursor: pointer;
        }

        .hero-btn-primary {
            background: var(--color-primary);
            color: white;
        }
        .hero-btn-primary:hover {
            background: var(--color-primary-hover);
            color: white;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .hero-btn-secondary {
            background: white;
            color: var(--color-foreground);
            border: 1px solid var(--color-border);
        }
        .hero-btn-secondary:hover {
            background: var(--color-muted);
            color: var(--color-foreground);
        }

        /* Stats Bar */
        .stats-bar {
            padding: 3rem 1.5rem;
            background: white;
            border-top: 1px solid var(--color-border);
            border-bottom: 1px solid var(--color-border);
        }

        .stats-inner {
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            text-align: center;
        }

        .stat-item { }

        .stat-value {
            font-family: var(--font-heading);
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--color-foreground);
            display: block;
        }

        .stat-label {
            font-size: 0.875rem;
            color: #64748b;
            margin-top: 0.25rem;
        }

        /* Features Section */
        .features {
            padding: 6rem 1.5rem;
        }

        .section-header {
            text-align: center;
            max-width: 600px;
            margin: 0 auto 3.5rem;
        }

        .section-header h2 {
            font-size: 2rem;
            color: var(--color-foreground);
            margin-bottom: 0.875rem;
        }

        .section-header p {
            color: #64748b;
            font-size: 1.0625rem;
        }

        .features-grid {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 1.5rem;
        }

        .feature-card {
            background: white;
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            padding: 2rem;
            transition: var(--transition);
        }

        .feature-card:hover {
            box-shadow: var(--shadow-md);
            border-color: transparent;
        }

        .feature-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--color-primary-light);
            border-radius: var(--radius);
            margin-bottom: 1.25rem;
        }

        .feature-icon svg {
            width: 24px;
            height: 24px;
            color: var(--color-primary);
        }

        .feature-card h3 {
            font-size: 1.125rem;
            color: var(--color-foreground);
            margin-bottom: 0.5rem;
        }

        .feature-card p {
            font-size: 0.9375rem;
            color: #64748b;
            line-height: 1.65;
        }

        /* Workflow Section */
        .workflow {
            padding: 6rem 1.5rem;
            background: var(--color-muted);
        }

        .workflow-steps {
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 2rem;
            position: relative;
        }

        .workflow-step {
            text-align: center;
            position: relative;
        }

        .step-number {
            width: 56px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--color-primary);
            color: white;
            font-family: var(--font-heading);
            font-size: 1.5rem;
            font-weight: 700;
            border-radius: 50%;
            margin: 0 auto 1.25rem;
        }

        .workflow-step h4 {
            font-size: 1rem;
            color: var(--color-foreground);
            margin-bottom: 0.375rem;
        }

        .workflow-step p {
            font-size: 0.875rem;
            color: #64748b;
        }

        /* CTA Section */
        .cta {
            padding: 6rem 1.5rem;
            text-align: center;
            background: linear-gradient(135deg, var(--color-foreground) 0%, #1e293b 100%);
            color: white;
        }

        .cta h2 {
            font-size: 2rem;
            color: white;
            margin-bottom: 0.875rem;
        }

        .cta p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.0625rem;
            margin-bottom: 2rem;
        }

        .cta-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.875rem 2rem;
            background: var(--color-accent);
            color: white;
            font-size: 1rem;
            font-weight: 600;
            border-radius: var(--radius);
            text-decoration: none;
            transition: var(--transition);
        }
        .cta-btn:hover {
            background: var(--color-accent-hover);
            color: white;
            transform: translateY(-1px);
        }

        /* Footer */
        .footer {
            padding: 2rem 1.5rem;
            text-align: center;
            background: white;
            border-top: 1px solid var(--color-border);
        }

        .footer p {
            font-size: 0.875rem;
            color: #64748b;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-links { gap: 0.25rem; }
            .nav-link { padding: 0.5rem 0.75rem; font-size: 0.875rem; }

            .hero { padding: 8rem 1.5rem 4rem; }
            .hero h1 { font-size: 2.25rem; }

            .stats-inner { grid-template-columns: 1fr; gap: 1.5rem; }
            .stats-bar { padding: 2rem 1.5rem; }

            .workflow-steps { grid-template-columns: 1fr 1fr; gap: 2.5rem 1.5rem; }

            .features-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 480px) {
            .nav { padding: 0 1rem; }
            .nav-inner { height: 64px; }
            .nav-brand span { display: none; }
            .hero-actions { flex-direction: column; align-items: center; }
            .hero-btn { width: 100%; justify-content: center; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="nav">
        <div class="nav-inner">
            <a href="" class="nav-brand">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25"/>
                </svg>
                <span>Research Repository</span>
            </a>
            <div class="nav-links">
                <a href="#features" class="nav-link">Features</a>
                <a href="#workflow" class="nav-link">How It Works</a>
                <a href="login" class="nav-btn nav-btn-outline">Sign In</a>
                <a href="register" class="nav-btn nav-btn-primary">Get Started</a>
            </div>
        </div>
    </nav>

    <!-- Hero -->
    <section class="hero">
        <div class="hero-inner">
            <div class="hero-badge">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z"/>
                </svg>
                Academic Research Made Simple
            </div>
            <h1>Streamline Your Research Paper Submission</h1>
            <p class="hero-subtitle">A modern platform for students and faculty to submit, review, and manage academic research papers — from submission to publication.</p>
            <div class="hero-actions">
                <a href="register" class="hero-btn hero-btn-primary">
                    Submit Your Paper
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"/>
                    </svg>
                </a>
                <a href="login" class="hero-btn hero-btn-secondary">Faculty Login</a>
            </div>
        </div>
    </section>

    <!-- Stats Bar -->
    <section class="stats-bar">
        <div class="stats-inner">
            <div class="stat-item">
                <span class="stat-value">10MB</span>
                <span class="stat-label">Max File Size</span>
            </div>
            <div class="stat-item">
                <span class="stat-value">3</span>
                <span class="stat-label">User Roles</span>
            </div>
            <div class="stat-item">
                <span class="stat-value">4</span>
                <span class="stat-label">Review Statuses</span>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="features" id="features">
        <div class="section-header">
            <h2>Everything You Need</h2>
            <p>Powerful tools for managing academic research papers from submission to publication.</p>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5M16.5 12L12 16.5m0 0L7.5 12m4.5 4.5V3"/>
                    </svg>
                </div>
                <h3>Easy Submission</h3>
                <p>Upload research papers in PDF, DOC, or DOCX format with an intuitive interface. Add title, abstract, and metadata effortlessly.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
                <h3>Real-time Tracking</h3>
                <p>Monitor your paper's status throughout the review process. Know exactly when it's under review, accepted, or rejected.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z"/>
                    </svg>
                </div>
                <h3>Role-based Access</h3>
                <p>Separate workflows for students and faculty. Secure authentication with role-based permissions and dedicated dashboards.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M9 12.75L11.25 15 15 9.75M21 12c0 1.268-.63 2.39-1.593 3.068a3.745 3.745 0 01-1.043 3.296 3.745 3.745 0 01-3.296 1.043A3.745 3.745 0 0112 21c-1.268 0-2.39-.63-3.068-1.593a3.746 3.746 0 01-3.296-1.043 3.745 3.745 0 01-1.043-3.296A3.745 3.745 0 013 12c0-1.268.63-2.39 1.593-3.068a3.745 3.745 0 011.043-3.296 3.746 3.746 0 013.296-1.043A3.746 3.746 0 0112 3c1.268 0 2.39.63 3.068 1.593a3.746 3.746 0 013.296 1.043 3.746 3.746 0 011.043 3.296A3.745 3.745 0 0121 12z"/>
                    </svg>
                </div>
                <h3>Review Workflow</h3>
                <p>Faculty can efficiently review papers, update statuses, and manage their review workload from a dedicated dashboard.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"/>
                    </svg>
                </div>
                <h3>Paper Discovery</h3>
                <p>Browse and search through all submitted papers. Filter by status, date, or author to find relevant research.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        <path d="M13.5 10.5H21M13.5 7.5H21M13.5 13.5H21M2.25 13.5C2.25 13.5 3 12.5 4.5 12.5C6 12.5 6 13.5 6 13.5C6 13.5 6 14.5 4.5 14.5C3 14.5 2.25 13.5 2.25 13.5Z"/>
                    </svg>
                </div>
                <h3>Secure & Safe</h3>
                <p>Your research is protected with secure file handling, SQL injection prevention, and parameterized queries.</p>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="workflow" id="workflow">
        <div class="section-header">
            <h2>How It Works</h2>
        </div>
        <div class="workflow-steps">
            <div class="workflow-step">
                <div class="step-number">1</div>
                <h4>Register</h4>
                <p>Create your account as a student or faculty</p>
            </div>
            <div class="workflow-step">
                <div class="step-number">2</div>
                <h4>Submit</h4>
                <p>Upload your research paper with title and abstract</p>
            </div>
            <div class="workflow-step">
                <div class="step-number">3</div>
                <h4>Review</h4>
                <p>Faculty reviews and updates paper status</p>
            </div>
            <div class="workflow-step">
                <div class="step-number">4</div>
                <h4>Published</h4>
                <p>Get notified when your paper is accepted</p>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="cta">
        <h2>Ready to Get Started?</h2>
        <p>Join researchers and faculty in streamlining academic paper management.</p>
        <a href="register" class="cta-btn">
            Create Your Account
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"/>
            </svg>
        </a>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <p>Research Repository System</p>
    </footer>
</body>
</html>
