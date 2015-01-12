package zut.project.controller;
 
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.Principal;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.management.DescriptorRead;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import zut.project.entity.Descriptor;
import zut.project.entity.User;
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
     
    @RequestMapping(value = { "/", "/home" }, method = RequestMethod.GET)
    public String home(Model model) {
        model.addAttribute("files", descriptorService.findByParentAndAccess(null, descriptorService.ACCESS_PUBLIC));
         
        return "home";
    }
    
    @RequestMapping(value = "/upload", method = RequestMethod.GET)
    public String upload(Model model) {
        logger.info("Upload page !");
         
        return "upload";
    }
    
    @RequestMapping(value = "/files/upload", method = RequestMethod.POST)
	public String upload(@RequestParam("file") CommonsMultipartFile[] files,  @RequestParam("parent") String parent,
			Principal principal) {
    	
   		User user = userService.findByName(principal.getName());

    	for (CommonsMultipartFile file : files){
    		Descriptor descriptor = new Descriptor();
    		Descriptor desParent = descriptorService.findByName(parent);
    		descriptor.setParent(desParent);
    		
	    	descriptor.setName(file.getOriginalFilename());
	    	descriptor.setType(file.getContentType());
	    	descriptor.setUploadTime(new Date());
	    	descriptor.setUser(user);
	    	descriptor.setAccess(descriptorService.ACCESS_PRIVATE);

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
    	}
		return "redirect:/files";
	}
    
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(value = "/files", method = RequestMethod.GET)
    public String files(Model model) {
        logger.info("Files page !");
        // get items without any parents
        model.addAttribute("files", descriptorService.findByParent(null));
         
        return "files"; 
    }
    
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @RequestMapping(value = "/files/all")
    public String filesAll(Model model) {
        logger.info("Files page !");
        model.addAttribute("files", descriptorService.findAll());
         
        return "files"; 
    }
    
    @RequestMapping(value = "/files/{name}", method = RequestMethod.GET)
    public String filesInFolder(@PathVariable String name, Model model) {
        logger.info("Files page !");
        Descriptor parent = descriptorService.findByName(name);
        model.addAttribute("files", descriptorService.findByParent(parent));
        
        return "files"; 
    }
       
    @RequestMapping(value = "/download/{id}", method = RequestMethod.GET)
    public String download(@PathVariable Integer id, HttpServletResponse response, Principal princ, Model model) {
         Descriptor desc = (Descriptor) descriptorService.findOne(id);
         
         User user = userService.findByName(princ.getName());
         if ( desc.getAccess().equals(descriptorService.ACCESS_PRIVATE) && user != desc.getUser() )
         {
 			model.addAttribute("This is private!");
 			return "error?id=file-private";
         }
        	 
         File file = new File(desc.getUrl());
         try {
             
        	 BufferedInputStream stream = new BufferedInputStream(new FileInputStream(file));
        	 response.setContentType(desc.getType());
             response.setContentLength((int)file.length());
             response.setHeader("Content-Disposition", "attachment; filename="+desc.getName());
             
             IOUtils.copy(stream, response.getOutputStream()); 
             response.flushBuffer();
             
           } catch (IOException ex) {
             System.out.println(ex.getMessage());
           }                     
     	return "home";
    }    
   
    @RequestMapping(value = "/files/createFolder", method = RequestMethod.POST)
   	public String createFolder(@RequestParam("name") String name, @RequestParam("parent") String parent, 
   			Principal principal) {       	
       	
       		Descriptor descriptor = new Descriptor();
       		Descriptor desParent = descriptorService.findByName(parent);
       	
       		User user = userService.findByName(principal.getName());
       		
   	    	descriptor.setName(name);
   	    	descriptor.setType(descriptorService.FOLDER);
   	    	descriptor.setUploadTime(new Date());
   	    	descriptor.setUser( user );
   	    	descriptor.setParent(desParent);
   	    	    	    	
   	    	try
   	    	{
   	    		System.out.println(name);   	    		    
   	    		descriptorService.save(descriptor);
   	    	}
   	    	catch(Exception ex)
   	    	{
   	    		System.out.println(ex.getMessage());
   	    	}
       	
   		return "redirect:/files";
   	} 
    
    @RequestMapping(value = "/files/updateAccess", method = RequestMethod.POST)
   	public String updateAccess(@RequestParam("access") String access, @RequestParam("file_id") String id, Principal principal) {       	
       	
    	System.out.println( id + " " + access );
    	
    	try
    	{
	   		Descriptor descriptor = (Descriptor) descriptorService.findOne(Integer.parseInt(id));
	       	descriptor.setAccess(access);
	   		descriptorService.save(descriptor);
    	}
    	catch(Exception ex)
    	{
    		System.out.println(ex.getMessage());
    	}
   		return "redirect:/files";
   	} 
    
    @RequestMapping(value = "/files/delete", method = RequestMethod.POST)
    public String deleteFiles(@RequestParam("filesToDelete") String Delete){   
    	String[] tab = Delete.split(",");
    	for(String i : tab){
    		try
    		{
    			int id = Integer.parseInt(i);
    			Descriptor desc = (Descriptor) descriptorService.findOne(id);
    			
    			// file must be delete from server
    			if(!desc.getType().equals(descriptorService.FOLDER)){
    				new File(desc.getUrl()).delete();
    				System.out.println("Delete file");
    			}
    			
    			descriptorService.deleteById(id);
    			
    			System.out.println("Delete: " +i);
    		}
    		catch(Exception e)
    		{
    			System.out.println(e.getMessage());
    		}
    		
    	}
    	    	
    	return "redirect:/files";    	
    }
    
    @RequestMapping(value = "/files/move", method = RequestMethod.POST)
    public String moveFilesToFolder(@RequestParam("folder") int folder, @RequestParam("elements") String elements){   
    	String[] tab = elements.split(",");
    	for(String i : tab){
    		try
    		{
    			int id = Integer.parseInt(i);
    			if(folder == id)
    				continue;
    			descriptorService.updateParent(folder, id);
    			System.out.println(i);
    		}
    		catch(Exception e)
    		{
    			System.out.println(e.getMessage());
    		}
    		
    	}
    	    	
    	return "redirect:/files";    	
    }
    
}