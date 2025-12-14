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
            <div class="card-hint">
              Clic para voltear
              <div class="spanish-hint">Click to flip</div>
            </div>
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
            <span class="btn-text">✓ Correcto</span>
            <span class="btn-hint">Correct</span>
          </button>
          <button class="btn btn-incorrect" type="button" {{on 'click' this.handleIncorrect}}>
            <span class="btn-text">✗ Incorrecto</span>
            <span class="btn-hint">Incorrect</span>
          </button>
          <button class="btn btn-learned" type="button" {{on 'click' this.handleLearned}}>
            <span class="btn-text">★ Ya lo sé</span>
            <span class="btn-hint">I Know This</span>
          </button>
        </div>
      {{/if}}
    </div>

    <style scoped>
      .flashcard-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: clamp(var(--size-3), 3vh, var(--size-6));
        padding-block: clamp(var(--size-2), 2vh, var(--size-5));
        inline-size: 100%;
        block-size: 100%;
        max-inline-size: 100vw;
        max-block-size: 100vh;
      }

      .flashcard {
        inline-size: 100%;
        block-size: min(50vh, 400px);
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
        inset-block-start: clamp(var(--size-2), 2vh, var(--size-3));
        inset-inline-start: clamp(var(--size-2), 2vh, var(--size-3));
        font-size: clamp(var(--font-size-00), 1.5vh, var(--font-size-1));
        text-transform: uppercase;
        font-weight: var(--font-weight-7);
        padding: var(--size-1) var(--size-2);
        border-radius: var(--radius-2);
      }

      .card-text {
        font-size: clamp(var(--font-size-3), 4vh, var(--font-size-7));
        font-weight: var(--font-weight-7);
        text-align: center;
        color: var(--gray-9);
        line-height: 1.3;
        padding: clamp(var(--size-3), 3vh, var(--size-6));
      }

      .card-hint {
        position: absolute;
        inset-block-end: clamp(var(--size-2), 2vh, var(--size-3));
        font-size: clamp(var(--font-size-0), 1.5vh, var(--font-size-2));
        color: var(--indigo-9);
        font-weight: var(--font-weight-6);
        background: var(--indigo-1);
        padding: var(--size-1) var(--size-3);
        border-radius: var(--radius-2);
        text-align: center;
      }

      .spanish-hint {
        font-size: clamp(var(--font-size-00), 1.2vh, var(--font-size-1));
        opacity: 0.7;
        margin-block-start: var(--size-1);
        font-style: italic;
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
        gap: clamp(var(--size-2), 2vw, var(--size-4));
        justify-content: center;
        inline-size: 100%;
      }

      .btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: clamp(var(--size-1), 1vh, var(--size-2));
        padding: clamp(var(--size-3), 2vh, var(--size-6)) clamp(var(--size-4), 3vw, var(--size-7));
        border-radius: var(--radius-3);
        border: 2px solid transparent;
        font-weight: var(--font-weight-6);
        cursor: pointer;
        transition: all 0.2s var(--ease-3);
        box-shadow: var(--shadow-2);
        flex: 1;
        min-inline-size: min(100px, 20vw);
      }

      .btn:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-4);
      }

      .btn:active {
        transform: translateY(0);
        box-shadow: var(--shadow-1);
      }

      .btn-success {
        background: var(--green-6);
        border-color: var(--green-8);
        color: white;
      }

      .btn-success:hover {
        background: var(--green-7);
        border-color: var(--green-9);
      }

      .btn-incorrect {
        background: var(--red-6);
        border-color: var(--red-8);
        color: white;
      }

      .btn-incorrect:hover {
        background: var(--red-7);
        border-color: var(--red-9);
      }

      .btn-learned {
        background: var(--yellow-6);
        border-color: var(--yellow-8);
        color: var(--gray-12);
      }

      .btn-learned:hover {
        background: var(--yellow-7);
        border-color: var(--yellow-9);
      }

      .btn-text {
        font-weight: var(--font-weight-7);
        font-size: clamp(var(--font-size-1), 2.5vh, var(--font-size-4));
      }

      .btn-hint {
        font-size: clamp(var(--font-size-0), 1.5vh, var(--font-size-2));
        opacity: 0.9;
        font-style: italic;
        font-weight: var(--font-weight-5);
      }

      @media (width <= 640px) {
        .card-actions { gap: var(--size-2); }
      }

      @media (height <= 500px) {
        .flashcard { block-size: 60vh; }
        .flashcard-container { gap: var(--size-2); }
      }
    </style>
  </template>
}
