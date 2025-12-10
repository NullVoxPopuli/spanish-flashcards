import Component from '@glimmer/component';
import { on } from '@ember/modifier';

interface QuizHeaderSignature {
  Args: {
    mode: 'english-to-spanish' | 'spanish-to-english' | 'random';
    onBack: () => void;
  };
}

export default class QuizHeader extends Component<QuizHeaderSignature> {
  get modeLabel(): string {
    if (this.args.mode === 'english-to-spanish') {
      return 'English → Spanish';
    } else if (this.args.mode === 'spanish-to-english') {
      return 'Spanish → English';
    } else {
      return 'Random Mode';
    }
  }

  <template>
    <div class="quiz-header">
      <button class="btn-back" type="button" {{on 'click' @onBack}}>
        ← Back
      </button>
      <div class="quiz-mode">
        {{this.modeLabel}}
      </div>
    </div>

    <style scoped>
      .quiz-header {
        display: flex;
        align-items: center;
        gap: 2rem;
        margin-bottom: 1rem;
      }

      .btn-back {
        background: transparent;
        border: none;
        color: #4a5568;
        font-size: 1rem;
        cursor: pointer;
        padding: 0.5rem;
        transition: color 0.2s;
      }

      .btn-back:hover {
        color: #2d3748;
      }

      .quiz-mode {
        font-size: 1.125rem;
        font-weight: 600;
        color: #2d3748;
      }

      @media (max-width: 640px) {
        .quiz-header {
          gap: 0.5rem;
          margin-bottom: 0.25rem;
          flex-shrink: 0;
        }

        .btn-back {
          font-size: clamp(0.75rem, 2vw, 0.875rem);
          padding: 0.25rem 0.5rem;
        }

        .quiz-mode {
          font-size: clamp(0.75rem, 2vw, 0.875rem);
        }
      }
    </style>
  </template>
}
