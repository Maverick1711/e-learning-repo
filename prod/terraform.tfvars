region                  = "eu-west-2"
vpc-cidr-block          = "10.0.0.0/16"
pub-sub-1-cidr-block    = "10.0.1.0/24"
pub-sub-2-cidr-block    = "10.0.2.0/24"
priv-sub-1-cidr-block   = "10.0.3.0/24"
priv-sub-2-cidr-block   = "10.0.4.0/24"
app_count               = 2
fargate_cpu             = 512
fargate_memory          = 1024
domain_name             = "e-learning.click"
db_user                 = "test_user"  #store as an environmental variable. Do not expose
db_password             = "admin1234"  #store as an environmental variable. Do not expose
