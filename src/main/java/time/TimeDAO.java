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
			String SQL = "UPDATE TIME SET seat = ?, start = ?, timelimit = DATE_ADD(?, INTERVAL 2 HOUR) WHERE userID = ? ";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, seat);
				pstmt.setString(2, getDate());
				pstmt.setString(3, getDate());
				pstmt.setString(4, userID);

				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		//좌석 이용중일때 다른좌석 이용하지 못하도록 자신 좌석 확인하는 함수
		public String myseat(String userID) {
			//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
			String SQL = "SELECT seat FROM TIME WHERE userID = ?";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
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
		//종료버튼 클릭시 동작하는 함수 좌석과 제한시간 초기화하고 현재시간을 end에 넣는다.
		public int end(String userID) {
			String SQL = "UPDATE TIME SET seat = null, end = ?, timelimit = null WHERE userID = ? ";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, getDate());
				pstmt.setString(2, userID);

				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		//연장을 위한 함수
		public int extend(String userID, String time) {
			String SQL = "UPDATE TIME SET timelimit = DATE_ADD(?, INTERVAL 2 HOUR) WHERE userID = ? ";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, time);
				pstmt.setString(2, userID);

				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		//연장하기위해 기존 종료시간 가져오는 함수
		public String getlimit(String userID) {
			//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
			String SQL = "SELECT timelimit FROM TIME WHERE userID = ?";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
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
		// 누구 자리인지 판별하기위한 함수
		public String whoseat(String seat) {
				String SQL = "SELECT userID FROM TIME WHERE seat = ?";
				//try,catch문으로 예외처리를 해주고
				try {
					//pstmt에 어떠한 정해진 sql문장을 데이터베이스에 삽입하는 형식으로 인스턴스를 가져온다.
					pstmt = conn.prepareStatement(SQL); 
					//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
					pstmt.setString(1, seat);
					//이렇게 db에 넣을 쿼리문 셋팅이 끝났다. 실행한 결과를 rs에다가 담아준다.
					rs = pstmt.executeQuery();
					//이제 결과의 존재 여부에 따른 행동을 실행시켜주는 부분을 만들어 보자, 자리가 존재할때
					if (rs.next()) {
						//자리를 차지하고 있는 user정보를 보냄
						return rs.getString(1);
					}
					// 자리가 비어있을 때
					return "2";
				//그 외의 예상 불가 예외는 catch로 잡아준다.
				} catch (Exception e) {
					//해당 예외 출력
					e.printStackTrace();
				}
				// 데이터베이스 오류를 의미
				return "3";
			}
		//종료시간 - 시작시간 계산함수
		public String timediff(String userID) {
			//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
			String SQL = "SELECT TIMEDIFF (end, start) FROM TIME WHERE userID = ?";
			try {
				//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
				pstmt.setString(1, userID);
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
		//날짜 판별을 위한 시작시간 가져오는 함수
		public String starttime(String userID) {
		//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
		String SQL = "SELECT start FROM TIME WHERE userID = ?";
		try {
			//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
			pstmt.setString(1, userID);
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
		//자동으로 종료하기 위해 제한시간 가져오는 함수
		public int autoend() {
			String SQL = "UPDATE TIME SET seat = null, end = ?, timelimit = null WHERE timelimit < ? ";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, getDate());
				pstmt.setString(2, getDate());

				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		//제한시간이 된 사용자를 찾기위한 함수
		public String limiteduser() {
		//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
		String SQL = "SELECT userID FROM TIME WHERE timelimit < ?";
		try {
			//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
			pstmt.setString(1, getDate());
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

		//상세정보 화면에서 종료시간 나타내는 함수
		public String endtime(String userID) {
		//이건 mysql에서 시간을 계산해주는 함수를 불러운다.
		String SQL = "SELECT end FROM TIME WHERE userID = ?";
		try {
			//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
			pstmt.setString(1, userID);
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
		//회원가입 시 time데이터베이스에 userID집어 넣는다
		public int firstjoin(String userID) {
			String SQL = "INSERT INTO TIME(userID) VALUES (?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
			
				return pstmt.executeUpdate();							
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
			
}
