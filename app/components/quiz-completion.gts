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
      <h1>
        ¡Cuestionario completo!
        <div style="font-size: var(--font-size-3); opacity: 0.7; font-style: italic; margin-block-start: var(--size-1);">Quiz Complete!</div>
      </h1>
      <p class="completion-message">
        ¡Buen trabajo! Has revisado todas las tarjetas no aprendidas en esta sesión.
        <span style="font-size: var(--font-size-1); opacity: 0.7; font-style: italic; display: block; margin-block-start: var(--size-1);">Great job! You've reviewed all the unlearned cards in this session.</span>
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
            Tarjetas aprendidas
            <div style="font-size: var(--font-size-0); opacity: 0.7; font-style: italic;">Cards Learned</div>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-value">
            {{@cardProgress.progressPercentage}}%
          </div>
          <div class="stat-label">
            Progreso total
            <div style="font-size: var(--font-size-0); opacity: 0.7; font-style: italic;">Overall Progress</div>
          </div>
        </div>
      </div>
      <div class="button-group">
        <button class="btn btn-primary" type="button" {{on 'click' @onRestart}} style="display: flex; flex-direction: column; gap: var(--size-1);">
          <span>Repetir cuestionario</span>
          <span style="font-size: var(--font-size-1); opacity: 0.75; font-style: italic;">Quiz Again</span>
        </button>
        <button class="btn btn-secondary" type="button" {{on 'click' @onReturnHome}} style="display: flex; flex-direction: column; gap: var(--size-1);">
          <span>Volver al inicio</span>
          <span style="font-size: var(--font-size-1); opacity: 0.75; font-style: italic;">Return Home</span>
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
