<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="guestbook.Subscriber" %>
<%@ page import="guestbook.OfyService" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 

<html>
  <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
   <title>Bonfire</title>
  </head>
  
  
  
  	<body>
  
  	<p><lightGrey>Welcome to the Admin Page. Manage all posts and subscribers here.</lightGrey></p>
	<hr>  
    
<%
	
	
    
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<top><p>Greetings, ${fn:escapeXml(user.nickname)}
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>"> Log Out</a></p></top>
<%
    } else {
%>
<top><p>Greetings traveler.
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>"> Sign In</a>
to post</p></top>
<%
    }
    %>
  
  
  <img src="res/star.jpg" alt="Night Sky"
  style="width:800;height:600px;">
	
	<p><i>Staring upward at the gleaming stars in the obsidian sky, the traveler wondered if he was truly alone...</i></p>

    <a href="bonfire.jsp">Return</a>
    <br>
    <hr>
      
    <blog>
    
    

<p><a href="viewsubs.jsp" float="left">View Subscribers</a></p> 


<form action="/unsubscribeall" method="post"> 
    	<div><input type="submit" value="Remove All Subs" /></div>
</form>
   

<form action="/deleteposts" method="post"> 
    	<div><input type="submit" value="Delete All Posts" /></div>
</form>
    
    


    </blog>
 
  </body>
</html>