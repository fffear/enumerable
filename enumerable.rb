module Enumerable
    def my_each
        for element in self
            yield(element)
        end
        self
    end

    def my_each_with_index
        i = 0
        loop do
            yield(self[i], i)
            i += 1
            break if i > self.length - 1
        end
        self
    end
    
    def my_select
        select_array = []
        self.each { |element| select_array << element if yield(element) }
        select_array
    end

    def my_all
        truth_array = []

        self.each do |element|
            truth_array << element if yield(element)
            break if yield(element) == false
        end
        
        (self.length > truth_array.length) ? false : true
    end

end