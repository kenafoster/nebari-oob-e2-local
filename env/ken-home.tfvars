# ------------------------------------------------------
# Configuration Settings for Ken's AWS Account and Local
# ------------------------------------------------------

# Project settings
account_id = "914373967732"
region     = "us-east-1"

# User's local settings
my_local_ip = "75.130.176.230" # temp beach house.  "100.36.36.218"
my_key_pair = "nebari-sandbox"
my_route_53_domain   = "kflabs.click"

# Need larger size for user servers to actually deploy
nebari_ec2_size   = "t3.2xlarge"

# Git settings - no multiline syntax, variable should be list of URLs separated by spaces not newline
git_repos = "https://github.com/nebari-dev/nebari.git"