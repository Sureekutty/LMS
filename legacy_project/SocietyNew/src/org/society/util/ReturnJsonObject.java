package org.society.util;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.google.gson.Gson;

public class ReturnJsonObject {
	
	public static void returnJsonObject(JSONObject jsonObject, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("utf8");
		ArrayList<String> jsonObjList = new ArrayList<>();
		jsonObjList.add(jsonObject.toString());
		Gson gson = new Gson();
		String json = gson.toJson(jsonObjList);
		response.getWriter().write(json.toString());
	}

}
