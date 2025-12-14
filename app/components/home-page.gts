import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';
import { properLinks } from 'ember-primitives/proper-links';
import type CardProgressService from '#app/services/card-progress.ts';

@properLinks
export default class HomePage extends Component {
  @service('card-progress') declare cardProgress: CardProgressService;

  <template>
    <div class="container">
      <header class="page-header">
        <h1 class="page-title">
          Tarjetas de español
          <span style="font-size: var(--font-size-4); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Spanish Flashcards</span>
        </h1>
        <p class="page-subtitle">
          Domina tu vocabulario y frases en español
          <span style="font-size: var(--font-size-2); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Master your Spanish vocabulary and phrases</span>
        </p>
      </header>

      <div class="progress-card">
        <h2>
          Tu progreso
          <span style="font-size: var(--font-size-2); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Your Progress</span>
        </h2>
        <div class="progress-bar">
          <div class="progress-bar-fill" style="inline-size: {{this.cardProgress.progressPercentage}}%;"></div>
        </div>
        <p class="progress-text">
          {{this.cardProgress.learnedCount}} / {{this.cardProgress.totalCards}} tarjetas dominadas
          ({{this.cardProgress.progressPercentage}}%)
          <span style="font-size: var(--font-size-1); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">cards mastered</span>
        </p>
      </div>

      <section class="section">
        <h2 class="section-title">
          Elige tu modo de cuestionario
          <span style="font-size: var(--font-size-3); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Choose Your Quiz Mode</span>
        </h2>
        <div class="quiz-mode-grid">
          <LinkTo @route="quiz" @model="english-to-spanish" class="quiz-mode-card">
            <div class="quiz-mode-icon">🇺🇸 → 🇪🇸</div>
            <h3 class="quiz-mode-title">
              Inglés a español
              <span style="font-size: var(--font-size-2); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">English to Spanish</span>
            </h3>
            <p class="quiz-mode-description">
              Ve la palabra en inglés, recuerda el español
              <span style="font-size: var(--font-size-1); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">See the English word, recall the Spanish</span>
            </p>
          </LinkTo>

          <LinkTo @route="quiz" @model="spanish-to-english" class="quiz-mode-card">
            <div class="quiz-mode-icon">🇪🇸 → 🇺🇸</div>
            <h3 class="quiz-mode-title">
              Español a inglés
              <span style="font-size: var(--font-size-2); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Spanish to English</span>
            </h3>
            <p class="quiz-mode-description">
              Ve la palabra en español, recuerda el inglés
              <span style="font-size: var(--font-size-1); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">See the Spanish word, recall the English</span>
            </p>
          </LinkTo>

          <LinkTo @route="quiz" @model="random" class="quiz-mode-card">
            <div class="quiz-mode-icon">🔀</div>
            <h3 class="quiz-mode-title">
              Aleatorio
              <span style="font-size: var(--font-size-2); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Random</span>
            </h3>
            <p class="quiz-mode-description">
              ¡Mezclalo! Cualquier dirección al azar
              <span style="font-size: var(--font-size-1); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Mix it up! Either direction randomly</span>
            </p>
          </LinkTo>
        </div>
      </section>
    </div>

    <style scoped>
      @media (width <= 640px) {
        .container { padding: var(--size-3); }
        .page-header { margin-block-end: var(--size-5); }
        .page-title { font-size: var(--font-size-5); }
        .page-subtitle { font-size: var(--font-size-2); }
        .section { margin-block-end: var(--size-5); }
        .section-title { font-size: var(--font-size-3); margin-block-end: var(--size-3); }
        .quiz-mode-grid { grid-template-columns: 1fr; gap: var(--size-3); }
        .quiz-mode-card { padding: var(--size-6) var(--size-3); }
        .quiz-mode-icon { font-size: var(--font-size-5); margin-block-end: var(--size-2); }
        .quiz-mode-title { font-size: var(--font-size-2); }
      }
    </style>
  </template>
}
