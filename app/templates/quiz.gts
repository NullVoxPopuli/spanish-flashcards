<template>
  <div>
    {{outlet}}
  </div>

  <style scoped>
    @media (width > 640px) {
      div {
        max-inline-size: 700px;
        margin-inline: auto;
      }
    }

    @media (width <= 640px) {
      div {
        padding: 0;
        block-size: 100vh;
        display: flex;
        flex-direction: column;
      }
    }
  </style>
</template>
