package net.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Queue;
import java.util.TimerTask;

public class ClientSocket extends TimerTask{

	Socket socket;
	BufferedReader stream;
	PrintWriter out;
	
	Queue <Integer> index_queue, middle_queue;

	public ClientSocket(Queue <Integer> a_queue, Queue <Integer> b_queue){
		index_queue = a_queue;
		middle_queue = b_queue;

	try{
		socket = new Socket("192.168.1.14", 23);
		stream = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		out = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()));
	} catch (IOException e) {
		e.printStackTrace();
	}

	}
	
	@Override
	public void run(){
		Integer index = index_queue.poll();
		Integer middle = middle_queue.poll();
		if(index != null && middle != null){
			String indexStr = getTargetString("a", index.intValue(), 0.0, 80.0);
			String middleStr = getTargetString("b", middle.intValue(), 0.0, 180.0);
			out.print(indexStr+middleStr);
			out.flush();
		}
	}
	
	String getTargetString(String prefix, int value, double min, double max){
		//0Å`180ÇÃê›íËílÇ110Å`255ÇÃä‘Ç…é˚ÇﬂÇÈ
		if(value < min){value = (int)min;}
		if(value > max){value = (int)max;}
		value = (int) (((double)((value - min)/(max - min))) * (255.0 - 110.0) + 110.0);
		String targetStr;

		if(value < 100){
			targetStr = prefix + "0" + value;
		}else{
			targetStr = prefix + value;
		}		
		
		return targetStr;
	}

	
}
