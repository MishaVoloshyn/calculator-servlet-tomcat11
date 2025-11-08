package calc;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "CalculatorServlet", urlPatterns = {"/calculator"})
public class CalculatorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String aStr = req.getParameter("a");
        String bStr = req.getParameter("b");
        String op = req.getParameter("op");

        String error = null;
        double a = 0, b = 0, res = 0;
        String symbol = "?";

        try {
            a = Double.parseDouble(aStr.trim());
            b = Double.parseDouble(bStr.trim());
        } catch (Exception e) {
            error = "Введите корректные числа.";
        }

        if (error == null) {
            switch (op) {
                case "add": res = a + b; symbol = "+"; break;
                case "sub": res = a - b; symbol = "−"; break;
                case "mul": res = a * b; symbol = "×"; break;
                case "div":
                    symbol = "÷";
                    if (b == 0) error = "Деление на ноль запрещено.";
                    else res = a / b;
                    break;
                default: error = "Неизвестная операция.";
            }
        }

        try (PrintWriter out = resp.getWriter()) {
            out.println("<!doctype html><html lang='ru'><head><meta charset='UTF-8'><title>Результат</title>");
            out.println("<style>body{font-family:Segoe UI,Arial,sans-serif;margin:2rem} .card{max-width:560px;padding:16px;border:1px solid #ddd;border-radius:12px}</style>");
            out.println("</head><body><div class='card'><h2>Результат</h2>");
            if (error != null) {
                out.printf("<p style='color:#b00020'>%s</p>", error);
            } else {
                out.printf("<p><b>%s %s %s = %s</b></p>", a, symbol, b, strip(res));
            }
            out.println("<p><a href='index.html'>Назад</a></p></div></body></html>");
        }
    }

    private String strip(double v) {
        String s = Double.toString(v);
        if (s.contains(".")) s = s.replaceAll("0+$", "").replaceAll("\\.$", "");
        return s;
    }
}
