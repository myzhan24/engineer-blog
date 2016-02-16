package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class GAEJEmailServlet extends HttpServlet{
	
	Properties props = new Properties();
	Session session = Session.getDefaultInstance(props, null);
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		
		
		ObjectifyService.register(Subscriber.class);
		ObjectifyService.register(Greeting.class);
		
		String strCallResult = "";

		
		try {
			// email list
			List<Subscriber> subs = ofy().load().type(Subscriber.class).list();
			List<Greeting> msgs = ofy().load().type(Greeting.class).list();
			
			System.out.println("num subs: "+subs.size());
			
			// msg list

			System.out.println("num msgs: "+ msgs.size());
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.HOUR_OF_DAY, -24);
			Date dayAgo = calendar.getTime();
			
			keepAfter(msgs,dayAgo);
			Collections.sort(msgs);
			
			System.out.println("num msgs: "+ msgs.size()+" after "+dayAgo);
			if(subs.isEmpty() || msgs.isEmpty())
			{
				strCallResult = "no subs or no msgs: " + "no emails sent.";
				System.out.println(strCallResult);
				resp.sendRedirect("/bonfire.jsp");
			}
			else
			{

				// build the email message
				String strSubject = "Bonfire Entries Update";
				
				StringBuilder body = new StringBuilder();
				try{
				body.append("Greetings traveler,\n\nThe Bonfire continues to burn. Here is what has been burned since ");
				body.append(dayAgo.toString()+".");
				body.append("\n\n");
				} catch(Exception e) {
					System.out.println(e);
				}
				
				for(Greeting g : msgs)
				{
					body.append("\t"+g.title);
					body.append("\n\t\t"+g.content);
					body.append("\n\t\t"+g.user.toString());
					body.append("\n\t\t"+g.date.toString()+"\n\n");
				}

				for(Subscriber s: subs)
				{
					System.out.println("subscriber s: " + s.getEmail());
					//Extract out the To, Subject and Body of the Email to be sent
					String strTo = s.getEmail();

					//Do validations here. Only basic ones i.e. cannot be null/empty
					//Currently only checking the To Email field
					//if (strTo == null) throw new Exception("To field cannot be empty.");

					//Trim the stuff
					//strTo = strTo.trim();
					//if (strTo.length() == 0) throw new Exception("To field cannot be empty.");
					mail("myzhan24@gmail.com",strTo,strSubject,body.toString());
//					mail("myzhan24@gmail.com",strTo,strSubject,strSubject);
					System.out.println("email sent to "+strTo);
					System.out.println(strSubject);
					System.out.println(body.toString());
				}





				strCallResult = "Success: " + "Email has been delivered.";
				//resp.getWriter().println(strCallResult);
				System.out.println(strCallResult);
				resp.sendRedirect("/bonfire.jsp");
			}
		}
		catch (Exception ex) {
			strCallResult = "Fail: " + ex.getMessage();
			//resp.getWriter().println(strCallResult);
			ex.printStackTrace();
			resp.sendRedirect("/bonfire.jsp");
		}
	}


	public void mail(String from, String to, String subject, String body) throws AddressException, MessagingException
	{
		//Call the GAEJ Email Service
		
		Message msg = new MimeMessage(session);
		msg.setFrom(new InternetAddress(from));
		msg.addRecipient(Message.RecipientType.TO,
				new InternetAddress(to));
		msg.setSubject(subject);
		msg.setText(body);
		Transport.send(msg);
	}
	
	public void keepAfter(List<Greeting> list,Date start)
	{
		for(int i = 0; i < list.size(); i++)
		{
			Greeting g = list.get(i);
			if(g.date.before(start))
			{
				list.remove(i);
				i--;
			}
		}
	}
}
