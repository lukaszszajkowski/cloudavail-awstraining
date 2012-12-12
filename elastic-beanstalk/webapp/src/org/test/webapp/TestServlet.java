package org.test.webapp;

import java.io.File;
import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import java.io.File;

public class TestServlet extends HttpServlet {
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
	resp.getWriter().println(new Date());
	//String variable = System.getenv("SHELL");  
	String var_osarch = System.getProperty("os.arch");
	resp.getWriter().println(var_osarch);
	String var_envconf = System.getProperty("env.conf");
	resp.getWriter().println(var_envconf);
	//want to write: determine if file exists, if it does, read values else exit
	//File envconf = new File(var_envconf.toString());
	String envconf_path = System.getProperty("catalina.home").toString() + "/webapps/webapp/" + var_envconf;
	File envconf = new File(envconf_path);
	resp.getWriter().println(envconf_path);
	if(envconf.exists()) { resp.getWriter().println("File Exists"); }
	else { resp.getWriter().println("File Does Not Exist"); }
}
}
