<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="guestbook.Subscriber" %>
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
	ObjectifyService.register(Subscriber.class);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) {
      pageContext.setAttribute("user", user);
%>

<top><p>Greetings, ${fn:escapeXml(user.nickname)}
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>"> Log Out</a></p></top>


<%
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

	List<Subscriber> subs = ObjectifyService.ofy().load().type(Subscriber.class).list();   
	

    if (subs.isEmpty()) {
        %>
        <p>There are currently no Subscribers.</p>
        <%
    } else {
        %>
        <p>Subscribers:</p>
        <%
        for (Subscriber s: subs) {
            pageContext.setAttribute("subscriber_email", s.getEmail());
              
                %>
                <p> ${fn:escapeXml(subscriber_email)}</p>
                <%
    }
    }
%>



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