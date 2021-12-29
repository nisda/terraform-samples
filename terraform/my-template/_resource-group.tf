
resource "aws_resourcegroups_group" "project_rsg" {
  name = local.name.project_rsg
  tags = {
    Name = local.name.project_rsg
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
          "Values" : [var.project_name]
        },
        {
          "Key" : "EnvironmentName",
          "Values" : [var.environment_name]
        }
      ]
    })
  }
}