guard 'cucumber' do
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch( %r{^features/.+\.feature$} )
  watch( %r{^features/support/.+$} ) { 'features' }
  watch( %r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[ File.join("**/#{m[1]}.feature") ].first || 'features'
  end
end
