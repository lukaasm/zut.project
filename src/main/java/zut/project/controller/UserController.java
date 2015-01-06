package zut.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import zut.project.entity.User;
import zut.project.service.UserService;

@Controller
public class UserController {

	@Autowired
	private UserService userService;

	@ModelAttribute("createUser")
	public User construct() {
		return new User();
	}

	@RequestMapping("/users")
	public String users(Model model) {
		model.addAttribute("users", userService.findAll());
		return "users";
	}

	@RequestMapping("/register")
	public String showRegister(Model model) {
		return "user-register";
	}
	
	@RequestMapping("/login")
	public String login()
	{
		return "user-login";
	}
	
	@RequestMapping(value="/register", method=RequestMethod.POST)
	public String doRegister(@ModelAttribute("createUser") User user) {
		if ( userService.findByName( user.getName() ) != null )
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
