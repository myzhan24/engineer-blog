package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.TimeZone;

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
public class EmailCronServlet extends HttpServlet{
	
	Properties props = new Properties();
	Session session = Session.getDefaultInstance(props, null);
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		ObjectifyService.register(Subscriber.class);
		ObjectifyService.register(Greeting.class);
		
		String strCallResult = "";

		
		
		
		try {
			// email list
			List<Subscriber> subs = ofy().load().type(Subscriber.class).list();
			List<Greeting> msgs = ofy().load().type(Greeting.class).list();
			
												
			Calendar calendar = Calendar.getInstance();
			TimeZone tz = TimeZone.getTimeZone("CST");
			calendar.setTimeZone(tz);
			calendar.add(Calendar.HOUR_OF_DAY, -24);
			Date dayAgo = calendar.getTime();
			
			keepAfter(msgs,dayAgo);
			Collections.sort(msgs);
			
			
			if(subs.isEmpty() || msgs.isEmpty())
			{
				strCallResult = "no subs or no msgs: " + "no emails sent.";
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

//					System.out.println("subscriber s: " + s.getEmail());
					//Extract out the To, Subject and Body of the Email to be sent
					String strTo = s.getEmail();


					
//					mail("myzhan24@gmail.com",strTo,strSubject,strSubject);
					mail("myzhan24@gmail.com",strTo,strSubject,body.toString());
//					System.out.println("email sent to "+strTo);
//					System.out.println(strSubject);
//					System.out.println(body.toString());
				}





				strCallResult = "Success: " + "Email has been delivered.";

			}
		}
		catch (Exception ex) {
			strCallResult = "Fail: " + ex.getMessage();

			ex.printStackTrace();

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

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}
	
}
