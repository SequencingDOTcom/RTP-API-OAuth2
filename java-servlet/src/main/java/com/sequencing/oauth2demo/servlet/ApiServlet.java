package com.sequencing.oauth2demo.servlet;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.sequencing.oauth.core.SequencingFileMetadataApi;
import com.sequencing.oauth.exception.NonAuthorizedException;
import com.sequencing.oauth.helper.JsonHelper;

/**
 * We make API requests after success authorization.
 */
public class ApiServlet extends HttpServlet
{
	private static final long serialVersionUID = -8690407547185006175L;
	private Logger logger = Logger.getLogger(getClass());
	private SequencingFileMetadataApi fileApi;
    
    @Override
	public void init(ServletConfig config) throws ServletException
	{
		fileApi = (SequencingFileMetadataApi) config.getServletContext().getAttribute(
				SequencingServletContextListener.CFG_FILE_HANDLER);
	}
        
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String result = null;
		try
		{
			result = fileApi.getSampleFiles();
		}
		catch (NonAuthorizedException e)
		{
			logger.warn("App does not contain access token", e);
			e.printStackTrace();
        }

		if (result == null)
		{
			logger.warn("An unsuccessful attempt to query to the API server");
            request.setAttribute("error", "An unsuccessful attempt to query to the API server");
            request.getRequestDispatcher("/error").forward(request, response);
            return;
        }       
        
        request.setAttribute("response_json", JsonHelper.toJsonArray(result));
        request.getRequestDispatcher("/apiResponse").forward(request, response);
    }
}
