package com.example.spring;

/**
 * Default implementation that would be managed by Spring when jars are present.
 */
public class GreetingServiceImpl implements GreetingService {
    @Override
    public String greet(String name) {
        return "Spring says hi, " + name + "!";
    }
}

