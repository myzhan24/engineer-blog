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

public class RemoveAllSubscribersServlet extends HttpServlet{
	public void doPost(HttpServletRequest req, HttpServletResponse resp)

			throws IOException {

		Objectify objectify = OfyService.ofy();
		Iterable<Key<Subscriber>> keys = objectify.load().type(Subscriber.class).keys();

		objectify.delete().keys(keys);



		List<Subscriber> subs = objectify.load().type(Subscriber.class).list();

		System.out.println("Current Sub Count: "+subs.size());
		for(Subscriber s : subs)
		{
			System.out.println(s.email+"\t"+s.id);
		}
		System.out.println();

		resp.sendRedirect("/admin.jsp");
	}
}
