<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.time.*, java.util.*" %>
<%--
  Демонстрируем:
  - директиву page (language, contentType, pageEncoding, import)
  - декларацию <%! ... %> (глобальные поля/методы JSP-класса)
  - скриптлет <% ... %> (код в методе _jspService)
  - выражение <%= ... %> (вставка значения)
--%>
<%!
   // Декларация: поле-счётчик живёт в инстансе JSP (не потокобезопасно, но нужно для демо)
   private int visitCounter = 0;

   private String greet() {
     return "Вітаю з JSP!";
   }
%>
<%
    // Скриптлет: выполняется при каждом запросе
    visitCounter++;
    LocalDateTime now = LocalDateTime.now();
    String userAgent = request.getHeader("User-Agent");
%>
<!doctype html>
<html lang="uk">
<head>
  <meta charset="UTF-8">
  <title>JSP демо — скриптлети</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
  <h1><%= greet() %></h1>
  <p class="small">Директива page використовується нагорі файлу.</p>

  <h2>Дані запиту</h2>
  <ul>
    <li>Час сервера: <b><%= now %></b></li>
    <li>User-Agent: <span class="badge"><%= userAgent %></span></li>
    <li>Лічильник відвідувань цієї JSP (з декларації): <b><%= visitCounter %></b></li>
  </ul>

  <div class="row">
    <a class="btn" href="../index.html">← Назад до калькулятора</a>
    <a class="btn" href="hello.jsp">Оновити сторінку</a>
  </div>
</div>
</body>
</html>
