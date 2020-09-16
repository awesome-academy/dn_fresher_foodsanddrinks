namespace :gemfile do
  desc "Edit gem file..."
  task :edit do
    text = File.read "Gemfile"

    # Xoa comment
    new_contents = text.gsub(/^\s*#.*/, "")
    # Chuyen nhay don => nhay kep
    new_contents.gsub!(/'/, '"')

    puts new_contents
    File.open("Gemfile", "w"){|file| file.puts new_contents}
  end
end
