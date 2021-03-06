/****** Object:  StoredProcedure [dbo].[river_GetTestData]    Script Date: 9/23/2014 12:49:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[river_GetTestData]
	 @rows int = 10000
	,@children int = 5
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Create tmp table
	create table #tmpData (
		 [id] int
		,[key] bigint
		,[code] nvarchar(255)
		,[desc] nvarchar(255)
		,[longDesc] nvarchar(1024)
		,[groupId] bigint
		,[groupCode] nvarchar(255)
		,[groupDesc] nvarchar(255)
		,[amount] bigint
		,[total] bigint
		,[allowed] bigint
		,[isActive] bit
		,[createDate] datetime
	);

	-- insert random test data into tmp table
	declare @idx int
	set @idx = 0

	while @idx < @rows
	begin
		declare @inner int
		set @inner = 0

		while @inner < @children
		begin
			insert into #tmpData
			values (
				 @idx
				,abs(cast(cast(newid() as varbinary) as bigint))
				,convert(varchar(255), newid())
				,convert(varchar(255), newid())
				,convert(varchar(1024), newid())
				,abs(cast(cast(newid() as varbinary) as bigint))
				,convert(varchar(255), newid())
				,convert(varchar(255), newid())
				,abs(cast(cast(newid() as binary(8)) as bigint))
				,@inner + 1
				,abs(cast(cast(newid() as binary(8)) as bigint))
				,1
				,getdate()
			)

			set @inner = @inner + 1
		end

		set @idx = @idx + 1
	end

	-- select data out of tmp table
	select
		 'test' as _index
		,'random' as _type
		,id as _id
		,[id]
		,[key] as "key[]"
		,[code] as "code[]"
		,[desc] as "desc[]"
		,[longDesc] as "longDesc[]"
		,[groupId] as "group[_id]"
		,[groupCode] as "group[code]"
		,[groupDesc] as "group[desc]"
		,[amount]
		,[total] as "total[]"
		,[allowed]
		,[isActive]
		,[createDate]
	from #tmpData
	order by _id asc

	drop table #tmpData
END
