<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="java.sql.*" %>
<%--
  Демо JDBC у JSP (для навчання). У проді так не роблять —
  але ДЗ просить scriptlets, тому приклад inline ок.
--%>
<%
  String url = "jdbc:h2:mem:test;DB_CLOSE_DELAY=-1"; // пам'ять, не закривати при закритті останнього коннекта
  String user = "sa";
  String pass = "";

  // 1) створимо таблицю, якщо ще нема; 2) вставимо дані; 3) виберемо й виведемо
  try (Connection cn = DriverManager.getConnection(url, user, pass)) {
      try (Statement st = cn.createStatement()) {
          st.executeUpdate("""
              CREATE TABLE IF NOT EXISTS products(
                  id IDENTITY PRIMARY KEY,
                  name VARCHAR(100) NOT NULL,
                  price DECIMAL(10,2) NOT NULL
              )
          """);
          // маленька ініціалізація — лише якщо таблиця порожня
          try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM products")) {
              rs.next();
              if (rs.getInt(1) == 0) {
                  st.executeUpdate("INSERT INTO products(name,price) VALUES ('Калькулятор', 199.99), ('Олівець', 9.50), ('Блокнот', 39.00)");
              }
          }
      }
  } catch (SQLException e) {
      throw new RuntimeException("DB init error", e);
  }
%>
<!doctype html>
<html lang="uk">
<head>
  <meta charset="UTF-8">
  <title>JSP + JDBC (H2)</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
<div class="container">
  <h1>JSP + JDBC (H2)</h1>
  <p class="small">Дані з вбудованої БД H2 (in-memory).</p>

  <table>
    <thead><tr><th>ID</th><th>Назва</th><th>Ціна</th></tr></thead>
    <tbody>
    <%
      try (Connection cn = DriverManager.getConnection("jdbc:h2:mem:test;DB_CLOSE_DELAY=-1","sa","")) {
          try (PreparedStatement ps = cn.prepareStatement("SELECT id,name,price FROM products ORDER BY id")) {
              try (ResultSet rs = ps.executeQuery()) {
                  while (rs.next()) {
    %>
                    <tr>
                      <td><%= rs.getLong("id") %></td>
                      <td><%= rs.getString("name") %></td>
                      <td><%= rs.getBigDecimal("price") %></td>
                    </tr>
    <%
                  }
              }
          }
      } catch (SQLException e) {
          out.println("<tr><td colspan='3' style='color:#fca5a5'>DB error: " + e.getMessage() + "</td></tr>");
      }
    %>
    </tbody>
  </table>

  <div class="row">
    <a class="btn" href="../index.html">← Назад до калькулятора</a>
    <a class="btn" href="db.jsp">Оновити</a>
  </div>
</div>
</body>
</html>
