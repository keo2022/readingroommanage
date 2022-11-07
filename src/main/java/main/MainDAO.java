package main;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MainDAO {
	//Database 접근 객체로 사용할 conn을 선언해주고,
		private Connection conn;
		// 정보를 담을 수 있는 객체 선언
		private PreparedStatement pstmt;
		private ResultSet rs;

		//UserDAO를 생성자로 만들어 주고, 자동적으로 데이터베이스 연결이 이뤄지게 해주는 코드를 짠다.
		public MainDAO() {
			//예외 처리를 하기 위해서 try&catch 문을 쓴다.
			try {
				//dbURL안에 localhost라는 것은 본인 컴퓨터에 접속을 의미하고 3306포트에 연결된 BBSdb에 접속할 수 있게 해준다.
				//강의랑 디비 버전을 다르게해서 뒤에 뭘더붙임 ㅇㅇ;
				String dbURL =  "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
				//db에 접속하는 ID를 담는 부분
				String dbID = "root";
				//db에 접속하는 PW를 담는 부분
				String dbPassword = "123456";
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
		/*public String studytime(int year, int month, int day) {
			String result; 	
			int NowYear, NowMonth, NowDay;
				String SQL= "SELECT Year, Month, Day, Time FROM main";
			 try {
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					rs = pstmt.executeQuery();
					while (rs.next()) { // 마지막 데이터까지 반복함.
				        //날짜가 같으면 데이터 출력
				        NowYear=rs.getInt("Year");
				        NowMonth=rs.getInt("Month");
				        NowDay=rs.getInt("Day");
				        if(year==NowYear&& month+1==NowMonth && day==NowDay) {
				        	result = rs.getString("Time");
				        	return result;
				        
				        
				       }
				       rs.close();
				      }
			 }catch(Exception e) {
					//오류의 내용을 내부 콘솔에 띄우기 위한 함수이다.
					e.printStackTrace();
				}
			
		}*/
}
