class DropboxProxy
  def get_file(*)
    if File.file?(self.file_path)
      File.read(self.file_path)
    else
      ''
    end
  end

  def put_file(_, contents, *)
    File.write(self.file_path, contents)
  end

  def file_path
    ENV['SUGAR_FILE'] || '/tmp/sugar-flow.txt'
  end
  protected :file_path
end
