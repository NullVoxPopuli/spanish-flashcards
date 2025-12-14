import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';
import { eq } from 'ember-truth-helpers';
import { properLinks } from 'ember-primitives/proper-links';
import type CardProgressService from '#app/services/card-progress.ts';
import { topics } from '#app/topics/index.ts';

@properLinks
export default class IndexRoute extends Component {
  @service('card-progress') declare cardProgress: CardProgressService;
  @tracked selectedTopic = 'all';

  get topicOptions() {
    return [
      { key: 'all', label: 'Todos / All' },
      ...Object.keys(topics).map(key => ({
        key,
        label: key.charAt(0).toUpperCase() + key.slice(1)
      }))
    ];
  }

  @action
  selectTopic(topic: string) {
    this.selectedTopic = topic;
  }

  get quizUrl() {
    return this.selectedTopic === 'all'
      ? ''
      : `?topic=${this.selectedTopic}`;
  }

  <template>
    <div class="container">
      <header class="page-header">
        <h1 class="page-title">
          Tarjetas de español
          <span class="hint-text" style="font-size: var(--font-size-4); font-style: italic; display: block; margin-block-start: var(--size-1);">Spanish Flashcards</span>
        </h1>
        <p class="page-subtitle">
          Aprende vocabulario y frases en español
          <span class="hint-text" style="font-size: var(--font-size-2); font-style: italic; display: block; margin-block-start: var(--size-1);">Learn Spanish vocabulary and phrases</span>
        </p>
      </header>

      <section class="section">
        <h2 class="section-title">
          Elige tu modo de cuestionario
          <span class="hint-text" style="font-size: var(--font-size-3); font-style: italic; display: block; margin-block-start: var(--size-1);">Choose Your Quiz Mode</span>
        </h2>
        <div class="quiz-mode-grid">
          <a href="/quiz/english-to-spanish{{this.quizUrl}}" class="quiz-mode-card">
            <div class="quiz-mode-icon">EN → ES</div>
            <h3 class="quiz-mode-title">
              Inglés a español
              <span class="hint-text" style="font-size: var(--font-size-2); font-style: italic; display: block; margin-block-start: var(--size-1);">English to Spanish</span>
            </h3>
            <p class="quiz-mode-description">
              Ve la palabra en inglés, recuerda el español
              <span class="hint-text" style="font-size: var(--font-size-1); font-style: italic; display: block; margin-block-start: var(--size-1);">See the English word, recall the Spanish</span>
            </p>
          </a>

          <a href="/quiz/spanish-to-english{{this.quizUrl}}" class="quiz-mode-card">
            <div class="quiz-mode-icon">ES → EN</div>
            <h3 class="quiz-mode-title">
              Español a inglés
              <span class="hint-text" style="font-size: var(--font-size-2); font-style: italic; display: block; margin-block-start: var(--size-1);">Spanish to English</span>
            </h3>
            <p class="quiz-mode-description">
              Ve la palabra en español, recuerda el inglés
              <span class="hint-text" style="font-size: var(--font-size-1); font-style: italic; display: block; margin-block-start: var(--size-1);">See the Spanish word, recall the English</span>
            </p>
          </a>

          <a href="/quiz/random{{this.quizUrl}}" class="quiz-mode-card">
            <div class="quiz-mode-icon">↔</div>
            <h3 class="quiz-mode-title">
              Aleatorio
              <span class="hint-text" style="font-size: var(--font-size-2); font-style: italic; display: block; margin-block-start: var(--size-1);">Random</span>
            </h3>
            <p class="quiz-mode-description">
              ¡Mezclalo! Cualquier dirección al azar
              <span class="hint-text" style="font-size: var(--font-size-1); font-style: italic; display: block; margin-block-start: var(--size-1);">Mix it up! Either direction randomly</span>
            </p>
          </a>
        </div>
      </section>

      <section class="section">
        <h2 class="section-title">
          Elige un tema
          <span class="hint-text" style="font-size: var(--font-size-3); font-style: italic; display: block; margin-block-start: var(--size-1);">Choose a Topic</span>
        </h2>
        <div class="topic-buttons">
          {{#each this.topicOptions as |option|}}
            <button
              type="button"
              class="topic-button {{if (eq this.selectedTopic option.key) 'active'}}"
              {{on "click" (fn this.selectTopic option.key)}}
            >
              {{option.label}}
            </button>
          {{/each}}
        </div>
      </section>
    </div>

    <style scoped>
      .container {
        padding-inline: clamp(var(--size-6), 5vw, var(--size-10));
      }

      .page-title,
      .section-title {
        color: var(--gray-9);
      }

      .page-subtitle {
        color: var(--gray-8);
      }

      .hint-text {
        color: var(--gray-7);
        opacity: 0.85;
      }

      .topic-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: var(--size-3);
        margin-block-start: var(--size-4);
      }

      .topic-button {
        padding: var(--size-3) var(--size-5);
        border: 2px solid var(--gray-6);
        border-radius: var(--radius-2);
        background: var(--gray-0);
        color: var(--gray-9);
        font-size: var(--font-size-2);
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
      }

      .topic-button:hover {
        border-color: var(--blue-6);
        background: var(--blue-1);
        color: var(--blue-9);
      }

      .topic-button.active {
        border-color: var(--blue-7);
        background: var(--blue-6);
        color: white;
      }

      @media (width <= 640px) {
        .page-header { margin-block-end: var(--size-5); }
        .page-title { font-size: var(--font-size-5); }
        .page-subtitle { font-size: var(--font-size-2); }
        .section { margin-block-end: var(--size-5); }
        .section-title { font-size: var(--font-size-3); margin-block-end: var(--size-3); }
        .quiz-mode-grid { grid-template-columns: 1fr; gap: var(--size-3); }
        .quiz-mode-card { padding: var(--size-6) var(--size-3); }
        .quiz-mode-icon { font-size: var(--font-size-5); margin-block-end: var(--size-2); }
        .quiz-mode-title { font-size: var(--font-size-2); }
        .topic-buttons { gap: var(--size-2); }
        .topic-button { padding: var(--size-2) var(--size-4); font-size: var(--font-size-1); }
      }
    </style>
  </template>
}
