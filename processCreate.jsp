<%@ page import="java.io.*, java.net.*, org.json.*" %>
<%
    String departamento = request.getParameter("departamento");
    String provincia = request.getParameter("provincia");
    String distrito = request.getParameter("distrito");

    try {
        // Crear departamento
        URL url = new URL("http://localhost:8081/api/departamentos");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; utf-8");
        conn.setDoOutput(true);
        
        String jsonInputString = new JSONObject().put("name", departamento).toString();
        try(OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("utf-8");
            os.write(input, 0, input.length);           
        }
        
        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
        StringBuilder departamentoResponse = new StringBuilder();
        String responseLine;
        while ((responseLine = br.readLine()) != null) {
            departamentoResponse.append(responseLine.trim());
        }
        JSONObject departamentoJson = new JSONObject(departamentoResponse.toString());
        Long departamentoId = departamentoJson.getLong("id");
        
        // Crear provincia
        url = new URL("http://localhost:8081/api/provincias");
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; utf-8");
        conn.setDoOutput(true);
        
        jsonInputString = new JSONObject().put("name", provincia).put("departamento_id", departamentoId).toString();
        try(OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("utf-8");
            os.write(input, 0, input.length);           
        }
        
        br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
        StringBuilder provinciaResponse = new StringBuilder();
        while ((responseLine = br.readLine()) != null) {
            provinciaResponse.append(responseLine.trim());
        }
        JSONObject provinciaJson = new JSONObject(provinciaResponse.toString());
        Long provinciaId = provinciaJson.getLong("id");
        
        // Crear distrito
        url = new URL("http://localhost:8081/api/distritos");
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; utf-8");
        conn.setDoOutput(true);
        
        jsonInputString = new JSONObject().put("name", distrito).put("provincia_id", provinciaId).toString();
        try(OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("utf-8");
            os.write(input, 0, input.length);           
        }
        
        br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
        StringBuilder distritoResponse = new StringBuilder();
        while ((responseLine = br.readLine()) != null) {
            distritoResponse.append(responseLine.trim());
        }
        
        // Redirigir a la página de lectura
        response.sendRedirect("read.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>



