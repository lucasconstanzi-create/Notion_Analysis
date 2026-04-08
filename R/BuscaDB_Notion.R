install.packages("httr2")
library(httr2)

token <- Sys.getenv("NOTION_TOKEN")

resposta <- request("https://api.notion.com/v1/search") |>
  req_headers(
    Authorization = paste("Bearer", token),
    "Notion-Version" = "2022-06-28",
    "Content-Type" = "application/json"
  ) |>
  req_body_raw('{"filter": {"value": "database", "property": "object"}}') |>
  req_perform()

dados <- resp_body_json(resposta)

str(dados, max.level = 3)