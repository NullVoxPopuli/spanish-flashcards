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
  get isFullyLearned(): boolean {
    return this.args.cardProgress.learnedCount === this.args.cardProgress.totalCards;
  }

  <template>
    <div class="card completion-card">
      <div class="completion-icon">🎉</div>
      <h1>Quiz Complete!</h1>
      <p class="completion-message">
        Great job! You've reviewed all the unlearned cards in this session.
        {{#if this.isFullyLearned}}
          <br /><strong>Congratulations! You've learned all cards!</strong>
        {{else}}
          <br />Keep practicing to learn all {{@cardProgress.totalCards}} cards.
        {{/if}}
      </p>
      <div class="stats-container">
        <div class="stat-item">
          <div class="stat-value">
            {{@cardProgress.learnedCount}}
          </div>
          <div class="stat-label">
            Cards Learned
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-value">
            {{@cardProgress.progressPercentage}}%
          </div>
          <div class="stat-label">
            Overall Progress
          </div>
        </div>
      </div>
      <div class="button-group">
        <button class="btn btn-primary" type="button" {{on 'click' @onRestart}}>
          Quiz Again
        </button>
        <button class="btn btn-secondary" type="button" {{on 'click' @onReturnHome}}>
          Return Home
        </button>
      </div>
    </div>

    <style scoped>
      @media (width <= 640px) {
        .completion-card { padding: var(--size-5) var(--size-3); margin-block-start: var(--size-5); }
        h1 { font-size: var(--font-size-4); }
        .completion-message { font-size: var(--font-size-1); }
        .stats-container { flex-direction: column; gap: var(--size-3); }
        .stat-value { font-size: var(--font-size-5); }
        .button-group { flex-direction: column; }
        .btn { inline-size: 100%; }
      }
    </style>
  </template>
}
