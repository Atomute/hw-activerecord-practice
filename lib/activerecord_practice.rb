require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    h = Customer.where(first:"Candice")
  end

  def self.with_valid_email
    emails = Customer.where("email like '%@%'")
  end

  def self.with_dot_org_email
    emails = Customer.where("email like '%.org%'")
  end

  def self.with_invalid_email
    emails = Customer.where("email not like '%@%'")
  end

  def self.with_blank_email
    emails = Customer.where("email is NULL")
  end

  def self.born_before_1980
    result = Customer.where("birthdate < '1980-01-01'")
  end

  def self.with_valid_email_and_born_before_1980
    result = Customer.where("birthdate < '1980-01-01' and email like '%@%'")
  end

  def self.last_names_starting_with_b
    result = Customer.where("last like 'b%'")
    result.order("birthdate")
  end

  def self.twenty_youngest
    result = Customer.order("birthdate desc")
    result.limit(20)
  end

  def self.update_gussie_murray_birthdate
    user = Customer.find_by(first: 'Gussie')
    user.birthdate = "2004-02-08"
    user.save
  end

  def self.change_all_invalid_emails_to_blank
    invalid = Customer.where("email not like '%@%'")
    invalid.update_all "email = NULL"
  end

  def self.delete_meggie_herman
    meggie = Customer.find_by(first:"Meggie")
    meggie.destroy
  end

  def self.delete_everyone_born_before_1978
    boomer = Customer.where("birthdate < '1978-01-01'")
    boomer.destroy_all
  end

  # etc. - see README.md for more details
end
