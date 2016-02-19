package guestbook;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;

import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

 

 

@Entity

public class Greeting implements Comparable<Greeting> {
    @Id Long id;
    User user;
    @Index String email;
    String content;
    String title;
    @Index String cstDate;
    Date date;
    
    
    
    private Greeting() {}
    
    public Greeting(User user, String title, String content) {
        this.user = user;
        this.title = title;
        this.content = content;
        this.email = user.getEmail();
        
        Calendar calendar = Calendar.getInstance();
		TimeZone tz = TimeZone.getTimeZone("CST");
		calendar.setTimeZone(tz);

		date = calendar.getTime();
		
		cstDate = getDateCST();
    }
    
    public User getUser() {
        return user;
    }

    public String getContent() {
        return content;
    }
    
    public String getTitle(){
    	return title;
    }
    
    public String getDate() {
    	return date.toString();
    }
    
    public String getDateCST(){
    	SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy hh:mm:ss a");
    	sdf.setTimeZone(TimeZone.getTimeZone("CST"));
    	return sdf.format(date);
    }

    @Override

    public int compareTo(Greeting other) {
        if (date.after(other.date)) {
            return -1;
        } else if (date.before(other.date)) {
            return 1;
        }
        return 0;
    }

}