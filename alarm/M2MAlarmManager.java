package test.alarm;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;

// アプリケーションリスナはDB登録と別のリスナを新しく定義する
public class M2MAlarmManager implements ApplicationListener{

	// この実装プラスDB Poolのサイズを20に増やす
	
	// インスタンス生成用ApplicationContext
	private ApplicationContext context;
	
	// リクエストを振り分けるmap
	private Map <String, RequestController>map;
	
	// 実行用Executor
	private ExecutorService executor;
	
	@PostConstruct
	public void initialize(){
		map = new ConcurrentHashMap<String, RequestController>();
		executor = Executors.newCachedThreadPool();
	}
	
	@PreDestroy
	public void finalize(){
		// 終了メッセージを送る
		for(RequestController controller :map.values()){
			controller.setDone(true);
		}
		executor.shutdown();
		map.clear();
	}
	
	@Override
	public void onApplicationEvent(ApplicationEvent arg0) {
		String sensorId = null;
		Map<String, Object> requestMap = null;
		
		RequestController controller = map.get(sensorId);
		if(controller == null){
			// コントローラクラスのインスタンス化
			controller = context.getBean(RequestController.class);
			// Executorに入れる
			executor.submit(controller);
		}
		
		// キューにリクエストを入れる
		controller.addRequestToQueue(requestMap);
	}

}
