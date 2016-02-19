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
  
  	<p><lightGrey><b>Welcome to the Bonfire Blog!</b> This is a simple blog that allows anyone signed into a google account post. It is in the theme of a bonfire that keeps any written messages burned in its flames. Write down an honest thought and eternalize it by fire. Subscribe to get updated everyday at 5PM CST! Created by Matthew Zhan for EE 461L SP 2016. </lightGrey></p>
	<hr>  
    
<%
	
	
    
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<top><p>Greetings, ${fn:escapeXml(user.nickname)}
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>"> Log Out</a> | <a href="admin.jsp">Admin Page</a></p></top>
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
    <a href="note.jsp">Toss a note in</a> | 
    <a href="allposts.jsp">Look closer</a>
    <br>
    <hr>
      
    <blog>
    
    
 


<%
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
	Objectify objectify = OfyService.ofy();
	List<Greeting> greetings = objectify.load().type(Greeting.class).list();   
	Collections.sort(greetings); 

    if (greetings.isEmpty()) {
        %>
        <h2>The Cinders show no messages</h2>
        <br>
        <%
    } else {
        %>
        <h2>Recent messages in The Cinders</h2> 
        <br>
        <%
        int i = 0;
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.getContent());
            pageContext.setAttribute("greeting_user", greeting.getUser());
            pageContext.setAttribute("greeting_date", greeting.getDateCST());
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

if(user!=null)
{
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
}


%>




    </blog>
 
  </body>
</html>