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

    def my_all?(test=nil)
        truth_array = []

        if (test != nil)
            self.my_each do |element|
                truth_array << element if test === element 
                break if (test === element) == false
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

    def my_any?(test=nil)
        truth_array = []

        if (test != nil)
            self.my_each do |element|
                truth_array << element if test === element
                break if (test === element) == false
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

    def my_none?(test=nil)
        truth_array = []

        if (test != nil)
            self.my_each do |element| 
                truth_array << element if test === element
                break if test === element
            end
        elsif (block_given? == false)
            self.my_each do |element| 
                truth_array << element if element
                break if element
            end
        else
            self.my_each do |element|
                truth_array << element if yield(element)
                break if yield(element)
            end
        end

        truth_array.length == 0 ? true : false
    end

    def my_count(arg=nil)
        truth_array = []

        (arg != nil) ? self.my_each { |element| truth_array << element if arg == element } :
        (block_given? == false) ? self.my_each { |element| truth_array << element }:
        self.my_each { |element| truth_array << element if yield(element) }

        truth_array.length
    end

    def my_map(&proc)
        return self.to_enum(:my_map) unless block_given?
        mapped_array = []
        self.my_each { |element| mapped_array << proc.call(element) }
        mapped_array
    end

    def my_inject(*args)
        sum = 0

        if (args[1].is_a?(Symbol) && args[0].is_a?(Integer))
            sum = args[0]
            self.my_each { |element| sum = sum.method(args[1]).call(element) }
        elsif (args[0].is_a?(Symbol))
            i = 0
            self.my_each do |element|
                (i == 0) ? sum += element : sum = sum.method(args[0]).call(element)
                i += 1
            end
        elsif (args.length == 0 && block_given?)
            i = 0
            self.my_each do |element|
                (i == 0) ? sum += element : sum = yield(sum, element) 
                i += 1
            end
        elsif (args[0].is_a?(Integer) && block_given?)
            sum = args[0]
            self.my_each { |element| sum = yield(sum, element) }
        end
        sum
    end
end
    


def multiply_els(array)
    array.my_inject { |accumulator, element| accumulator * element }
end
