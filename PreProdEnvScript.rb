require 'fileutils'
require 'yaml'
yml_file = YAML.load_file('config.yml')
count=0
result=File.exist?("TEST-PreProdEnvTestCases.txt")
if result==true
        file_handler = File.open("TEST-PreProdEnvTestCases.txt")
        for line in file_handler do
                count=count+1
                if count==2
                        temp = line.split(" ")
                        total_tests = temp[2].chop
                        failed_tests = temp[4].chop
                        success_count=total_tests.to_i - failed_tests.to_i
                end
        end
else
        raise "Build Failed"
end
puts total_tests
puts failed_tests
FileUtils.rm_rf("TEST-PreProdEnvTestCases.txt")
if failed_tests == 0
        puts "Code will Deploy to Prod Environment"
else
        puts (success_count.to_f/total_tests.to_f)*100
        if ((success_count.to_f/total_tests.to_f)*100).to_i >= (yml_file["ProdEnv"]["percentage"])
                puts "Code will Deploy to Prod Environment"
        else
                puts "Code will not Deploy to Prod Environment"
                abort("pollo")
        end
end
