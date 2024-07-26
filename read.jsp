<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, org.json.JSONObject, org.json.JSONArray, java.io.IOException, java.util.Map, java.util.HashMap, java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Listado de Registros</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 20px;
            color: #2b2b2b;
        }

        .header-container {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

h1 {
    color: #093d77;
    margin-right: 20px;
    animation: moveTitle 1.5s ease-in-out infinite alternate;
}

#peru-image {
    max-width: 50px;
    height: auto;
}

        @keyframes moveTitle {
            0% {
                transform: translateX(-5px);
            }
            100% {
                transform: translateX(5px);
            }
        }

        .main-container {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
        }

        .table-container {
            flex: 1;
            margin-right: 20px;
            min-width: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #ffffff;
            border: 1px solid #ddd;
            overflow-x: auto;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            white-space: nowrap;
        }

        th {
            background-color: #3a7ca5;
            color: #ffffff;
        }

        tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        tr:hover {
            background-color: #f2f2f2;
        }

        .actions {
            white-space: nowrap;
        }

        .actions a {
            margin-right: 10px;
            color: #f5f5f5;
            text-decoration: none;
        }

        .actions a:hover {
            text-decoration: underline;
        }

        .create-link {
            display: block;
            margin-top: 20px;
            text-align: center;
        }

        .create-link a {
            background-color: #093d77;
            color: #ffffff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .create-link a:hover {
            background-color: #3a7ca5; /* Dark moderate blue */
        }

        .update-link {
            background-color: #093d77;
            color: #ffffff;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .update-link:hover {
            background-color: #2b2b2b;
        }

        .delete-link {
            background-color: #daaa52;
            color: #ffffff;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .delete-link:hover {
            background-color: #2b2b2b;
        }

        .imagen-responsive {
            max-width: 100%;
            height: auto;
            max-width: 300px;
        }

        .image-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-shrink: 0;
            min-width: 0;
        }
    </style>
</head>
<body>
    <div class="header-container">
        <h1>Listado de Departamentos, Provincias y Distritos</h1>
        <img id="peru-image" src="./bandera.png" alt="Mapa de Perú">
    </div>
    <div class="main-container">
        <!-- Contenedor de la tabla -->
        <div class="table-container">
            <table border="1">
                <tr>
                    <th>Departamento</th>
                    <th>Provincia</th>
                    <th>Distrito</th>
                    <th>Acciones</th>
                </tr>
                <%
                    // Mapas y listas para organizar los datos
                    Map<Long, String> departamentosMap = new HashMap<>();
                    Map<Long, String> provinciasMap = new HashMap<>();
                    Map<Long, List<JSONObject>> distritosMap = new HashMap<>();
                    Map<Long, Long> provinciasToDepartamentosMap = new HashMap<>(); // Mapa para relacionar provincias con departamentos

                    try {
                        // Obtener departamentos
                        URL urlDepartamentos = new URL("http://localhost:8081/api/departamentos");
                        HttpURLConnection connDepartamentos = (HttpURLConnection) urlDepartamentos.openConnection();
                        connDepartamentos.setRequestMethod("GET");
                        BufferedReader brDepartamentos = new BufferedReader(new InputStreamReader(connDepartamentos.getInputStream()));
                        StringBuilder responseDepartamentos = new StringBuilder();
                        String lineDepartamentos;
                        while ((lineDepartamentos = brDepartamentos.readLine()) != null) {
                            responseDepartamentos.append(lineDepartamentos);
                        }
                        brDepartamentos.close();
                        JSONArray departamentos = new JSONArray(responseDepartamentos.toString());

                        for (int i = 0; i < departamentos.length(); i++) {
                            JSONObject departamento = departamentos.getJSONObject(i);
                            departamentosMap.put(departamento.getLong("id"), departamento.getString("name"));
                        }

                        // Obtener provincias
                        URL urlProvincias = new URL("http://localhost:8081/api/provincias");
                        HttpURLConnection connProvincias = (HttpURLConnection) urlProvincias.openConnection();
                        connProvincias.setRequestMethod("GET");
                        BufferedReader brProvincias = new BufferedReader(new InputStreamReader(connProvincias.getInputStream()));
                        StringBuilder responseProvincias = new StringBuilder();
                        String lineProvincias;
                        while ((lineProvincias = brProvincias.readLine()) != null) {
                            responseProvincias.append(lineProvincias);
                        }
                        brProvincias.close();
                        JSONArray provincias = new JSONArray(responseProvincias.toString());

                        for (int j = 0; j < provincias.length(); j++) {
                            JSONObject provincia = provincias.getJSONObject(j);
                            provinciasMap.put(provincia.getLong("id"), provincia.getString("name"));
                            provinciasToDepartamentosMap.put(provincia.getLong("id"), provincia.getLong("departamento_id"));
                            distritosMap.put(provincia.getLong("id"), new ArrayList<JSONObject>()); // Inicializa la lista de distritos
                        }

                        // Obtener distritos
                        URL urlDistritos = new URL("http://localhost:8081/api/distritos");
                        HttpURLConnection connDistritos = (HttpURLConnection) urlDistritos.openConnection();
                        connDistritos.setRequestMethod("GET");
                        BufferedReader brDistritos = new BufferedReader(new InputStreamReader(connDistritos.getInputStream()));
                        StringBuilder responseDistritos = new StringBuilder();
                        String lineDistritos;
                        while ((lineDistritos = brDistritos.readLine()) != null) {
                            responseDistritos.append(lineDistritos);
                        }
                        brDistritos.close();
                        JSONArray distritos = new JSONArray(responseDistritos.toString());

                        for (int k = 0; k < distritos.length(); k++) {
                            JSONObject distrito = distritos.getJSONObject(k);
                            long provinciaId = distrito.getLong("provincia_id");
                            List<JSONObject> distritosList = distritosMap.get(provinciaId);
                            if (distritosList != null) {
                                distritosList.add(distrito);
                            }
                        }

                        // Inicialización adecuada
                        long previousDepartamentoId = -1L; // Valor especial
                        String previousDepartamentoName = null;
                        long previousProvinciaId = -1L; // Valor especial
                        String previousProvinciaName = null;

                        for (Map.Entry<Long, String> provEntry : provinciasMap.entrySet()) {
                            long provinciaId = provEntry.getKey();
                            String provinciaName = provEntry.getValue();
                            long departamentoId = provinciasToDepartamentosMap.get(provinciaId);
                            String departamentoName = departamentosMap.get(departamentoId);

                            // Verificar si estamos cambiando de departamento o provincia
                            if (departamentoId != previousDepartamentoId) {
                                if (previousDepartamentoId != -1L) {
                                    out.print("</td></tr>");
                                }
                                out.print("<tr><td colspan='4'><strong>" + departamentoName + "</strong></td></tr>");
                                previousDepartamentoId = departamentoId;
                                previousDepartamentoName = departamentoName;
                            }

                            if (provinciaId != previousProvinciaId) {
                                if (previousProvinciaId != -1L) {
                                    out.print("</td></tr>");
                                }
                                out.print("<tr><td colspan='4'><strong>" + provinciaName + "</strong></td></tr>");
                                previousProvinciaId = provinciaId;
                                previousProvinciaName = provinciaName;
                            }

                            List<JSONObject> distritosList = distritosMap.get(provinciaId);
                            for (JSONObject distrito : distritosList) {
                                out.print("<tr>");
                                out.print("<td>" + departamentoName + "</td>");
                                out.print("<td>" + provinciaName + "</td>");
                                out.print("<td>" + distrito.getString("name") + "</td>");
                                out.print("<td class='actions'>");
                                out.print("<a href='update.jsp?departamentoId=" + departamentoId + "&provinciaId=" + provinciaId + "&distritoId=" + distrito.getLong("id") + "' class='update-link'>Actualizar</a>");
                                out.print("<a href='delete.jsp?departamentoId=" + departamentoId + "&provinciaId=" + provinciaId + "&distritoId=" + distrito.getLong("id") + "' class='delete-link'>Eliminar</a>");
                                out.print("</td>");
                                out.print("</tr>");
                            }
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                %>
            </table>
            <div class="create-link">
                <a href="create.jsp">Crear Nuevo Registro</a>
            </div>
        </div>
        <!-- Contenedor de la imagen -->
        <div class="image-container">
            <img src="./Peru.png" alt="Descripción de la imagen" class="imagen-responsive">
        </div>
    </div>
</body>
</html>
