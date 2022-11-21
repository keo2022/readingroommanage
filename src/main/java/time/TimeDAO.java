package time;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import user.User;

public class TimeDAO {
	//Database 접근 객체로 사용할 conn을 선언해주고,
		private Connection conn;
		// 정보를 담을 수 있는 객체 선언
		private PreparedStatement pstmt;
		private ResultSet rs;

		//UserDAO를 생성자로 만들어 주고, 자동적으로 데이터베이스 연결이 이뤄지게 해주는 코드를 짠다.
		public TimeDAO() {
			//예외 처리를 하기 위해서 try&catch 문을 쓴다.
			try {
				//dbURL안에 localhost라는 것은 본인 컴퓨터에 접속을 의미하고 3306포트에 연결된 BBSdb에 접속할 수 있게 해준다.
				//강의랑 디비 버전을 다르게해서 뒤에 뭘더붙임 ㅇㅇ;
				String dbURL =  "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
				//db에 접속하는 ID를 담는 부분
				String dbID = "root";
				//db에 접속하는 PW를 담는 부분
				String dbPassword = "0000";
				//mysql에 접속할 수 있는 driver를 찾을수 있게 해주는 코드 driver라는건 mysql에 접속할 수 있도록 매개체 역할을 해주는 라이브러리이다.
				//강의버전보다 한참 높은 버전의 디비를 써서 드라이버 주소가 좀다름
				Class.forName("com.mysql.cj.jdbc.Driver");
				//getConnection함수 내부에 dbURL에 root root 로 접속할 수 있게 해주는 데이터를 넣어 접속이 완료되면 conn객체안에 접속된 정보가 담기게 된다.
				conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			
			} catch (Exception e) {
				//오류의 내용을 내부 콘솔에 띄우기 위한 함수이다.
				e.printStackTrace();
			}
		

		}
		
		//현재날짜, 시간 가져오는 함수
		public String getDate() {
			//이건 mysql에서 현재의 시간을 가져오는 하나의 문장
			String SQL = "SELECT NOW()";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
				rs = pstmt.executeQuery();
				//결과가 있는경우는 다음과 같이 getString 1을 해서 현재의 그 날짜를 반환할 수 있게 해준다.
				if(rs.next()) {
					return rs.getString(1);
				}
			} catch (Exception e) {
				//오류 발생 내용을 콘솔에 띄움
				e.printStackTrace();
			}
			//데이터베이스 오류인데 웬만해선 디비오류가 날 이유가없기때문에 빈문장으로 넣어준다.
			return ""; 
		}
		public int start(String userID, String seat) {
			String SQL = "INSERT INTO TIME VALUES (?, ?, ?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setString(2, getDate());
				pstmt.setString(3, seat);

				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		public int end(String userID) {
			String SQL = "DELETE FROM TIME WHERE USERID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);

				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		
}
