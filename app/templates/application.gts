<template>

  <div class="app-container">
    {{outlet}}
  </div>

  <style scoped>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
        'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
        sans-serif;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      background: #f7fafc;
    }

    .app-container {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    @media (max-width: 640px) {
      body {
        overflow: hidden;
      }

      .app-container {
        min-height: 100vh;
        max-height: 100vh;
        overflow: hidden;
      }
    }

    h1, h2, h3, h4, h5, h6 {
      margin: 0;
    }

    button {
      font-family: inherit;
    }
  </style>
</template>
