guard :rspec, cmd: 'rspec -fp --profile --fail-fast --order defined',
              all_on_start: true, all_after_pass: true,
              run_all: { cmd: 'rspec -fp --fail-fast' } do
  watch(%r{^spec/.+_spec\.rb$}) { |m| m[0] }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/factories/(.+)\.rb$})
  watch('spec/spec_helper.rb') { 'spec' }
end
