module Helpers
  module General

    module_function

    def shuffle(array)
      counter = array.length - 1
      while counter > 0
          random_index = rand(counter)
          array[counter], array[random_index] = array[random_index], array[counter]
          counter -= 1
      end
      array
    end
  end
end
