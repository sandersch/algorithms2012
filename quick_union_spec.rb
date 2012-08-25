require_relative './quick_union'

describe QuickUnion do

  describe '#inspect' do
    subject { described_class.new(10) }

    it 'has output matching the assignment spec' do
      subject.inspect.should == "0 1 2 3 4 5 6 7 8 9"
    end
  end

  describe '#root' do
    let(:p) { 0 }

    context 'a root node' do
      it 'returns the root, p' do
        subject.root(p) == p
      end
    end

    context 'a child node' do
      let(:root) { 1 }

      before do
        subject.id = [root, root]
      end

      it 'returns the root of its parent' do
        subject.root(p).should == root
      end
    end

    context "given an example tree" do
      let(:root) { 0 }
      let(:p) { 4 }

      before do
        subject.id = [0, 0, 1, 1, 2]
      end

      it 'finds the root of 4 is 0' do
        subject.root(p).should == root
      end
    end

  end

  describe '#union' do
    let(:p) { 0 }
    let(:q) { 1 }

    context 'union with two roots' do
      subject { described_class.new(2) }

      it 'changes id[p] but not id[q]' do
        subject.union(p, q)
        subject.id.should == [p, p]
      end
    end

    context 'union with already connected nodes' do
      subject do
        described_class.new(2).tap do |tree|
          tree.id = [p, p]
        end
      end

      it "doesn't change anything" do
        subject.union(p, q)
        subject.id.should == [p, p]
      end
    end

    context 'union of two child nodes' do
      let(:p) { 1 }
      let(:q) { 4 }

      context 'of equal size' do
        let(:before) { [0, 0, 0, 3, 3, 3] }
        let(:after) { [0, 0, 0, 0, 3, 3] }

        subject do
          described_class.new(6).tap do |tree|
            tree.id = before
          end
        end

        it 'changes id[root(p)] but not id[root(q)]' do
          subject.union(p, q)
          subject.id.should == after
        end
      end

      context 'when p is bigger' do
        let(:before) { { id: [0, 0, 0, 3, 3], size: [3, 0, 0, 2, 0] } }
        let(:after) { { id: [0, 0, 0, 0, 3], size: [5, 0, 0, 0, 0] } }

        subject do
          described_class.new.tap do |tree|
            tree.id = before[:id]
            tree.size = before[:size]
          end
        end

        it 'adds root(p) to root(q)' do
          subject.union(p, q)
          subject.id.should == after[:id]
          subject.size.should == after[:size]
        end
      end

      context 'when q is bigger' do
        let(:before) { { id: [0, 0, 3, 3, 3], size: [2, 0, 0, 3, 0] } }
        let(:after) { { id: [3, 0, 3, 3, 3], size: [0, 0, 0, 5, 0] } }

        subject do
          described_class.new.tap do |tree|
            tree.id = before[:id]
            tree.size = before[:size]
          end
        end

        it 'adds root(q) to root(p)' do
          subject.union(p, q)
          subject.id.should == after[:id]
          subject.size.should == after[:size]
        end
      end
    end
  end

  describe 'the assignment' do
    subject { described_class.new(10) }

    it 'can complete the assignment with seed 530752' do
      subject.union(5, 8)
      subject.id.should   == [0, 1, 2, 3, 4, 5, 6, 7, 5, 9]
      subject.size.should == [1, 1, 1, 1, 1, 2, 1, 1, 0, 1]
      subject.union(9, 3)
      subject.union(2, 0)
      subject.union(1, 7)
      subject.union(8, 1)
      subject.union(5, 4)
      subject.union(0, 6)
      subject.union(0, 9)
      subject.union(6, 7)
      subject.id.should   == [2, 5, 2, 9, 5, 2, 2,  1, 5, 2]
    end

    it 'can complete the assignment with seed 637568' do
      subject.union(8, 1)
      subject.id.should   == [0, 8, 2, 3, 4, 5, 6, 7, 8, 9]
      subject.size.should == [1, 0, 1, 1, 1, 1, 1, 1, 2, 1]

      subject.union(0, 3)
      subject.id.should   == [0, 8, 2, 0, 4, 5, 6, 7, 8, 9]
      subject.size.should == [2, 0, 1, 0, 1, 1, 1, 1, 2, 1]

      subject.union(9, 5)
      subject.id.should   == [0, 8, 2, 0, 4, 9, 6, 7, 8, 9]
      subject.size.should == [2, 0, 1, 0, 1, 0, 1, 1, 2, 2]

      subject.union(3, 2)
      subject.id.should   == [0, 8, 0, 0, 4, 9, 6, 7, 8, 9]
      subject.size.should == [3, 0, 0, 0, 1, 0, 1, 1, 2, 2]

      subject.union(0, 6)
      subject.id.should   == [0, 8, 0, 0, 4, 9, 0, 7, 8, 9]
      subject.size.should == [4, 0, 0, 0, 1, 0, 0, 1, 2, 2]

      subject.union(8, 5)
      subject.id.should   == [0, 8, 0, 0, 4, 9, 0, 7, 8, 8]
      subject.size.should == [4, 0, 0, 0, 1, 0, 0, 1, 4, 0]

      subject.union(3, 1)
      subject.id.should   == [0, 8, 0, 0, 4, 9, 0, 7, 0, 8]
      subject.size.should == [8, 0, 0, 0, 1, 0, 0, 1, 0, 0]

      subject.union(3, 4)
      subject.id.should   == [0, 8, 0, 0, 0, 9, 0, 7, 0, 8]
      subject.size.should == [9, 0, 0, 0, 0, 0, 0, 1, 0, 0]

      subject.union(5, 7)
      subject.id.should   == [ 0, 8, 0, 0, 0, 9, 0, 0, 0, 8]
      subject.size.should == [10, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    end
  end

end
