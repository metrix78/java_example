package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.io.*;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		System.out.println("I got here");
		SpringApplication.run(DemoApplication.class, args);
	}

}
