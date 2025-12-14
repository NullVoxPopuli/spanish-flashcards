import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

interface FlippableCardSignature {
  Args: {
    frontText: string;
    backText: string;
    cardType: string;
    typeColor: string;
    onCorrect: () => void;
    onIncorrect: () => void;
    onLearned: () => void;
  };
}

export default class FlippableCard extends Component<FlippableCardSignature> {
  @tracked isFlipped = false;

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
          <div class="flashcard-face">
            <div class="card-type" style="color: {{@typeColor}};">{{@cardType}}</div>
            <div class="card-text">{{@frontText}}</div>
            <div class="card-hint">Click to flip</div>
          </div>
          <div class="flashcard-face back">
            <div class="card-type" style="color: {{@typeColor}};">{{@cardType}}</div>
            <div class="card-text">{{@backText}}</div>
          </div>
        </div>
      </div>

      {{#if this.isFlipped}}
        <div class="card-actions">
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
      .flashcard {
        inline-size: 400px;
        block-size: 300px;
        perspective: 1000px;
        cursor: pointer;
        flex-shrink: 0;
      }

      .flashcard-inner {
        position: relative;
        inline-size: 100%;
        block-size: 100%;
        transition: transform 0.6s var(--ease-3);
        transform-style: preserve-3d;
      }

      .flashcard.flipped .flashcard-inner {
        transform: rotateY(180deg);
      }

      .flashcard-face {
        position: absolute;
        inset: 0;
        inline-size: 100%;
        block-size: 100%;
        -webkit-backface-visibility: hidden;
        backface-visibility: hidden;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        padding: var(--size-5);
        border-radius: var(--radius-3);
        box-shadow: var(--shadow-4);
        background: var(--indigo-3);
        border: var(--border-size-3) solid var(--indigo-6);
        transform: rotateY(0deg);
      }

      .flashcard-face.back {
        transform: rotateY(180deg);
        background: var(--teal-3);
        border-color: var(--teal-6);
      }

      .card-type {
        position: absolute;
        inset-block-start: var(--size-3);
        inset-inline-start: var(--size-3);
        font-size: var(--font-size-0);
        text-transform: uppercase;
        font-weight: var(--font-weight-7);
        padding: var(--size-1) var(--size-2);
        border-radius: var(--radius-2);
      }

      .card-text {
        font-size: var(--font-size-5);
        font-weight: var(--font-weight-7);
        text-align: center;
        color: var(--gray-9);
        line-height: 1.3;
      }

      .card-hint {
        position: absolute;
        inset-block-end: var(--size-3);
        font-size: var(--font-size-1);
        color: var(--indigo-9);
        font-weight: var(--font-weight-6);
        background: var(--indigo-1);
        padding: var(--size-1) var(--size-3);
        border-radius: var(--radius-2);
      }

      .flashcard-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: var(--size-5);
        padding: var(--size-5);
      }

      .card-actions {
        display: flex;
        gap: var(--size-3);
        justify-content: center;
      }

      @media (width <= 640px) {
        .flashcard-container { padding: var(--size-3); }
        .flashcard-face { padding: var(--size-3) var(--size-2); }
        .card-actions { gap: var(--size-2); inline-size: 100%; padding: 0; flex-shrink: 0; }
        .btn { flex: 1; min-inline-size: 0; padding: clamp(var(--size-2), 2vh, var(--size-3)) var(--size-1); font-size: clamp(var(--font-size-00), 2vw, var(--font-size-1)); }
      }

      @media (width <= 640px) and (max-aspect-ratio: 3/4) {
        .flashcard-container { gap: var(--size-3); padding: 0; flex: 1; min-block-size: 0; justify-content: space-between; inline-size: 100%; }
        .flashcard { inline-size: 100%; block-size: auto; min-block-size: unset; max-block-size: none; aspect-ratio: unset; flex: 1; }
        .card-text { font-size: var(--font-size-6); padding: var(--size-5) var(--size-6); word-wrap: break-word; overflow-wrap: break-word; hyphens: auto; }
        .card-type { font-size: var(--font-size-2); inset-block-start: var(--size-3); inset-inline-start: var(--size-3); }
        .card-hint { font-size: var(--font-size-2); inset-block-end: var(--size-3); }
        .card-actions { gap: var(--size-3); flex-shrink: 0; inline-size: 100%; }
        .btn { padding: var(--size-7) var(--size-6); font-size: var(--font-size-4); }
      }

      @media (height <= 500px) {
        .flashcard-container { padding: var(--size-1); gap: var(--size-1); }
        .flashcard { max-block-size: 75vh; aspect-ratio: 16/9; }
        .card-text { font-size: clamp(var(--font-size-2), 4vh, var(--font-size-4)); padding-inline: var(--size-1); }
        .card-type { font-size: var(--font-size-00); inset-block-start: var(--size-1); inset-inline-start: var(--size-1); }
        .card-hint { font-size: var(--font-size-0); inset-block-end: var(--size-1); }
        .flashcard-face { padding: var(--size-2) var(--size-1); }
        .btn { padding: var(--size-2) var(--size-1); font-size: var(--font-size-0); }
      }
    </style>
  </template>
}
