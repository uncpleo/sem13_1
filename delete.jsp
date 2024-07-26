<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, org.json.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eliminar Registro</title>
</head>
<body>
    <h1>Eliminar Registro</h1>
    <form action="processDelete.jsp" method="post">
        <%
            long distritoId = Long.parseLong(request.getParameter("distritoId"));

            // Obtener los datos actuales del distrito para mostrar el nombre antes de eliminar
            URL urlDistrito = new URL("http://localhost:8081/api/distritos/" + distritoId);
            HttpURLConnection connDistrito = (HttpURLConnection) urlDistrito.openConnection();
            connDistrito.setRequestMethod("GET");
            BufferedReader brDistrito = new BufferedReader(new InputStreamReader(connDistrito.getInputStream()));
            StringBuilder responseBuilderDistrito = new StringBuilder();
            String lineDistrito;
            while ((lineDistrito = brDistrito.readLine()) != null) {
                responseBuilderDistrito.append(lineDistrito);
            }
            brDistrito.close();
            JSONObject distrito = new JSONObject(responseBuilderDistrito.toString());
            String nombreDistrito = distrito.getString("name");
        %>
        
        <input type="hidden" name="distritoId" value="<%= distritoId %>">
        
        <p>Estás a punto de eliminar el distrito "<%= nombreDistrito %>". ¿Estás seguro?</p>
        
        <input type="submit" value="Eliminar">
        <a href="read.jsp">Cancelar</a>
    </form>
</body>
</html>

