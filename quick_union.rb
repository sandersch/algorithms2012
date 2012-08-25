class QuickUnion
  def initialize(size=3)
    @id   = Array.new(size) { |i| i }
    @size = Array.new(size) { 1 }
  end
  attr_accessor :id, :size

  def union(p, q)
    root_p = root(p)
    root_q = root(q)

    if root_p == root_q
      root_p
    elsif self.size[root_p] >= self.size[root_q]
      self.id[root_q] = root_p
      self.size[root_p] += self.size[root_q]
      self.size[root_q] = 0
    else
      self.id[root_p] = root_q
      self.size[root_q] += self.size[root_p]
      self.size[root_p] = 0
    end
  end

  def root(p)
    if self.id[p] == p
      p
    else
      self.root(self.id[p])
    end 
  end

  def inspect
    @id.join ' '
  end
end
