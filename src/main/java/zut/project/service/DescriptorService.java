package zut.project.service;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import zut.project.entity.Descriptor;
import zut.project.repositories.DescriptorRepository;

@Service
public class DescriptorService {

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
}
