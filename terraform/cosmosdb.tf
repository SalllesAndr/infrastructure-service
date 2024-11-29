resource "azurerm_cosmosdb_account" "db" {
  name                = "feedback-tsystems-app"
  location            = var.azure_backend_resources_region
  resource_group_name = azurerm_resource_group.production.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  automatic_failover_enabled = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.azure_backend_resources_region
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_collection" "feedback" {
  name                = "feedbacks"
  resource_group_name = azurerm_resource_group.production.name
  account_name        = azurerm_cosmosdb_account.db.name
  database_name       = azurerm_cosmosdb_mongo_database.feedback.name

  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"
  throughput          = 400

  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_cosmosdb_mongo_collection" "users" {
  name                = "users"
  resource_group_name = azurerm_resource_group.production.name
  account_name        = azurerm_cosmosdb_account.db.name
  database_name       = azurerm_cosmosdb_mongo_database.feedback.name

  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"
  throughput          = 400

  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_cosmosdb_mongo_database" "feedback" {
  name                = "feedback-cosmos-mongo-db"
  resource_group_name = azurerm_resource_group.production.name
  account_name        = azurerm_cosmosdb_account.db.name
}
