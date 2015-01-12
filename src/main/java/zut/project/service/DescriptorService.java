package zut.project.service;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import zut.project.entity.Descriptor;
import zut.project.entity.User;
import zut.project.repositories.DescriptorRepository;

@Service
public class DescriptorService {

	public final String FOLDER = "Folder";
	
	@Autowired
	private DescriptorRepository descriptorRepository;
	
	public List<Descriptor> findAll()
	{
		return descriptorRepository.findAll();
	}

	public Object findOne(Integer id) {
		
		return descriptorRepository.findOne(id);
	}
	
	public void save(Descriptor descriptor){
		descriptorRepository.save(descriptor);
	}	
	
	public Descriptor findByName(String name) {
		return descriptorRepository.findByName( name );
	}
	
	public List<Descriptor> findByParent(Descriptor parent){
		return descriptorRepository.findByParent(parent);
	}
	
	public void deleteById(int id){
		descriptorRepository.delete(id);
	}

	public List<Descriptor> findByUserAndParent(User user, Descriptor parent) {
		return descriptorRepository.findByUserAndParent(user,parent);
	}
}
