# 1. Imagen oficial de Tomcat 10 para Jakarta EE
FROM tomcat:10.1-jdk17-temurin

# 2. Limpiar aplicaciones por defecto para evitar conflictos
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. Copiar tu .war a la carpeta raíz de Tomcat
# IMPORTANTE: Asegúrate de que el nombre PROYECTO-VITALD.war sea exacto al tuyo
COPY ./dist/PROYECTO-VITALD.war /usr/local/tomcat/webapps/ROOT.war

# 4. Exponer el puerto para Railway
EXPOSE 8080

# 5. Iniciar el servidor
CMD ["catalina.sh", "run"]
