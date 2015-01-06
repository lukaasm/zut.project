package zut.project.controller;
 
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import zut.project.service.DescriptorService;
 
/**
 * Handles requests for the application upload page.
 */
@Controller
public class FileController {
     
	@Autowired
	private DescriptorService descriptorService;
	
    private static final Logger logger = LoggerFactory.getLogger(FileController.class);
     
    @RequestMapping(value = "/upload", method = RequestMethod.GET)
    public String upload(Model model) {
        logger.info("Upload page !");
         
        return "upload";
    }
    
    @RequestMapping(value = "/files", method = RequestMethod.GET)
    public String files(Model model) {
        logger.info("Files page !");
        
        model.addAttribute("files", descriptorService.findAll());
         
        return "files";
    }
     
}