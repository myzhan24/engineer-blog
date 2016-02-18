<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 

<html>
  <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>
  
  
  
  <body>
  
    
<%    
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) {
      pageContext.setAttribute("user", user);
%>

<top><p>Greetings, ${fn:escapeXml(user.nickname)}
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>"> Log Out</a></p></top>


<img src="res/george.gif" alt="Fire Bowl"
  style="width:800;height:600px;">

<p>${fn:escapeXml(user.nickname)} is now unsubscribed.</p>
	<a href="bonfire.jsp">Return</a>


<%
    } else {
%>
<top><p>Greetings traveler.
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>"> Sign In</a>
to post</p></top>
	
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a>
	<a href="bonfire.jsp">Return</a>
  
<%
    }
    %>
  
  
 
	
	
    
   
  </body>
</html>