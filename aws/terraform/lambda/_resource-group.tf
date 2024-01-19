
resource "aws_resourcegroups_group" "project_rsg" {
  name = local.prefix
  tags = {
    Name = local.prefix
  }
  resource_query {
    type = "TAG_FILTERS_1_0"
    query = jsonencode({
      ResourceTypeFilters : [
        "AWS::AllSupported"
      ]
      TagFilters : [
        {
          "Key" : "Project",
          "Values" : [local.project_name]
        },
        {
          "Key" : "Env",
          "Values" : [local.env]
        }
      ]
    })
  }
}