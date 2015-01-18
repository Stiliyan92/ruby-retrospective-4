module RBFS
    def to_boolean(str)
      str == 'true'
    end

  class RBFS::File
    attr_accessor :data

    def File.parse(string_data)
      type_and_data = string_data.partition(":")
      file_type = File.get_type(type_and_data[0])
      file_content = File.convert_data( type_and_data[2], file_type)
      parsed_file = RBFS::File.new(file_content)
    end
    def File.get_type(string_data)
      case string_data
        when "numbers" then :numbers
        when "string" then :string
        when "boolean" then :boolean
        when "symbol" then :symbol
        when "nil" then :nil
      end
    end

    def File.convert_data(string_data, type)
      case type
        when :numbers then string_data.to_f
        when :string then string_data
        when :boolean then to_boolean(string_data)
        when :symbol then string_data.to_sym
        else
          nil
      end
    end

    def initialize( data_to_store_in_file = '')
      @data = data_to_store_in_file
    end

    def data_type
      case
        when @data.class == Fixnum, @data.class == Float then :number
        when @data.class == String then :string
        when @data.class == Symbol then :symbol
        when @data.class == TrueClass, @data.class == FalseClass then :boolean
        else
          :nil
      end
    end

    def serialize
      self.data_type.to_s + ":" + @data.to_s
    end
  end

  class RBFS::Directory
    attr_reader :files
    attr_reader :directories
    def initialize
      @directories = {}
      @files = {}
    end

    def add_file(name, file)
      files[name] = file
    end

    def add_directory(name, directory = RBFS::Directory.new)
      directories[name] = directory
    end

    def [](name)
      if directories[name] != nil
        directories[name]
      else
        files[name]
      end
    end
    def serialize()
      serialized_files = serialized_hash(@files) + serialized_hash(@directories)
    end
    def serialized_hash(hash)
      serialized_files = hash.size.to_s + ":"
      hash.each do |key, value|
        srlzd_elem = value.serialize
        file_size = srlzd_elem.size.to_s
        serialized_files = serialized_files + key + ":" + file_size + ":" + srlzd_elem
      end
      serialized_files
    end

    def Directory.parse(string_data)
      dir = Directory.new
      partitioned = string_data.partition(":")
      count_of_files, counter, serialized_data = partitioned[0].to_i, 0, partitioned[2]
      while(counter < count_of_files )
        serialized_data = dir.parse_file(serialized_data)
        counter = counter + 1
      end
      partitioned = serialized_data.partition(":")
      count_of_dirs, counter, serialized_data = partitioned[0].to_i, 0, partitioned[2]
      while(counter < count_of_dirs)
        serialized_data = dir.parse_directory(serialized_data)
        counter = counter + 1
      end
      dir
    end
    def parse_directory(dir_data)
      dir_name = dir_data.partition(":")
      serialized_dir = dir_name[2].partition(":")
      @directories[dir_name[0]] = RBFS::Directory.parse(serialized_dir[2].slice!(0, serialized_dir[0].to_i))
      serialized_dir[20]
    end
    def parse_file(file_data)
      file_name = file_data.partition(":")
      serialized_file = file_name[2].partition(":")
      @files[file_name[0]] = RBFS::File.parse(serialized_file[2].slice!(0, serialized_file[0].to_i))
      serialized_file[2]
    end
  end
end

directory = RBFS::Directory.new 
directory.add_file 'README', RBFS::File.new('Hello world!')
directory.add_file 'spec.rb', RBFS::File.new('describe RBFS')
directory.add_directory 'rbfs'

parsed_directory = RBFS::Directory.parse("2:README:19:string:Hello world!spec.rb:20:string:describe RBFS1:rbfs:4:0:0:")
p parsed_directory.files.size
p "dasdasda"
p parsed_directory.files
p parsed_directory.directories
p parsed_directory['README'].data
p parsed_directory['spec.rb'].data
p  parsed_directory['rbfs']