require 'spec_helper'

describe Week do
  
  before(:each) do
    @seven_days = 7 * 24 * 60 * 60
    @six_days = 6 * 24 * 60 * 60
    Date.stub!(:today).and_return(Date.parse('Jan 3, 2011'))
    @last_monday = Time.parse('Jan 3, 2011')
  end
  
  it "Should return all the weeks in the month" do
    weeks = Week.in_month(Date.parse('Mar 1, 2011'))
    
    weeks.count.should == 5
    
    weeks[0].start.should == Time.parse('Feb 28, 2011')
    weeks[1].start.should == Time.parse('Mar 7, 2011')
    weeks[2].start.should == Time.parse('Mar 14, 2011')
    weeks[3].start.should == Time.parse('Mar 21, 2011')
    weeks[4].start.should == Time.parse('Mar 28, 2011')
  end
  
  it "Should include all days int the week" do
    w = Week.current
    6.times { |i| w.include?(w.start + i).should be_true }
  end
  
  it "Should return current week" do
    w = Week.current
    w.start.should == @last_monday
    w.finish.should == w.start + @six_days
  end
  
  it "Should calculate the week starting each day" do
    (0..6).each do |days|
      w = Week.new(@last_monday + days)      
      w.start.should == @last_monday
      w.finish.should == w.start + @six_days
    end
  end

  it "Should return the previous week" do
    w = Week.current.previous
    w.start.should == @last_monday - @seven_days
  end
  
  # Checks the previous weeks are returned
  it "Should return the previous weeks" do
    previous = Week.previous(4)
    
    current = Week.current
    
    previous.each do |w|
      w.should == current
      current = current.previous
    end
  end
  
end
