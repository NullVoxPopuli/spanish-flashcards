<template>
  {{outlet}}

  <style>
    body {
      font-family: var(--font-sans);
      background: var(--gray-1);
    }

    @media (width <= 640px) {
      body {
        overflow: hidden;
        block-size: 100vh;
      }
    }
  </style>
</template>
