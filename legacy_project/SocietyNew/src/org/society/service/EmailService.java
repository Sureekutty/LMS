package org.society.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.multipart.FormDataMultiPart;
import com.sun.jersey.multipart.MultiPart;
import com.sun.jersey.multipart.file.FileDataBodyPart;
import com.sun.jersey.multipart.impl.MultiPartWriter;

public class EmailService {

	public static String sendMail(String receiverAddress, String mailBody, File attachmentFile) throws IOException{
	
		Properties  sconfig=new Properties();
		InputStream is= EmailService.class.getResourceAsStream("/mail.properties");
		sconfig.load(is);
		is.close();
		
//		System.out.println("mail-props-loaded");
		
		WebResource resource = null;
		Client client = null;
		
		String user = sconfig.getProperty("sendMail_ServiceUser");
		String password = sconfig.getProperty("sendMail_ServicePassword");
		String from = sconfig.getProperty("sendMail_fromID");
		String replyToMail=sconfig.getProperty("sendMail_replyToID");
		
		ClientConfig cc = new DefaultClientConfig();
		cc.getClasses().add(MultiPartWriter.class);
		client = Client.create(cc);
		resource = client.resource(sconfig.getProperty("sendMail_ServiceURL"));
		
		String subjectText = "SPECCS Annual Statement";
		String bodyText = mailBody;
		
// 		fileArr.add(tenderInv);
		
		String mailData = "[{"
			    + "\"USER\":\""+user+"\","
			    + " \"PASSWORD\":\""+password+"\","
			    + " \"SUBJECT\":\""+subjectText+"\","
			    + " \"BODY\":\""+bodyText+"\","
			    + " \"TOMAIL\":\""+receiverAddress+"\","
			    + " \"FROMMAIL\":\""+from+"\""
			    + "}]";
		
		MultiPart multiPart = new FormDataMultiPart().field("JSONMAILPARAMS", mailData, MediaType.APPLICATION_JSON_TYPE);
		multiPart.bodyPart(new FileDataBodyPart("FILE", attachmentFile));
		ClientResponse mailResponse = resource.type(MediaType.MULTIPART_FORM_DATA_TYPE).post(ClientResponse.class, multiPart);
		
		String mailerResponse=mailResponse.getEntity(String.class);
		
 		System.out.println("response - "+mailerResponse);
		
		return mailerResponse;
	}
}
