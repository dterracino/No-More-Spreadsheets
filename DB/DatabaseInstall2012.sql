USE [master]
GO
/****** Object:  Database [pricing]    Script Date: 04/12/2012 08:45:51 ******/
CREATE DATABASE [pricing]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'pricing', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\pricing.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'pricing_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\pricing_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [pricing] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [pricing].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [pricing] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [pricing] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [pricing] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [pricing] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [pricing] SET ARITHABORT OFF 
GO
ALTER DATABASE [pricing] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [pricing] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [pricing] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [pricing] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [pricing] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [pricing] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [pricing] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [pricing] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [pricing] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [pricing] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [pricing] SET  DISABLE_BROKER 
GO
ALTER DATABASE [pricing] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [pricing] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [pricing] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [pricing] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [pricing] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [pricing] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [pricing] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [pricing] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [pricing] SET  MULTI_USER 
GO
ALTER DATABASE [pricing] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [pricing] SET DB_CHAINING OFF 
GO
ALTER DATABASE [pricing] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [pricing] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [pricing]
GO
/****** Object:  User [pricing]    Script Date: 04/12/2012 08:45:51 ******/
CREATE USER [pricing] FOR LOGIN [pricing] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [pricing]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [pricing]
GO
/****** Object:  StoredProcedure [dbo].[AttachProductLineToPackage]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AttachProductLineToPackage]
	-- Add the parameters for the stored procedure here
	@PackageId int,
	@ProductLineId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [PackagesProductLinesLinks] ([PackageId],[ProductLineId]) VALUES( @PackageId, @ProductLineId ) ;
END


GO
/****** Object:  StoredProcedure [dbo].[AttachProductLineToPricelist]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AttachProductLineToPricelist]
	-- Add the parameters for the stored procedure here
	@ProductLineId int,
	@PricelistId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [PricelistsProductLinesLinks] ([PricelistId],[ProductLineId]) VALUES ( @PricelistId, @ProductLineId ) ;
END


GO
/****** Object:  StoredProcedure [dbo].[AttachProductLineToProduct]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AttachProductLineToProduct]
	-- Add the parameters for the stored procedure here
	@ProductId int,
	@ProductLineId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [ProductsProductLinesLinks] ([ProductId],[ProductLineId]) VALUES( @ProductId, @ProductLineId ) ;
END


GO
/****** Object:  StoredProcedure [dbo].[AttachProductToPackageComponent]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AttachProductToPackageComponent]
	-- Add the parameters for the stored procedure here
	@PackageComponentId int,
	@ProductId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [PackageComponentsProductsLinks] ([PackageComponentId],[ProductId]) VALUES( @PackageComponentId, @ProductId ) ;
END


GO
/****** Object:  StoredProcedure [dbo].[ClearItems]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ClearItems]
	@QuoteId int
AS
	DELETE FROM [QuoteItems] WHERE [QuoteItems].[QuoteId] = @QuoteId;
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[ClearPackageComponentsProductsLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClearPackageComponentsProductsLinks]
	-- Add the parameters for the stored procedure here
	@PackageComponentId int
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [PackageComponentsProductsLinks] WHERE [PackageComponentId] = @PackageComponentId;
END


GO
/****** Object:  StoredProcedure [dbo].[ClearPackagePackageComponents]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClearPackagePackageComponents] 
	-- Add the parameters for the stored procedure here
	@PackageId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [PackageComponentsProductsLinks] WHERE [PackageComponentId] IN (SELECT [Id] FROM [PackageComponents] WHERE [PackageId] = @PackageId ) ;
	DELETE FROM [PackageComponents] WHERE [PackageId] = @PackageId 
END

GO
/****** Object:  StoredProcedure [dbo].[ClearPackagesProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClearPackagesProductLinesLinks]
	-- Add the parameters for the stored procedure here
	@PackageId int
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [PackagesProductLinesLinks] WHERE [PackageId] = @PackageId
END


GO
/****** Object:  StoredProcedure [dbo].[ClearPricelistsProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClearPricelistsProductLinesLinks]
	-- Add the parameters for the stored procedure here
	@PricelistId int
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [PricelistsProductLinesLinks] WHERE [PricelistId] = @PricelistId;
END


GO
/****** Object:  StoredProcedure [dbo].[ClearProductsProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClearProductsProductLinesLinks]
	-- Add the parameters for the stored procedure here
	@ProductId int
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [ProductsProductLinesLinks] WHERE [ProductId] = @ProductId
END


GO
/****** Object:  StoredProcedure [dbo].[CloseQuote]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CloseQuote] 
	-- Add the parameters for the stored procedure here
	@QuoteId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [Quotes] SET [Status] = 'closed', [ClosedDate] = CURRENT_TIMESTAMP WHERE [Id] = @QuoteId;
END


GO
/****** Object:  StoredProcedure [dbo].[CreateQuote]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateQuote]
	@OwnerId int,
	@CustomerId NCHAR(255),
	@CustomerName NCHAR(255),
	@PricelistId int,
	@QuoteTitle NCHAR(255)
AS
	INSERT INTO [Quotes] (
		[OwnerId], 
		[CustomerId],
		[CustomerName],
		[PricelistId], 
		[Title], 
		[Status],
		[CreatedDate],
		[LastChanged]) 
		VALUES ( 
			@OwnerId, 
			@CustomerId, 
			@CustomerName,
			@PricelistId, 
			@QuoteTitle, 
			'draft',
			CURRENT_TIMESTAMP,
			CURRENT_TIMESTAMP
			);
RETURN @@IDENTITY

GO
/****** Object:  StoredProcedure [dbo].[DeletePackage]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeletePackage]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [Packages] WHERE [Id] = @Id;
	DELETE FROM [PackagesProductLinesLinks] WHERE [PackageId] = @Id;
	DELETE FROM [PackageComponents] WHERE [PackageId] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[DeletePricelist]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeletePricelist]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [Pricelists] WHERE [Id] = @Id;
	DELETE FROM [PricelistItems] WHERE [PricelistId] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteProduct]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProduct]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [Products] WHERE [Id] = @Id;
	DELETE FROM [PricelistItems] WHERE [PricelistItems].[ProductId] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteProductLine]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProductLine] 
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [ProductLines] WHERE [Id] = @Id;
	DELETE FROM [PricelistsProductLinesLinks] WHERE [PricelistsProductLinesLinks].ProductLineId = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[GetAllPricelists]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPricelists]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Pricelists].*, [Users].[RealName] AS [OwnerName] FROM Pricelists LEFT OUTER JOIN [Users] ON [Users].Id = [Pricelists].[OwnerId] ORDER BY [Pricelists].[Name] ASC;
END


GO
/****** Object:  StoredProcedure [dbo].[GetAllProductLines]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllProductLines]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [ProductLines] ORDER BY [ProductLines].[Name] ASC;
END


GO
/****** Object:  StoredProcedure [dbo].[GetAllProducts]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllProducts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [Products] ORDER BY [Products].[Group] ASC, [Products].[Subgroup] ASC, [Products].[Title] ASC; 
END


GO
/****** Object:  StoredProcedure [dbo].[GetAllQuotesForUser]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllQuotesForUser]
	@UserId int
AS
	SELECT [Quotes].*,[Users].[RealName] AS [OwnerName] FROM Quotes LEFT OUTER JOIN [Users] ON [Users].Id = [Quotes].[OwnerId]  WHERE OwnerId = @UserId AND Status IN ('draft','live') ORDER BY [Quotes].CreatedDate DESC;
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetAllUsers]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllUsers]

AS
	SELECT * FROM Users ORDER BY [Users].[RealName] ASC;
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetPackage]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPackage]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [Packages] WHERE [Id] = @Id
END


GO
/****** Object:  StoredProcedure [dbo].[GetPackageComponent]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPackageComponent]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [PackageComponents] WHERE [Id] = @Id
END


GO
/****** Object:  StoredProcedure [dbo].[GetPackageComponentsInPackage]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPackageComponentsInPackage] 
	-- Add the parameters for the stored procedure here
	@PackageId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [PackageComponents] WHERE [PackageId] = @PackageId;
END

GO
/****** Object:  StoredProcedure [dbo].[GetPackageComponentsProductsLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPackageComponentsProductsLinks]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [ProductId] FROM [PackageComponentsProductsLinks] WHERE [PackageComponentId] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[GetPackageProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPackageProductLinesLinks]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [ProductLineId] FROM [PackagesProductLinesLinks] WHERE [PackageId] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[GetPackages]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPackages] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Packages ;
END


GO
/****** Object:  StoredProcedure [dbo].[GetPackagesInProductLine]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPackagesInProductLine]
	@ProductLineId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Packages].* FROM [PackagesProductLinesLinks] INNER JOIN [Packages] ON [Packages].[Id] = [PackagesProductLinesLinks].[PackageId] WHERE [PackagesProductLinesLinks].[ProductLineId] = @ProductLineId;
END


GO
/****** Object:  StoredProcedure [dbo].[GetPricedPackagesToQuote]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPricedPackagesToQuote]
	@PricelistId int,
	@ProductLineId int
AS
	SELECT [Packages].*, SetupPrice, RecurringPrice, SetupCost, RecurringCost FROM [PricelistItems] 
		INNER JOIN [Packages] ON [PricelistItems].[PackageId] = [Packages].[Id]
		INNER JOIN [PackagesProductLinesLinks] ON [PackagesProductLinesLinks].[PackageId] = [Packages].[Id]
		INNER JOIN [ProductLines] ON [PackagesProductLinesLinks].[ProductLineId] = [ProductLines].[Id]
		 WHERE [PricelistItems].[PricelistId] = @PricelistId 
		 AND [ProductLines].[Id] = @ProductLineId
		ORDER BY [Packages].Title ASC
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetPricedProduct]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPricedProduct]
	@PricelistId int,
	@ProductId int
AS
	SELECT [Products].*, PricelistId, SetupPrice, RecurringPrice, SetupCost, RecurringCost FROM [PricelistItems] 
		INNER JOIN [Products] ON [PricelistItems].[ProductId] = [Products].[Id]
		 WHERE [PricelistItems].[PricelistId] = @PricelistId 
		 AND [Products].[Id] = @ProductId
		ORDER BY [Products].[Group] ASC,[Products].[Subgroup] ASC
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetPricedProductsToQuote]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPricedProductsToQuote]
	@PricelistId int,
	@ProductLineId int
AS
	SELECT [Products].*, PricelistId, SetupPrice, RecurringPrice, SetupCost, RecurringCost FROM [PricelistItems] 
		INNER JOIN [Products] ON [PricelistItems].[ProductId] = [Products].[Id]
		INNER JOIN [ProductsProductLinesLinks] ON [ProductsProductLinesLinks].[ProductId] = [Products].[Id]
		INNER JOIN [ProductLines] ON [ProductsProductLinesLinks].[ProductLineId] = [ProductLines].[Id]
		 WHERE [PricelistItems].[PricelistId] = @PricelistId 
		 AND [ProductLines].[Id] = @ProductLineId
		ORDER BY [Products].[Group] ASC,[Products].[Subgroup] ASC
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetPricelist]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPricelist]
	-- Add the parameters for the stored procedure here
	@Id int = 0
	AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 * FROM [Pricelists] WHERE [Pricelists].[Id] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[GetPricelistProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPricelistProductLinesLinks]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [ProductLineId] FROM [PricelistsProductLinesLinks] WHERE [PricelistId] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[GetPricelistsForUser]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anthony Shaw
-- Create date: 21-08-12
-- Description:	Get the quotes for a user
-- =============================================
CREATE PROCEDURE [dbo].[GetPricelistsForUser]
	-- Add the parameters for the stored procedure here
	@UserId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Pricelists].*,[Users].[RealName] AS [OwnerName] FROM Pricelists LEFT OUTER JOIN [Users] ON [Users].Id = [Pricelists].[OwnerId]  WHERE OwnerId = @UserId ORDER BY [Pricelists].Name;
END


GO
/****** Object:  StoredProcedure [dbo].[GetProduct]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProduct]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [Products] WHERE [Id] = @Id
END


GO
/****** Object:  StoredProcedure [dbo].[GetProductLine]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductLine]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [ProductLines] WHERE [Id] = @Id
END


GO
/****** Object:  StoredProcedure [dbo].[GetProductProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductProductLinesLinks]
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [ProductLineId] FROM [ProductsProductLinesLinks] WHERE [ProductId] = @Id;
END


GO
/****** Object:  StoredProcedure [dbo].[GetProductsAvailableToQuote]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductsAvailableToQuote]
	@QuoteId int 
AS
	DECLARE @PricelistId int
	SELECT @PricelistId = [Quotes].[PricelistId] FROM [Quotes] WHERE [Quotes].[Id] = @QuoteId 
	SELECT * FROM [PricelistItems] 
		INNER JOIN [Products] ON [PricelistItems].[ProductId] = [Products].[Id]
		 WHERE [PricelistItems].[PricelistId] = @PricelistId 
		ORDER BY [Products].[Group] ASC,[Products].[Subgroup] ASC
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetQuote]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetQuote]
	@Id int = 0
AS
	SELECT TOP 1 * FROM  [Quotes] WHERE [Id] = @Id ;
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[GetQuoteItems]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetQuoteItems]
	@QuoteId int 
AS
	SELECT 
		[QuoteItems].*, 
		([QuoteItems].[RecurringPrice]*[QuoteItems].[Quantity]) AS [TotalRecurringPrice], 
		([QuoteItems].[SetupPrice]*[QuoteItems].[Quantity]) AS [TotalSetupPrice]
	FROM [QuoteItems] 
		LEFT OUTER JOIN 
			[Products] ON [Products].[Id] = [QuoteItems].[ProductId]
		WHERE 
			[QuoteItems].[QuoteId] = @QuoteId 
		ORDER BY 
			[QuoteItems].[GroupName] ASC, 
			[QuoteItems].[Index] ASC,
			[QuoteItems].[Title] ASC
RETURN 0

GO
/****** Object:  Table [dbo].[PackageComponents]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageComponents](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [ntext] NOT NULL,
	[AllowMultiple] [bit] NOT NULL,
	[PackageId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PackageComponentsProductsLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageComponentsProductsLinks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageComponentId] [int] NOT NULL,
	[ProductId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Packages]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Packages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nchar](255) NOT NULL,
	[Configurable] [bit] NOT NULL,
	[InheritPrice] [bit] NOT NULL,
	[InheritCost] [bit] NOT NULL,
	[DescriptionTemplate] [ntext] NOT NULL,
	[Partcode] [nchar](255) NOT NULL,
	[Manufacturer] [nchar](255) NULL,
	[Availability] [nchar](32) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PackagesProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackagesProductLinesLinks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductLineId] [int] NOT NULL,
	[PackageId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PricelistItems]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PricelistItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PricelistId] [int] NULL,
	[PackageId] [int] NULL,
	[ProductId] [int] NULL,
	[SetupPrice] [float] NULL,
	[RecurringPrice] [float] NULL,
	[SetupCost] [float] NULL,
	[RecurringCost] [float] NULL,
 CONSTRAINT [PK_PricelistItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Pricelists]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pricelists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Date] [datetime] NOT NULL,
	[IsPrivate] [bit] NOT NULL,
	[OwnerId] [int] NULL,
	[IsDefault] [bit] NOT NULL,
	[Currency] [nchar](10) NULL,
 CONSTRAINT [PK__Table__3214EC07057480B0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PricelistsProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PricelistsProductLinesLinks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PricelistId] [int] NOT NULL,
	[ProductLineId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PrintLog]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrintLog](
	[Id] [int] NOT NULL,
	[QuoteId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Command] [nchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductLines]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductLines](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](255) NOT NULL,
	[Description] [ntext] NULL,
	[ProductManager] [nchar](255) NULL,
	[LineOfBusiness] [nchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nchar](255) NULL,
	[Description] [ntext] NULL,
	[Group] [nchar](255) NULL,
	[Partcode] [nchar](255) NULL,
	[SubGroup] [nchar](255) NULL,
	[Availability] [nchar](32) NULL,
	[InternalNotes] [ntext] NULL,
	[Manufacturer] [nchar](255) NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductsProductLinesLinks]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductsProductLinesLinks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductLineId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuoteItems]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuoteItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QuoteId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Title] [nchar](255) NULL,
	[Description] [ntext] NULL,
	[Quantity] [smallint] NOT NULL,
	[SetupPrice] [float] NOT NULL,
	[RecurringPrice] [float] NOT NULL,
	[SetupCost] [float] NOT NULL,
	[RecurringCost] [float] NOT NULL,
	[TotalSetupPrice] [float] NOT NULL,
	[TotalRecurringPrice] [float] NOT NULL,
	[GroupName] [nchar](255) NULL,
	[SubGroupName] [nchar](255) NULL,
	[Partcode] [nchar](255) NULL,
	[Notes] [ntext] NULL,
	[Index] [smallint] NULL,
	[IsPackage] [bit] NOT NULL,
	[PackageId] [int] NULL,
	[PackageConfigJson] [ntext] NULL,
 CONSTRAINT [PK_QuoteItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuoteItemsHistory]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuoteItemsHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QuoteId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Title] [nchar](255) NULL,
	[Description] [ntext] NULL,
	[Quantity] [smallint] NOT NULL,
	[SetupPrice] [float] NOT NULL,
	[RecurringPrice] [float] NOT NULL,
	[SetupCost] [float] NOT NULL,
	[RecurringCost] [float] NOT NULL,
	[GroupName] [nchar](255) NULL,
	[SubGroupName] [nchar](255) NULL,
	[Partcode] [nchar](255) NULL,
	[Notes] [ntext] NULL,
	[Index] [smallint] NULL,
	[IsBundle] [bit] NOT NULL,
	[IsPart] [bit] NOT NULL,
	[BundleId] [int] NULL,
	[Revision] [int] NULL,
 CONSTRAINT [PK_QuoteItemsHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuoteLog]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuoteLog](
	[Id] [int] NOT NULL,
	[QuoteId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Total] [float] NOT NULL,
	[Revision] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Quotes]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quotes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OwnerId] [int] NULL,
	[CustomerId] [nchar](255) NULL,
	[CustomerName] [nchar](255) NULL,
	[PricelistId] [int] NULL,
	[Title] [nchar](255) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[LastChanged] [datetime] NULL,
	[DiscountPercent] [float] NOT NULL,
	[DiscountPercent24] [float] NOT NULL,
	[DiscountPercent36] [float] NOT NULL,
	[DiscountWritein] [float] NOT NULL,
	[DiscountPercentSetup] [float] NOT NULL,
	[TotalValue] [float] NOT NULL,
	[TotalSetupValue] [float] NOT NULL,
	[ClosedDate] [datetime] NULL,
	[ContractLengthMonths] [smallint] NOT NULL,
	[Revision] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK__Quotes__3214EC078CC1B559] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 04/12/2012 08:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RealName] [nchar](255) NULL,
	[Email] [nchar](255) NULL,
	[Password] [nchar](255) NULL,
	[Team] [nchar](10) NULL,
	[Permissions] [nchar](10) NULL,
 CONSTRAINT [PK__Table__3214EC0700D8C066] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_Availability]  DEFAULT (N'available') FOR [Availability]
GO
ALTER TABLE [dbo].[Pricelists] ADD  CONSTRAINT [DF__Table__Pricelist__2F10007B]  DEFAULT ((0)) FOR [IsPrivate]
GO
ALTER TABLE [dbo].[Pricelists] ADD  CONSTRAINT [DF__Table__Pricelist__300424B4]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[PrintLog] ADD  DEFAULT ('pdf') FOR [Command]
GO
ALTER TABLE [dbo].[QuoteItems] ADD  CONSTRAINT [DF_QuoteItems_Quantity]  DEFAULT ((1)) FOR [Quantity]
GO
ALTER TABLE [dbo].[QuoteItems] ADD  CONSTRAINT [DF_QuoteItems_SetupPrice]  DEFAULT ((0)) FOR [SetupPrice]
GO
ALTER TABLE [dbo].[QuoteItems] ADD  CONSTRAINT [DF_QuoteItems_RecurringPrice]  DEFAULT ((0)) FOR [RecurringPrice]
GO
ALTER TABLE [dbo].[QuoteItems] ADD  CONSTRAINT [DF_QuoteItems_SetupCost]  DEFAULT ((0)) FOR [SetupCost]
GO
ALTER TABLE [dbo].[QuoteItems] ADD  CONSTRAINT [DF_QuoteItems_RecurringCost]  DEFAULT ((0)) FOR [RecurringCost]
GO
ALTER TABLE [dbo].[QuoteItems] ADD  CONSTRAINT [DF_QuoteItems_IsBundle]  DEFAULT ((0)) FOR [IsPackage]
GO
ALTER TABLE [dbo].[QuoteItemsHistory] ADD  CONSTRAINT [DF_QuoteItemsHistory_Quantity]  DEFAULT ((1)) FOR [Quantity]
GO
ALTER TABLE [dbo].[QuoteItemsHistory] ADD  CONSTRAINT [DF_QuoteItemsHistory_SetupPrice]  DEFAULT ((0)) FOR [SetupPrice]
GO
ALTER TABLE [dbo].[QuoteItemsHistory] ADD  CONSTRAINT [DF_QuoteItemsHistory_RecurringPrice]  DEFAULT ((0)) FOR [RecurringPrice]
GO
ALTER TABLE [dbo].[QuoteItemsHistory] ADD  CONSTRAINT [DF_QuoteItemsHistory_SetupCost]  DEFAULT ((0)) FOR [SetupCost]
GO
ALTER TABLE [dbo].[QuoteItemsHistory] ADD  CONSTRAINT [DF_QuoteItemsHistory_RecurringCost]  DEFAULT ((0)) FOR [RecurringCost]
GO
ALTER TABLE [dbo].[QuoteItemsHistory] ADD  CONSTRAINT [DF_QuoteItemsHistory_IsBundle]  DEFAULT ((0)) FOR [IsBundle]
GO
ALTER TABLE [dbo].[QuoteItemsHistory] ADD  CONSTRAINT [DF_QuoteItemsHistory_IsPart]  DEFAULT ((0)) FOR [IsPart]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteSta__239E4DCF]  DEFAULT ('draft') FOR [Status]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteDis__24927208]  DEFAULT ((0)) FOR [DiscountPercent]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteDis__25869641]  DEFAULT ((0)) FOR [DiscountPercent24]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteDis__267ABA7A]  DEFAULT ((0)) FOR [DiscountPercent36]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteDis__276EDEB3]  DEFAULT ((0)) FOR [DiscountWritein]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteDis__286302EC]  DEFAULT ((0)) FOR [DiscountPercentSetup]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteTot__29572725]  DEFAULT ((0)) FOR [TotalValue]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteTot__2A4B4B5E]  DEFAULT ((0)) FOR [TotalSetupValue]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteCon__2B3F6F97]  DEFAULT ((12)) FOR [ContractLengthMonths]
GO
ALTER TABLE [dbo].[Quotes] ADD  CONSTRAINT [DF__Quotes__QuoteRev__2C3393D0]  DEFAULT ((1)) FOR [Revision]
GO
USE [master]
GO
ALTER DATABASE [pricing] SET  READ_WRITE 
GO
