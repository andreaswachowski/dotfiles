# vi mode is unimplemented in rb-readline,
# see https://github.com/ConnorAtherton/rb-readline/issues/136
require 'rb-readline'
# require 'pry-stack_explorer'
# require 'readline'

# if defined?(RbReadline)
#   def RbReadline.rl_reverse_search_history(sign, key)
#     rl_insert_text  `cat ~/.pry_history | fzf --tac |  tr '\n' ' '`
#   end
# end

# if defined?(PryByebug)
#   Pry.commands.alias_command 'c', 'continue'
#   Pry.commands.alias_command 's', 'step'
#   Pry.commands.alias_command 'n', 'next'
#   Pry.commands.alias_command 'f', 'finish'
# end

# if defined?(PryRails::RAILS_PROMPT)
#   Pry.config.prompt = PryRails::RAILS_PROMPT
# end
