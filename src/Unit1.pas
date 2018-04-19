unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ActnList, Vcl.Menus, Generics.Collections, Generics.Defaults;

type
  TNodeType = (NodeStart, NodeEnd, NodeWall, NodeOpen, NodeRoad, NodeDealed,
    NodeToBeDealed);

type
  node = record
    Id: string;
    X: Integer;
    Y: Integer;
    NodeType: TNodeType;
    FScore: Integer;
    GScore: Integer;
    HScore: Integer;
    ParentX: Integer;
    ParentY: Integer;
  end;

  TuMain = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label3: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    PaintBoxMain: TPaintBox;
    MainMenu1: TMainMenu;
    tab1: TMenuItem;
    open: TMenuItem;
    calculate: TMenuItem;
    ActionList1: TActionList;
    ActOpen: TAction;
    ActCalculate: TAction;
    N1: TMenuItem;
    options: TMenuItem;
    ActOptions: TAction;
    procedure ShowMaze;
    procedure PaintCell(node: node);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CalculateMaze;
    procedure OpenMazeFile;
    function IntToCoordinate(num: Integer): Integer;
    procedure ActOpenExecute(Sender: TObject);
    procedure ActCalculateExecute(Sender: TObject);
    procedure PaintBoxMainPaint(Sender: TObject);
    function CalFScoure(CurrentNode: node): node;
    procedure AddAdjacentNodes(CurrentNode: node);
    function IsNodeWalkable(node: node): Boolean;
    function GetNodeIndex(nodeList: TList<node>; node: node): Integer;
    procedure ActOptionsExecute(Sender: TObject);
    procedure RunOptions;
    procedure UpdateMaze(CurrentNode: node);
    function GetCurrentRoad(CurrentNode: node; nodeList: TList<node>)
      : TList<node>;
    // procedure DrawCurrentRoad(CurrentNode: node; nodeList: TList<node>);
    procedure UpdateMazeRoute(UpdateType: Integer);

  private
    { Private declarations }
    function CompareFScore(const Item1, Item2: node): Integer;
  public
    { Public declarations }
  end;

var
  uMain: TuMain;

  gAllNodes, gAllNodesCopy: Array of Array of node;

  gColMax, gRowMax: Integer;
  gCellWidth: Integer;
  gFlag: Boolean;
  gNodeType: TNodeType;
  gOpenList, gClosedList, gAdjacentNodes, gRouteNodes: TList<node>;
  // gCurrentNode: node;
  gAnime: Boolean;

implementation

uses unit2;
{$R *.dfm}

function TuMain.CompareFScore(const Item1, Item2: node): Integer;
// var
// lCompare: Integer;
begin
  result := Item1.FScore - Item2.FScore;

  // œ‡µ» ±,currentNodeµƒ◊”Ω⁄µ„≈≈«∞√ÅE
  if result = 0 then
  begin
    result := Item2.GScore - Item1.GScore;
  end;

end;

procedure TuMain.ActCalculateExecute(Sender: TObject);
begin
  CalculateMaze;
end;

procedure TuMain.UpdateMazeRoute(UpdateType: Integer);
var
  i: Integer;
  lNodeTemp: node;
begin
  // œ˚≥˝¬∑œﬂ
  if UpdateType = 0 then
  begin
    for i := 0 to gRouteNodes.Count - 1 do
    begin
      lNodeTemp := gRouteNodes[i];
      lNodeTemp.NodeType := NodeDealed;
      PaintCell(lNodeTemp);
    end;

  end;
  // Ã˙ÿ”¬∑œﬂ
  if UpdateType = 1 then
  begin
    for i := 0 to gRouteNodes.Count - 1 do
    begin
      PaintCell(gRouteNodes[i]);
    end;
  end;
end;

function TuMain.GetCurrentRoad(CurrentNode: node; nodeList: TList<node>)
  : TList<node>;
var
  lParentX, lParentY: Integer;
  lIndex: Integer;

begin
  result := TList<node>.create;
  lParentX := CurrentNode.ParentX;
  lParentY := CurrentNode.ParentY;
  if (lParentX = 0) AND (lParentY = 0) then
  begin
    exit;
  end;

  while (lParentX >= 0) AND (lParentY >= 0) do
  begin
    lIndex := GetNodeIndex(nodeList, gAllNodes[lParentX][lParentY]);
    Application.ProcessMessages;
    result.Add(nodeList[lIndex]);
    lParentX := nodeList[lIndex].ParentX;
    lParentY := nodeList[lIndex].ParentY;
    if (lParentX = 0) AND (lParentY = 0) then
    begin
      break;
    end;
  end;
end;

procedure TuMain.OpenMazeFile;
var
  lList: TStringList;
  // lRowList: TStringList;
  i, j: Integer;
  lTempNode: node;
  lTempNodeType: string;
begin
  if OpenDialog1.Execute then
  begin
    gRouteNodes.clear;
    // ≥ı ºªØnodes
    lList := TStringList.create;
    // lRowList := TStringList.create;
    lList.LoadFromFile(OpenDialog1.FileName);
    gRowMax := lList.Count;
    gColMax := Length(lList.Strings[0]);
    setLength(gAllNodes, gColMax);
    setLength(gAllNodesCopy, gColMax);
    gFlag := true;
    for i := 0 to gColMax - 1 do
    begin
      // lRowList.Delimiter := ' ';
      // lRowList.DelimitedText := lList.Strings[i];
      setLength(gAllNodes[i], gRowMax);
      setLength(gAllNodesCopy[i], gRowMax);
      // ShowMessage(IntToStr(Length(lList.Strings[i])));
      for j := 0 to gRowMax - 1 do
      begin
        lTempNode.Id := IntToStr(i) + ',' + IntToStr(j);
        lTempNode.X := i;
        lTempNode.Y := j;
        lTempNodeType := Copy(lList.Strings[j], i + 1, 1);
        if lTempNodeType = '0' then
        begin
          lTempNode.NodeType := NodeOpen;
        end
        else if lTempNodeType = '1' then
        begin
          lTempNode.NodeType := NodeWall;
        end;
        // lTempNode.NodeType := not StrToBool(Copy(lList.Strings[i], j + 1, 1));
        lTempNode.FScore := 0;
        lTempNode.GScore := 0;
        lTempNode.HScore := 0;
        lTempNode.ParentX := -1;
        lTempNode.ParentY := -1;
        gAllNodes[i][j] := lTempNode;
        gAllNodesCopy[i][j] := lTempNode;
      end;

    end;
    // ª≠∆µ„∫Õ÷’µÅE
    gAllNodes[0][0].NodeType := NodeStart;
    gAllNodesCopy[0][0].NodeType := NodeStart;
    gAllNodes[gColMax - 1][gRowMax - 1].NodeType := NodeEnd;
    gAllNodesCopy[gColMax - 1][gRowMax - 1].NodeType := NodeEnd;
    // Edit1.Text := '0,0';
    // Edit2.Text := IntToStr(gColMax - 1) + ',' + IntToStr(gRowMax - 1);
    // lRowList.Free;
    lList.Free;
    ShowMaze;
    uMain.Position := poDesktopCenter;
  end;

end;

procedure TuMain.ActOpenExecute(Sender: TObject);
begin
  OpenMazeFile;
end;

procedure TuMain.ActOptionsExecute(Sender: TObject);
begin
  RunOptions;
end;

procedure TuMain.RunOptions;
begin
  Form2.ShowModal;
  if Length(gAllNodes) <> 0 then
  begin
    if Form2.needResize then
    begin
      ShowMaze;
      uMain.Position := poDesktopCenter;
    end;

  end;

end;

procedure TuMain.ShowMaze;
var
  i, j, k: Integer;
  lIndex: Integer;
begin
  // ª≠Õº
  gAllNodes[0][0].NodeType := NodeStart;
  gAllNodes[gColMax - 1][gRowMax - 1].NodeType := NodeEnd;

  for i := 0 to gColMax - 1 do
  begin
    for j := 0 to gRowMax - 1 do
    begin
      lIndex := GetNodeIndex(gRouteNodes, gAllNodes[i][j]);
      if lIndex = -1 then
      begin
        PaintCell(gAllNodes[i][j]);
      end
      else
      begin
        PaintCell(gRouteNodes[lIndex]);
      end;
    end;
  end;
  {
    if gResultList.Count > 0 then
    begin
    for k := 0 to gResultList.Count - 1 do
    begin
    PaintCell(gResultList[k].X, gResultList[k].Y, gResultList[k].NodeType);
    end;
    end;
  }
  FormResize(nil);
end;

procedure TuMain.FormResize(Sender: TObject);
var
  lWidth: Integer;
begin
  Self.ClientWidth := gColMax * gCellWidth;
  Self.ClientHeight := gRowMax * gCellWidth;
end;

procedure TuMain.FormCreate(Sender: TObject);
begin
  gCellWidth := 20;
  gAnime := true;
  gOpenList := TList<node>.create;
  gClosedList := TList<node>.create;
  gAdjacentNodes := TList<node>.create;
  gRouteNodes := TList<node>.create;
end;

function TuMain.IntToCoordinate(num: Integer): Integer;
begin
  result := num * gCellWidth;
end;

procedure TuMain.UpdateMaze(CurrentNode: node);
begin
  if gAnime then
  begin
    ShowMaze;
  end
  else
  begin
    PaintCell(gAllNodes[CurrentNode.X][CurrentNode.Y]);
  end;
end;

{
  procedure TuMain.DrawCurrentRoad(CurrentNode: node; nodeList: TList<node>);
  var
  lParentX, lParentY: Integer;
  lIndex: Integer;
  begin
  lParentX := CurrentNode.ParentX;
  lParentY := CurrentNode.ParentY;
  if (lParentX = 0) AND (lParentY = 0) then
  begin
  exit;
  end;

  while (lParentX >= 0) AND (lParentY >= 0) do
  begin
  lIndex := GetNodeIndex(nodeList, gAllNodes[lParentX][lParentY]);
  Application.ProcessMessages;
  PaintCell(nodeList[lIndex]);
  lParentX := nodeList[lIndex].ParentX;
  lParentY := nodeList[lIndex].ParentY;
  if (lParentX = 0) AND (lParentY = 0) then
  begin
  break;
  end;

  end;
  end;
}
procedure TuMain.CalculateMaze;
var
  lAdjacentNodesTemp: TList<node>;
  lEndFlag: Boolean;
  i, j: Integer;
  lNodeTmp: node;
  lParentX, lParentY: Integer;
  lParentNodeTmp: node;
  lStartEndNode: Boolean;
begin
  if Length(gAllNodesCopy) = 0 then
  begin
    ShowMessage('ñ¿ã{ÉtÉ@ÉCÉãÇëIëÇµÇƒÇ≠ÇæÇ≥Ç¢');
    exit;
  end;

  for i := 0 to gColMax - 1 do
  begin
    for j := 0 to gRowMax - 1 do
    begin
      gAllNodes[i][j] := gAllNodesCopy[i][j];
    end;
  end;

  gOpenList.clear;
  gClosedList.clear;
  gRouteNodes.clear;
  lAdjacentNodesTemp := TList<node>.create;
  lEndFlag := false;
  // ∆ ºµ„º”Ω¯openlist
  gOpenList.Add(gAllNodes[0][0]);
  while lEndFlag = false do
  begin
    // ºÅEÈ÷’µ„ «∑Ò‘⁄closelist
    if gClosedList.Count <> 0 then
    begin
      if (gClosedList[gClosedList.Count - 1].X = gColMax - 1) AND
        (gClosedList[gClosedList.Count - 1].Y = gRowMax - 1) then
      begin
        lEndFlag := true;
        continue;
      end;
      // openlistŒ™ø’ ±Ω· ÅE
      if gOpenList.Count = 0 then
      begin
        lEndFlag := true;
        continue;
      end;
    end;
    // »°≥ˆopenlistµƒµ⁄“ª∏ˆ‘™Àÿ
    lNodeTmp := gOpenList.First;
    // ¥”openlist÷–…æ≥˝»°≥ˆµƒ‘™Àÿ
    gOpenList.Delete(0);
    lStartEndNode := false;
    if (lNodeTmp.NodeType = NodeEnd) or (lNodeTmp.NodeType = NodeStart) then
    begin
      lStartEndNode := true;
    end;

    if not lStartEndNode then
    begin
      lNodeTmp.NodeType := NodeRoad;
    end;
    //  «∑Ò–Ë“™÷ÿªÊµ±«∞œﬂ¬∑
    if (gRouteNodes.Count = 0) and (not lStartEndNode) then
    begin
      gRouteNodes.Add(lNodeTmp);
    end;
    // »°≥ˆµƒµ„ «∑Ò‘⁄‘≠œﬂ¬∑,»Á≤ª «,÷ÿª≠œﬂ¬∑,∑Ò‘Úº”»ÅEﬂ¬∑list
    if GetNodeIndex(gAdjacentNodes, lNodeTmp) = -1 then
    begin
      UpdateMazeRoute(0);
      gRouteNodes.clear;
      gRouteNodes := GetCurrentRoad(lNodeTmp, gClosedList);
      gRouteNodes.Add(lNodeTmp);
      UpdateMazeRoute(1);
    end
    else
    begin
      gRouteNodes.Add(lNodeTmp);
      PaintCell(lNodeTmp);
    end;

    if not lStartEndNode then
    begin
      gAllNodes[lNodeTmp.X][lNodeTmp.Y].NodeType := NodeRoad;
      UpdateMaze(gAllNodes[lNodeTmp.X][lNodeTmp.Y]);
    end;
    gAdjacentNodes.clear;
    // ºÅEÈœ‡¡⁄‘™Àÿ
    AddAdjacentNodes(lNodeTmp);
    // lNodeTmp.NodeType := NodeDealed;
    // Ω´¥À‘™Àÿ∑≈Ω¯closeList
    if not lStartEndNode then
    begin
      gAllNodes[lNodeTmp.X][lNodeTmp.Y].NodeType := NodeDealed;
    end;
    gClosedList.Add(lNodeTmp);
    Application.ProcessMessages;
    UpdateMaze(gAllNodes[lNodeTmp.X][lNodeTmp.Y]);
  end;

  ShowMaze;
  lParentNodeTmp := gAllNodes[gColMax - 1][gRowMax - 1];
  lParentX := lParentNodeTmp.ParentX;
  lParentY := lParentNodeTmp.ParentY;
  if (lParentX = -1) AND (lParentY = -1) then
  begin
    ShowMessage('ÉãÅ[ÉgÇ™å©Ç¬Ç©ÇËÇ‹ÇπÇÒÇ≈ÇµÇΩ');
    exit;
  end
  else
  begin
    ShowMessage('äÆóπÇµÇ‹ÇµÇΩ');
  end;
  {
    while (lParentX >= 0) AND (lParentY >= 0) do
    begin

    gAllNodes[lParentX][lParentY].NodeType := NodeRoad;
    Application.ProcessMessages;
    UpdateMaze(gAllNodes[lParentX][lParentY]);
    lParentNodeTmp := gAllNodes[lParentX][lParentY];
    lParentX := lParentNodeTmp.ParentX;
    lParentY := lParentNodeTmp.ParentY;
    if (lParentX = 0) AND (lParentY = 0) then
    begin
    break;
    end;

    end;
  }
end;

procedure TuMain.AddAdjacentNodes(CurrentNode: node);
var
  i: Integer;
  lX, lY: Integer;
  lIndex: Integer;
  lNodeTemp: node;
  lSortFlag: Boolean;
  lStartEndNode: Boolean;
  lFmin: Integer;
const
  lXTemp: array [0 .. 3] of Integer = (1, 0, -1, 0);
  lYTemp: array [0 .. 3] of Integer = (0, 1, 0, -1);

begin
  lX := CurrentNode.X;
  lY := CurrentNode.Y;
  lSortFlag := false;
  // gCurrentNode := CurrentNode;
  for i := 0 to Length(lXTemp) - 1 do
  begin
    // ≈–∂œ «∑Ò≥¨≥ˆ√‘π¨±ﬂΩÅE
    if (lX + lXTemp[i] < 0) or (lY + lYTemp[i] < 0) then
    begin
      continue;
    end
    else if (lX + lXTemp[i] > gColMax - 1) or (lY + lYTemp[i] > gRowMax - 1)
    then
    begin
      continue;
    end
    else
    begin
      // showMessage(IntToStr(lX + lXTemp[i])+'|'+IntToStr(lYTemp[i]));
      lNodeTemp := gAllNodes[lX + lXTemp[i]][lY + lYTemp[i]];
      //  «∑Ò‘⁄closelist, «‘ÚÃ¯π˝
      if GetNodeIndex(gClosedList, lNodeTemp) <> -1 then
      begin
        continue;
      end;

      //  «∑Ò «ø…Õ®––node
      if (IsNodeWalkable(lNodeTemp)) then
      begin
        lStartEndNode := false;
        if (lNodeTemp.NodeType = NodeEnd) or (lNodeTemp.NodeType = NodeStart)
        then
        begin
          lStartEndNode := true;
        end;
        // ≤ª‘⁄openlist,º∆À„F≤¢Ã˙ÿ”µΩopenlist
        if GetNodeIndex(gOpenList, lNodeTemp) = -1 then
        begin
          lSortFlag := true;
          lNodeTemp.ParentX := lX;
          lNodeTemp.ParentY := lY;
          lNodeTemp.GScore := CurrentNode.GScore + 1;
          lNodeTemp := CalFScoure(lNodeTemp);
          if not lStartEndNode then
          begin
            lNodeTemp.NodeType := NodeToBeDealed;
          end;
          gAllNodes[lX + lXTemp[i]][lY + lYTemp[i]] := lNodeTemp;
          gOpenList.Add(lNodeTemp);

        end
        else
        // ‘⁄openlist,±»Ωœ¡Ω÷÷¬∑æ∂µƒG
        begin
          // ¥˝ π”√µƒ¬∑æ∂±»‘≠¿¥µƒ¬∑æ∂∫√,∏ÅE¬F∫ÕG
          if lNodeTemp.GScore > CurrentNode.GScore + 1 then
          begin
            lSortFlag := true;
            lIndex := GetNodeIndex(gOpenList, lNodeTemp);
            lNodeTemp.ParentX := lX;
            lNodeTemp.ParentY := lY;
            lNodeTemp.GScore := CurrentNode.GScore + 1;
            lNodeTemp := CalFScoure(lNodeTemp);
            gAllNodes[lX + lXTemp[i]][lY + lYTemp[i]] := lNodeTemp;
            gOpenList[lIndex] := lNodeTemp;
          end;
        end;
        gAdjacentNodes.Add(lNodeTemp);
        UpdateMaze(lNodeTemp);
      end;
    end;

  end;
  // ”–Ã˙ÿ”nodeµΩopenlistªÚ∏ƒ±‰openlistƒ⁄nodeµƒ÷µ ±,÷ÿ–¬≈≈–Úopenlist
  if lSortFlag then
  begin
    gOpenList.Sort(TComparer<node>.Construct(CompareFScore));
    {
      lFmin := gOpenList[0].FScore;
      // ”≈œ»∞—µ±«∞µ„œ‡¡⁄µƒµ„∑≈µΩ◊˚Âœ∑Ω
      for i := 0 to gOpenList.Count - 1 do
      begin
      if lFmin = gOpenList[i].FScore then
      begin
      if (gOpenList[i].ParentX = CurrentNode.X) AND (gOpenList[i].ParentY = CurrentNode.Y)
      then
      begin
      lNodeTemp := gOpenList[i];
      gOpenList.Delete(i);
      gOpenList.insert(0, lNodeTemp);
      break;
      end;
      end
      else
      begin
      break;
      end;
      end;
    }
  end;

end;

// À„≥ˆ√ø∏ˆµ„µƒF G H ,F = G + H
// G:æ‡≥ı ºµ„µƒæ‡¿ÅEH:æ‡÷’µ„µƒºŸœÅE‡¿ÅE
function TuMain.CalFScoure(CurrentNode: node): node;

begin
  if (CurrentNode.FScore = 0) AND (CurrentNode.NodeType <> NodeEnd) then
  begin
    CurrentNode.HScore := Abs(CurrentNode.X - gAllNodes[gColMax - 1]
      [gRowMax - 1].X) + Abs(CurrentNode.Y - gAllNodes[gColMax - 1]
      [gRowMax - 1].Y);
  end;
  CurrentNode.FScore := CurrentNode.HScore + CurrentNode.GScore;

  result := CurrentNode;
end;

function TuMain.IsNodeWalkable(node: node): Boolean;
begin
  if node.NodeType = NodeWall then
  begin
    result := false;
  end
  else
  begin
    result := true;
  end;

end;

function TuMain.GetNodeIndex(nodeList: TList<node>; node: node): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to nodeList.Count - 1 do
  begin
    if node.Id = nodeList[i].Id then
    begin
      result := i;
    end;
  end;
end;

procedure TuMain.PaintBoxMainPaint(Sender: TObject);
begin
  if gFlag then
  begin
    ShowMaze;
  end;
end;

procedure TuMain.PaintCell(node: node);
var
  tmpX, tmpY: Integer;
begin
  tmpX := IntToCoordinate(node.X);
  tmpY := IntToCoordinate(node.Y);
  with PaintBoxMain do
  begin
    Canvas.Pen.Color := clBlack;
    if node.NodeType = NodeStart then
    begin
      Canvas.Brush.Color := clBlue;
    end
    else if node.NodeType = NodeEnd then
    begin
      Canvas.Brush.Color := clGreen;
    end
    else if node.NodeType = NodeOpen then
    begin
      Canvas.Brush.Color := clWhite;
    end
    else if node.NodeType = NodeWall then
    begin
      Canvas.Brush.Color := clBlack;
    end
    else if node.NodeType = NodeRoad then
    begin
      Canvas.Brush.Color := clRed;
    end
    else if node.NodeType = NodeDealed then
    begin
      Canvas.Brush.Color := clGray;
    end
    else if node.NodeType = NodeToBeDealed then
    begin
      Canvas.Brush.Color := clPurple;
    end;
    Canvas.Rectangle(tmpX, tmpY, tmpX + gCellWidth, tmpY + gCellWidth);
  end;
end;

end.
