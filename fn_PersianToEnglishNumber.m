// fn_PersianToEnglishNumber
let
    fn_PersianToEnglishNumber = 
    /************************Function body************************/
        (Persian_Number as text) as number => 
            let
                #"Base Table" = Record.ToTable(Record.FromList(List.Combine({{"۰".."۹"}, {"،", "/"}, {Character.FromNumber(1644)}}), {"0".."9", "", ".", " "})),
                #"Input to Table" = Table.FromList(Text.ToList(Persian_Number), null, {"PersianValue"}),
                #"Index Column Added" = Table.AddIndexColumn(#"Input to Table", "Index", 1, 1, Int64.Type),
                #"Joining Input Table and Base Table" = Table.NestedJoin(#"Index Column Added", "PersianValue", #"Base Table", "Value", "Mapping", JoinKind.Inner),
                #"Sorted Rows" = Table.Sort(#"Joining Input Table and Base Table",{{"Index", Order.Ascending}}),
                #"English Number" = Number.FromText(Text.Replace(Text.Combine(Table.ExpandTableColumn(#"Sorted Rows", "Mapping", {"Name"}, {"Name"})[Name]), " ",""))
            in
                #"English Number"
    /************************Function documentation************************/
    , FunctionType = type function
        (
            Persian_Number as 
            (type text meta
                [
                Documentation.FieldCaption = "Persian Number عدد فارسی",
                Documentation.FieldDescription = "Accepting persian numbers as text. این فانکشن یک عدد فارسی را با فرمت تکست میپذیرد",
                Documentation.SampleValues = {"۱۲۳/..."}
                ]
            )
        ) as number 
        meta
        [
            Documentation.Name = "fn_PersianToEnglishNumber",
            Documentation.Description = "Converts persian numbers to english numbers.این فانکشن اعداد فارسی را به معادل انگلیسی آنها تبدیل میکند "
        ]
in
    Value.ReplaceType(fn_PersianToEnglishNumber, FunctionType)