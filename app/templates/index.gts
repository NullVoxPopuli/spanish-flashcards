import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { properLinks } from 'ember-primitives/proper-links';
import type CardProgressService from '#app/services/card-progress.ts';

@properLinks
export default class IndexRoute extends Component {
  @service('card-progress') declare cardProgress: CardProgressService;

  <template>
    <div class="container">
      <header class="page-header">
        <h1 class="page-title">Spanish Flashcards</h1>
        <p class="page-subtitle">
          Learn Spanish vocabulary and phrases
        </p>
      </header>

      <section class="section">
        <h2 class="section-title">Choose Your Quiz Mode</h2>
        <div class="quiz-mode-grid">
          <a href="/quiz/english-to-spanish" class="quiz-mode-card">
            <div class="quiz-mode-icon">EN → ES</div>
            <h3 class="quiz-mode-title">English to Spanish</h3>
            <p class="quiz-mode-description">See the English word, recall the Spanish</p>
          </a>

          <a href="/quiz/spanish-to-english" class="quiz-mode-card">
            <div class="quiz-mode-icon">ES → EN</div>
            <h3 class="quiz-mode-title">Spanish to English</h3>
            <p class="quiz-mode-description">See the Spanish word, recall the English</p>
          </a>

          <a href="/quiz/random" class="quiz-mode-card">
            <div class="quiz-mode-icon">↔</div>
            <h3 class="quiz-mode-title">Random</h3>
            <p class="quiz-mode-description">Mix it up! Either direction randomly</p>
          </a>
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
