library(httr2)

token <- Sys.getenv("NOTION_TOKEN")
database_id <- Sys.getenv("NOTION_DATABASE_ID")

resposta <- request("https://api.notion.com/v1/databases/") |>
  req_url_path_append(database_id, "query") |>
  req_headers(
    Authorization = paste("Bearer", token),
    "Notion-Version" = "2022-06-28",
    "Content-Type" = "application/json"
  ) |>
  req_body_raw('{}') |>
  req_error(is_error = function(resp) FALSE) |>
  req_perform()

cat("Status:", resp_status(resposta), "\n")
cat("Resposta completa:\n")
print(resp_body_json(resposta))
