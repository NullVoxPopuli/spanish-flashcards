import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import type RouterService from '@ember/routing/router-service';
import type CardProgressService from '#app/services/card-progress.ts';

export default class HomePage extends Component {
  @service declare router: RouterService;
  @service('card-progress') declare cardProgress: CardProgressService;

  @action
  startQuiz(mode: 'english-to-spanish' | 'spanish-to-english' | 'random'): void {
    if (mode === 'english-to-spanish') {
      this.router.transitionTo('quiz-english-to-spanish');
    } else if (mode === 'spanish-to-english') {
      this.router.transitionTo('quiz-spanish-to-english');
    } else {
      this.router.transitionTo('quiz-random');
    }
  }

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
        <p class="subtitle">Master your Spanish vocabulary and phrases</p>
      </div>

      <div class="progress-card">
        <h2>Your Progress</h2>
        <div class="progress-bar">
          <div class="progress-fill" style="width: {{this.cardProgress.progressPercentage}}%"></div>
        </div>
        <p class="progress-text">
          {{this.cardProgress.masteredCount}} / {{this.cardProgress.totalCards}} cards mastered
          ({{this.cardProgress.progressPercentage}}%)
        </p>
      </div>

      <div class="quiz-modes">
        <h2>Choose Your Quiz Mode</h2>
        <div class="mode-buttons">
          <button
            class="mode-btn"
            type="button"
            {{on 'click' (fn this.startQuiz 'english-to-spanish')}}
          >
            <div class="mode-icon">🇺🇸 → 🇪🇸</div>
            <h3>English to Spanish</h3>
            <p>See the English word, recall the Spanish</p>
          </button>

          <button
            class="mode-btn"
            type="button"
            {{on 'click' (fn this.startQuiz 'spanish-to-english')}}
          >
            <div class="mode-icon">🇪🇸 → 🇺🇸</div>
            <h3>Spanish to English</h3>
            <p>See the Spanish word, recall the English</p>
          </button>

          <button
            class="mode-btn"
            type="button"
            {{on 'click' (fn this.startQuiz 'random')}}
          >
            <div class="mode-icon">🔀</div>
            <h3>Random</h3>
            <p>Mix it up! Either direction randomly</p>
          </button>
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

      .progress-card {
        background: white;
        border-radius: 12px;
        padding: 2rem;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin-bottom: 3rem;
      }

      .progress-card h2 {
        margin-top: 0;
        color: #2d3748;
      }

      .progress-bar {
        width: 100%;
        height: 24px;
        background: #e2e8f0;
        border-radius: 12px;
        overflow: hidden;
        margin: 1rem 0;
      }

      .progress-fill {
        height: 100%;
        background: linear-gradient(90deg, #48bb78, #38a169);
        transition: width 0.3s ease;
      }

      .progress-text {
        text-align: center;
        color: #4a5568;
        font-weight: 600;
        margin: 0;
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
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 2rem 1.5rem;
        cursor: pointer;
        transition: all 0.2s;
        text-align: center;
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
        .header h1 {
          font-size: 2rem;
        }

        .mode-buttons {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </template>
}
