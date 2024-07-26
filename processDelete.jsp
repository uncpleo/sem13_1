<%@ page import="java.io.OutputStreamWriter, java.net.HttpURLConnection, java.net.URL" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eliminar Registro</title>
</head>
<body>
    <%
        long distritoId = Long.parseLong(request.getParameter("distritoId"));

        // URL de la API para eliminar un distrito
        URL url = new URL("http://localhost:8081/api/distritos/" + distritoId);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("DELETE");
        conn.setDoOutput(true);

        // Enviar la solicitud
        conn.getOutputStream().flush();
        conn.getOutputStream().close();

        // Verificar la respuesta
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_NO_CONTENT) {
            // Redirigir si la eliminación fue exitosa
            response.sendRedirect("read.jsp");
        } else {
            // Mostrar mensaje de error si la eliminación falló
            out.println("<h2>Error al eliminar el registro. Código de respuesta: " + responseCode + "</h2>");
        }
    %>
    <a href="read.jsp">Volver al Listado</a>
</body>
</html>
