package zut.project.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import zut.project.entity.Descriptor;
import zut.project.entity.Role;
import zut.project.entity.User;
import zut.project.repositories.DescriptorRepository;
import zut.project.repositories.RoleRepository;
import zut.project.repositories.UserRepository;

@Transactional
@Service
public class InitDBService {

	@Autowired
	private RoleRepository roleRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private DescriptorRepository descriptorRepository;
	
	@PostConstruct
	public void Init()
	{
		Role roleUser = new Role();
		roleUser.setName("ROLE_USER");
		
		roleRepository.save(roleUser);
		
		Role roleAdmin = new Role();
		roleAdmin.setName("ROLE_ADMIN");
		
		roleRepository.save(roleAdmin);
		
		User userAdmin = new User();
		userAdmin.setName("admin");
		
		List<Role> roles = new ArrayList<Role>();
		roles.add(roleUser);
		roles.add(roleAdmin);
		
		userAdmin.setRoles(roles);
		
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		
		userAdmin.setPassword(encoder.encode("admin"));

		userRepository.save( userAdmin );
		
		/*Descriptor file1 = new Descriptor();
		file1.setName("DUMMY FILE1");
		file1.setUser( userAdmin );
		
		descriptorRepository.save(file1);

		Descriptor file2 = new Descriptor();
		file2.setName("DUMMY FILE1");
		file2.setUser( userAdmin );
		
		descriptorRepository.save(file2);*/
	}
}
