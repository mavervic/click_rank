package websocket;

import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.stream.Collectors;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;

import redis.clients.jedis.JedisPooled;
import redis.clients.jedis.resps.Tuple;
import utils.RedisUtils;

@ServerEndpoint("/click")
public class ClickWebSocket {
	private static Set<Session> sessions = new CopyOnWriteArraySet<>();
	private static JedisPooled jedis = RedisUtils.getJedisPooled();
	private static final String redisStoreKey = "click.rank:clicks";
	private static Gson gson = new Gson();

	@OnOpen
	public void onOpen(Session session) {
		sessions.add(session);
		System.out.println("Connected: " + session.getId());
	}

	@OnMessage
	public void onMessage(String message, Session session) throws IOException {
		String[] parts = message.split(":");
		String username = parts[0];
		int clicks = Integer.parseInt(parts[1]);

		jedis.zadd(redisStoreKey, clicks, username);

		// Retrieve the sorted set from Redis
		List<Tuple> turpleList = jedis.zrevrangeWithScores(redisStoreKey, 0, -1);
		// Convert Set<Tuple> to List<UserScore>
		List<UserScore> userScoreList = turpleList.stream()
				.map(tuple -> new UserScore(tuple.getElement(), tuple.getScore())).collect(Collectors.toList());

		String json = gson.toJson(userScoreList);
		System.out.println(json);

		// Broadcast the updated leaderboard to all clients
		for (Session s : sessions) {
			if (s.isOpen()) {
				s.getBasicRemote().sendText(json);
			}
		}
	}

	@OnClose
	public void onClose(Session session) {
		System.out.println("Disconnected: " + session.getId());
	}

	class UserScore {
		private String username;
		private Double score;

		public UserScore(String username, Double score) {
			this.username = username;
			this.score = score;
		}

		public String getUsername() {
			return username;
		}

		public void setUsername(String username) {
			this.username = username;
		}

		public Double getScore() {
			return score;
		}

		public void setScore(Double score) {
			this.score = score;
		}

	}
}