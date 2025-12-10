import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

interface PhraseCardSignature {
  Args: {
    english: string | string[];
    spanish: string | string[];
    showEnglish: boolean;
    onCorrect: () => void;
    onIncorrect: () => void;
    onLearned: () => void;
  };
}

export default class PhraseCard extends Component<PhraseCardSignature> {
  @tracked isFlipped = false;

  get frontText(): string {
    if (this.args.showEnglish) {
      const english = this.args.english;
      return Array.isArray(english) ? english[0]! : english;
    } else {
      const spanish = this.args.spanish;
      return Array.isArray(spanish) ? spanish[0]! : spanish;
    }
  }

  get backText(): string {
    if (this.args.showEnglish) {
      const spanish = this.args.spanish;
      return Array.isArray(spanish) ? spanish.join(' / ') : spanish;
    } else {
      const english = this.args.english;
      return Array.isArray(english) ? english.join(' / ') : english;
    }
  }

  @action
  flipCard(): void {
    this.isFlipped = !this.isFlipped;
  }

  @action
  handleCorrect(): void {
    this.isFlipped = false;
    setTimeout(() => {
      this.args.onCorrect();
    }, 600);
  }

  @action
  handleIncorrect(): void {
    this.isFlipped = false;
    setTimeout(() => {
      this.args.onIncorrect();
    }, 600);
  }

  @action
  handleLearned(): void {
    this.isFlipped = false;
    setTimeout(() => {
      this.args.onLearned();
    }, 600);
  }

  <template>
    <div class="flashcard-container">
      <div class="flashcard {{if this.isFlipped 'flipped'}}" {{on 'click' this.flipCard}}>
        <div class="flashcard-inner">
          <div class="flashcard-front">
            <div class="card-type">phrase</div>
            <div class="card-text">{{this.frontText}}</div>
            <div class="card-hint">Click to flip</div>
          </div>
          <div class="flashcard-back">
            <div class="card-type">phrase</div>
            <div class="card-text">{{this.backText}}</div>
          </div>
        </div>
      </div>

      {{#if this.isFlipped}}
        <div class="flashcard-actions">
          <button class="btn btn-success" type="button" {{on 'click' this.handleCorrect}}>
            ✓ Correct
          </button>
          <button class="btn btn-incorrect" type="button" {{on 'click' this.handleIncorrect}}>
            ✗ Incorrect
          </button>
          <button class="btn btn-learned" type="button" {{on 'click' this.handleLearned}}>
            ★ I Know This
          </button>
        </div>
      {{/if}}
    </div>

    <style scoped>
      .flashcard-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 2rem;
        padding: 2rem;
      }

      .flashcard {
        width: 400px;
        height: 300px;
        perspective: 1000px;
        cursor: pointer;
      }

      .flashcard-inner {
        position: relative;
        width: 100%;
        height: 100%;
        transition: transform 0.6s;
        transform-style: preserve-3d;
      }

      .flashcard.flipped .flashcard-inner {
        transform: rotateY(180deg);
      }

      .flashcard-front,
      .flashcard-back {
        position: absolute;
        width: 100%;
        height: 100%;
        backface-visibility: hidden;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        padding: 2rem;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        background: white;
        border: 2px solid #e2e8f0;
      }

      .flashcard-back {
        transform: rotateY(180deg);
        background: #f7fafc;
      }

      .card-type {
        position: absolute;
        top: 1rem;
        left: 1rem;
        font-size: 0.75rem;
        text-transform: uppercase;
        color: #718096;
        font-weight: 600;
      }

      .card-text {
        font-size: 2rem;
        font-weight: 600;
        text-align: center;
        color: #2d3748;
      }

      .card-hint {
        position: absolute;
        bottom: 1rem;
        font-size: 0.875rem;
        color: #a0aec0;
      }

      .flashcard-actions {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
        justify-content: center;
      }

      .btn {
        padding: 0.75rem 1.5rem;
        font-size: 1rem;
        font-weight: 600;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }

      .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }

      .btn:active {
        transform: translateY(0);
      }

      .btn-success {
        background: #48bb78;
        color: white;
      }

      .btn-success:hover {
        background: #38a169;
      }

            .btn-incorrect:hover {
        background: #f56565;
        transform: scale(1.05);
      }

      .btn-learned {
        background: #fbbf24;
        color: white;
      }

      .btn-learned:hover {
        background: #f59e0b;
        transform: scale(1.05);
      }

      @media (max-width: 640px) {
        .flashcard-container {
          padding: 0.5rem;
          gap: 0.5rem;
          height: 100%;
          justify-content: center;
        }

        .flashcard {
          width: 100%;
          max-width: 100%;
          height: auto;
          max-height: 50vh;
          aspect-ratio: 4/3;
          flex-shrink: 1;
        }

        .card-text {
          font-size: clamp(0.875rem, 3.5vw, 1.25rem);
          padding: 0 0.5rem;
        }

        .card-type {
          font-size: 0.625rem;
          top: 0.5rem;
          left: 0.5rem;
        }

        .card-hint {
          font-size: 0.75rem;
          bottom: 0.5rem;
        }

        .flashcard-front,
        .flashcard-back {
          padding: 0.75rem 0.5rem;
        }

        .flashcard-actions {
          gap: 0.5rem;
          width: 100%;
          padding: 0;
          flex-shrink: 0;
        }

        .btn {
          flex: 1;
          min-width: 0;
          padding: clamp(0.5rem, 2vh, 1rem) 0.25rem;
          font-size: clamp(0.625rem, 2vw, 0.875rem);
        }
      }
    </style>
  </template>
}
