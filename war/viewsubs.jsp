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


<%
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

	Objectify objectify = OfyService.ofy();
	List<Subscriber> subs = objectify.load().type(Subscriber.class).list();   
	

    if (subs.isEmpty()) {
        %>
        <subs>There are currently no subscribers, be the first to subscribe!</subs>
        <p>
        </p>
        <%
    } else {
        %>
        <subs>Subscribers</subs>
        <%
        for (Subscriber s: subs) {
            pageContext.setAttribute("subscriber_email", s.getEmail());
              
                %>
                <signature><p> ${fn:escapeXml(subscriber_email)}</p></signature>
                <%
    }
    }


%>

<a href="admin.jsp">Return</a>
<p>
</p>
<%

Subscriber fetch = objectify.load().type(Subscriber.class).filter("email",user.getEmail()).first().get();

			if(fetch!=null)
			{
				%>
				
<form action="/unsubscribe" method="post"> 
    	<div><input type="submit" value="Unsubscribe" /></div>
</form>
  
				<%
			}
			else
			{
			%>
			<form action="/subscribe" method="post"> 
    	<div><input type="submit" value="Subscribe" /></div>
</form>
			
			<%
			}


%>



	


<%
    } else {
%>
<top><p>Greetings traveler.
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>"> Sign In</a></p></top>
	
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a>
	<a href="bonfire.jsp">Return</a>
  
<%
    }
    %>
  
  
 
	
	
    
   
  </body>
</html>