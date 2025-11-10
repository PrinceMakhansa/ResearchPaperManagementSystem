package com.example.spring;

/**
 * Simple service interface used by Spring bean. Implemented as a plain Java class too.
 */
public interface GreetingService {
    String greet(String name);
}

