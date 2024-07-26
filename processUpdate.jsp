<%@ page import="java.io.IOException, java.io.OutputStream, java.net.HttpURLConnection, java.net.URL" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Procesar Actualización</title>
</head>
<body>
    <%
        long departamentoId = Long.parseLong(request.getParameter("departamentoId"));
        long provinciaId = Long.parseLong(request.getParameter("provinciaId"));
        long distritoId = Long.parseLong(request.getParameter("distritoId"));
        String nombreDistrito = request.getParameter("distritoName");

        // Preparar la solicitud para actualizar el distrito
        URL url = new URL("http://localhost:8081/api/distritos/" + distritoId);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("PUT");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        String jsonInputString = "{\"name\": \"" + nombreDistrito + "\"}";
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            out.println("Registro actualizado con éxito.");
        } else {
            out.println("Error al actualizar el registro.");
        }
    %>
    <br><br>
    <a href="read.jsp">Volver al Listado</a>
</body>
</html>
