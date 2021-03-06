package com.example.demo;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ExecutionException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.google.api.core.ApiFuture;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;

@Controller // 해당 클래스가 controller로 사용됨을 spring framework에 알림
public class HelloController {
	@RequestMapping("/main") // value: 해당 url로 요청이 들어오면 메소드 수행
	public String hello(Model model) throws InterruptedException, ExecutionException {
		
		User test = new User();
		Map<String, Object> sigData = new HashMap<>();
		ArrayList<String> signal = new ArrayList<>();
		
		// Use the application default credentials
		try {
			/*
			 * GoogleCredentials credentials = GoogleCredentials.getApplicationDefault();
			 * FirebaseOptions options = new FirebaseOptions.Builder()
			 * .setCredentials(credentials) .setProjectId("project-vr-1") .build();
			 */
			FileInputStream serviceAccount = new FileInputStream(
					"C:\\Users\\shin jieun\\Documents\\졸작\\project-vr-1-firebase-adminsdk-29vpw-637fb83f51.json");

			FirebaseApp firebaseApp = null;
			List<FirebaseApp> firebaseApps = FirebaseApp.getApps();
			 
			if(firebaseApps != null && !firebaseApps.isEmpty()){
			             
			    for(FirebaseApp app : firebaseApps){
			        if(app.getName().equals(FirebaseApp.DEFAULT_APP_NAME)) {
			            firebaseApp = app;
			        }
			    }			             
			}else{
			    FirebaseOptions options = new FirebaseOptions.Builder()
			        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
			        .setDatabaseUrl("https://주소.firebaseio.com")
			        .build();
			    firebaseApp = FirebaseApp.initializeApp(options);              
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		Firestore db = FirestoreClient.getFirestore();

//		// asynchronously retrieve all users
//		ApiFuture<QuerySnapshot> query = db.collection("user").get();
//		// ...
//		// query.get() blocks on response
//		QuerySnapshot querySnapshot = query.get();
//		List<QueryDocumentSnapshot> documents = querySnapshot.getDocuments();
//		for (QueryDocumentSnapshot document : documents) {
//			System.out.println("User: " + document.getId());
//			model.addAttribute("id", document.getId()); // 뷰로 보낼 데이터 값
//
//			/*
//			 * System.out.println("First: " + document.getString("first")); if
//			 * (document.contains("middle")) { System.out.println("Middle: " +
//			 * document.getString("middle")); } System.out.println("Last: " +
//			 * document.getString("last")); System.out.println("Born: " +
//			 * document.getLong("born"));
//			 */
//		}
//		
		
		// Get session info using user id
		Session session = null;
		//asynchronously retrieve multiple documents
		ApiFuture<QuerySnapshot> future =
		    db.collection("session").whereEqualTo("userId", "fQD1R5yPUeRexlB77Siu").get();
		// future.get() blocks on response
		List<QueryDocumentSnapshot> documents = future.get().getDocuments();
		for (DocumentSnapshot document : documents) {
			System.out.println(document.getId() + " => " + document.toObject(Session.class));
			session = document.toObject(Session.class);
		}
		
		// Get signal data using session info
		DocumentReference docRef = db.collection("heart").document(session.heartId);
		ApiFuture<DocumentSnapshot> doc = docRef.get();
		// ...
		// future.get() blocks on response
		DocumentSnapshot document = doc.get();
		if (document.exists()) {
			System.out.println("Document data: " + document.getData());

			sigData = document.getData();
			signal = (ArrayList<String>) sigData.get("signal");
			System.out.println(signal);

			model.addAttribute("heartId", document.getId()); // 뷰로 보낼 데이터 값
			model.addAttribute("heartData", signal);
			model.addAttribute("timePlayed", session.timePlayed);
			model.addAttribute("length", signal.size());
		} else {
			System.out.println("No such document!");
		}
		
		
		return "hello1";

	}
	
}