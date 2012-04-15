guard 'bdd' do
  watch(%r{lib/(.*)\.rb$}) { |m| "spec/unit/#{File.basename(m[1])}_spec.rb" }
  watch(%r{spec/.*_spec\.rb$})
end


