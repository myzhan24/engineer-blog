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
   <title>Bonfire</title>
  </head>
  
  
  
  	<body>
  
  	<p><lightGrey>This is a simple blog that allows anyone signed into a google account post. It is in the theme of a bonfire that keeps any written messages burned in its flames. Created by Matthew Zhan for EE 461L SP 2016</lightGrey></p>
	<hr>  
    
<%
	ObjectifyService.register(Greeting.class);
    
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
  
  
  <img src="res/bonfire.jpg" alt="Fire at Night"
  style="width:800;height:600px;">
	
	<p><i>Caressed by the warm glow, the traveler decided to unwind. He reflected on his past life as he gazed idly at the heart of the fire...</i></p>
    <a href="note.jsp">Toss a note in</a>
    <br>
    <hr>
      
    <blog>
    
    
 


<%
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	Collections.sort(greetings); 

    if (greetings.isEmpty()) {
        %>
        <h2>The cinders show no messages</h2>
        <%
    } else {
        %>
        <h2>Messages in The Cinders</h2> 
        <br>
        <%
        int i = 0;
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.getContent());
            pageContext.setAttribute("greeting_user", greeting.getUser());
            pageContext.setAttribute("greeting_date", greeting.getDate());
            pageContext.setAttribute("greeting_title", greeting.getTitle());
            
           %>
			<blogTitle><p>${fn:escapeXml(greeting_title)}</p></blogTitle>
			<blockquote><i>${fn:escapeXml(greeting_content)} </i></blockquote>
            <blockquote><b><signature>- ${fn:escapeXml(greeting_user.nickname)}</signature></b> <br><date>circa ${fn:escapeXml(greeting_date)}</date></br></blockquote>
            
            <br>
            <%
            i++;
            if(i > 3)
            	break;
        }
    }
%>
<a href="allposts.jsp">Look closer into the flames</a>

<form action="/subscribe" method="post"> 
    	<div><input type="submit" value="Subscribe" /></div>
</form>

<form action="/unsubscribe" method="post"> 
    	<div><input type="submit" value="Unsubscribe" /></div>
</form>
    
    </blog>
 
  </body>
</html>