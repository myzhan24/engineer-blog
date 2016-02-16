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
import com.googlecode.objectify.Result;



public class SubscribeServlet extends HttpServlet{
	public void doPost(HttpServletRequest req, HttpServletResponse resp)

			throws IOException {


		UserService userService = UserServiceFactory.getUserService();

		User user = userService.getCurrentUser();


		if(user==null)
		{
			System.out.println("No user, cannot subscribe");
			resp.sendRedirect("/bonfire.jsp");
		}
		else
		{
			
			Subscriber sub = new Subscriber(user);
			Subscriber fetch1 = ofy().load().type(Subscriber.class).filter("email",sub.email).first().get();

			if(fetch1!=null)
			{
				System.out.println("fetch FOUND "+user.getEmail()+":\t"+fetch1.getEmail());
				resp.sendRedirect("/alreadysubbed.jsp");
			}
			else
			{
				

			
			
			ofy().save().entity(sub).now();  

			System.out.println("Added new sub: "+user.getEmail());


			List<Subscriber> subs = ofy().load().type(Subscriber.class).list();

			System.out.println("Current Sub Count: "+subs.size());
			for(Subscriber s : subs)
			{
				System.out.println(s.email+"\t"+s.id);
			}
			System.out.println();

//			Subscriber fetch1 = ofy().load().type(Subscriber.class).filter("email",user.getEmail()).first().now();

//			if(fetch1!=null)
//				System.out.println("fetch result for user with email: "+user.getEmail()+":\t"+fetch1.getEmail());
			resp.sendRedirect("/subscribe.jsp");
			}
		}
		
	}
}
