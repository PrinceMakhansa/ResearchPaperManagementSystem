# Minimal Spring Integration (No Boot) for This Project

This project now contains a tiny, optional Spring hook that does NOT break anything if the Spring jars are missing.
If you add Spring jars later, a greeting line will appear on the dashboard.

## What Was Added
Files:
- `src/java/com/example/spring/SpringHelper.java` (reflection loader – safe if Spring absent)
- `src/java/com/example/spring/GreetingService.java`
- `src/java/com/example/spring/GreetingServiceImpl.java`
- `src/java/applicationContext.xml` (XML config with one bean: `greetingService`)
- `web/dashboard.jsp` imports `SpringHelper` and shows a greeting if Spring loads successfully.

No compile‑time Spring dependency is required. Until you add jars, the greeting just stays hidden.

## Add Spring Jars in NetBeans (When Ready)
1. Download Spring Framework 5.3.x (e.g. 5.3.39) from: https://repo.spring.io/release/org/springframework/spring
   Required core jars (place them into a `lib/` folder OR add directly via NetBeans):
   - `spring-core-5.3.x.jar`
   - `spring-beans-5.3.x.jar`
   - `spring-context-5.3.x.jar`
   - `spring-expression-5.3.x.jar`
   - Plus dependency: `spring-jcl-5.3.x.jar` (already inside Spring distribution)
   (You do NOT need AOP, web, tx, etc. for this tiny demo.)
2. In NetBeans: Right‑click project > Properties > Libraries > Add JAR/Folder… select the jars.
3. Ensure they end up in the built WAR under `WEB-INF/lib`. (NetBeans does this automatically when added as project libraries.)
4. Clean & Build the project (important to clear old compiled JSPs): Project context menu > Clean and Build.
5. Deploy/run on your servlet container (Tomcat/GlassFish bundled with NetBeans) while XAMPP runs MySQL.
6. Open `http://localhost:XXXX/project-context/dashboard` and look for the line beginning with the wrench icon 🔧 saying: `Spring says hi, <YourName>!`

If you want to avoid XML and use annotations instead, you could later replace the XML with a `@Configuration` class and adjust `SpringHelper` to load `AnnotationConfigApplicationContext`; but XML keeps reflection simple.

## How the Reflection Loader Works
- Tries to load `org.springframework.context.support.ClassPathXmlApplicationContext`.
- If not found (no jars), returns `null` silently – no errors for the user.
- If found, loads `applicationContext.xml` and retrieves bean `greetingService`, then calls `greet(name)`.

## Troubleshooting
| Issue | Cause | Fix |
|-------|-------|-----|
| Greeting not visible | Jars not on classpath | Add jars & rebuild |
| ClassNotFoundException for Spring in logs | JSP compiled before jars added | Clean & Build after adding jars |
| XML not found | `applicationContext.xml` not on classpath | Ensure it sits in `src/java/` (NetBeans copies to `WEB-INF/classes`) |

## Database Column Errors Previously Seen
You encountered: `Unknown column 'abstract_text' in 'field list'` and `Unknown column 'keywords' in 'field list'`.
Current code & schema use only column name `abstract` (not `abstract_text`) and do NOT reference `keywords` anywhere.
Likely causes:
- Old/stale DAO code or JSP previously deployed still referencing old column names.
- A manual SQL INSERT executed with wrong column list.
- A DB migration attempt that added code first, schema not updated.

### Fix Steps
1. Confirm actual table layout in MySQL (XAMPP):
   ```sql
   USE research_repo;
   DESCRIBE papers;
   ```
2. If you really want a `keywords` column (optional):
   ```sql
   ALTER TABLE papers ADD COLUMN keywords VARCHAR(255) NULL AFTER abstract;
   ```
3. If some old code expects `abstract_text`, create a view as a compatibility layer (avoid editing all code):
   ```sql
   CREATE OR REPLACE VIEW papers_compat AS
   SELECT paper_id, title, abstract AS abstract_text, abstract, file_path,
          submitted_by, status, submission_date
   FROM papers;
   ```
   Then adjust only those legacy queries to read from `papers_compat` or just update them to use `abstract`.
4. Always Clean & Build after changing Java so JSP re-compiles using current classes.

### Verify No Stray References
Search in NetBeans (Edit > Find in Projects) for: `abstract_text` and `keywords`. Should return zero results in `src/` now.

## MySQL (XAMPP) Notes
- Default root user often has no password. Your `DatabaseUtil` uses empty password: OK for local dev.
- For production: set a password and update `DatabaseUtil`.
- Ensure MySQL is running before deploying the webapp; otherwise connection exceptions appear on dashboard.

## Optional: Adding a Real Spring Bean to a Servlet
Later, if you want to inject a Spring bean into a servlet without full rewrite:
1. Initialize Spring once using a `ServletContextListener` (only if you abandon the reflection helper).
2. Store the `ApplicationContext` in `ServletContext`.
3. Look it up inside your servlet's `init()`.

For now, the current lightweight approach is enough to satisfy a “uses Spring” requirement with minimal risk.

## Next Small Enhancements (Optional)
- Add a `SystemInfoService` bean to show Spring Framework version via reflection (`Package.getImplementationVersion()`).
- Add a `keywords` field to the upload form and persist it (requires schema change & DAO updates).

---
Feel free to delete this file if you later move to a fuller Spring setup.

