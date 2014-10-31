

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class Tweet
 */
public class Tweet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Tweet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
 
		response.setContentType("text/event-stream");
		response.setCharacterEncoding("UTF-8");
    	PrintWriter writer = response.getWriter();
    	for (int i = 0; i < 1000; i++) {
    		Twit twit = TweetGet.getCurrentTwit();
    		while(twit == null) {
    			//start the sampling
    			TweetGet.TwitterExample();
    			try {
    				Thread.sleep(2000);
    			} catch (InterruptedException e) {
    				e.printStackTrace();
    			}
    			twit = TweetGet.getCurrentTwit();
    		}
    		System.out.println(twit.keyword);
    		String tweetString = twit.id + "^" + twit.screenName + "^" + twit.latitude + "^" + twit.longitude + "^" + twit.content;
    		writer.write("data: "+ tweetString +"\n\n");
    		writer.flush();
    		try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
    	}
    	writer.close();
    	
	}
    
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		Map<String, Object> map = new HashMap<String, Object>();
		String selectedFilter = request.getParameter("filterByKeyword");
		ArrayList<Twit> tweetList = AwsConsoleApp.selectRecord("TwitData", selectedFilter);
		for(int i = 0; i<tweetList.size(); i++ ) {
			map.put(String.valueOf(i), tweetList.get(i));
		}
		write(response, map);
	}
	private void write(HttpServletResponse response, Map<String, Object> map) throws IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");
		response.getWriter().write(new Gson().toJson(map));
	}
}
