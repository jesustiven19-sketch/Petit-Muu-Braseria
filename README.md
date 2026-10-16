# Petit Muu Braseria · Eixample

Web de una página para Petit Muu Braseria, Plaça del Doctor Letamendi, 28 (Barcelona).

## Archivos

- `index.html`: la web lista para publicar. Usa la carpeta `img/` y las librerías GSAP, ScrollTrigger y Lenis desde CDN.
- `entrega/petit-muu.html`: la misma web en un solo archivo, con las imágenes incrustadas. Se abre con doble clic.
- `src.html`: el código fuente. No se edita `index.html` a mano.
- `icons/`: iconos SVG que se convierten en un sprite al construir.
- `build.ps1`: genera `index.html` y el archivo de `entrega/` a partir de `src.html`.

## Construir

```powershell
.\build.ps1
```
