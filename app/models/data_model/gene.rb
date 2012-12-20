module DataModel
  class Gene < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    include Genome::Extensions::HasCacheableQuery
    has_and_belongs_to_many :gene_claims

    cache_query :all_gene_names, :all_gene_names

    def self.for_search
      eager_load{[gene_claims, gene_claims.interaction_claims, gene_claims.interaction_claims.drug_claim, gene_claims.interaction_claims.drug_claim.drug_claim_aliases, gene_claims.interaction_claims.drug_claim.drug_claim_attributes, gene_claims.interaction_claims.source, gene_claims.interaction_claims.interaction_claim_attributes ]}
    end

    def self.for_gene_categories
      eager_load{[gene_claims, gene_claims.gene_claim_aliases]}
    end

    def self.all_gene_names
      pluck(:name).sort
    end

    def potentially_druggable_gene_claims
      #return Go or other potentially druggable categories
      source_ids = DataModel::Source.potentially_druggable_sources.map{|s| s.id}
      gene_claims.select{|g| source_ids.include?(g.source.id)}
    end


  end
end