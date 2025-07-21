FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app


# Proje dosyalarını kopyala
COPY *.csproj ./
RUN dotnet restore

# Kalan tüm dosyaları kopyala
COPY . .
WORKDIR /app

# Projeyi yayımlama
RUN dotnet publish -c Release -o out

#  Nihai imaj
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/out .

# Uygulama protu
EXPOSE 8080 

ENTRYPOINT ["dotnet", "pet_store.dll"] # Proje adını