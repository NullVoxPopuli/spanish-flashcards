import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import type CardProgressService from '#app/services/card-progress.ts';

interface QuizCompletionSignature {
  Args: {
    cardProgress: CardProgressService;
    onRestart: () => void;
    onReturnHome: () => void;
  };
}

export default class QuizCompletion extends Component<QuizCompletionSignature> {
  get isFullyMastered(): boolean {
    return this.args.cardProgress.masteredCount === this.args.cardProgress.totalCards;
  }

  <template>
    <div class="completion-card">
      <div class="completion-icon">🎉</div>
      <h1>Quiz Complete!</h1>
      <p class="completion-text">
        Great job! You've reviewed all the unmastered cards in this session.
        {{#if this.isFullyMastered}}
          <br /><strong>Congratulations! You've mastered all cards!</strong>
        {{else}}
          <br />Keep practicing to master all {{@cardProgress.totalCards}} cards.
        {{/if}}
      </p>
      <div class="completion-stats">
        <div class="stat">
          <div class="stat-value">{{@cardProgress.masteredCount}}</div>
          <div class="stat-label">Cards Mastered</div>
        </div>
        <div class="stat">
          <div class="stat-value">{{@cardProgress.progressPercentage}}%</div>
          <div class="stat-label">Overall Progress</div>
        </div>
      </div>
      <div class="completion-actions">
        <button class="btn btn-primary" type="button" {{on 'click' @onRestart}}>
          Quiz Again
        </button>
        <button class="btn btn-secondary" type="button" {{on 'click' @onReturnHome}}>
          Return Home
        </button>
      </div>
    </div>

    <style>
      .completion-card {
        background: white;
        border-radius: 12px;
        padding: 3rem 2rem;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
        margin-top: 4rem;
      }

      .completion-icon {
        font-size: 5rem;
        margin-bottom: 1rem;
      }

      .completion-card h1 {
        margin: 0 0 1rem 0;
        color: #2d3748;
      }

      .completion-text {
        color: #718096;
        font-size: 1.125rem;
        margin-bottom: 2rem;
      }

      .completion-stats {
        display: flex;
        gap: 2rem;
        justify-content: center;
        margin-bottom: 2rem;
      }

      .stat {
        text-align: center;
      }

      .stat-value {
        font-size: 2.5rem;
        font-weight: 700;
        color: #48bb78;
      }

      .stat-label {
        color: #718096;
        font-size: 0.875rem;
        margin-top: 0.25rem;
      }

      .completion-actions {
        display: flex;
        gap: 1rem;
        justify-content: center;
        flex-wrap: wrap;
      }

      .btn {
        padding: 0.75rem 2rem;
        font-size: 1rem;
        font-weight: 600;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
      }

      .btn-primary {
        background: #4299e1;
        color: white;
      }

      .btn-primary:hover {
        background: #3182ce;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }

      .btn-secondary {
        background: white;
        color: #4a5568;
        border: 2px solid #e2e8f0;
      }

      .btn-secondary:hover {
        border-color: #cbd5e0;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }

      @media (max-width: 640px) {
        .completion-stats {
          flex-direction: column;
          gap: 1rem;
        }
      }
    </style>
  </template>
}
