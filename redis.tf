resource "aws_elasticache_cluster" "gatmauel" {
  cluster_id = "cluster-gatmauel"
  engine = "redis"
  node_type = "cache.t2.micro"
  num_cache_nodes = 1
  engine_version = "6.x"
  port = 6379

  maintenance_window = "mon:20:00-mon:21:00"
  snapshot_window = "17:00-18:00"
  snapshot_retention_limit = 1

  security_group_ids = [aws_security_group.allow_redis.id]
}