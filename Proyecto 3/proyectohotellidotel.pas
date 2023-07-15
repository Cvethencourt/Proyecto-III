program hotelidotel;

uses
  SysUtils, Crt;

const
  
  children_max = 5;
  grupom = 25;
type
  clientData = record
    allName: array[1..grupom] of string;
    mail: array[1..grupom] of string;
    celPhone: array[1..grupom] of string;
    cedula: array[1..grupom] of string;
    children: array[1..children_max] of string;
    edad: array[1..children_max] of integer;
    roomNum: string;
    roomType: string;
    personAmount: integer;
    childrenAmount: integer;
    days : integer;
  end;

  data = file of clientData;

var
parejaData: data;
individualData: data;
acData: data;
acliente: clientData;
i, x: integer;
edad: integer;

Procedure bienvenida;

Begin
	textcolor (Yellow);
	Writeln ('Bienvenid@ a Lidotel Hotel Boutique Margarita');
	Writeln ('======================================================================');
	textcolor (White);
	Writeln ('Podra realizar reservaciones, consultar reservaciones, entre otras');
	Writeln ('funciones de utilidad...');
	Writeln ('======================================================================');
	Writeln ('Este hotel se encuentra comodamente equipado para atender a todos sus ');
	Writeln ('clientes, esperamos disfrute su estadia y pueda relajarse y aprovechar');
	Writeln ('de todo lo que Lidotel tiene para usted ');
	Writeln ('');
	readkey;
	clrscr;
end;

function ContainsNumbers(const str: string): Boolean;
var
  i: Integer;
begin
  for i := 1 to Length(str) do
  begin
    if str[i] in ['0'..'9'] then
    begin
      ContainsNumbers := True;
      Exit;
    end;
  end;
  ContainsNumbers := False;
end;

procedure fileOpen(var parejaData: data; var individualData: data; var acData: data);
begin
  Assign(parejaData, 'pareja.dat');
  Assign(individualData, 'individual.dat');
  Assign(acData, 'acompanados.dat');
  {$I-}
  Reset(parejaData);
  Reset(individualData);
  Reset(acData);
  {$I+}
  if IOResult <> 0 then
  begin
    Rewrite(parejaData);
    Rewrite(individualData);
    Rewrite(acData);
  end;
end;

function existeNumHabitacion(roomNum: string; var parejaData: data; var individualData: data; var acData: data): Boolean;
var
  fileRun: data;
begin
  Assign(fileRun, 'Pareja.dat');
  Reset(fileRun);
  if IOResult = 0 then
  begin
    while not EOF(fileRun) do
    begin
      Read(fileRun, acliente);
      if acliente.roomNum = roomNum then
      begin
        Close(fileRun);
        existeNumHabitacion := True;
        Exit;
      end;
    end;
    Close(fileRun);
  end;

  Assign(fileRun, 'Individual.dat');
  Reset(fileRun);
  if IOResult = 0 then
  begin
    while not EOF(fileRun) do
    begin
      Read(fileRun, acliente);
      if acliente.roomNum = roomNum then
      begin
        Close(fileRun);
        existeNumHabitacion := True;
        Exit;
      end;
    end;
    Close(fileRun);
  end;

  Assign(fileRun, 'Acompanados.dat');
  Reset(fileRun);
  if IOResult = 0 then
  begin
    while not EOF(fileRun) do
    begin
      Read(fileRun, acliente);
      if acliente.roomNum = roomNum then
      begin
        Close(fileRun);
        existeNumHabitacion := True;
        Exit;
      end;
    end;
    Close(fileRun);
  end;

  existeNumHabitacion := False;
end;

procedure showRooms(roomType: string);
begin
  case roomType of
    'S':
      begin
       writeln('Habitacion Sencilla:');
       writeln('-------------------');
       writeln('Esta habitacion es para una sola persona.');
       writeln('Amplia y confortable habitacion decorada con un estilo vanguardista,');
       writeln('cama Lidotel Royal King con sabanas de algodon egipcio, soporte para ');
       writeln('iPod con reloj despertador, TV 32 HD Plasma con cable, bano con ducha,');
       writeln(' cafetera electrica, nevera ejecutiva, caja electronica de seguridad ');
       writeln('y secador de cabello.');
      end;
    'T':
      begin
        writeln('Suite:');
        writeln('-------');
        writeln('Esta habitacion es para una pareja.');
        writeln('Calida y confortable habitacion decorada con un estilo vanguardista,');
        Writeln('100% libre de humo, Cama Lidotel Royal King, con reloj despertador,');
        writeln('TV 32 HD Plasma con cable, 2 banos con ducha, cafetera electrica, ');
        writeln('nevera ejecutiva, caja electronica de seguridad y secador de cabello,');
        writeln(' armario adicional amplio y area separada con 2 sofa-cama individuales.');
      end;
    'D':
      begin
        writeln('Habitacion Doble:');
        writeln('-----------------');
        writeln('Esta habitacion es para dos personas.');
        writeln('Amplia y confortable habitacion decorada con un estilo vanguardista,');
        writeln('Dos Camas Lidotel Full con sabanas de algodon egipcio, soporte para');
        writeln('iPod con reloj despertador, TV 32 HD Plasma con cable, bano con ducha,');
        Writeln('cafetera electrica, nevera ejecutiva, caja electronica de seguridad ');
        writeln('secador de cabello.');
      end;
    'F':
      begin
        writeln('Family Room:');
        writeln('------------');
        writeln('Esta habitacion es para familias.');
        writeln('Calida y confortable habitacion decorada con un estilo vanguardista,');
        Writeln('100% libre de humo, cama Lidotel Royal King, con reloj despertador,');
        Writeln('TV 32” HD Plasma con cable, bano con ducha, cafetera electrica, nevera');
        writeln('ejecutiva, caja electronica de seguridad y secador de cabello,');
        Writeln('armario adicional amplio, una habitacion separada con 2 camas full,');
        Writeln('bano con ducha.');
      end;
  end;
end;

procedure availableRooms;
begin
  writeln('Habitaciones Disponibles:');
  writeln('------------------------');
  writeln('S. Sencilla');
  writeln('T. Suite');
  writeln('D. Doble');
  writeln('F. Family Room');
  writeln('------------------------');
end;

function ContainsAtSymbol(mail: string): Boolean;
begin
  ContainsAtSymbol := Pos('@', mail) > 0;
end;

procedure addData(var parejaData: data; var individualData: data; var acData: data);
var
  acliente : clientData;
  hospedajeType: char;
  roomType: char;
  roomNum: string;
  numAdultos: integer;
  i, x: integer;
begin
  if IOresult = 0 then
  begin
    Close(parejaData);
    Close(individualData);
    Close(acData);
  end;
  clrscr;
  writeln('----- Agregar Registro -----');

  // Tipo de Hospedaje
  while not (hospedajeType in ['I', 'P', 'A']) do
  begin
    writeln('Ingrese el tipo de hospedaje:');
    writeln('I. Individual');
    writeln('P. Pareja');
    writeln('A. Acompanados');
    write('Opcion: ');
    hospedajeType := UpCase(ReadKey);
    writeln(hospedajeType);
    clrscr;
  end;

  // Validaciones y datos adicionales para Acompanados
  if hospedajeType = 'A' then
  begin
    Assign(acData, 'Acompanados.dat');
    Reset(acData);
    writeln('Datos adicionales para Acompanados:');
    writeln;

    repeat
      writeln('¿Cuantos adultos se hospedaran? ');
      readln(numAdultos);
      acliente.childrenAmount := numAdultos;
    until numAdultos > 0;

    for i := 1 to numAdultos do
    begin
      writeln;
      writeln('Datos del adulto ', i);
      writeln('------------------');
      write('Numero de cedula: ');
      readln(acliente.cedula[i]);
      writeln('------------------------');
      write('Nombre y apellido: ');
      readln(acliente.allName[i]);
      writeln('------------------------');
      write('Email: ');
      readln(acliente.mail[i]);
      writeln('------------------------');
      write('Telefono: ');
      readln(acliente.celPhone[i]);
      writeln('------------------------');
      writeln('');
    end;

    repeat
      writeln;
      write('¿Cuantos ninyos se hospedaran? ');
      readln(x);
      acliente.personAmount := x;
    until x >= 0;

    for i := 1 to x do
    begin
      writeln;
      writeln('Datos del ninyo ', i);
      writeln('-----------------');
      write('Nombre y apellido: ');
      readln(acliente.children[i]);
      writeln('------------------------');
      write('Edad: ');
      readln(acliente.edad[i]);
    end;

    Close(acData);
  end
  else if hospedajeType = 'P' then
  begin
    Assign(parejaData, 'Pareja.dat');
    Reset(parejaData);
    writeln('Datos para Pareja:');
    writeln;
    write('Proporcione el primer nombre y apellido: ');
    readln(acliente.allName[1]);
    writeln('------------------------');
    write('Proporcione el segundo nombre y apellido: ');
    readln(acliente.allName[2]);
    writeln('------------------------');
    write('Proporcione el numero de cedula de ', acliente.allName[1], ': ');
    readln(acliente.cedula[1]);
    writeln('------------------------');
    write('Proporcione el numero de cedula de ', acliente.allName[2], ': ');
    readln(acliente.cedula[2]);
    writeln('------------------------');
    write('Proporcione el mail de ', acliente.allName[1], ': ');
    readln(acliente.mail[1]);
    writeln('------------------------');
    write('Proporcione el mail de ', acliente.allName[2], ': ');
    readln(acliente.mail[2]);
    writeln('------------------------');
    write('Proporcione el telefono de ', acliente.allName[1], ': ');
    readln(acliente.celPhone[1]);
    writeln('------------------------');
    write('Proporcione el telefono de ', acliente.allName[2], ': ');
    readln(acliente.celPhone[2]);
    writeln('------------------------');

    Close(parejaData);
  end
  else
  begin
    Assign(individualData, 'Individual.dat');
    Reset(individualData);

    // Inicializar variables para hospedaje individual
    acliente.roomNum := '';
    acliente.roomType := '';
    acliente.allName[1] := '';
    acliente.cedula[1] := '';
    acliente.mail[1] := '';
    acliente.celPhone[1] := '';

    // Nombre y Apellido
    writeln('Nombre y apellido: ');
    readln(acliente.allName[1]);
    writeln('------------------------');
    // Cedula
    repeat
      writeln('Numero de cedula: ');
      readln(acliente.cedula[1]);
      writeln('------------------------');
    until ContainsNumbers(acliente.cedula[1]);

    // Telefono
    writeln('Telefono: ');
    readln(acliente.celPhone[1]);
    writeln('------------------------');

    // Email
    writeln('Email: ');
    readln(acliente.mail[1]);
    writeln('------------------------');

    Close(individualData);
  end;

  // Mostrar informacion de las habitaciones disponibles
  while not (roomType in ['S', 'T', 'D', 'F']) do
  begin
    clrscr;
    availableRooms;
    WriteLn('');
    writeln('------------------------');
    write('Seleccione una opcion: ');
    roomType := UpCase(ReadKey);
    writeln(roomType);
    writeln('------------------------');
  end;

  // Mostrar informacion de la habitacion seleccionada
  showRooms(roomType);

  // Solicitar numero de habitacion y validar disponibilidad
  repeat
    writeln;
    WriteLn('');
    writeln('------------------------');
    write('Ingrese el numero de habitacion: ');
    readln(roomNum);
    writeln('------------------------');
    if existeNumHabitacion(roomNum, parejaData, individualData, acData) then
    begin
      writeln('El numero de habitacion ya esta ocupado. Por favor, seleccione otro.');
      readln;
    end;
  until not existeNumHabitacion(roomNum, parejaData, individualData, acData);

  // Guardar datos en el archivo correspondiente
  acliente.roomNum := roomNum;
  acliente.roomType := roomType;

  case hospedajeType of
    'I':
      begin
        Assign(individualData, 'Individual.dat');
        Reset(individualData);
        Seek(individualData, FileSize(individualData));
        Write(individualData, acliente);
        Close(individualData);
      end;
    'P':
      begin
        Assign(parejaData, 'Pareja.dat');
        Reset(parejaData);
        Seek(parejaData, FileSize(parejaData));
        Write(parejaData, acliente);
        Close(parejaData);
      end;
    'A':
      begin
        Assign(acData, 'Acompanados.dat');
        Reset(acData);
        Seek(acData, FileSize(acData));
        Write(acData, acliente);
        Close(acData);
      end;
  end;

  writeln;
  writeln('Registro agregado exitosamente.');
  readln;
end;

procedure showData(var parejaData: data; var individualData: data; var acData: data);
var
  fileRun: data;
  acliente: clientData;
  option: char;
  key: char;
begin
  if IOresult = 0 then
  begin
    Close(parejaData);
    Close(individualData);
    Close(acData);
  end;
  clrscr;
  writeln('***** Mostrar Datos *****');
  writeln('T. Todos');
  writeln('I. Individual');
  writeln('P. Pareja');
  writeln('A. Acompanados');
  writeln('------------------------');
  write('Seleccione una opcion: ');
  option := UpCase(ReadKey);
  writeln(option);
  writeln;

  case option of
    'T':
      begin
        Assign(fileRun, 'Individual.dat');
        Reset(fileRun);
        writeln('***** Hospedajes Individuales *****');
        writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
        while not EOF(fileRun) do
        begin
          Read(fileRun, acliente);
          write(acliente.cedula[1], ' | ');
          write(acliente.allName[1], ' | ');
          write(acliente.mail[1], ' | ');
          write(acliente.celPhone[1], ' | ');
          write(acliente.roomType, ' | ');
          write(acliente.roomNum, ' | ');
          writeln(acliente.days);
        end;
        Close(fileRun);

        Assign(fileRun, 'Pareja.dat');
        Reset(fileRun);
        writeln('***** Hospedajes en Pareja *****');
        writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
        while not EOF(fileRun) do
        begin
          Read(fileRun, acliente);
          write(acliente.cedula[1], ' | ');
          write(acliente.allName[1], ' | ');
          write(acliente.mail[1], ' | ');
          write(acliente.celPhone[1], ' | ');
          write(acliente.roomType, ' | ');
          write(acliente.roomNum, ' | ');
          writeln(acliente.days);
          write(acliente.cedula[2], ' | ');
          write(acliente.allName[2], ' | ');
          write(acliente.mail[2], ' | ');
          write(acliente.celPhone[2], ' | ');
          write(acliente.roomType, ' | ');
          write(acliente.roomNum, ' | ');
          writeln(acliente.days);
        end;
        Close(fileRun);

        Assign(fileRun, 'Acompanados.dat');
        Reset(fileRun);
        writeln('***** Hospedajes Acompanados *****');
        writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
        while not EOF(fileRun) do
        begin
          Read(fileRun, acliente);
          for i := 1 to acliente.childrenAmount do
          begin
            write(acliente.cedula[i], ' | ');
            write(acliente.allName[i], ' | ');
            write(acliente.mail[i], ' | ');
            write(acliente.celPhone[i], ' | ');
            write(acliente.roomType, ' | ');
            write(acliente.roomNum, ' | ');
            writeln(acliente.days, ' | ');
          end;
        end;
        Close(fileRun);
      end;
    'I':
      begin
        Assign(fileRun, 'Individual.dat');
        Reset(fileRun);
        writeln('***** Hospedajes Individuales *****');
        writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
        while not EOF(fileRun) do
        begin
          Read(fileRun, acliente);
          write(acliente.cedula[1], ' | ');
          write(acliente.allName[1], ' | ');
          write(acliente.mail[1], ' | ');
          write(acliente.celPhone[1], ' | ');
          write(acliente.roomType, ' | ');
          write(acliente.roomNum, ' | ');
          writeln(acliente.days, ' | ');
        end;
        Close(fileRun);
      end;
    'P':
      begin
        Assign(fileRun, 'Pareja.dat');
        Reset(fileRun);
        writeln('***** Hospedajes en Pareja *****');
        writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
        while not EOF(fileRun) do
        begin
          Read(fileRun, acliente);
          write(acliente.cedula[1], ' | ');
          write(acliente.allName[1], ' | ');
          write(acliente.mail[1], ' | ');
          write(acliente.celPhone[1], ' | ');
          write(acliente.roomType, ' | ');
          write(acliente.roomNum, ' | ');
          writeln(acliente.days);
          write(acliente.cedula[2], ' | ');
          write(acliente.allName[2], ' | ');
          write(acliente.mail[2], ' | ');
          write(acliente.celPhone[2], ' | ');
          write(acliente.roomType, ' | ');
          write(acliente.roomNum, ' | ');
          writeln(acliente.days, ' | ');
        end;
        Close(fileRun);
      end;
    'A':
      begin
        Assign(fileRun, 'Acompanados.dat');
        Reset(fileRun);
        writeln('***** Hospedajes Acompanados *****');
        writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
        while not EOF(fileRun) do
        begin
          Read(fileRun, acliente);
          for i := 1 to acliente.childrenAmount do
          begin
            write(acliente.cedula[i], ' | ');
            write(acliente.allName[i], ' | ');
            write(acliente.mail[i], ' | ');
            write(acliente.celPhone[i], ' | ');
            write(acliente.roomType, ' | ');
            write(acliente.roomNum, ' | ');
            writeln(acliente.days, ' | ');
          end;
        end;
        Close(fileRun);
      end;
  end;

  writeln('Presione cualquier key para volver al menu principal.');
  ReadKey;
end;

procedure searchData(var parejaData: data; var individualData: data; var acData: data);
var
  fileRun: data;
  searchCedula: string;
  founds: Boolean;
  acliente: clientData;

  procedure dataClientPrint(const acliente: clientData; i: integer);
  begin
    writeln('| ', acliente.cedula[i], ' | ', acliente.allName[i], ' | ', acliente.mail[i], ' | ', acliente.celPhone[i], ' | ', acliente.roomType, ' | ', acliente.roomNum, ' | ', acliente.days, ' |');
  end;

begin
  if IOresult = 0 then
  begin
    Close(parejaData);
    Close(individualData);
    Close(acData);
  end;
  clrscr;
  writeln('------ Buscar Datos ------');
  write('Ingrese el numero de cedula a buscar: ');
  readln(searchCedula);
  writeln;

  founds := False;

  // Buscar en Hospedajes Individuales
  Assign(fileRun, 'Individual.dat');
  Reset(fileRun);
  writeln('***** Resultados de la busqueda en Hospedajes Individuales *****');
  while not EOF(fileRun) do
  begin
    Read(fileRun, acliente);
    if acliente.cedula[1] = searchCedula then
    begin
      writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
      dataClientPrint(acliente, 1);
      founds := True;
    end;
  end;
  Close(fileRun);

  // Buscar en Hospedajes en Pareja
  Assign(fileRun, 'Pareja.dat');
  Reset(fileRun);
  writeln('***** Resultados de la busqueda en Hospedajes en Pareja *****');
  while not EOF(fileRun) do
  begin
    Read(fileRun, acliente);
    if (acliente.cedula[1] = searchCedula) or (acliente.cedula[2] = searchCedula) then
    begin
      writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
      dataClientPrint(acliente, 1);
      dataClientPrint(acliente, 2);
      founds := True;
    end;
  end;
  Close(fileRun);

  // Buscar en Hospedajes Acompanados (Grupo)
  Assign(fileRun, 'Acompanados.dat');
  Reset(fileRun);
  while not EOF(fileRun) do
  begin
    Read(fileRun, acliente);
    if acliente.roomNum = searchCedula then
    begin
      writeln('***** Resultados de la busqueda en Hospedajes Acompanados *****');
      writeln('Cedula | Nombre y Apellido | Email | Telefono | Tipo de Habitacion | Habitacion | Noches');
      for i := 1 to acliente.childrenAmount do
      begin
        dataClientPrint(acliente, i);
      end;
      founds := True;
    end;
  end;
  Close(fileRun);

  if not founds then
  begin
    writeln('No se encontraron resultados para la cedula especificada.');
  end;

  readln;
end;

procedure checkOutBill(var parejaData: data; var individualData: data; var acData: data);
var
  i, j, x: integer;
  cedula: string;
  foundit: Boolean;
  fileRun: data;
  cliente: clientData;
  roomType: string;

  function roomTypeObtain(tipo: char): string;
  var
    rtype: string;
  begin
    case tipo of
      'S': rtype := 'Sencilla';
      'T': rtype := 'Suite';
      'F': rtype := 'Family Room';
      'D': rtype := 'Doble';
      else
        rtype := 'Desconocido';
    end;
    roomTypeObtain := rtype;
  end;

  function price4day(roomType: string): integer;
  var
    price: integer;
  begin
    case roomType[1] of
      'S': price := 60; // Sencilla
      'T': price := 300; // Suite
      'F': price := 200; // Family Room
      'D': price := 120; // Doble
      else
        price := 0; // Tipo de habitacion invalido
    end;
    price4day := price;
  end;

begin
  if IOresult = 0 then
  begin
    Close(parejaData);
    Close(individualData);
    Close(acData);
  end;
  
  clrscr;
  writeln('----- Facturacion por Cedula -----');
  writeln('Ingrese el numero de cedula: ');
  readln(cedula);

  // Buscar en el archivo Individual.dat
  Assign(fileRun, 'Individual.dat');
  Reset(fileRun);
  foundit := False;
  while not EOF(fileRun) do
  begin
    Read(fileRun, cliente);
    if cliente.cedula[1] = cedula then
    begin
      writeln('Facturacion para Cliente Individual:');
      writeln('-----------------------------------');
      writeln('Cedula: ', cliente.cedula[1]);
      writeln('Nombre y apellido: ', cliente.allName[1]);
      writeln('Email: ', cliente.mail[1]);
      writeln('Telefono: ', cliente.celPhone[1]);
      writeln('Numero de habitacion: ', cliente.roomNum);
      roomType := roomTypeObtain(cliente.roomType[1]);
      writeln('Tipo de habitacion: ', roomType);
      writeln('Noches: ', cliente.days);
      writeln('Precio por noche: ', price4day(roomType));
      writeln('Total a pagar: ', cliente.days * price4day(roomType));
      foundit := True;
      Break;
    end;
  end;
  Close(fileRun);

  if not foundit then
  begin
    // Buscar en el archivo Pareja.dat
    Assign(fileRun, 'Pareja.dat');
    Reset(fileRun);
    foundit := False;
    while not EOF(fileRun) do
    begin
      Read(fileRun, cliente);
      if (cliente.cedula[1] = cedula) or (cliente.cedula[2] = cedula) then
      begin
        writeln('Facturacion para Cliente en Pareja:');
        writeln('----------------------------------');
        writeln('Primer nombre y apellido: ', cliente.allName[1]);
        writeln('Segundo nombre y apellido: ', cliente.allName[2]);
        writeln('Email de ', cliente.allName[1], ': ', cliente.mail[1]);
        writeln('Email de ', cliente.allName[2], ': ', cliente.mail[2]);
        writeln('Telefono de ', cliente.allName[1], ': ', cliente.celPhone[1]);
        writeln('Telefono de ', cliente.allName[2], ': ', cliente.celPhone[2]);
        writeln('Numero de cedula de ', cliente.allName[1], ': ', cliente.cedula[1]);
        writeln('Numero de cedula de ', cliente.allName[2], ': ', cliente.cedula[2]);
        writeln('Numero de habitacion: ', cliente.roomNum);
        roomType := roomTypeObtain(cliente.roomType[1]);
        writeln('Tipo de habitacion: ', roomType);
        writeln('Noches: ', cliente.days);
        writeln('Precio por noche: ', price4day(roomType));
        writeln('Total a pagar: ', cliente.days * price4day(roomType));
        foundit := True;
        Break;
      end;
    end;
    Close(fileRun);
  end;

  if not foundit then
  begin
    // Buscar en el archivo Acompanados.dat
    Assign(fileRun, 'Acompanados.dat');
    Reset(fileRun);
    foundit := False;
    while not EOF(fileRun) do
    begin
      Read(fileRun, cliente);
      for i := 1 to cliente.childrenAmount do
      begin
        if cliente.cedula[i] = cedula then
        begin
          writeln('Facturacion para Cliente Acompanado:');
          writeln('-----------------------------------');
          writeln('Cantidad de adultos: ', cliente.childrenAmount);
          for j := 1 to cliente.childrenAmount do
          begin
            writeln('Adulto ', i);
            writeln('Numero de cedula: ', cliente.cedula[i]);
            writeln('Nombre y apellido: ', cliente.allName[i]);
            writeln('Email: ', cliente.mail[i]);
            writeln('Telefono: ', cliente.celPhone[i]);
            writeln('------------------------');
          end;
          writeln('Cantidad de ninyos: ', cliente.personAmount);
          for x := 1 to cliente.personAmount do
          begin
            writeln('Ninyo ', i);
            writeln('Nombre y apellido: ', cliente.children[i]);
            writeln('Edad: ', cliente.edad[i]);
            writeln('------------------------');
          end;
          writeln('Numero de habitacion: ', cliente.roomNum);
          roomType := roomTypeObtain(cliente.roomType[1]);
          writeln('Tipo de habitacion: ', roomType);
          writeln('Noches: ', cliente.days);
          writeln('Precio por noche: ', price4day(roomType));
          writeln('Total a pagar: ', cliente.days * price4day(roomType));
          foundit := True;
          Break;
        end;
      end;
      if foundit then
        Break;
    end;
    Close(fileRun);
  end;

  if not foundit then
    writeln('No se encontro ningun cliente con el numero de cedula proporcionado.');

  readln;
end;

procedure menu(var parejaData: data; var individualData: data; var acData: data);
var
  option: char;
begin
  repeat
    clrscr;
writeln('============================');
writeln('|       Menu principal      |');
writeln('============================');
writeln('| 1. Agregar reservacion    |');
writeln('| 2. Mostrar reservacion    |');
writeln('| 3. Buscar reservacion     |');
writeln('| 4. Facturar               |');
writeln('| 0. Salir                  |');
writeln('============================');
writeln('---------------------------------');
    write('Seleccione una opcion: ');
    option := ReadKey;
    writeln(option);
    case option of
      '1':begin
      addData(parejaData, individualData, acData);
      fileOpen(parejaData, individualData, acData);
        end;
      '2':begin
        showData(parejaData, individualData, acData);
        fileOpen(parejaData, individualData, acData);
        end;
      '3': 
      begin

      searchData(parejaData, individualData, acData);
      fileOpen(parejaData, individualData, acData);
      end;
      '4': begin
          checkOutBill(parejaData, individualData, acData);
          fileOpen(parejaData, individualData, acData);
      end;
    end;
  until option = '0';
end;

begin
  bienvenida;
  fileOpen(parejaData, individualData, acData);
  menu(parejaData, individualData, acData);
end.
