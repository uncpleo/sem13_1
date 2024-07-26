<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, org.json.JSONObject, org.json.JSONArray" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Actualizar Registro</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #F8F9FA; /* Light grayish blue */
            color: #2B2B2B; /* Very dark gray */
            margin: 20px;
        }

        h1 {
            color: #093D77; /* Dark moderate blue */
        }

        form {
            background-color: #FFFFFF; /* White */
            border: 1px solid #ddd; /* Light gray border */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: auto;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #093D77; /* Dark moderate blue */
        }

        select, input[type="text"], input[type="submit"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 12px;
            border: 1px solid #ddd; /* Light gray border */
            border-radius: 4px;
            box-sizing: border-box;
        }

        select:focus, input[type="text"]:focus {
            border-color: #3A7CA5; /* Dark moderate blue */
            outline: none;
            box-shadow: 0 0 4px rgba(58, 124, 165, 0.5);
        }

        input[type="submit"] {
            background-color: #093D77; /* Dark moderate blue */
            color: #FFFFFF; /* White text */
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #3A7CA5; /* Dark moderate blue */
        }

        a {
            color: #DAAA52; /* Deep saffron */
            text-decoration: none;
            font-weight: bold;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Actualizar Registro</h1>
    <form action="processUpdate.jsp" method="post">
        <%
            long departamentoId = Long.parseLong(request.getParameter("departamentoId"));
            long provinciaId = Long.parseLong(request.getParameter("provinciaId"));
            long distritoId = Long.parseLong(request.getParameter("distritoId"));

            // Obtener los datos actuales del distrito
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

            // Obtener lista de departamentos
            URL urlDepartamentos = new URL("http://localhost:8081/api/departamentos");
            HttpURLConnection connDepartamentos = (HttpURLConnection) urlDepartamentos.openConnection();
            connDepartamentos.setRequestMethod("GET");
            BufferedReader brDepartamentos = new BufferedReader(new InputStreamReader(connDepartamentos.getInputStream()));
            StringBuilder responseBuilderDepartamentos = new StringBuilder();
            String lineDepartamento;
            while ((lineDepartamento = brDepartamentos.readLine()) != null) {
                responseBuilderDepartamentos.append(lineDepartamento);
            }
            brDepartamentos.close();
            JSONArray departamentos = new JSONArray(responseBuilderDepartamentos.toString());

            // Obtener lista de provincias
            URL urlProvincias = new URL("http://localhost:8081/api/provincias");
            HttpURLConnection connProvincias = (HttpURLConnection) urlProvincias.openConnection();
            connProvincias.setRequestMethod("GET");
            BufferedReader brProvincias = new BufferedReader(new InputStreamReader(connProvincias.getInputStream()));
            StringBuilder responseBuilderProvincias = new StringBuilder();
            String lineProvincia;
            while ((lineProvincia = brProvincias.readLine()) != null) {
                responseBuilderProvincias.append(lineProvincia);
            }
            brProvincias.close();
            JSONArray provincias = new JSONArray(responseBuilderProvincias.toString());

            // Obtener el nombre de la provincia actual
            URL urlProvincia = new URL("http://localhost:8081/api/provincias/" + provinciaId);
            HttpURLConnection connProvincia = (HttpURLConnection) urlProvincia.openConnection();
            connProvincia.setRequestMethod("GET");
            BufferedReader brProvincia = new BufferedReader(new InputStreamReader(connProvincia.getInputStream()));
            StringBuilder responseBuilderProvincia = new StringBuilder();
            String lineProv;
            while ((lineProv = brProvincia.readLine()) != null) {
                responseBuilderProvincia.append(lineProv);
            }
            brProvincia.close();
            JSONObject provincia = new JSONObject(responseBuilderProvincia.toString());
            String nombreProvincia = provincia.getString("name");
        %>
        
        <input type="hidden" name="distritoId" value="<%= distritoId %>">
        
        <label for="departamento">Departamento:</label>
        <select id="departamento" name="departamentoId" required>
            <%
                for (int i = 0; i < departamentos.length(); i++) {
                    JSONObject dep = departamentos.getJSONObject(i);
                    long id = dep.getLong("id");
                    String nombre = dep.getString("name");
                    %>
                    <option value="<%= id %>" <%= (id == departamentoId) ? "selected" : "" %>><%= nombre %></option>
                    <%
                }
            %>
        </select>
        <br><br>
        
        <label for="provincia">Provincia:</label>
        <select id="provincia" name="provinciaId" required>
            <%
                for (int i = 0; i < provincias.length(); i++) {
                    JSONObject prov = provincias.getJSONObject(i);
                    long id = prov.getLong("id");
                    String nombre = prov.getString("name");
                    %>
                    <option value="<%= id %>" <%= (id == provinciaId) ? "selected" : "" %>><%= nombre %></option>
                    <%
                }
            %>
        </select>
        <br><br>
        
        <label for="distritoName">Nombre del Distrito:</label>
        <input type="text" id="distritoName" name="distritoName" value="<%= nombreDistrito %>" required>
        <br><br>
        
        <input type="submit" value="Actualizar">
    </form>
    <a href="read.jsp">Volver al Listado</a>
</body>
</html>
