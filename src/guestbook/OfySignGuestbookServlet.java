package guestbook;

 
import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


public class OfySignGuestbookServlet extends HttpServlet {
		
    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {
	
    	
        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();

//        String guestbookName = req.getParameter("guestbookName");
        String content = req.getParameter("content");
        String title = req.getParameter("title");
        
        System.out.println(user.toString() + "\t" + content.toString() + "\t" + title.toString());
        if(user.toString().isEmpty() || content.isEmpty() || title.isEmpty())
        {
        	System.out.println("skipping this because something's empty!");
        	
        }
        else
        {
        	Greeting greeting = new Greeting(user,title,content);
        	ofy().save().entity(greeting).now();  
        }
        //resp.sendRedirect("/ofyguestbook.jsp?guestbookName=" + guestbookName);
        resp.sendRedirect("/bonfire.jsp");
    }

}