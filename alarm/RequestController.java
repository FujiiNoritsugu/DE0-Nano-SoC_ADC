package test.alarm;

import java.util.Map;
import java.util.concurrent.ConcurrentLinkedQueue;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;

@Scope("prototype")
public class RequestController implements Runnable{
	
	@Autowired
	private M2MAlarm alarm;
	
	@Autowired
	private SensorCache request;
	
	private ConcurrentLinkedQueue <Map<String, Object>>queue;

	public void addRequestToQueue(Map<String, Object> request){
		queue.add(request);
	}

	// 終了フラグ
	private boolean done = false;
	
	@Override
	public void run() {
		while(!done){
			// キューからマップを取得する
			Map<String, Object> requestMap = queue.poll();
			
			// マップの中身がリクエストであればリクエスト処理を実行、そうでなければ発災判定を行う
			if(requestMap == null){
				continue;
			}
			
			if(requestMap.containsKey("requestType")){
				request.executeRequest(requestMap);
			}else{
				alarm.checkAlarm(requestMap);
			}
			
			// 0.1秒待つ
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}		
	}
	
	public void setDone(boolean param){
		done = param;
	}
}
