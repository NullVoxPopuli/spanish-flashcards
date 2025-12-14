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
        <h1 class="page-title">Spanish Flashcards</h1>
        <p class="page-subtitle">
          Master your Spanish vocabulary and phrases
        </p>
      </header>

      <div class="progress-card">
        <h2>Your Progress</h2>
        <div class="progress-bar">
          <div class="progress-bar-fill" style="inline-size: {{this.cardProgress.progressPercentage}}%;"></div>
        </div>
        <p class="progress-text">
          {{this.cardProgress.masteredCount}} / {{this.cardProgress.totalCards}} cards mastered
          ({{this.cardProgress.progressPercentage}}%)
        </p>
      </div>

      <section class="section">
        <h2 class="section-title">Choose Your Quiz Mode</h2>
        <div class="quiz-mode-grid">
          <LinkTo @route="quiz" @model="english-to-spanish" class="quiz-mode-card">
            <div class="quiz-mode-icon">🇺🇸 → 🇪🇸</div>
            <h3 class="quiz-mode-title">English to Spanish</h3>
            <p class="quiz-mode-description">See the English word, recall the Spanish</p>
          </LinkTo>

          <LinkTo @route="quiz" @model="spanish-to-english" class="quiz-mode-card">
            <div class="quiz-mode-icon">🇪🇸 → 🇺🇸</div>
            <h3 class="quiz-mode-title">Spanish to English</h3>
            <p class="quiz-mode-description">See the Spanish word, recall the English</p>
          </LinkTo>

          <LinkTo @route="quiz" @model="random" class="quiz-mode-card">
            <div class="quiz-mode-icon">🔀</div>
            <h3 class="quiz-mode-title">Random</h3>
            <p class="quiz-mode-description">Mix it up! Either direction randomly</p>
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
