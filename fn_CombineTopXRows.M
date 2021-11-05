// fn_CombineTopXRows
(InputTable as table, Iterator as number) as table =>
let
  TopXRows = List.Generate(
        () => 0
        , each _ < Iterator
        , each _ + 1
        , each InputTable{_}
        ),
    TableFromRecords = Table.FromRecords(
        List.Generate(
            () => 0
            , each _ < Iterator
            , each _ + 1
            , each InputTable{_}
            )
        ),
    TransposeTable = Table.Transpose(
        TableFromRecords
        , List.Generate(
            () => 0
            , each _ < Iterator
            , each _ + 1
            , each "Col" & Text.From(_)
            )
        ),
    
    // Special thanks to Imke Feldman for this line of code👍
    // https://www.thebiccountant.com/2017/01/09/dynamic-bulk-type-transformation-in-power-query-power-bi-and-m/
    DataTypeToText = Table.TransformColumnTypes(
        TransposeTable
        , List.Transform(
            Table.ColumnNames(TransposeTable)
            , each {_, type text}
            )
        ),
    
    CombineColumns = Table.CombineColumns(
        DataTypeToText
        , List.Generate(
            () => 0
            , each _ < Iterator
            , each _ + 1
            , each "Col" & Text.From(_)
            )
        , Combiner.CombineTextByDelimiter(
            " "
            , QuoteStyle.None
            )
        ,"Merged"
        ),
    TransposeCombined = Table.Transpose(CombineColumns),
    AppendToOriginalTable = Table.Combine({TransposeCombined, Table.Skip(InputTable, Iterator)}),
    PromotedHeaders = Table.PromoteHeaders(AppendToOriginalTable, [PromoteAllScalars=true])
in
    PromotedHeaders