FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src
COPY ["src/ktragiuaki.Web.Host/ktragiuaki.Web.Host.csproj", "src/ktragiuaki.Web.Host/"]
COPY ["src/ktragiuaki.Web.Core/ktragiuaki.Web.Core.csproj", "src/ktragiuaki.Web.Core/"]
COPY ["src/ktragiuaki.Application/ktragiuaki.Application.csproj", "src/ktragiuaki.Application/"]
COPY ["src/ktragiuaki.Core/ktragiuaki.Core.csproj", "src/ktragiuaki.Core/"]
COPY ["src/ktragiuaki.EntityFrameworkCore/ktragiuaki.EntityFrameworkCore.csproj", "src/ktragiuaki.EntityFrameworkCore/"]
WORKDIR "/src/src/ktragiuaki.Web.Host"
RUN dotnet restore 

WORKDIR /src
COPY ["src/ktragiuaki.Web.Host", "src/ktragiuaki.Web.Host"]
COPY ["src/ktragiuaki.Web.Core", "src/ktragiuaki.Web.Core"]
COPY ["src/ktragiuaki.Application", "src/ktragiuaki.Application"]
COPY ["src/ktragiuaki.Core", "src/ktragiuaki.Core"]
COPY ["src/ktragiuaki.EntityFrameworkCore", "src/ktragiuaki.EntityFrameworkCore"]
WORKDIR "/src/src/ktragiuaki.Web.Host"
RUN dotnet publish -c Release -o /publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
EXPOSE 80
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "ktragiuaki.Web.Host.dll"]
