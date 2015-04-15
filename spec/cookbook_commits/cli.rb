require 'spec_helper'

RepoDouble = Struct.new(:full_name)

describe CookbookCommits::CommitFinder do
  let(:client) { instance_double(Octokit::Client) }
  let(:cookbooks) do
    [
      CookbookCommits::CommitFinder::Cookbook.new('shopkeep/cookbook-foo', %w{ bar baz }),
      CookbookCommits::CommitFinder::Cookbook.new('shopkeep/cookbook-one', %w{ two three })
    ]
  end
  let(:cookbook_repos) do
    [
      RepoDouble.new('shopkeep/cookbook-foo'),
      RepoDouble.new('shopkeep/cookbook-one'),
      RepoDouble.new('shopkeep/cookbook-moe')
    ]
  end
  subject(:finder) { CookbookCommits::CommitFinder.new }

  before do
    allow_any_instance_of(CookbookCommits::CommitFinder).to receive(:cookbooks).and_return(cookbook_repos)
    allow_any_instance_of(CookbookCommits::CommitFinder).to receive(:client).and_return(client)
  end

  describe '#all_cookbooks' do
    context 'With no arguments' do
      it 'returns all cookbooks with all commits' do
        allow(client).to receive(:commits).with('shopkeep/cookbook-foo', {}).and_return(%w{ bar baz })
        allow(client).to receive(:commits).with('shopkeep/cookbook-one', {}).and_return(%w{ two three })
        allow(client).to receive(:commits).with('shopkeep/cookbook-moe', {}).and_raise(Octokit::Conflict)
        expect(finder.all_cookbooks).to eq(cookbooks)
        expect(client.commits('shopkeep/cookbook-foo', {})).to eq(%w{ bar baz })
        expect(client.commits('shopkeep/cookbook-one', {})).to eq(%w{ two three })
        expect(client).to receive(:commits).with('shopkeep/cookbook-moe', {})
      end
    end

    context 'With arguments' do
      it 'returns cookbooks with commits filtered by arguments' do
        allow(client).to receive(:commits).with('shopkeep/cookbook-foo', author: 'foo').and_return(%w{ bar baz })
        allow(client).to receive(:commits).with('shopkeep/cookbook-one', author: 'foo').and_return(%w{ two three })
        allow(client).to receive(:commits).with('shopkeep/cookbook-moe', author: 'foo').and_raise(Octokit::Conflict)
        expect(finder.all_cookbooks(author: 'foo')).to eq(cookbooks)
        expect(client.commits('shopkeep/cookbook-foo', author: 'foo')).to eq(%w{ bar baz })
        expect(client.commits('shopkeep/cookbook-one', author: 'foo')).to eq(%w{ two three })
        expect(client).to receive(:commits).with('shopkeep/cookbook-moe', author: 'foo')
      end
    end
  end
end
