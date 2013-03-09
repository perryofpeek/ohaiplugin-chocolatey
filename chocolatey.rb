#
# Author:: Owain Perry (<perry@peek.org.uk>)
# Copyright:: Copyright (c) 2013 PerryOfPeek
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides 'chocolatey/packages'

chocolatey Mash.new unless chocolatey
chocolatey[:packages] = Mash.new unless chocolatey[:packages]

cverCmd = "cver"

def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable? exe
    }
  end
  return nil
end

def chocolateyIsInThePath(cmd)
	return (which "#{cmd}") != nil
end 

if ( chocolateyIsInThePath cverCmd )	
	IO.popen("#{cverCmd} all -localonly").each do |line|    
	  line = line.chomp
	  if(line.include?('name') || line.include?('----') || line.length == 0)
	  else
	    lines = line.split     
	    chocolatey[:packages][lines[0]] = lines[1]
	  end
	end
end
