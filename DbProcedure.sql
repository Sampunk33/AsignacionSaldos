-- Crea la base de datos
CREATE DATABASE Gestores;
GO

-- Usa la base de datos
USE Gestores;
GO

-- Crea la tabla Gestores
CREATE TABLE dbo.Gestores (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);
GO

-- Inserta datos
INSERT INTO dbo.Gestores (Id, Nombre) VALUES
(1, 'Gestor 1'),
(2, 'Gestor 2'),
(3, 'Gestor 3'),
(4, 'Gestor 4'),
(5, 'Gestor 5'),
(6, 'Gestor 6'),
(7, 'Gestor 7'),
(8, 'Gestor 8'),
(9, 'Gestor 9'),
(10, 'Gestor 10');
GO

-- Crea el procedimiento almacenado
CREATE PROCEDURE AsignarSaldos
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Saldos TABLE (Saldo DECIMAL(18, 2));
    DECLARE @Gestores TABLE (Id INT);
    DECLARE @TotalGestores INT;

    -- Agregar los saldos a la tabla temporal
    INSERT INTO @Saldos (Saldo)
    VALUES (2277), (3953), (4726), (1414), (627), (1784), (1634), (3958), (2156),
           (1347), (2166), (820), (2325), (3613), (2389), (4130), (2007), (3027),
           (2591), (3940), (3888), (2975), (4470), (2291), (3393), (3588), (3286),
           (2293), (4353), (3315), (4900), (794), (4424), (4505), (2643), (2217),
           (4193), (2893), (4120), (3352), (2355), (3219), (3064), (4893), (272),
           (1299), (4725), (1900), (4927), (4011);

    -- Obtener los gestores (debe haber 10)
    INSERT INTO @Gestores (Id)
    SELECT TOP 10 Id FROM dbo.Gestores;

    SET @TotalGestores = (SELECT COUNT(*) FROM @Gestores);

    -- Verificar que haya gestores antes de continuar
    IF @TotalGestores = 0
    BEGIN
        RAISERROR('No hay gestores disponibles para asignar saldos.', 16, 1);
        RETURN; -- Termina la ejecución del procedimiento si no hay gestores
    END

    -- Crear la tabla de resultados
    CREATE TABLE #SaldosAsignados (GestorId INT, Saldo DECIMAL(18, 2));

    -- Asignar saldos a gestores
    DECLARE @Index INT = 0; -- Cambiado a 0 para facilitar el cálculo
    DECLARE @Saldo DECIMAL(18, 2);
    DECLARE @GestorId INT;

    -- Ordenar los saldos en orden descendente
    DECLARE cur CURSOR FOR
    SELECT Saldo FROM @Saldos ORDER BY Saldo DESC;

    OPEN cur;

    FETCH NEXT FROM cur INTO @Saldo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcular el Gestor correspondiente
        SET @GestorId = (SELECT Id FROM @Gestores ORDER BY Id OFFSET (@Index % @TotalGestores) ROWS FETCH NEXT 1 ROWS ONLY);
        
        -- Insertar el saldo asignado
        INSERT INTO #SaldosAsignados (GestorId, Saldo) VALUES (@GestorId, @Saldo);

        -- Incrementar el índice para asignar al siguiente gestor
        SET @Index = @Index + 1;

        FETCH NEXT FROM cur INTO @Saldo;
    END

    CLOSE cur;
    DEALLOCATE cur;

    -- Retornar los resultados
    SELECT * FROM #SaldosAsignados;

    DROP TABLE #SaldosAsignados;
END;
GO

