FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

RUN dotnet tool install -g Microsoft.Web.LibraryManager.Cli
RUN ln -s ~/.dotnet/tools/libman /usr/local/bin/libman

WORKDIR /src
COPY ["src/ktragiuaki.Web.Mvc/ktragiuaki.Web.Mvc.csproj", "src/ktragiuaki.Web.Mvc/"]
COPY ["src/ktragiuaki.Web.Core/ktragiuaki.Web.Core.csproj", "src/ktragiuaki.Web.Core/"]
COPY ["src/ktragiuaki.Application/ktragiuaki.Application.csproj", "src/ktragiuaki.Application/"]
COPY ["src/ktragiuaki.Core/ktragiuaki.Core.csproj", "src/ktragiuaki.Core/"]
COPY ["src/ktragiuaki.EntityFrameworkCore/ktragiuaki.EntityFrameworkCore.csproj", "src/ktragiuaki.EntityFrameworkCore/"]
WORKDIR "/src/src/ktragiuaki.Web.Mvc"
RUN dotnet restore 

WORKDIR /src
COPY ["src/ktragiuaki.Web.Mvc", "src/ktragiuaki.Web.Mvc"]
COPY ["src/ktragiuaki.Web.Core", "src/ktragiuaki.Web.Core"]
COPY ["src/ktragiuaki.Application", "src/ktragiuaki.Application"]
COPY ["src/ktragiuaki.Core", "src/ktragiuaki.Core"]
COPY ["src/ktragiuaki.EntityFrameworkCore", "src/ktragiuaki.EntityFrameworkCore"]
WORKDIR "/src/src/ktragiuaki.Web.Mvc"
RUN libman restore
RUN dotnet publish -c Release -o /publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
EXPOSE 80
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "ktragiuaki.Web.Mvc.dll"]
