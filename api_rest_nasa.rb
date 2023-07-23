# Sergio Dominguez
# Desafío - Arreglos, hashes y APIs

# Carga las librerías URL, net/http y json
require 'uri'
require 'net/http'
require 'json'

# 1. Crear el método request que reciba una url y retorne el hash con los resultados.
def request(url_requested)
    url = URI(url_requested)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(url)
    # request["cache-control"] = 'no-cache'
    # request["postman-token"] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'
    response = http.request(request)
    # return JSON.parse(response.body)

    var_json =  JSON.parse(response.body) 
    var_hash = var_json["photos"] # Convierte la respuesta a hash usando "photos" de cabecera
    return var_hash 
end

# Crear un método llamado buid_web_page que reciba el hash de respuesta con todos
# los datos y construya una página web. Se evaluará la página creada

def build_web_page (respuesta)
    # Transforma el Hash a Array
    photos = respuesta.to_a 
    # Creacion de sintasis html
    html = "<html>\n"
    html += "  <head>\n"
    html += "  </head>\n"
    html += "  <body>\n"
    html += "    <ul>\n"

    # rutina para añadir las imagenes al html
    photos.each do |photo|
        html += "      <li><img src=\"#{photo["img_src"].to_s}\"></li>\n"
    end

    # Creacion de sintasis html
    html += "    </ul>\n"
    html += "  </body>\n"
    html += "</html>"

    # generacion de archivo html
    File.write('nasa_api.html', html)
    puts "HTML Creado  -> nasa_api.html"
end

# 3. Crear un método photos_count que reciba el hash de respuesta y devuelva un nuevo
# hash con el nombre de la cámara y la cantidad de fotos.
def photos_count (respuesta)
    # Transforma el Hash a Array
    fotos = respuesta.to_a 
    # Crea el hash contador
    contador = Hash.new(0) 
    # Por cada dato en fotos guarda el nombre y suma 1 al contador
    fotos.each do |foto| 
      camara = foto["camera"]["name"]
      contador[camara] += 1
    end

    # Imprime el hash contador
    print "El hash de conteo es: "
    puts contador
end

# previamente cree las credenciales, adicionalmente acotamos la solicitud de fotos a solo 10
data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=H1VfNZZeBXfto5gcK6CXNZ82QvL0KpYgQcBdg8kl")
# print data
# puts('*****************')
# photos = data.map{|x| x['img_src']}
# print photos
# puts('*****************')
# contruccion de html
build_web_page(data)
# conteo de fotos por camara
photos_count(data)