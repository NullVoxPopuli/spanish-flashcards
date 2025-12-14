<template>
  <div style="max-inline-size: var(--size-content-3); margin-inline: auto; padding: var(--size-5);">
    {{outlet}}
  </div>

  <style scoped>
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
