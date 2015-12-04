module UsersHelper
	def profile_pic_tag image, class1="img-thumbnail img-md"
		image_url = current_user.profile_picture.file.url || "amura.png"
    image_tag(image_url, class: class1)
	end
end
