module IndexHunter
  class Display
    class << self
      def query(query)
        puts "------------------------------------------------\n\n"
        puts "Please replace variables with mock data in the following query : \n\n"
        puts "if the query is fine, just press Enter \n\n"
        puts "------------------------------------------------\n\n"
        puts query
        puts "------------------------------------------------\n\n"
        ask_user_for_input(query)
      end

      def show_indexes(indexes)
        puts "Here are the indexes we suggest : \n"
        puts "------------------------------------------------\n"
        puts indexes.to_s
        puts "------------------------------------------------ \n\n"
        puts "You can change them, if you think you can do better :) \n\n"
        puts "When you are happy, just press Enter to proceed to benchmark \n\n"
        eval(ask_user_for_input(indexes.to_s))
      end

      def should_keep_index?
        valid = false
        while !valid
          puts "-----------------------------------------------------\n"
          puts "Do you want to keep the Indexes or roll them back ?\n\n"
          puts "-----------------------------------------------------\n"
          puts "Y to keep, N to rollback\n\n"
          keep_index = STDIN.gets.chomp
          valid = true if (keep_index == "Y") ||  (keep_index == "N")
        end
        keep_index == "Y"
      end

      private

      def ask_user_for_input(prefill)
        Readline.pre_input_hook = -> {
          Readline.insert_text(prefill)
          Readline.redisplay
        }
        Readline.readline("Please modify if necessary : ")
      end

    end
  end
end
