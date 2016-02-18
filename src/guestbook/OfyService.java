package guestbook;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyFactory;
import com.googlecode.objectify.ObjectifyService;

public class OfyService {
	static {
		ObjectifyService.register(Greeting.class);
		ObjectifyService.register(Subscriber.class);
	}
	
	public static Objectify ofy() {
		return ObjectifyService.ofy();
	}
	
	public static ObjectifyFactory factory(){
		return ObjectifyService.factory();
	}
}
