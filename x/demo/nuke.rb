# clear the universe
::Spaces::Space.universes.path.join('universe').tap do |path|
  path.rmtree if path.exist?
end

# clear Docker (except for debian image; it's slow to download)
::Docker::Container.all(all: true).each do |container|
  container.delete(:force => true)
end
::Docker::Image.all.each do |image|
  next if image.info['RepoTags'].include?("debian:latest")
  image.remove(:force => true)
end