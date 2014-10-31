
public class Twit {
		public double latitude;
		public double longitude;
		public String content;
		public String screenName;
		public String keyword;
		public long id;
		public Twit() {
		}
		public Twit(String screenName, String content, double latitude, double longitude, String keyword, long id) {
			this.screenName = screenName;
			this.content = content;
			this.latitude = latitude;
			this.longitude = longitude;
			this.keyword = keyword;
			this.id = id;
		}
}
