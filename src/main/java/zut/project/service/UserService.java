package zut.project.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import zut.project.entity.Role;
import zut.project.entity.User;
import zut.project.repositories.RoleRepository;
import zut.project.repositories.UserRepository;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private RoleRepository roleRepository;
	
	public List<User> findAll()
	{
		return userRepository.findAll();
	}

	public Object findOne(Integer id) {
		
		return userRepository.findOne(id);
	}

	public void save(User user) {
		
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		user.setPassword(encoder.encode(user.getPassword()));

		List<Role> roles = new ArrayList<Role>();
		roles.add(roleRepository.findByName("ROLE_USER"));
		user.setRoles(roles);
		
		userRepository.save(user);
	}

	public Object findByName(String name) {
		return userRepository.findByName( name );
	}
}
