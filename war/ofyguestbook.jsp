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
  
  <h2>Rain on Glass</h2>
  <h2>
  <img src="res/glass.jpg" alt="Glass View"
  style="width:304px;height:228px;">
  </h2>
  
  
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
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
    %>
<%
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	Collections.sort(greetings); 

    if (greetings.isEmpty()) {
        %>
        <p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
        <%
    } else {
        %>
        <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
        <%
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.getContent());
            pageContext.setAttribute("greeting_user", greeting.getUser());
            pageContext.setAttribute("greeting_date", greeting.getDate());
            
                %>
                <p> ${fn:escapeXml(greeting_date)} <b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
                <%
            
            %>
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            <%
        }
    }
%>
 
    <form action="/ofysign" method="post"> 
    	<div><textarea name="title" rows = "1" cols="60"></textarea></div>
    	<div><textarea name="content" rows="3" cols="60"></textarea></div>
    	<div><input type="submit" value="New Post" /></div>
    	<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>
 
  </body>
</html>