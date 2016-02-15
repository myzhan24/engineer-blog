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
	ObjectifyService.register(Greeting.class);
	
    String guestbookName = request.getParameter("guestbookName");
    
    if (guestbookName == null) {
        guestbookName = "default";
    }
    
    pageContext.setAttribute("guestbookName", guestbookName);
    
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<top><p>Greetings, ${fn:escapeXml(user.nickname)}.
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">log out</a></p></top>


<img src="sparks.gif" alt="Fire Bowl"
  style="width:800;height:600px;">

<p><i>The traveler eagerly took out his journal and began writing...</i></p>
	<a href="bonfire.jsp">Return</a>
    <br>
    <br>
    <hr>
      
   
    
    
 
	<br>
    <form action="/bonfire" method="post"> 
    	Title:
    	<div><textarea name="title" rows = "1" cols="60"></textarea></div>
    	Message:
    	<div><textarea name="content" rows="3" cols="60"></textarea></div>
    	<div><input type="submit" value="Toss" /></div>
    	<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>


<%
    } else {
%>
<top><p>Greetings traveler.
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to post.</p></top>

<img src="sparks.gif" alt="Fire Bowl"
  style="width:800;height:600px;">
  
  <p><i>The traveler eagerly took out his journal and tried to remember who he was...</i></p>
	
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	<a href="bonfire.jsp">Return</a>
  
<%
    }
    %>
  
  
 
	
	
    
   
  </body>
</html>