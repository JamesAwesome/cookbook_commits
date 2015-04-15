require 'thor'
require 'colorize'
require 'cookbook_commits'

module CookbookCommits
  class CLI < Thor
    class_option :org, desc: 'org to list cookbook commits for', required: true

    desc :since, 'DATE print cookbook commit logs since DATE'
    option :redact_author, default: true
    def since(date)
      commit_finder.all(options[:org], since: date) do |cookbook, commits|
        print_cookbook(cookbook)
        commits.each do |commit|
          author = options[:redact_author] ? 'REDACTED' : commit[:author][:login]
          print_commit(author, commit)
        end
      end
    end

    desc :for, 'AUTHOR print cookbook commit logs for AUTHOR'
    option :since, desc: 'Print only commits since DATE'
    def for(author)
      args = { author: author }
      args[:since] = options[:since] if options[:since]
      commit_finder.all(options[:org], args) do |cookbook, commits|
        print_cookbook(cookbook)
        commits.each do |commit|
          print_commit(commit[:author][:login], commit)
        end
      end
    end

    desc :version, 'Prints version.'
    def version
      puts CookbookCommits::VERSION
    end

    default_task :since

    private

    def commit_finder
      @commit_finder ||= CommitFinder.new
    end

    def print_cookbook(name)
      puts name.colorize(:yellow)
      puts '=' * name.length
      puts
    end

    def print_commit(author, commit)
      puts author.colorize(:green)
      puts '-' * author.length
      puts commit[:commit][:message].colorize(:white)
      puts
    end
  end
end
