package user;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bbs.Bbs;

public class UserDAO {
	//Database 접근 객체로 사용할 conn을 선언해주고,
	private Connection conn;
	// 정보를 담을 수 있는 객체 선언
	private PreparedStatement pstmt;
	private ResultSet rs;

	//UserDAO를 생성자로 만들어 주고, 자동적으로 데이터베이스 연결이 이뤄지게 해주는 코드를 짠다.
	public UserDAO() {
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

	//위에꺼는 실제로 mysql에 접속을 하게 해주는 부분이고, 이제 실제로 로그인을 시도하는 하나의 함수 구현 userID,userPassword를 입력 받아서 실행한다.
	public int login(String userID, String userPassword) {
		//이제 입력받은 userID 와 PW가 일치하는지 확인을 하기위해서 db내에서 userID 값에 대한 PW를 조회하는 쿼리를 넣어준다. *1.해킹방지를 위해 중간에 ?를 넣어놓고
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		//try,catch문으로 예외처리를 해주고
		try {
			//pstmt에 어떠한 정해진 sql문장을 데이터베이스에 삽입하는 형식으로 인스턴스를 가져온다.
			pstmt = conn.prepareStatement(SQL); 
			//*2.쿼리 중 userID = ? 에 해당하는 부분에 입력받은 userID를 넣어주는 것이다. 그니까 바로 쿼리문으로 드가면 해킹틈 생기니까 setString으로 한번 거치고간다.
			pstmt.setString(1, userID);
			//이렇게 db에 넣을 쿼리문 셋팅이 끝났다. 실행한 결과를 rs에다가 담아준다.
			rs = pstmt.executeQuery();
			//이제 결과의 존재 여부에 따른 행동을 실행시켜주는 부분을 만들어 보자, 아이디가 존재할때
			if (rs.next()) {
				//만약 rs에 들어있는 값과 db내부의 userPW가 일치하면 login성공
				if (rs.getString(1).equals(userPassword))
					//login 성공
					return 1;
			 else 
				 //아니면 비밀번호 미 일치 실행한다. 
				return 0;
			}
			// 아이디가 없을때
			return -1;
		//그 외의 예상 불가 예외는 catch로 잡아준다.
		} catch (Exception e) {
			//해당 예외 출력
			e.printStackTrace();
		}
		// 데이터베이스 오류를 의미
		return -2;
	//로그인 시도 함수 작성 끝 loginAction Page 가자;
	}
	
	
	//회원가입 정보를 넣는곳
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	public User profile(String userID) {
		String SQL = "SELECT * FROM USER WHERE UserID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			//결과가 나왔을때 실행되어
			if (rs.next()) {
				//bbs인스턴스 내에 결과 값으로 나온 데이터를 다 집어 처넣고
				User user= new User();
				user.setUserID(rs.getString(1));
				user.setUserPassword(rs.getString(2));
				user.setUserName(rs.getString(3));
				user.setUserGender(rs.getString(4));
				user.setUserEmail(rs.getString(5));
				//그 결과를 getBbs함수를 불러온 대상에게 반환 해 준다~ 
				return user;
				
				}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; //데이터베이스 오류
	}
}
