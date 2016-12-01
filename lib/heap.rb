require 'byebug'
class BinaryMinHeap
  def initialize(&prc)
    @store = []
    @prc = prc;
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[@store.length-1] = @store[@store.length-1], @store[0]
    result = @store.pop();
    @store = BinaryMinHeap.heapify_down(@store, 0)
    result
  end

  def peek
  end

  def push(val)
    @store.push(val)
    @store = BinaryMinHeap.heapify_up(@store, @store.length-1)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    ind1 = (parent_index*2+1)
    ind2 = (parent_index*2+2)
    if ind2 < len
      return [ind1, ind2]
    elsif ind1 < len
      return [ind1]
    else
      nil
    end
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    ind = (child_index-1)/2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    child_indices = BinaryMinHeap.child_indices(len, parent_idx);
    return array if child_indices == nil

    if child_indices[1]
      children_verdict = array[child_indices[0]] <=> array[child_indices[1]]
      children_verdict = prc.call(array[child_indices[0]], array[child_indices[1]]) if block_given?
      if children_verdict <= 0
        smaller_child_indx = child_indices[0]
      else
        smaller_child_indx = child_indices[1]
      end
    else
      smaller_child_indx = child_indices[0]
    end


    smaller_child = array[smaller_child_indx]
    parent = array[parent_idx]

    if block_given?
      verdict = prc.call(parent, smaller_child)
    else
      verdict = parent <=> smaller_child
    end

    if verdict > 0
      array[parent_idx], array[smaller_child_indx] = array[smaller_child_indx], array[parent_idx]
    end
    BinaryMinHeap.heapify_down(array, smaller_child_indx, len, &prc)

  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    return array if child_idx == 0
    parent_idx = BinaryMinHeap.parent_index(child_idx)
    parent = array[parent_idx]
    child = array[child_idx]
    if block_given?
      verdict = prc.call(parent, child)
    else
      verdict = parent <=> child
    end

    if verdict > 0
      array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
    end
    BinaryMinHeap.heapify_up(array, parent_idx, len, &prc)
  end

end
