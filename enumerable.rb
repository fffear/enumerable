module Enumerable
    def my_each
        return self.to_enum unless block_given?
        for element in self
            yield(element)
        end
        self
    end



    def my_each_with_index
        return self.to_enum(:my_each_with_index) unless block_given?
        i = 0
        loop do
            yield(self[i], i)
            i += 1
            break if i > self.length - 1
        end
        self
    end

    def my_select
        return self.to_enum(:my_select) unless block_given?
        select_array = []
        self.my_each { |element| select_array << element if yield(element) }
        select_array
    end

    def my_all?(regexp=nil)
        truth_array = []

        if (regexp != nil)
            self.my_each do |element|
                truth_array << element if regexp === element 
                break if (regexp === element) == false
            end
        elsif (block_given? == false)
            self.my_each do |element|
                truth_array << element if element
                break if element == false
            end
        else
            self.my_each do |element|
                truth_array << element if yield(element)
                break if yield(element) == false
            end
        end
        (self.length > truth_array.length) ? false : true
    end

    def my_any?(regexp=nil)
        truth_array = []

        if (regexp != nil)
            self.my_each do |element|
                truth_array << element if regexp === element
                break if (regexp === element) == false
            end
        elsif block_given? == false
            self.my_each do |element|
                truth_array << element if element
                break if element
            end
        else
            self.my_each do |element| 
                if yield(element)
                    truth_array << element
                    break
                end
            end
        end
        (truth_array.length == 0) ? false : true
    end

    def my_none? #work
        return self.to_enum(:my_none?) unless block_given?
        truth_array = []
        self.my_each { |element| truth_array << element if yield(element) }
        truth_array.length == 0 ? true : false
    end

    def my_count #work
        truth_array = []
        self.my_each { |element| truth_array << element if yield(element) }
        truth_array.length
    end

    def my_map(&proc)
        return self.to_enum(:my_map) unless block_given?
        mapped_array = []
        self.my_each { |element| mapped_array << proc.call(element) }
        mapped_array
    end

    def my_inject(sum=nil)
        sum = self.shift if (sum == nil)
        self.my_each { |element| sum = yield(sum, element) }
        sum
    end


end

def multiply_els(array)
    array.my_inject { |accumulator, element| accumulator * element }
end
