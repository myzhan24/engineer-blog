package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;
import com.googlecode.objectify.cmd.QueryKeys;

public class DeletePostServlet extends HttpServlet{
	public void doPost(HttpServletRequest req, HttpServletResponse resp)

			throws IOException {

		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if(user==null)
		{
			System.out.println("No user, cannot delete messages");
			resp.sendRedirect("/bonfire.jsp");
		}
		else
		{
			
			String cstdate = req.getParameter("cstdate").trim();
		    String email = req.getParameter("email").trim();
		    
		    System.out.println("email: " + email + "\tdate: "+cstdate);
			Objectify objectify = OfyService.ofy();
			Iterable<Key<Greeting>> keys = objectify.load().type(Greeting.class).filter("email", user.getEmail()).filter("cstDate",cstdate).keys();
			
//			Iterable<Key<Greeting>> keys = objectify.load().type(Greeting.class).keys();
			objectify.delete().keys(keys);
		}

		resp.sendRedirect("/myposts.jsp");
	}
}
