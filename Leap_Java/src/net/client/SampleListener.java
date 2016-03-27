package net.client;

import java.util.Queue;

import com.leapmotion.leap.Bone.Type;
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Listener;
import com.leapmotion.leap.Vector;

public class SampleListener extends Listener{
	Queue <Integer> index_queue, middle_queue;

	public SampleListener(Queue <Integer> a_queue, Queue <Integer> b_queue){
		super();
		index_queue = a_queue;
		middle_queue = b_queue;
	}
	
	public void onConnect(Controller controller){
		System.out.println("Connected");
		//controller.enableGesture(Gesture.Type.TYPE_SWIPE);
	}

	int handDirection, fingerDirection, counter = 0;

	public void onFrame(Controller controller){
		Frame frame = controller.frame();
		Hand hand = frame.hands().leftmost();
		Vector wristP = hand.arm().wristPosition();
		handDirection += getBendOfFinger(hand.direction().angleTo(wristP));
		
		for(Finger finger : frame.fingers()){
			switch (finger.type()) {
			case TYPE_MIDDLE:
				Vector intermediateCenter = finger.bone(Type.TYPE_INTERMEDIATE).direction();
				Vector proximalCenter = finger.bone(Type.TYPE_PROXIMAL).direction();
				fingerDirection += getBendOfFinger(intermediateCenter.angleTo(proximalCenter));
				break;
			default:
				break;
			}
		}
		
		if(counter == 60){
			index_queue.add(new Integer(fingerDirection / counter));
			middle_queue.add(new Integer(handDirection / counter));
System.out.println("index_bend = " + fingerDirection / counter);
System.out.println("hand dir = " + handDirection / counter);
			fingerDirection = 0;
			handDirection = 0;
			counter = 0;
		}else{
			counter++;
		}
	}
	
	private int getBendOfFinger(Float f){
		double angle = f * (180 / Math.PI);
		return (int)angle;
	}
	
}
