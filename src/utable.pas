unit utable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, DBGrids,
  DBCtrls, StdCtrls, ComCtrls, IniFiles, db, sqldb, FileUtil;

type

  { Tfm_table_view }

  Tfm_table_view = class(TForm)
    db_source_teams: TDataSource;
    dblcb_team1: TDBLookupComboBox;
    dblcb_team2: TDBLookupComboBox;
    ed_search: TEdit;
    ed_points_team1: TEdit;
    ed_points_team2: TEdit;
    gb_team: TGroupBox;
    gb_points: TGroupBox;
    lb_search: TLabel;
    lb_vs: TLabel;
    menu_german: TMenuItem;
    menu_english: TMenuItem;
    db_source_table: TDataSource;
    dbgrid: TDBGrid;
    menu_export: TMenuItem;
    menu_option: TMenuItem;
    menu_close: TMenuItem;
    menu_language: TMenuItem;
    menu_back: TMenuItem;
    menu_main: TMainMenu;
    db_query_table: TSQLQuery;
    db_query_teams: TSQLQuery;
    pc_controlles: TPageControl;
    tab1: TTabSheet;
    tab2: TTabSheet;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menu_backClick(Sender: TObject);
    procedure menu_closeClick(Sender: TObject);
    procedure menu_englishClick(Sender: TObject);
    procedure menu_germanClick(Sender: TObject);
  private
    procedure FormatGUI;
    procedure ConnectDatabaseToGrid;
    procedure TableSelection;
    procedure ConnectDatabase;
    procedure TeamSelection;
  public
  end;

var
  fm_table_view: Tfm_table_view;

implementation

uses umain;

{$R *.lfm}

{ Tfm_table_view }

procedure Tfm_table_view.FormActivate(Sender: TObject);
begin
  ConnectDatabase;
  ConnectDatabaseToGrid;
  TableSelection;
  TeamSelection;
  FormatGUI;
end;

procedure Tfm_table_view.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  fm_tournament.close;
end;

procedure Tfm_table_view.FormCreate(Sender: TObject);
begin
  //Formatierung der Form
  fm_table_view.Top:=50;
  fm_table_view.Left:=50;
  fm_table_view.Width:=920;
  fm_table_view.Height:=480;
  fm_table_view.dbgrid.Align:=alNone;
  fm_table_view.dbgrid.Anchors:=[];
end;

procedure Tfm_table_view.menu_backClick(Sender: TObject);
begin
  fm_tournament.Show;
  fm_table_view.hide;
end;

procedure Tfm_table_view.menu_closeClick(Sender: TObject);
begin
  fm_table_view.close;
  fm_tournament.close;
end;

procedure Tfm_table_view.menu_englishClick(Sender: TObject);
begin
  fm_tournament.AssignLanguageFile('englisch.ini');
  FormatGUI;
end;

procedure Tfm_table_view.menu_germanClick(Sender: TObject);
begin
  fm_tournament.AssignLanguageFile('deutsch.ini');  
  FormatGUI;
end;

procedure Tfm_table_view.FormatGUI;
//var i:integer;
begin
  //Legt die Formatierungen für alle GUI-Elemente fest
  //Spracheinstellungen
  fm_table_view.Caption:=fm_tournament.language.ReadString('GUI','fm_table_view','');
  menu_language.Caption:=fm_tournament.language.ReadString('GUI','menu_language','');
  menu_option.Caption:=fm_tournament.language.ReadString('GUI','menu_option','');
  menu_back.Caption:=fm_tournament.language.ReadString('GUI','menu_back','');
  menu_close.Caption:=fm_tournament.language.ReadString('GUI','menu_close',''); 
  menu_export.Caption:=fm_tournament.language.ReadString('GUI','menu_export','');
  menu_german.Caption:=fm_tournament.language.ReadString('GUI','menu_german','');
  menu_english.Caption:=fm_tournament.language.ReadString('GUI','menu_english','');
  lb_vs.Caption:=fm_tournament.language.ReadString('GUI', 'lb_vs','');
  gb_team.Caption:=fm_tournament.language.ReadString('GUI','gb_team','');
  gb_points.Caption:=fm_tournament.language.ReadString('GUI','gb_points','');
  lb_search.Caption:=fm_tournament.language.ReadString('GUI','lb_search','');
  tab1.Caption:=fm_tournament.language.ReadString('GUI','tab1','');
  tab2.Caption:=fm_tournament.language.ReadString('GUI','tab2','');

  //Objektdarstellung
  //grid
  dbgrid.FastEditing:=false;
  dbgrid.Enabled:=false;
  dbgrid.Top:=30;
  dbgrid.Left:=10;
  dbgrid.Width:=500;
  dbgrid.Height:=410;
  dbgrid.AutoFillColumns:=true;
  dbgrid.ScrollBars:=ssNone;

  //lookupcombobox
  dblcb_team1.ListSource:=db_source_teams;
  dblcb_team1.KeyField:='Teamname';
  dblcb_team2.ListSource:=db_source_teams;
  dblcb_team2.KeyField:='Teamname';

  //edits
  ed_points_team1.text:='';
  ed_points_team2.text:='';
  ed_search.Text:='';

  //pagecontroller
  pc_controlles.Top:=10;
  pc_controlles.Left:=530;
  pc_controlles.Width:=370;
  pc_controlles.Height:=430;

end;

procedure Tfm_table_view.ConnectDatabaseToGrid;
begin
  dbgrid.DataSource:=fm_table_view.db_source_table;
end;

procedure Tfm_table_view.TableSelection;
begin
  //Lässt alle Tabellen der Datenbank in der combobox anzeigen
  fm_tournament.SqlQuery('SELECT * FROM ' + fm_tournament.dblcb_tables.Items[fm_tournament.dblcb_tables.ItemIndex] + ';', db_query_table);
  dbgrid.DataSource:=db_source_table;
end;

procedure Tfm_table_view.ConnectDatabase;
begin
  //Query
  db_query_table.Transaction:=fm_tournament.db_transaction;
  db_query_table.DataBase:=fm_tournament.db_connector;
  db_query_teams.Transaction:=fm_tournament.db_transaction;
  db_query_teams.DataBase:=fm_tournament.db_connector;

  //Datasource
  db_source_table.DataSet:=db_query_table;
  db_source_teams.DataSet:=db_query_teams;
end;

procedure Tfm_table_view.TeamSelection;
begin
  fm_tournament.SqlQuery('SELECT Teamname FROM ' + fm_tournament.dblcb_tables.Items[fm_tournament.dblcb_tables.ItemIndex] + ';', db_query_teams);
end;

end.

