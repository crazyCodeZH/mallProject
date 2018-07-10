package com.hj.webSocket;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hj.po.Message;
import com.hj.po.User;
import com.hj.utils.common.Const;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by hongjin on 2018/1/5.
 */
public class WebsocketEndPoint extends TextWebSocketHandler {
    public static final Map<Integer,WebSocketSession> userSocketSessionMap;

    static {
        userSocketSessionMap = new HashMap<Integer, WebSocketSession>();
    }

    @Override
    protected void handleTextMessage(WebSocketSession session,
                                     TextMessage message) throws Exception {

        if(message.getPayloadLength()==0)return;
        super.handleTextMessage(session, message);
        //得到Socket通道中的数据并转化为Message对象
        Message msg=new Gson().fromJson(message.getPayload().toString(),Message.class);

        Timestamp now = new Timestamp(System.currentTimeMillis());
        msg.setMessageDate(now);
        //将信息保存至数据库
//        youandmeService.addMessage(msg.getFromId(),msg.getFromName(),msg.getToId(),msg.getMessageText(),msg.getMessageDate());

        //发送Socket信息
        sendMessageToUser(msg.getToId(), new TextMessage(new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create().toJson(msg)));





//        TextMessage returnMessage = new TextMessage(message.getPayload()+" received at server");
//        session.sendMessage(returnMessage);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session)
            throws Exception {
        User user = (User) session.getAttributes().get(Const.SESSION_USER);
        if (userSocketSessionMap.get(user.getUID()) == null) {
            userSocketSessionMap.put(user.getUID(), session);
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session,
                                     Throwable exception) throws Exception {
        // 消息传输出错时调用
        System.out.println("handleTransportError");
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session,
                                      CloseStatus closeStatus) throws Exception {
        // 一个客户端连接断开时关闭
        Iterator<Map.Entry<Integer,WebSocketSession>> iterator = userSocketSessionMap.entrySet().iterator();
        while(iterator.hasNext()){
            Map.Entry<Integer,WebSocketSession> entry = iterator.next();
            if(entry.getValue().getAttributes().get(Const.SESSION_USER)==session.getAttributes().get(Const.SESSION_USER)){
                userSocketSessionMap.remove(session.getAttributes().get(Const.SESSION_USER));
                System.out.println("WebSocket in staticMap:" + session.getAttributes().get("uid") + "removed");
            }
        }
    }

    @Override
    public boolean supportsPartialMessages() {
        // TODO Auto-generated method stub
        return false;
    }

    //发送信息的实现
    public void sendMessageToUser(int uid, TextMessage message)
            throws IOException {
        WebSocketSession session = userSocketSessionMap.get(uid);
        if (session != null && session.isOpen()) {
            session.sendMessage(message);
        }
    }

}
