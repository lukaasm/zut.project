package zut.project.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import zut.project.entity.Role;
import zut.project.entity.User;
import zut.project.repositories.RoleRepository;
import zut.project.service.DescriptorService;
import zut.project.service.UserService;

@Controller
public class UserController {

	@Autowired
	private UserService userService;

	@Autowired
	private DescriptorService descriptorService;
	
	@ModelAttribute("createUser")
	public User construct() {
		return new User();
	}

    @PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping("/users/all")
	public String users(Model model, Principal principal) {
		model.addAttribute("users", userService.findAll());
		return "users";
	}

	@RequestMapping("/register")
	public String showRegister(Model model) {
		return "user-register";
	}

	@RequestMapping("/login")
	public String login() {
		return "user-login";
	}

    @PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/account")
	public String account(Model model, Principal principal) {
		model.addAttribute("user", userService.findByName(principal.getName()));
		return "user-detail";
	}
	
    @PreAuthorize("hasRole('ROLE_USER')")
	@RequestMapping("/account/files")
	public String accountFiles(Model model, Principal principal) {
		User user = userService.findByName(principal.getName());
		model.addAttribute("files", descriptorService.findByUserAndParent(user, null));
		return "files";
	}

	@RequestMapping("/users/delete/{id}")
	public String delete(Model model, @PathVariable Integer id,
			Principal principal) {
		
		model.addAttribute("users", userService.findAll());

		userService.deleteById(id);
		return "users";
	}
	
	@RequestMapping("/users/deleteself")
	public String deleteSelf(Model model, Principal principal)
	{
		User user = userService.findByName(principal.getName());
		
		userService.deleteById(user.getId());
		return "redirect:/logout";
	}

	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String doRegister(@ModelAttribute("createUser") User user) {
		if (userService.findByName(user.getName()) != null)
			return "user-register-failed";

		userService.save(user);
		return "home";
	}

	@RequestMapping("/users/{id}")
	public String detail(Model model, @PathVariable Integer id) {
		model.addAttribute("user", userService.findOne(id));
		return "user-detail";
	}
}
