# README

## Importar códigos desde xlsx

Primeramente, se utilizó libreoffice para convertir los archivos xlsx a csv.
Se copiaron los archivos en la carpeta db/seeds/codes/ y se utilizó el script xlsx_to_csv.sh para convertirlos.

```bash
chmod +x xlsx_to_csv.sh
./xlsx_to_csv.sh
```

En producción, Se copia en el server utilizando rsync:

```bash
rsync -avz db/seeds/codes/ root@server:/project/db/seeds/codes/
```

Luego se ejecuta el seeder de códigos `db/seeds/002_codes.rb` (tiempo de ejecución ~13 min.)

```bash
rails db:seed FILE=002
```

