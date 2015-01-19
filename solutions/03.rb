module RBFS

  class Parser
    def initialize(string_data)
      @string_data = string_data
    end

    def parse_list
      objects_count, @string_data = @string_data.split(':', 2)
      objects_count.to_i.times do
        name, length, rest = @string_data.split(':', 3)
        yield name, rest[0...length.to_i]
        @string_data = rest[length.to_i..-1]
      end
    end
  end

  class File
    attr_accessor :data

    def File.parse(string_data)
      file_type, file_data = string_data.split(':', 2)
      data = case file_type
               when 'number'  then File.to_number file_data
               when 'string'  then file_data
               when 'symbol'  then file_data.to_sym
               when 'boolean' then file_data == 'true'
             end
      File.new data
    end

    def data_type
      case @data
        when String                then :string
        when Symbol                then :symbol
        when Fixnum, Float         then :number
        when TrueClass, FalseClass then :boolean
        when NilClass              then :nil
      end
    end

    def initialize( data_to_store_in_file = nil)
      @data = data_to_store_in_file
    end

    def serialize
      "#{data_type}:#{data}"
    end

    private

    def self.to_number(string)
      if string.include? '.'
        string.to_f
      else
        string.to_i
      end
    end

  end

  class Directory

    attr_reader :files
    attr_reader :directories

    def initialize(files = {}, directories = {})
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
      directories[name] || files[name]
    end

    def serialize()
      serialized_files = serialized_hash(@files)
      serialized_directories = serialized_hash(@directories)
      serialized = "#{@files.size}:#{serialized_files.join''}"
      serialized + "#{@directories.size}:#{serialized_directories.join''}"
    end

    def serialized_hash(files)
      files.map {|n, d| "#{n}:#{d.serialize.size}:#{d.serialize}"}
    end

    def self.parse(string_data)
      directory = Directory.new
      parser = Parser.new(string_data)
      parser.parse_list do |name, data|
        directory.add_file(name, File.parse(data))
      end
      parser.parse_list do |name, data|
        directory.add_directory(name, Directory.parse(data))
      end
      directory
    end
  end
end