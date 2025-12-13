import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { properLinks } from 'ember-primitives/proper-links';
import type CardProgressService from '#app/services/card-progress.ts';

@properLinks
export default class IndexRoute extends Component {
  @service('card-progress') declare cardProgress: CardProgressService;

  @action
  resetProgress(): void {
    if (confirm('Are you sure you want to reset all progress? This cannot be undone.')) {
      this.cardProgress.resetProgress();
    }
  }

  <template>
    <div class="home-container">
      <div class="header">
        <h1>Spanish Flashcards</h1>
        <p class="subtitle">Learn Spanish vocabulary and phrases</p>
      </div>

      <div class="quiz-modes">
        <h2>Choose Your Quiz Mode</h2>
        <div class="mode-buttons">
          <a href="/quiz/english-to-spanish" class="mode-btn">
            <div class="mode-icon">EN → ES</div>
            <h3>English to Spanish</h3>
            <p>See the English word, recall the Spanish</p>
          </a>

          <a href="/quiz/spanish-to-english" class="mode-btn">
            <div class="mode-icon">ES → EN</div>
            <h3>Spanish to English</h3>
            <p>See the Spanish word, recall the English</p>
          </a>

          <a href="/quiz/random" class="mode-btn">
            <div class="mode-icon">↔</div>
            <h3>Random</h3>
            <p>Mix it up! Either direction randomly</p>
          </a>
        </div>
      </div>

      <div class="actions">
        <button
          class="btn-reset"
          type="button"
          {{on 'click' this.resetProgress}}
        >
          Reset All Progress
        </button>
      </div>
    </div>

    <style scoped>
      .home-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 2rem;
      }

      .header {
        text-align: center;
        margin-bottom: 3rem;
      }

      .header h1 {
        font-size: 3rem;
        margin: 0;
        color: #2d3748;
      }

      .subtitle {
        font-size: 1.25rem;
        color: #718096;
        margin-top: 0.5rem;
      }

      .quiz-modes h2 {
        text-align: center;
        color: #2d3748;
        margin-bottom: 2rem;
      }

      .mode-buttons {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 1.5rem;
        margin-bottom: 3rem;
      }

      .mode-btn {
        display: block;
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 2rem 1.5rem;
        cursor: pointer;
        transition: all 0.2s;
        text-align: center;
        text-decoration: none;
        color: inherit;
      }

      .mode-btn:hover {
        border-color: #4299e1;
        transform: translateY(-4px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
      }

      .mode-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
      }

      .mode-btn h3 {
        margin: 0.5rem 0;
        color: #2d3748;
        font-size: 1.25rem;
      }

      .mode-btn p {
        margin: 0;
        color: #718096;
        font-size: 0.875rem;
      }

      .actions {
        text-align: center;
      }

      .btn-reset {
        background: transparent;
        border: 2px solid #e2e8f0;
        color: #718096;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        cursor: pointer;
        font-size: 0.875rem;
        transition: all 0.2s;
      }

      .btn-reset:hover {
        border-color: #f56565;
        color: #f56565;
      }

      @media (max-width: 640px) {
        .home-container {
          padding: 1rem;
        }

        .header {
          margin-bottom: 2rem;
        }

        .header h1 {
          font-size: 2rem;
        }

        .subtitle {
          font-size: 1rem;
        }

        .quiz-modes h2 {
          font-size: 1.25rem;
          margin-bottom: 1rem;
        }

        .mode-buttons {
          grid-template-columns: 1fr;
          gap: 1rem;
          margin-bottom: 2rem;
        }

        .mode-btn {
          padding: 1.5rem 1rem;
        }

        .mode-icon {
          font-size: 2rem;
          margin-bottom: 0.5rem;
        }

        .mode-btn h3 {
          font-size: 1.125rem;
        }
      }
    </style>
  </template>
}
