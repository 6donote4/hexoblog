---
title: 「原创」Excel自动化
toc: false
tags:
  - Excel自动化
  - 快速创建表单 
  - Excel模版创建
categories:
  - "原创博文"
date: 2017-07-16 03:30
top: 1102
---

<font size=4>
翻墙后，即可评论博文

  最近，因工作需要，特意去折腾了一下Excel。基本上，就是实现自己想要的功能.至于熟练的玩转Excel,那还没到这种地步。权且把自己所实现的功能记录下来，供以后参考之用。
</font>
<!--more-->
<audio controls="controls" name="media" style="width:264px"  autoplay loop=true> <source src="/musics/wish.mp3"></audio>

***
<font size=4>

  先附上三张效果图:
  ![Excel自动化](/pictures/post_1102Excel_Automation.png)
  ![Excel自动化](/pictures/post_1102Excel_Automation2.png)
  ![Excel自动化](/pictures/post_1102Excel_Automation3.png)
  再放出我制作的表单范本(右键另存）:
  [Example.xlsx](/data/Example.xlsx) 
  [Excel_Example.rar](/data/Excel_Example.rar)
  [VBA_Example.rar](/data/VBA_Example.rar)

  先说说我想实现的功能：1.依照固定的格式内容模板，自动建立并格式化一个总表单；2.依照型号列的单元格内容，自动依照分表单模板创建所有对应型号的分表单（人工作业那要做到猴年马月啊，所以要用代码）；3.总表单要链接到分表单，方便跳转到分表录入数据，在修改完分表单之后，总表单在执行程式之后，能够更新剩余数量列项单元格的数据，如果需要更新总数量数据，执行完指定程序之后，总表的剩余数量列项要能够覆盖到总数量列项；4.分表单的型号项、总数量的内容要自动从总表的对应项获取填充，要能返回到总表。


  下面对应说明一下，实现这些功能所做的工作及应用的素材:

  一、创建带格式的模板，VBA程序语言基础，Excel中工具宏的使用。来谈谈VBA这个东东, 即Visual Basic Application。也就说使用的是VB编程语言。~~这门编程语言，我基本上没有接触过，大学修的计算机语言是C,毕业之后，有了解过一点点C++。各语言方面的基础元素也有相似的地方。（这些废话不重要。）~~　代码的话就网上搜索吧，当然要学会修改代码的参数。总表单的模板和分表单的模板可以一起做，拷贝一份代码，重命名一下子程序，删减一些语句就能做成另外一个模板了。Excel宏录制是用来自动生成VBA代码的。宏录制，制作表格，宏停止，再修改一下VBA代码，就能够制作出一份完美的表格模板，以后只要单击运行宏，就能一键建立表格(当然拷贝出另一个已作成的表格也行。如果制作的表格不多的话，可以用拷贝的方法)。


  二、用宏录制配合VBA制作分表单模板，创建批量建立表单的子程序，运用循环语句，自动依照模板，建立表格。利用循环语句，自动使用型号列内容命名分表单，并且自动引用目标表格中的数据，将其填充到分表。所有的操作均可以利用宏录制，来获取代码，通过观察代码，修改实现功能。

  三、在总表单建立之后，可在总表单上选一单元格，在单元格上使用超链接函数,<font color=red>=Hyperlink("#"&B2&"!a1")</font> ,左键双击单元格句柄，就能建立所有以B列单元格内容为名称的且相对应的表单链接，通过在分表单设定特定单元格来更新最新的剩余量数据，所有分表格在同一位置均有这个数据，就能利用循环语句更新总表的剩余量数据项。

  四、控制选取单元格操作，利用Cells对象属性来指定单元格的特定位置，指定Sheets对象的索引ID，这样就明确了指定了总表中的特定单元格。分表D2的单元格要运用函数=B2－C2，B3的单元格要取用D2的数据,取用数量的数据初始化为0;单列一个单元格填入最新的剩余数量数据，该单元格数据供总表更新剩余数量项的程序作为参数使用,分表单要链接到总表，提供返回入口。(通过宏录制可获取到链接操作的代码)



  光使用文字描述的话实在太过抽象，下面给出代码，方便理解。..
</font>

    总表模板代码:

  ```vb

  Sub 总表模板()
'
' 工作总表模板　Macro
'

'程序控制常量设定，在程序头使用常量，可以方便程序修改，不用到处找参数变量。
    Const sht_Main_Name = "test" '总表名称
    Const sht_Order_Begin = 2 '新建表格起始ID
    Const sht_Order_End = 6 '新建表格终止ID

    Const sht_A_ColumnWidth = 20 'A列单元格宽度参数
    Const sht_B_ColumnWidth = 14
    Const sht_C_ColumnWidth = 14
    Const sht_D_ColumnWidth = 14
    Const sht_E_ColumnWidth = 40
    'Const sht_F_ColumnWidth = 12　’关闭F,G,H列常量参数
    ' Const sht_G_ColumnWidth = 14
    ' Const sht_H_ColumnWidth = 14

           Const sht_Main_ID = 1 '总表顺序ID

'
               Sheets(sht_Main_ID ).Name = sht_Main_Name
'总表模板代码，该代码是在宏录制模式下，制作表格生成的代码。              
               Range("A1").Select
               ActiveCell.FormulaR1C1 = "项目"
               Range("B1").Select
               ActiveCell.FormulaR1C1 = "型号"
               Range("C1").Select
               ActiveCell.FormulaR1C1 = "总数量"
               Range("D1").Select
               ActiveCell.FormulaR1C1 = "剩余数量"
               Range("E1").Select
               ActiveCell.FormulaR1C1 = "分表"
               'Range("F1").Select
               'ActiveCell.FormulaR1C1 = "领取人"
               'Range("G1").Select
               'ActiveCell.FormulaR1C1 = "领取时间"
               Columns("B:B").Select
               Selection.NumberFormatLocal = "0.00_);[ºìÉ«](0.00)"
               Selection.NumberFormatLocal = "0.0_);[ºìÉ«](0.0)"
               Selection.NumberFormatLocal = "0_);[ºìÉ«](0)"
               Columns("C:C").Select
               Selection.NumberFormatLocal = "0.00_);[ºìÉ«](0.00)"
               Selection.NumberFormatLocal = "0.0_);[ºìÉ«](0.0)"
               Selection.NumberFormatLocal = "0_);[ºìÉ«](0)"
               Columns("D:D").Select
               Selection.NumberFormatLocal = "0.00_);[ºìÉ«](0.00)"
               Selection.NumberFormatLocal = "0.0_);[ºìÉ«](0.0)"
               Selection.NumberFormatLocal = "0_);[ºìÉ«](0)"
               'Columns("E:E").Select
               'Selection.NumberFormatLocal = "@"
               'Columns("F:F").Select
               'Selection.NumberFormatLocal = "@"
               'Columns("G:G").Select
               'Selection.NumberFormatLocal = "[$-F800]dddd, mmmm dd, yyyy"
               Columns("A:A").ColumnWidth = sht_A_ColumnWidth
               Columns("B:B").ColumnWidth = sht_B_ColumnWidth
               Columns("C:C").ColumnWidth = sht_C_ColumnWidth
               Columns("D:D").ColumnWidth = sht_D_ColumnWidth
               Columns("E:E").ColumnWidth = sht_E_ColumnWidth
               'Columns("F:F").ColumnWidth = sht_F_ColumnWidth
               Selection.ColumnWidth = 18
               Cells.Select
               With Selection
                   .HorizontalAlignment = xlCenter
                   .VerticalAlignment = xlCenter
                   .WrapText = False
                   .Orientation = 0
                   .AddIndent = False
                   .IndentLevel = 0
                   .ShrinkToFit = False
                   .ReadingOrder = xlContext
                   .MergeCells = False
               End With
               Columns("B:B").Select
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 5296274
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 5296274
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 5296274
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
               Columns("D:D").Select
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 65535
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
             '  Columns("F:F").Select
             '  With Selection.Interior
             '      .Pattern = xlSolid
             '      .PatternColorIndex = xlAutomatic
             '      .Color = 15773696
             '      .TintAndShade = 0
             '      .PatternTintAndShade = 0
             '  End With

                Columns("A:E").Select
                Selection.Borders(xlDiagonalDown).LineStyle = xlNone
                Selection.Borders(xlDiagonalUp).LineStyle = xlNone
                With Selection.Borders(xlEdgeLeft)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlEdgeTop)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlEdgeBottom)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlEdgeRight)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlInsideVertical)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlInsideHorizontal)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With

End Sub


  ```

建立全部分表:
  ```vb
  Sub 建立全部分表()
'
' 新增工作表 Macro
'

'程序常量参数设定
    Const sht_Order_Begin = 2 '新建表格起始ID
    Const sht_Order_End = 6 '新建表格终止 ID

    Const sht_A_ColumnWidth = 20 'A列单元格宽度
    Const sht_B_ColumnWidth = 14
    Const sht_C_ColumnWidth = 14
    Const sht_D_ColumnWidth = 14
    Const sht_E_ColumnWidth = 40
    Const sht_F_ColumnWidth = 12
    ' Const sht_G_ColumnWidth = 14
     Const sht_H_ColumnWidth = 14

    Const sht_Main_URL_Address As String = "test!A1" '总表超链接地址
    Const sht_Main_URL_Text As String = "返回总表" '超链接文字显示

    Const sht_Main_ID = 1 '总表顺序ＩＤ　
    Const sht_Data_Rel_One = 2 '总表型号项数据所在列数
    Const sht_Data_Rel_Two = 3 '总表总数项数据所在列数


    For i = sht_Order_Begin To sht_Order_End
        Sheets.Add After:=Sheets(Sheets.Count)  '循环创建表单语句。
        Sheets(Sheets.Count).Name = Sheets(sht_Main_ID).Cells(i, 2) '循环命名分表名称，赋值号左边制定了总表的第2列数据，通过变量i遍历该列数据，填充到分表名陈属性。

    '表格函数的使用，以及获取总表数据填充到指定单元格。
        Range("A2").Select '选中当前循环下，所建表格中的A2单元格
        ActiveCell.FormulaR1C1 = Sheets(sht_Main_ID).Cells(i, sht_Data_Rel_One)
        '将总表指定的数据填充到选中的单元格
        Range("B2").Select
        ActiveCell.FormulaR1C1 = Sheets(sht_Main_ID).Cells(i, sht_Data_Rel_Two)
        ’同上
        Range("C2").Select
        ActiveCell.FormulaR1C1 = "0"
        Range("D2").Select
        ActiveCell.FormulaR1C1 = "=RC[-2]-RC[-1]"
        ‘单元格运用函数
        Range("B3").Select
        ActiveCell.FormulaR1C1 = "=R[-1]C[2]"
        Range("C3").Select
        ActiveCell.FormulaR1C1 = "0"
        Range("D2").Select
        Selection.AutoFill Destination:=Range("D2:D3"), Type:=xlFillDefault
        Range("H1").Select
        ActiveSheet.Hyperlinks.Add Anchor:=Selection, Address:="", SubAddress:= _
        sht_Main_URL_Address, TextToDisplay:=sht_Main_URL_Text
        Range("H2").Select
        ActiveCell.FormulaR1C1 = "=LOOKUP(9E+307,C[-4])"
        ‘单元格运用函数，并实时更新变化了的数据，C[-4]为指定列
        Columns("H:H").ColumnWidth = sht_H_ColumnWidth

               '工作表模板
               Range("A1").Select
               ActiveCell.FormulaR1C1 = "型号"
               Range("B1").Select
               ActiveCell.FormulaR1C1 = "总数量"
               Range("C1").Select
               ActiveCell.FormulaR1C1 = "取用数量"
               Range("D1").Select
               ActiveCell.FormulaR1C1 = "剩余数量"
               Range("E1").Select
               ActiveCell.FormulaR1C1 = "用途"
               Range("F1").Select
               ActiveCell.FormulaR1C1 = "领取人"
               Range("G1").Select
               ActiveCell.FormulaR1C1 = "领取时间"
               Columns("B:B").Select
               Selection.NumberFormatLocal = "0.00_);[ºìÉ«](0.00)"
               Selection.NumberFormatLocal = "0.0_);[ºìÉ«](0.0)"
               Selection.NumberFormatLocal = "0_);[ºìÉ«](0)"
               Columns("C:C").Select
               Selection.NumberFormatLocal = "0.00_);[ºìÉ«](0.00)"
               Selection.NumberFormatLocal = "0.0_);[ºìÉ«](0.0)"
               Selection.NumberFormatLocal = "0_);[ºìÉ«](0)"
               Columns("D:D").Select
               Selection.NumberFormatLocal = "0.00_);[ºìÉ«](0.00)"
               Selection.NumberFormatLocal = "0.0_);[ºìÉ«](0.0)"
               Selection.NumberFormatLocal = "0_);[ºìÉ«](0)"
               Columns("E:E").Select
               Selection.NumberFormatLocal = "@"
               Columns("F:F").Select
               Selection.NumberFormatLocal = "@"
               Columns("G:G").Select
               Selection.NumberFormatLocal = "[$-F800]dddd, mmmm dd, yyyy"
               Columns("A:A").ColumnWidth = sht_A_ColumnWidth
               Columns("B:B").ColumnWidth = sht_B_ColumnWidth
               Columns("C:C").ColumnWidth = sht_C_ColumnWidth
               Columns("D:D").ColumnWidth = sht_D_ColumnWidth
               Columns("E:E").ColumnWidth = sht_E_ColumnWidth
               Columns("F:F").ColumnWidth = sht_F_ColumnWidth
               Selection.ColumnWidth = 18
               Cells.Select
               With Selection
                   .HorizontalAlignment = xlCenter
                   .VerticalAlignment = xlCenter
                   .WrapText = False
                   .Orientation = 0
                   .AddIndent = False
                   .IndentLevel = 0
                   .ShrinkToFit = False
                   .ReadingOrder = xlContext
                   .MergeCells = False
               End With
               Columns("B:B").Select
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 5296274
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 5296274
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 5296274
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
               Columns("D:D").Select
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 65535
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With
               Columns("F:F").Select
               With Selection.Interior
                   .Pattern = xlSolid
                   .PatternColorIndex = xlAutomatic
                   .Color = 15773696
                   .TintAndShade = 0
                   .PatternTintAndShade = 0
               End With

                Columns("A:G").Select
                Selection.Borders(xlDiagonalDown).LineStyle = xlNone
                Selection.Borders(xlDiagonalUp).LineStyle = xlNone
                With Selection.Borders(xlEdgeLeft)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlEdgeTop)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlEdgeBottom)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlEdgeRight)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlInsideVertical)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With
                With Selection.Borders(xlInsideHorizontal)
                    .LineStyle = xlContinuous
                    .ColorIndex = xlAutomatic
                    .TintAndShade = 0
                    .Weight = xlThin
                End With

    Next
End Sub

  ```

  更新剩余数量数据单元格状态:
  ```vb


Sub 更新总表剩余数量单元格状态()
'更新剩余数量单元格
'程序控制常量
'
'
Const sht_Cell_Beg = 2 '单列中，单元格起点位置
Const sht_Cell_End = 6 '单列中，单元格终点位置
Const sht_Cell_Rest = 4 '总表中，剩余数量项所在列数
Const sub_sht_Cell_Rest_Row = 8 '分表中，为实现剩余数量实时更新而设的单元格列位置
Const sub_sht_Cell_Rest_Col = 2 '行位置

'
'
'

    For i = sht_Cell_Beg To sht_Cell_End                                 ' ｉ为分表单ＩＤ　顺序号
    Cells(i, sht_Cell_Rest).Select
    ActiveCell.FormulaR1C1 = Sheets(i).Cells(sub_sht_Cell_Rest_Col, sub_sht_Cell_Rest_Row)
    ’激活单元格，并填充指定分表中　实时更新所在单元格的数据，这个单元格已在分表中定义了Lookup函数
     Next
End Sub


  ```

更新总表总数量单元格状态:
```vb

Sub 更新总表总数量单元格状态()
'
'程序控制常量
'
'
Const sht_Cell_Beg = 2 '单列中，单元格列起点位置
Const sht_Cell_End = 6 '单列中，单元格列终点位置
Const sht_Cell_Total = 3 '总表中总数量项所在列数
Const sht_Cell_Rest = 4 '总表中剩余数量项所在列数


'
'
'

    For i = sht_Cell_Beg To sht_Cell_End                                 
    Cells(i, sht_Cell_Total).Select　‘选中指定单元格
    ActiveCell.FormulaR1C1 = Cells(i, sht_Cell_Rest)
    Next
End Sub


```



***

<font size=4>

</font>
***
