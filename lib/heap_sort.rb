require_relative "heap"
require "byebug"
class Array
  def heap_sort!
    (self.length).times do |i|
      BinaryMinHeap.heapify_up(self, i, i+1)
    end
    (self.length).times do |i|
      # debugger
      self[0], self[self.length-i-1] = self[self.length-i-1], self[0]
      BinaryMinHeap.heapify_down(self, 0, self.length-i-1)
    end
    self.reverse!
  end
end
