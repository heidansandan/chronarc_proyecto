# CHRONARC 🧙✨

**Chronarc** es una aplicación de productividad gamificada desarrollada en Flutter para el proyecto de 2º de DAM. Convierte tus sesiones de enfoque en rituales mágicos.

## 📄 Documentación del Proyecto
Para entender mejor cómo funciona la app o cómo está construida, consulta los manuales:

# 📖 Manual de Usuario: CHRONARC

## 🔮 ¿Qué es Chronarc?

**Chronarc** es una app diseñada para que dejes de procrastinar de una vez.

La idea es que conviertas tus ratos de estudio o trabajo en **"Rituales Arcanos"**.  
Cuanto más te concentres, más nivel subes y más cartas mágicas desbloqueas.

---

## 🚀 Cómo empezar

### 🔐 Login / Registro

Nada más abrir la app, verás una pantalla mística.

Si es tu primera vez, pon tu correo y contraseña y dale a **"Registrarse"**.

Se te creará un perfil con:

- **100 de Esencia**
- **Nivel 1**

---

## 🏠 Pantalla Principal: Run de hoy

Aquí verás tu avatar y tu nivel.

Lo más guapo es que, según el tiempo que haga en tu ciudad, te saldrán rituales distintos.

> Usamos la ubicación de **Madrid** por defecto.

Ejemplos:

- Si llueve, toca limpieza.
- Si hace sol, toca meditación.

---

## 🕯️ Iniciar un Ritual

Para iniciar un ritual:

1. Elige un ritual de la lista.
2. Verás un cronómetro circular.
3. ¡No cierres la app!
4. Concéntrate hasta que llegue a cero.

Al acabar, te daremos:

- **XP** para subir nivel.
- **Esencia** como moneda del juego.

---

## 📚 El Códice: Coleccionismo

### ✨ ¿Para qué sirve la Esencia?

La **Esencia** sirve para ir a la pestaña del **Códice**.

---

## 🃏 Invocar

Te gastas **100 de Esencia** e invocas una carta.

Te puede salir una carta común como:

- **Fuego Fatuo**

O una carta legendaria como:

- **Fénix**

---

## 🔁 Repetidas

Si te sale una carta que ya tienes, no pasa nada.

Te devolvemos:

- **50 de Esencia**

---

## 🗂️ Colección

En la otra pestaña puedes ver todas las cartas que ya has descubierto.

¡Intenta pillarlas todas!

---

## 👤 Perfil

Aquí puedes ver tus estadísticas totales.

Si le das al emoji de tu avatar, puedes cambiarlo por otro que mole más, como por ejemplo:

- 🧙 Mago
- 🐉 Dragón
- 💎 Cristal

# 🛠️ Manual Técnico: CHRONARC

## 📌 Proyecto 2º DAM

---

## 💻 Introducción Técnica

**Chronarc** es una aplicación multiplataforma programada con el framework **Flutter** y el lenguaje **Dart**.

Para toda la parte del servidor, incluyendo base de datos y usuarios, he usado **Firebase**.

---

## 🏗️ Arquitectura del Sistema

He organizado el código siguiendo una estructura limpia para no volverme loco:

```txt
lib/
├── screens/
├── services/
└── widgets/


## 🛠️ Tecnologías utilizadas
* **Frontend:** Flutter & Dart
* **Backend:** Firebase (Auth & Firestore)
* **API:** OpenWeatherMap API
