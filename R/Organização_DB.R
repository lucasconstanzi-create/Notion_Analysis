library(httr2)

# Carrega as credenciais do .Renviron
token <- Sys.getenv("NOTION_TOKEN")
database_id <- Sys.getenv("NOTION_DATABASE_ID")

# Operador auxiliar para lidar com valores nulos
`%||%` <- function(a, b) if (!is.null(a)) a else b

# Busca os dados da API
resposta <- request("https://api.notion.com/v1/databases/") |>
  req_url_path_append(database_id, "query") |>
  req_headers(
    Authorization = paste("Bearer", token),
    "Notion-Version" = "2022-06-28",
    "Content-Type" = "application/json"
  ) |>
  req_body_raw('{}') |>
  req_perform()

dados <- resp_body_json(resposta)

# Transforma o JSON em data.frame
df <- do.call(rbind, lapply(dados$results, function(row) {
  props <- row$properties
  data.frame(
    projeto     = props$`Numero do Projeto`$select$name %||% NA,
    responsavel = props$Responsavel$people[[1]]$name %||% NA,
    data        = props$Data$date$start %||% NA,
    tempo       = props$Tempo$number %||% NA,
    disciplina  = props$Disciplina$select$name %||% NA,
    atividade   = props$Atividade$select$name %||% NA,
    stringsAsFactors = FALSE
  )
}))

# Converte a coluna data para formato de data
df$data <- as.Date(df$data)

# Mostra o resultado
print(df)