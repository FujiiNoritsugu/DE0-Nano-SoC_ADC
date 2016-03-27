package net.client;

import java.util.Queue;
import java.util.Timer;
import java.util.concurrent.ConcurrentLinkedQueue;

import com.leapmotion.leap.Controller;

public class Test20160313 {

	public static void main(String [] arg){
		Queue <Integer> a_queue = new ConcurrentLinkedQueue<Integer>();
		Queue <Integer> b_queue = new ConcurrentLinkedQueue<Integer>();
		SampleListener listener = new SampleListener(a_queue, b_queue);
		ClientSocket client_socket = new ClientSocket(a_queue, b_queue);
		Controller controller = new Controller();
		controller.addListener(listener);
		new Timer(true).schedule(client_socket, 500, 500);
		System.out.println("Press Enter");
		try{
			System.in.read();
		}catch(Exception e){
			e.printStackTrace();
		}
		
		controller.removeListener(listener);
	}
	
	
}
