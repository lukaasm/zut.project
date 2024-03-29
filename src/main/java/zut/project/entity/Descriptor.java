package zut.project.entity;

import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name="descriptor")
public class Descriptor {
	
	@Id
	@GeneratedValue
	private Integer id;
	
	private String url;
	private String name;
	private Date uploadTime;
	
	private String type;
	private String access;
	
	@OneToMany(mappedBy="parent", cascade={CascadeType.PERSIST, CascadeType.REMOVE})
	private List<Descriptor> descriptors;
	
	@ManyToOne
	private Descriptor parent;
	
	@ManyToOne
	@JoinColumn(name="user_id")
	private User user;
	
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getUploadTime() {
		return uploadTime;
	}
	public void setUploadTime(Date uploadTime) {
		this.uploadTime = uploadTime;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public List<Descriptor> getDescriptors() {
		return descriptors;
	}
	public void setDescriptors(List<Descriptor> descriptors) {
		this.descriptors = descriptors;
	}
	public Descriptor getParent() {
		return parent;
	}
	public void setParent(Descriptor parent) {
		this.parent = parent;
	}

	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getAccess() {
		return access;
	}
	public void setAccess(String access) {
		this.access = access;
	}
}
