deployments = {
  app1 = {
    name     = "app1"
    replicas = 2
    image    = "nginx:1.14.2"
    port     = 80
    env      = {
      ENV_VAR_1 = "value1"
      ENV_VAR_2 = "value2"
    }
  }
  
  app2 = {
    name     = "app2"
    replicas = 3
    image    = "redis:5.0.5"
    port     = 6379
    env      = {
      ENV_VAR_1 = "value3"
      ENV_VAR_2 = "value4"
    }
  }
}
