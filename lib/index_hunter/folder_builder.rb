# creates folders
module IndexHunter
  class FolderBuilder
    attr_accessor :folder_name
    def initialize(index_names)
      @folder_name = build_folder_name(index_names)
    end

    def create
      path = Rails.root.join('lib', 'tasks', 'index_reports', @folder_name).to_s
      FileUtils::mkdir_p(path)
    end

    private

    def build_folder_name(index_names)
      folder_name = ""
      index_names.each_with_index do |index_name, index|
        if index == index_names.length - 1
          folder_name += "#{index_name}"
        else
          folder_name += "#{index_name}_AND_"
        end
      end
      folder_name
    end
  end
end
