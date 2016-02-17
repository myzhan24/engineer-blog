package guestbook;

import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;

import com.googlecode.objectify.annotation.Id;

 

 

@Entity

public class Greeting implements Comparable<Greeting> {
	static {
//		ObjectifyService.register(Greeting.class);
	}
	
	
    @Id Long id;
    User user;
    String content;
    String title;
    Date date;
    
    
    
    private Greeting() {}
    
    public Greeting(User user, String title, String content) {
        this.user = user;
        this.title = title;
        this.content = content;
        
        Calendar calendar = Calendar.getInstance();
		TimeZone tz = TimeZone.getTimeZone("CST");
		calendar.setTimeZone(tz);

		date = calendar.getTime();
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