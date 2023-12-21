module "lake_formation" {
  source = "hashicorp/aws-lake-formation/aws"

  name = "Meu Lago de Dados"
  region = "us-east-1"
  bucket_arn = "arn:aws:s3:::meu-bucket-s3"
}

resource "aws_lakeformation_table" "tabela_vendas" {
  name = "tabela_vendas"
  database_name = module.lake_formation.database_name
  table_format = "PARQUET"

  schema {
    field {
      name = "data"
      type = "DATE"
    }
    field {
      name = "produto"
      type = "STRING"
    }
    field {
      name = "quantidade"
      type = "INTEGER"
    }
    field {
      name = "valor"
      type = "DECIMAL"
    }
  }
}

resource "aws_lakeformation_data_source" "vendas" {
  name = "vendas"
  data_source_id = module.lake_formation.data_source_id
  s3_import_job_parameters {
    source_bucket_arn = module.lake_formation.bucket_arn
    source_file_pattern = "vendas.csv"
  }
}
