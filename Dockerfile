FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY SampleWebApplication/*.sln .
COPY SampleWebApplication/MVC5App/*.csproj ./aspnetmvcapp/
COPY SampleWebApplication/MVC5App/*.config ./aspnetmvcapp/
RUN nuget restore

# copy everything else and build app
COPY SampleWebApplication/MVC5App/. ./aspnetmvcapp/
WORKDIR /app/aspnetmvcapp
RUN msbuild /p:Configuration=Release -r:False


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/aspnetmvcapp/. ./
