package guestbook;

 
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import static com.googlecode.objectify.ObjectifyService.ofy;
import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class OfySignGuestbookServlet extends HttpServlet {
		
    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();

        String guestbookName = req.getParameter("guestbookName");
        String content = req.getParameter("content");
        Greeting greeting = new Greeting(user, content);

        ofy().save().entity(greeting).now();  

        resp.sendRedirect("/ofyguestbook.jsp?guestbookName=" + guestbookName);

    }

}