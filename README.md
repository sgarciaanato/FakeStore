# Prueba técnica

Aplicación de prueba técnica en la que intentamos replicar un MVP de tienda electrónica apuntando a `https://fakestoreapi.com/`

## Que tiene

* Listado de productos
* Detalle de productos
* Listado de categorías
* Vista del carrito
* Pruebas del carrito

## Consideraciones

* Entre los requerimientos se pedia manejar las pantallas del Home y Carrito en un TabBar. En el proyecto resultante se cambió el acceso a un BarButton, lo que parece ser un comportamiento más natural para la funcionalidad de carrito
* La persistencia del carrito se maneja por UserDefaults. por limitaciones de Apple el guardado no toma efecto inmediantamente porque espera a hacer varios cambios simultáneamente. El gatillante para el guardado suele ser funciones del ciclo de vida de la aplicación, por lo que hacer cambios en el carrito y forzar el reload por un llamado de `Run` o `Stop` interrumpe el ciclo de vida de la aplicación y puede causar fallas en la persistencia

## Funcionalidades especiales

* Compositional Layout en el Home y en el Carrito
* DiffableDataSource en el Home y en el Carrito
* Soporte Light mode y Dark mode
* Soporte de lenguaje Ingles y Español
* Animaciones
  - Agregar un producto al carrito anima la imagen del producto hacia el botón del carrito
  - Luego de la animación de la imagen al carrito este salta por un segundo
  - Presionar el botón de más en un producto que no está agregado anima el stepper expandiéndolo y dando visibilidad al contador y al botón de reducir la cantidad
  - Llegar el producto agregado a 0 elimina el producto del carro y reduce el stepper
  - Hacer una compra anima la aparición y desaparición de un mensaje de éxito
  - Efecto de shimmer al cargar el home
