package zut.project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import zut.project.entity.Role;
import zut.project.repositories.RoleRepository;

@Service
public class RoleService {

	@Autowired
	private RoleRepository roleRepository;
	
	public Role findByName(String name) {
		
		return roleRepository.findByName(name);
	}
}
