package guestbook;


import com.google.appengine.api.users.User;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;


@Entity
public class Subscriber {
	static {
//		ObjectifyService.register(Subscriber.class);
	}
	
	
    @Id Long id;
    @Index String email;
    User user;
    
    
    
    private Subscriber() {}
    
    public Subscriber(User user) {
        this.user = user;
        this.email = user.getEmail();
    }
    
    public String getEmail() {
        return email;
    }

//    public Key<Subscriber> getKey() {
//    	return Key.create(Subscriber.class, user.getEmail());
//    }
//    

}
