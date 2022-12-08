package studytime;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StudytimeDAO {
	//Database 접근 객체로 사용할 conn을 선언해주고,
		private Connection conn;
		// 정보를 담을 수 있는 객체 선언
		private PreparedStatement pstmt;
		private ResultSet rs;

		//UserDAO를 생성자로 만들어 주고, 자동적으로 데이터베이스 연결이 이뤄지게 해주는 코드를 짠다.
		public StudytimeDAO() {
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
		//현재날짜, 시간 가져오는 함수
		public String getDate2() {
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
		//당일날 첫 공부시간 등록시
		public int incalcstudytime(String userID, String time, String studytime) {
			String SQL = "INSERT INTO STUDYTIME VALUES (?, DATE_FORMAT(?,'%Y-%m-%d'), ?, ?, ? )";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setString(2, time);
				pstmt.setString(3, studytime);
				pstmt.setString(4, time);
				pstmt.setString(5, getDate2());
			
				return pstmt.executeUpdate();							
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		//이전 공부시간과 얻은 공부시간을 합쳐서 저장
		public int upcalcstudytime(String userID, String time, String studytime, String existing) {
			String SQL = "UPDATE STUDYTIME SET studytime = ADDTIME(?, ?),dayend = ?  WHERE userID = ? AND year(date)= year(?) AND month(date)= month(?) AND day(date)= day(?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, existing);
				pstmt.setString(2, studytime);
				pstmt.setString(3, getDate2());
				pstmt.setString(4, userID);
				pstmt.setString(5, time);
				pstmt.setString(6, time);
				pstmt.setString(7, time);
					
				return pstmt.executeUpdate();							
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		// 새로운 공부시간을 합산하기위해 기존 공부시간을 가져온다
		public String existing(String userID, String date) {
			String SQL = "SELECT studytime FROM STUDYTIME WHERE userID = ? AND year(date)= year(?) AND month(date)= month(?) AND day(date)= day(?) ";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
				pstmt.setString(2, date);
				pstmt.setString(3, date);
				pstmt.setString(4, date);
				//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
				rs = pstmt.executeQuery();
				//결과가 있는경우는 다음과 같이 getString 1을 해서 시간 계산값 반환
				if(rs.next()) {
					return rs.getString(1);
				}
			} catch (Exception e) {
				//오류 발생 내용을 콘솔에 띄움
				e.printStackTrace();
			}
			//데이터베이스 오류
			return "4"; 
		}
		//오늘 처음 공부하는건지 확인한다.
		public String firststudy(String userID, String date) {
			String SQL = "SELECT date FROM STUDYTIME WHERE userID = ? AND year(date)= year(?) AND month(date)= month(?) AND day(date)= day(?) ";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
				pstmt.setString(2, date);
				pstmt.setString(3, date);
				pstmt.setString(4, date);
				//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
				rs = pstmt.executeQuery();
				//결과가 있는경우는 다음과 같이 getString 1을 해서 시간 계산값 반환
				if(rs.next()) {
					return rs.getString(1);
				}
			} catch (Exception e) {
				//오류 발생 내용을 콘솔에 띄움
				e.printStackTrace();
			}
			//데이터베이스 오류
			return "4"; 
		}
		//메인에 공부시간 보여주는 함수
		public String viewmain(String userID, int year, int month, int day) {
			String SQL = "SELECT DATE_FORMAT(studytime,'%H:%i') FROM STUDYTIME WHERE userID = ? AND year(date)= ? AND month(date)= ? AND day(date)= ? ";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
				pstmt.setInt(2, year);
				pstmt.setInt(3, month);
				pstmt.setInt(4, day);
				//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
				rs = pstmt.executeQuery();
				//결과가 있는경우는 다음과 같이 getString 1을 해서 시간 계산값 반환
				if(rs.next()) {
					return rs.getString(1);
				}
			} catch (Exception e) {
				//오류 발생 내용을 콘솔에 띄움
				e.printStackTrace();
			}
			//데이터베이스 오류
			return ""; 
		}
		//detail공부시간
				public String viewdetail(String userID, int year, int month, int day) {
					String SQL = "SELECT studytime FROM STUDYTIME WHERE userID = ? AND year(date)= ? AND month(date)= ? AND day(date)= ? ";
					try {
						//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
						pstmt.setString(1, userID);
						pstmt.setInt(2, year);
						pstmt.setInt(3, month);
						pstmt.setInt(4, day);
						//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
						rs = pstmt.executeQuery();
						//결과가 있는경우는 다음과 같이 getString 1을 해서 시간 계산값 반환
						if(rs.next()) {
							return rs.getString(1);
						}
					} catch (Exception e) {
						//오류 발생 내용을 콘솔에 띄움
						e.printStackTrace();
					}
					//데이터베이스 오류
					return ""; 
				}
		//종료시간에 현재 종료시간 넣기
		public int insertdayend(String userID, String time) {
			String SQL = "UPDATE STUDYTIME SET dayend = ? WHERE userID = ? AND year(date)= year(?) AND month(date)= month(?) AND day(date)= day(?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, getDate2());
				pstmt.setString(2, userID);
				pstmt.setString(3, time);
				pstmt.setString(4, time);
				pstmt.setString(5, time);
					
				return pstmt.executeUpdate();							
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		//하루 시작시간 가져오는 함수
		public String daystart(String userID, int year, int month, int day) {
			//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
			String SQL = "SELECT daystart FROM STUDYTIME WHERE userID = ? AND year(date)= ? AND month(date)= ? AND day(date)= ? ";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
				pstmt.setInt(2, year);
				pstmt.setInt(3, month);
				pstmt.setInt(4, day);
				//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
				rs = pstmt.executeQuery();
				//결과가 있는경우는 다음과 같이 getString 1을 해서 시간 계산값 반환
				if(rs.next()) {
					return rs.getString(1);
				}
			} catch (Exception e) {
				//오류 발생 내용을 콘솔에 띄움
				e.printStackTrace();
			}
			//데이터베이스 오류
			return ""; 
		}
		//하루 종료시간 가져오는 함수
		public String dayend(String userID, int year, int month, int day) {
			//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
			String SQL = "SELECT dayend FROM STUDYTIME WHERE userID = ? AND year(date)= ? AND month(date)= ? AND day(date)= ? ";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
				pstmt.setInt(2, year);
				pstmt.setInt(3, month);
				pstmt.setInt(4, day);
				//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
				rs = pstmt.executeQuery();
				//결과가 있는경우는 다음과 같이 getString 1을 해서 시간 계산값 반환
				if(rs.next()) {
					return rs.getString(1);
				}
			} catch (Exception e) {
				//오류 발생 내용을 콘솔에 띄움
				e.printStackTrace();
			}
			//데이터베이스 오류
			return ""; 
		}
		//휴식사간 가져오는 함수{(dayend-daystart)-studytime}
		public String breaktime(String userID, int year, int month, int day) {
			//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
			String SQL = "SELECT TIMEDIFF(TIMEDIFF(dayend,daystart),studytime) FROM STUDYTIME WHERE userID = ? AND year(date)= ? AND month(date)= ? AND day(date)= ? ";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
				pstmt.setInt(2, year);
				pstmt.setInt(3, month);
				pstmt.setInt(4, day);
				//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
				rs = pstmt.executeQuery();
				//결과가 있는경우는 다음과 같이 getString 1을 해서 시간 계산값 반환
				if(rs.next()) {
					return rs.getString(1);
				}
			} catch (Exception e) {
				//오류 발생 내용을 콘솔에 띄움
				e.printStackTrace();
			}
			//데이터베이스 오류
			return ""; 
		}

		
}
