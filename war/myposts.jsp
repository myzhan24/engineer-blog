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
  
  
  <img src="res/yule.gif" alt="Logs"
  style="width:800;height:600px;">
	
	<p><i>Peering into the ash and cinders, more messages became clear.</i></p>
    <a href="note.jsp">Toss a note in</a> | 
    <a href="bonfire.jsp">Return</a>
    <br>
    <hr>
      
    <blog>
    
    
 


<%
if(user!=null)
{
	Objectify objectify = OfyService.ofy();
	List<Greeting> greetings = objectify.load().type(Greeting.class).filter("email",user.getEmail()).list();   
	Collections.sort(greetings); 

    if (greetings.isEmpty()) {
        %>
        <h2>The Cinders show no messages</h2>
        <%
    } else {
        %>
        <h2>Messages in The Cinders</h2> 
        <br>
        <%
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.getContent());
            pageContext.setAttribute("greeting_user", greeting.getUser());
            pageContext.setAttribute("greeting_date", greeting.getDateCST());
            pageContext.setAttribute("greeting_title", greeting.getTitle());
            
           %>
			<blogTitle><p>${fn:escapeXml(greeting_title)}
<form action="/bonfire" method="post"> 
    	
    	<div><input type="submit" value="Delete" /></div>
    	<input type="hidden" name="cstdate" value="greeting.getDateCST()"/>
    	<input type="hidden" name="email" value="greeting.getUser().getEmail()"/>
    	
    	
</form>


</p></blogTitle> 
			<blockquote><i>${fn:escapeXml(greeting_content)} </i></blockquote>
            <blockquote><b><signature>- ${fn:escapeXml(greeting_user.nickname)}</signature></b> <br><date>circa ${fn:escapeXml(greeting_date)}</date></br></blockquote>
            
            <br>
            <%

        }
    }
}	
%>



    </blog>
 
  </body>
</html>