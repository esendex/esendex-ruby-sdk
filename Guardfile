guard 'rspec', cli: '--color --format nested' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/esendex/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('lib/esendex.rb') { "spec" }
end
