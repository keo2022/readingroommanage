package reply;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ReplyDAO {

	private Connection conn;
	private ResultSet rs;
	
	public ReplyDAO() {
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
	
	
	public ArrayList<Reply> getList(int bbsID,int pageNumber){
		String SQL="SELECT * FROM REPLY WHERE replyID<? AND replyAvailable=1 AND bbsID=? ORDER BY replyID DESC LIMIT 10";
		ArrayList<Reply> list=new ArrayList<Reply>();
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1,getNext()-(pageNumber-1)*10);
			pstmt.setInt(2, bbsID);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				Reply reply=new Reply();
				reply.setUserID(rs.getString(1));
				reply.setReplyID(rs.getInt(2));
				reply.setReplyContent(rs.getString(3));
				reply.setBbsID(bbsID);
				reply.setReplyAvailable(1); // rs.getInt(5) => out of index 오류
				list.add(reply);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int getNext() {
		String SQL="select replyID FROM REPLY ORDER BY replyID DESC";
		try {
		
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				System.out.println(rs.getInt(1)); // select문에서 첫번째 값
				return rs.getInt(1)+1;  // 현재 인덱스(현재 게시글 개수) +1 반환
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	public int write(int bbsID,String replyContent,String userID) {
		String SQL="INSERT INTO REPLY VALUES(?,?,?,?,?)";
		
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1,bbsID);
			pstmt.setInt(2, getNext());
			pstmt.setString(3, replyContent);
			pstmt.setString(4,userID);
			pstmt.setInt(5,1);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
}