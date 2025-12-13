<template>
  <div class="quiz-container">
    {{outlet}}
  </div>

  <style scoped>
    .quiz-container {
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
    }

    @media (max-width: 640px) {
      .quiz-container {
        padding: 0;
        height: 100vh;
        display: flex;
        flex-direction: column;
      }
    }
  </style>
</template>
