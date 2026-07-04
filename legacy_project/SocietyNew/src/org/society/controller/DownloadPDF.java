package org.society.controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DownloadPdfServlet")
public class DownloadPDF extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        // Get file name from query parameter
        String fileName = request.getParameter("file");
       
        if (fileName == null || fileName.contains("..")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file name.");
            return;
        }

        // Path to PDF folder inside the web application
        String filePath = getServletContext().getRealPath("/webapp/commonFiles/pdf/" + fileName);

        File downloadFile = new File(filePath);

        if (!downloadFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found.");
            return;
        }

        // Set response headers
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + downloadFile.getName() + "\"");
        response.setContentLengthLong(downloadFile.length());

        // Stream the file to the client
        try (BufferedInputStream inStream = new BufferedInputStream(new FileInputStream(downloadFile));
             BufferedOutputStream outStream = new BufferedOutputStream(response.getOutputStream())) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}