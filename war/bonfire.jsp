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
<top><p>Greetings, ${fn:escapeXml(user.nickname)} 
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">log out</a></p></top>
<%
    } else {
%>
<top><p>Greetings.
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to post.</p></top>
<%
    }
    %>
  
  
  <img src="bonfire.jpg" alt="Fire at Night"
  style="width:800;height:600px;">
	
	<p><i>Caressed by the warm glow, the traveler decided to unwind. He reflected on his past life as he gazed idly at the heart of the fire...</i></p>
    
    <p>He saw the messages of past visitors appear near the base of the flame.</p>
  

<%
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	Collections.sort(greetings); 

    if (greetings.isEmpty()) {
        %>
        <blogEntry><p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p></blogEntry>
        <%
    } else {
        %>
        <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
        <%
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.getContent());
            pageContext.setAttribute("greeting_user", greeting.getUser());
            pageContext.setAttribute("greeting_date", greeting.getDate());
            pageContext.setAttribute("greeting_title", greeting.getTitle());
            
                %>
                <blogEntry><p>${fn:escapeXml(greeting_title)}</p></blogEntry>
                <%
            
            %>
            <blogEntry><blockquote><i>${fn:escapeXml(greeting_content)} </i></blockquote></blogEntry>
            <blogEntry><blockquote><b>-${fn:escapeXml(greeting_user.nickname)}</b> <br>circa ${fn:escapeXml(greeting_date)}</br></blockquote></blogEntry>
            <%
        }
    }
%>
 
    <form action="/bonfire" method="post"> 
    	<div><textarea name="title" rows = "1" cols="60"></textarea></div>
    	<div><textarea name="content" rows="3" cols="60"></textarea></div>
    	<div><input type="submit" value="New Post" /></div>
    	<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>
 
  </body>
</html>