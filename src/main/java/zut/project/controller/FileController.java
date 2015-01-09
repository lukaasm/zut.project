package zut.project.controller;
 
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.Principal;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import zut.project.entity.Descriptor;
import zut.project.service.DescriptorService;
import zut.project.service.UserService;
 
/**
 * Handles requests for the application upload page.
 */
@Controller
public class FileController {
     
	@Autowired
	private DescriptorService descriptorService;
	@Autowired
	private UserService userService;
	
    private static final Logger logger = LoggerFactory.getLogger(FileController.class);
     
    @RequestMapping(value = "/upload", method = RequestMethod.GET)
    public String upload(Model model) {
        logger.info("Upload page !");
         
        return "upload";
    }
    
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
	public String upload(@RequestParam("file") CommonsMultipartFile file, Principal principal) {
    	Descriptor descriptor = new Descriptor();
    	
    	descriptor.setName(file.getOriginalFilename());
    	descriptor.setType(file.getContentType());
    	descriptor.setUploadTime(new Date());
    	descriptor.setUser(userService.findByName(principal.getName()));
    	// temporary URL
    	descriptor.setUrl("../" + file.getOriginalFilename());
    	    	    	
    	try
    	{
    		file.transferTo(new File(descriptor.getUrl()));
    		descriptorService.save(descriptor);
    	}
    	catch(Exception ex)
    	{
    		System.out.println(ex.getMessage());
    	}
    	
		return "redirect:/files";
	}
    
    @RequestMapping(value = "/files", method = RequestMethod.GET)
    public String files(Model model) {
        logger.info("Files page !");
        
        model.addAttribute("files", descriptorService.findAll());
         
        return "files";
    }
    
    @RequestMapping(value = "/files/{id}", method = RequestMethod.GET)
    public void download(@PathVariable Integer id, HttpServletResponse response) {
         Descriptor desc = (Descriptor) descriptorService.findOne(id);
         File file = new File(desc.getUrl());
         try {
             // get your file as InputStream
        	 BufferedInputStream stream = new BufferedInputStream(new FileInputStream(file));
        	 response.setContentType(desc.getType());
             response.setContentLength((int)file.length());
             response.setHeader("Content-Disposition", "attachment; filename="+desc.getName());
             
             IOUtils.copy(stream, response.getOutputStream()); 
             response.flushBuffer();
             
           } catch (IOException ex) {
             System.out.println(ex.getMessage());
           }                     
       
    }
     
}