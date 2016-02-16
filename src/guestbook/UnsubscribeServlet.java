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
import com.googlecode.objectify.LoadResult;
import com.googlecode.objectify.cmd.Query;
import com.googlecode.objectify.cmd.QueryKeys;

public class UnsubscribeServlet extends HttpServlet{
	public void doPost(HttpServletRequest req, HttpServletResponse resp)

			throws IOException {

		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if(user==null)
		{
			System.out.println("No user, cannot unsubscribe");
			resp.sendRedirect("/bonfire.jsp");
		}
		else
		{
			Subscriber sub = new Subscriber(user);
			
			Iterable<Key<Subscriber>> keys = ofy().load().type(Subscriber.class).filter("email", user.getEmail()).keys();
			
			System.out.println("key matches for "+user.getEmail()+":\t"+keys.toString());
			
			ofy().delete().keys(keys);
			
			

			List<Subscriber> subs = ofy().load().type(Subscriber.class).list();

			System.out.println("Current Sub Count: "+subs.size());
			for(Subscriber s : subs)
			{
				System.out.println(s.email+"\t"+s.id);
			}
			System.out.println();
		}
		resp.sendRedirect("/unsubscribe.jsp");
	}
}
