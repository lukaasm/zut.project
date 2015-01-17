package zut.project.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import zut.project.entity.Descriptor;
import zut.project.entity.User;
import zut.project.repositories.DescriptorRepository;

@Service
public class DescriptorService {

	public final String FOLDER = "Folder";
	public final String ALBUM = "Album";
	
	public final String ACCESS_PUBLIC = "a_public";
	public final String ACCESS_PRIVATE = "a_private";
	public final String ACCESS_LINK = "a_link";
	
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

	public Object findByParentAndAccess(Descriptor parent, String access) {
		return descriptorRepository.findByParentAndAccess(parent,access);
	}

	public void updateParent(int folderId, int elementId){
		descriptorRepository.setNewParent(folderId, elementId);

	}	
}
