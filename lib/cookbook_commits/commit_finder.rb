require 'octokit'

module CookbookCommits
  class CommitFinder

    def all(org, args)
      cookbooks_for(org) do |cookbook|
        yield cookbook.name, commits_for(cookbook, args)
      end
    end

    private

    def commits_for(cookbook, args)
      client.commits(cookbook.full_name, args)
    rescue Octokit::Conflict
      []
    end

    def cookbooks_for(org)
      client.org_repos(org).select do |repo|
        yield repo if repo.name.start_with?('cookbook')
      end
    end

    def client
      @client ||= Octokit::Client.new(netrc: true).tap do |c|
        c.auto_paginate = true
      end
    end
  end
end
