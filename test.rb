numbers = {dog: 1 ,cat: 2,monkey: 4,parrot: 2}
p numbers.select{|animal, number| number.even?}