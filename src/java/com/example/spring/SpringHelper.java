package com.example.spring;

/**
 * Minimal Spring integration without compile-time dependency.
 * Uses reflection to load Spring's ClassPathXmlApplicationContext if jars are present at runtime.
 */
public final class SpringHelper {
    private static volatile Object applicationContext; // org.springframework.context.ApplicationContext (kept as Object)
    private static final Object lock = new Object();

    private SpringHelper() {}

    /**
     * Try to get a greeting from Spring bean "greetingService" if Spring is available.
     * Returns null when Spring jars are not present or initialization fails.
     */
    public static String trySpringGreeting(String name) {
        try {
            Object ctx = ensureContext();
            if (ctx == null) return null;

            // ctx.getClass().getMethod("getBean", String.class).invoke(ctx, "greetingService")
            Object bean = ctx.getClass()
                    .getMethod("getBean", String.class)
                    .invoke(ctx, "greetingService");

            // Call bean.greet(String)
            return (String) bean.getClass()
                    .getMethod("greet", String.class)
                    .invoke(bean, name);
        } catch (Throwable t) {
            // Any failure -> treat as not available
            return null;
        }
    }

    private static Object ensureContext() {
        if (applicationContext != null) return applicationContext;
        synchronized (lock) {
            if (applicationContext != null) return applicationContext;
            try {
                // Load ClassPathXmlApplicationContext reflectively
                Class<?> ctxClass = Class.forName("org.springframework.context.support.ClassPathXmlApplicationContext");
                // new ClassPathXmlApplicationContext("applicationContext.xml")
                Object ctx = ctxClass.getConstructor(String[].class)
                        .newInstance((Object) new String[]{"applicationContext.xml"});
                applicationContext = ctx;
                return applicationContext;
            } catch (Throwable t) {
                // Spring not on classpath or failed to init
                return null;
            }
        }
    }
}

