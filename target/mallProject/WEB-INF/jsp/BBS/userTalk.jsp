<%--
  Created by IntelliJ IDEA.
  User: hongjin
  Date: 2018/1/5
  Time: 上午9:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jsp/include/easyui_core.jsp"%>
<html>
<head>
 <title>WebSocket/SockJS Echo Sample (Adapted from Tomcat's echo sample)</title>
 <style type="text/css">
  #connect-container {
   float: left;
   width: 400px
  }

  #connect-container div {
   padding: 5px;
  }

  #console-container {
   float: left;
   margin-left: 15px;
   width: 400px;
  }

  #console {
   border: 1px solid #CCCCCC;
   border-right-color: #999999;
   border-bottom-color: #999999;
   height: 170px;
   overflow-y: scroll;
   padding: 5px;
   width: 100%;
  }

  #console p {
   padding: 0;
   margin: 0;
  }
 </style>

 <script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>

 <script type="text/javascript">
     var ws = null;
     var url = null;
     var transports = [];

     function setConnected(connected) {
         document.getElementById('connect').disabled = connected;
         document.getElementById('disconnect').disabled = !connected;
         document.getElementById('echo').disabled = !connected;
     }

     function connect() {
         alert("url:"+url);
         if (!url) {
             alert('Select whether to use W3C WebSocket or SockJS');
             return;
         }

         ws = (url.indexOf('sockjs') != -1) ?
             new SockJS(url, undefined, {protocols_whitelist: transports}) : new WebSocket(url);

         ws.onopen = function () {
             setConnected(true);
             log('Info: connection opened.');
         };
         ws.onmessage = function (event) {
             var message = JSON.parse(event.data);//将数据解析成JSON形式
             log('Received: ' + event.data);
         };
         ws.onclose = function (event) {
             setConnected(false);
             log('Info: connection closed.');
             log(event);
         };
     }

     function disconnect() {
         if (ws != null) {
             ws.close();
             ws = null;
         }
         setConnected(false);
     }

     function echo() {
         if (ws != null) {
             var message = document.getElementById('message').value;
var sendUid = "1";
             var sendName = "hjj";
             var to = "2";
             var data = {};//新建data对象，并规定属性名与相应的值
             data['fromId'] = sendUid;
             data['fromName'] = sendName;
             data['toId'] = to;
             data['messageText'] = message;
             ws.send(JSON.stringify(data));//将对象封装成JSON后发送至服务器

             log('Sent: ' + message);
//             ws.send(message);
         } else {
             alert('connection not established, please connect.');
         }
     }
     function echo1() {
         if (ws != null) {
             var message = document.getElementById('message').value;
             var sendUid = "2";
             var sendName = "hj2";
             var to = "1";
             var data = {};//新建data对象，并规定属性名与相应的值
             data['fromId'] = sendUid;
             data['fromName'] = sendName;
             data['toId'] = to;
             data['messageText'] = message;
             ws.send(JSON.stringify(data));//将对象封装成JSON后发送至服务器

             log('Sent: ' + message);
//             ws.send(message);
         } else {
             alert('connection not established, please connect.');
         }
     }
     function updateUrl(urlPath) {
         if (urlPath.indexOf('sockjs') != -1) {
             url = urlPath;
             document.getElementById('sockJsTransportSelect').style.visibility = 'visible';
         }
         else {
             if (window.location.protocol == 'http:') {
                 url = 'ws://' + window.location.host + urlPath;
             } else {
                 url = 'wss://' + window.location.host + urlPath;
             }
             document.getElementById('sockJsTransportSelect').style.visibility = 'hidden';
         }
     }

     function updateTransport(transport) {
         alert(transport);
         transports = (transport == 'all') ?  [] : [transport];
     }

     function log(message) {
         var console = document.getElementById('console');
         var p = document.createElement('p');
         p.style.wordWrap = 'break-word';
         p.appendChild(document.createTextNode(message));
         console.appendChild(p);
         while (console.childNodes.length > 25) {
             console.removeChild(console.firstChild);
         }
         console.scrollTop = console.scrollHeight;
     }
 </script>
</head>
<body>
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websockets
 rely on Javascript being enabled. Please enable
 Javascript and reload this page!</h2></noscript>
<div>
 <div id="connect-container">
  <input id="radio1" type="radio" name="group1" onclick="updateUrl('${path}/websocket');">
  <label for="radio1">W3C WebSocket</label>
  <br>
  <input id="radio2" type="radio" name="group1" onclick="updateUrl('${path}/websocket');">
  <label for="radio2">SockJS</label>
  <div id="sockJsTransportSelect" style="visibility:hidden;">
   <span>SockJS transport:</span>
   <select onchange="updateTransport(this.value)">
    <option value="all">all</option>
    <option value="websocket">websocket</option>
    <option value="xhr-polling">xhr-polling</option>
    <option value="jsonp-polling">jsonp-polling</option>
    <option value="xhr-streaming">xhr-streaming</option>
    <option value="iframe-eventsource">iframe-eventsource</option>
    <option value="iframe-htmlfile">iframe-htmlfile</option>
   </select>
  </div>
  <div>
   <button id="connect" onclick="connect();">Connect</button>
   <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
  </div>
  <div>
   <textarea id="message" style="width: 350px">Here is a message!</textarea>
  </div>
  <div>
   <button id="echo" onclick="echo();" disabled="disabled">Echo message</button>
   <button id="echo1" onclick="echo1();" >EchoTo2 message</button>
  </div>
 </div>
 <div id="console-container">
  <div id="console"></div>
 </div>
</div>
</body>
</html>



<%--<%@include file="/WEB-INF/jsp/include/easyui_core.jsp"%>--%>
<%--<html>--%>
<%--<head>--%>
<%--<body>--%>
 <%--<div onclick="talkFunc()">点我发送</div>--%>
<%--</body>--%>
<%--<script>--%>
<%--//    var  socketPath = "";--%>
    <%--var webSocket = new WebSocket("ws://"+socketPath+"/ws");--%>
    <%--webSocket.onopen = function (event) {--%>
        <%--console.log("链接成功")--%>
        <%--console.log(event);--%>
    <%--}--%>
    <%--webSocket.onerror = function (event) {--%>
        <%--console.log("连接失败")--%>
        <%--console.log(event);--%>
    <%--}--%>
    <%--webSocket.onclose = function (event) {--%>
        <%--console.log("Socket连接断开");--%>
        <%--console.log(event);--%>
    <%--}--%>
    <%--webSocket.onmessage = function (event) {--%>
        <%--var message = JSON.parse(event.data);//将数据解析成JSON形式--%>
        <%--console.log(message);--%>
    <%--}--%>
    <%--function sendMessage(sendUid,sendName,to,messageText) {--%>
        <%--var data = {};--%>
        <%--data["fromId"] = sendUid;--%>
        <%--data["fromName"] = sendName;--%>
        <%--data["toId"] = to;--%>
        <%--data["messageText"] = messageText;--%>
        <%--webSocket.send(JSON.stringify(data));--%>
    <%--}--%>
    <%--function talkFunc() {--%>
        <%--sendMessage("1","hjj","2","nihao ");--%>
    <%--}--%>
<%--</script>--%>
<%--</html>--%>
