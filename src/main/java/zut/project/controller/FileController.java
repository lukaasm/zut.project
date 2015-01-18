package zut.project.controller;
 
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.imageio.ImageIO;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StreamUtils;
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
	
	@Autowired
	private EntityManager em;
	
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
	public String upload(@RequestParam("file") CommonsMultipartFile[] files,  @RequestParam("parent") int parent,
			Principal principal) {
    	
   		User user = userService.findByName(principal.getName());

    	for (CommonsMultipartFile file : files){
    		Descriptor descriptor = new Descriptor();
    		Descriptor desParent = (Descriptor) descriptorService.findOne(parent);
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
    	
		return "redirect:/files" ;
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
    
    @RequestMapping(value = "/files/{id}", method = RequestMethod.GET)
    public String filesInFolder(@PathVariable int id, Model model) {
        logger.info("Files page !");
        Descriptor parent = (Descriptor) descriptorService.findOne(id);
        model.addAttribute("files", descriptorService.findByParent(parent));
        
        return "files"; 
    }
    
    
    @RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
    public String getFile(@PathVariable Integer id) {
         Descriptor desc = (Descriptor) descriptorService.findOne(id);
         
         if(desc.getType().equals(descriptorService.FOLDER))
        	 return "redirect:/files/" + id.toString();
         else if (desc.getType().equals(descriptorService.ALBUM))
        	 return "redirect:/albums/" + id.toString();
         else
        	 return "redirect:/download/" + id.toString();
    }
    
    
    
    @RequestMapping(value = "/download/{id}", method = RequestMethod.GET)
    public String download(@PathVariable Integer id, HttpServletResponse response, Principal princ, Model model) {
         Descriptor desc = (Descriptor) descriptorService.findOne(id);
         
         User user = userService.findByName(princ.getName());
         if ( desc.getAccess().equals(descriptorService.ACCESS_PRIVATE) && user.getId() != desc.getUser().getId() )
         {
 			model.addAttribute("This is private!");
 			return "error?id=file-private";
         }
        	 
         File file = new File(desc.getUrl());
         try {
        	 System.out.println(file.getAbsolutePath());
        	 System.out.println(file.getCanonicalPath());
        	 System.out.println(file.getPath());
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
   
    @RequestMapping(value = "/multi-download/{download}", method = RequestMethod.GET)
    
    public void multiDownload(@PathVariable String download, HttpServletResponse response) {
    	String[] id = download.split(",");
        String zipName = "../download.zip"; 
        List<Descriptor> list = new ArrayList<Descriptor>();
        
        for(String i : id){
        	Descriptor desc = (Descriptor) descriptorService.findOne(Integer.parseInt(i));
        	
        	if(desc.getType().equals(descriptorService.ALBUM) || desc.getType().equals(descriptorService.FOLDER))
        		list.addAll(descriptorService.findByParent(desc));
        	else
        		list.add(desc);       
        }
        
		try {

			byte[] buffer = new byte[1024];
			FileOutputStream fos = new FileOutputStream(zipName);
			ZipOutputStream zos = new ZipOutputStream(fos);

			for (Descriptor file : list) {
				File srcFile = new File(file.getUrl());
				FileInputStream fis = new FileInputStream(srcFile);

				zos.putNextEntry(new ZipEntry(srcFile.getName()));
				
				int length;
				while ((length = fis.read(buffer)) > 0) {

					zos.write(buffer, 0, length);
				}

				zos.closeEntry();

				fis.close();
			}
			zos.flush();
			zos.close();
			fos.close();
		} catch (IOException ioe) {
			System.out.println("Error creating zip file: " + ioe);

		}

         
         File file = new File(zipName);      
         System.out.println(file.getAbsolutePath());
         try {
        	 
        	 BufferedInputStream stream = new BufferedInputStream(new FileInputStream(file));
        	 response.reset();
        	 response.setContentType("application/force-download");
        	 response.setContentLength((int)file.length());
             response.setHeader("Content-Disposition", "attachment; filename="+file.getName());  
             
             IOUtils.copy(stream, response.getOutputStream());              
             response.flushBuffer();
              
           } catch (IOException ex) {
             System.out.println(ex.getMessage()); 
           }                     
     	 
    }    
    
    @RequestMapping(value = "/files/createFolder", method = RequestMethod.POST)
   	public String createFolder(@RequestParam("name") String name, @RequestParam("parent") String parent, 
   			Principal principal) {       	
       	
       		Descriptor descriptor = new Descriptor();
       		Descriptor desParent = (Descriptor) descriptorService.findOne(Integer.parseInt(parent));
       	
       		User user = userService.findByName(principal.getName());
       		
   	    	descriptor.setName(name);
   	    	descriptor.setType(descriptorService.FOLDER);
   	    	descriptor.setUploadTime(new Date());
   	    	descriptor.setUser( user );
   	    	descriptor.setParent(desParent);
   	    	descriptor.setAccess(descriptorService.ACCESS_PRIVATE);
   	    	    	    	
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
    			
    			Descriptor desc = (Descriptor) descriptorService.findOne(folder);
    			
    			
    			if(desc.getType().equals(descriptorService.ALBUM)){
    				Descriptor file = (Descriptor) descriptorService.findOne(id); 
    				String[] tmp = file.getType().split("/");
    				if(!tmp[0].equals("image"))
    					continue;
    			}
    			
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
    
    @RequestMapping(value = "/files/createAlbum", method = RequestMethod.POST)
   	public String createAlbum(@RequestParam("name") String name, @RequestParam("parent") int parent, 
   			Principal principal) {       	
       	
       		Descriptor descriptor = new Descriptor();
       		Descriptor desParent = (Descriptor) descriptorService.findOne(parent);
       	
       		User user = userService.findByName(principal.getName());
       		
   	    	descriptor.setName(name);
   	    	descriptor.setType(descriptorService.ALBUM);
   	    	descriptor.setUploadTime(new Date());
   	    	descriptor.setUser( user );
   	    	descriptor.setParent(desParent);
   	    	descriptor.setAccess(descriptorService.ACCESS_PRIVATE);
   	    	    	    	
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
    
    @RequestMapping(value = "/albums/{id}", method = RequestMethod.GET)
    public String showAlbum(@PathVariable int id, Model model) {
         
        Descriptor album = (Descriptor) descriptorService.findOne(id);   
        model.addAttribute("name", album.getName());
        model.addAttribute("files", descriptorService.findByParent(album));
         
        return "albums"; 
    }
    
    @RequestMapping(value = "/files/getName", method = RequestMethod.POST)
    public @ResponseBody String getName(@RequestParam int id) {
         
        Descriptor file = (Descriptor) descriptorService.findOne(id);   
                
        return file.getName(); 
    }
    
    @RequestMapping(value = "/files/editName", method = RequestMethod.POST)
    public String setName(@RequestParam int id, @RequestParam String name) {
         
        Descriptor file = (Descriptor) descriptorService.findOne(id); 
        System.out.println(file.getName());
        if(!file.getType().equals(descriptorService.ALBUM) && !file.getType().equals(descriptorService.FOLDER)){
        	
        	File f = new File(file.getUrl());
        	f.renameTo(new File("../" + name));
        }
        
        file.setName(name);
        file.setUrl("../"+name);
        descriptorService.save(file);
        
        return "redirect:/files"; 
    }
   
    @RequestMapping(value = "/image/{id}", method = RequestMethod.GET, produces = "image/jpg")
    public @ResponseBody byte[] getImage(@PathVariable int id)  {
        try {
            // Retrieve image 
        	Descriptor desc = (Descriptor) descriptorService.findOne(id);
        	BufferedInputStream stream = new BufferedInputStream(new FileInputStream(new File(desc.getUrl())));	
        	
            // Prepare buffered image.
            BufferedImage img = ImageIO.read(stream);

            // Create a byte array output stream.
            ByteArrayOutputStream bao = new ByteArrayOutputStream();

            // Write to output stream
            ImageIO.write(img, "jpg", bao);

            return bao.toByteArray();
        } catch (IOException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        }
    }
      
    @RequestMapping(value = "/search", method = RequestMethod.POST)
   	public String search(@RequestParam("search") String search, @RequestParam("access") String access, 
   			@RequestParam("fileTypes") String[] fileTypes, Principal principal, Model model) {       
    	
    	String[] input = search.split(" ");
    	// create LIKE query
    	String likeQuery = "";
    	String fileTypesQuery = "";
    	String accessQuery = "";   
    	
    	if (input.length == 0)
    		likeQuery = "\'%%\'";
    	else if(input.length == 1)
    		likeQuery = "\'%" + input[0] + "%\'";
    	else{
    		
    		for(int i=0; i<input.length; i++){ 
    			likeQuery += "\'%" + input[i] + "%\' ";
    			if(i != input.length - 1)
    				likeQuery +=  "OR u.name LIKE ";
     		}    			
    	}
    	
    	if (fileTypes.length == 0)
    		fileTypesQuery = "\'%%\'";
    	else if(fileTypes.length == 1)
    		fileTypesQuery = "\'" + fileTypes[0] + "\'";
    	else{
    		
    		for(int i=0; i<fileTypes.length; i++){ 
    			fileTypesQuery += "\'" + fileTypes[i] + "\' ";
    			if(i != fileTypes.length - 1)
    				fileTypesQuery +=  "OR u.type LIKE ";
     		}    			
    	}
    	
    	if(access.equals(descriptorService.ACCESS_PUBLIC))
    		accessQuery = "u.access =\'" + access + "\'";
    	else {
    		User user = userService.findByName( principal.getName());
    		accessQuery = "u.user.id = " + user.getId();
    	}
    	
    	String query = "SELECT u FROM Descriptor u WHERE (u.name LIKE " + 
    					likeQuery + ") AND " +  accessQuery  +
    					" AND (u.type LIKE " + fileTypesQuery + " )";
    	
    	Query q =  em.createQuery(query);
    	System.out.println("LIKE QUERY -> "+ likeQuery);
    	System.out.println("fileTypes QUERY -> "+ fileTypesQuery);
    	System.out.println("QUERY -> "+ query);
    	
    	List<Descriptor> res = (List<Descriptor>) q.getResultList();
    	model.addAttribute("files", res);
    	model.addAttribute("access", access);
   	           	
   		return "search";
   	}
    
}