import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type { Card } from '#app/types.ts';

interface FlashcardSignature {
  Args: {
    card: Card;
    showEnglish: boolean;
    onCorrect: () => void;
    onIncorrect: () => void;
    onMastered: () => void;
  };
}

export default class FlashcardComponent extends Component<FlashcardSignature> {
  @tracked isFlipped = false;

  get frontText(): string {
    const card = this.args.card;

    if (this.args.showEnglish) {
      // Show English
      if ('english' in card) {
        const english = card.english;
        return Array.isArray(english) ? english[0]! : english;
      }
      // For conjugation, show the verb/tense/person
      if (card.type === 'conjugation') {
        return `${card.verb} (${card.tense}, ${card.person})`;
      }
      // For picture, show nothing (will show image)
      if (card.type === 'picture') {
        return '';
      }
      // For fill-in-the-blank, show the sentence
      if (card.type === 'fill-in-the-blank') {
        return card.sentence;
      }
    } else {
      // Show Spanish
      if ('spanish' in card) {
        const spanish = card.spanish;
        return Array.isArray(spanish) ? spanish[0]! : spanish;
      }
      // For fill-in-the-blank, show sentence
      if (card.type === 'fill-in-the-blank') {
        return card.sentence;
      }
    }

    return '';
  }

  get backText(): string {
    const card = this.args.card;

    if (this.args.showEnglish) {
      // Show Spanish
      if ('spanish' in card) {
        return Array.isArray(card.spanish) ? card.spanish.join(' / ') : card.spanish;
      }
      // For fill-in-the-blank, show answer
      if (card.type === 'fill-in-the-blank') {
        return card.answer;
      }
    } else {
      // Show English
      if ('english' in card) {
        return Array.isArray(card.english) ? card.english.join(' / ') : card.english;
      }
      // For conjugation, show the Spanish
      if (card.type === 'conjugation') {
        return card.spanish;
      }
      // For picture, show the Spanish
      if (card.type === 'picture') {
        return card.spanish;
      }
      // For fill-in-the-blank, show answer
      if (card.type === 'fill-in-the-blank') {
        return card.answer;
      }
    }

    return '';
  }

  get cardType(): string {
    return this.args.card.type;
  }

  @action
  flipCard(): void {
    this.isFlipped = !this.isFlipped;
  }

  @action
  handleCorrect(): void {
    this.args.onCorrect();
    this.isFlipped = false;
  }

  @action
  handleIncorrect(): void {
    this.args.onIncorrect();
    this.isFlipped = false;
  }

  @action
  handleMastered(): void {
    this.args.onMastered();
    this.isFlipped = false;
  }

  <template>
    <div class="flashcard-container">
      <div class="flashcard {{if this.isFlipped 'flipped'}}" {{on 'click' this.flipCard}}>
        <div class="flashcard-inner">
          <div class="flashcard-front">
            <div class="card-type">{{this.cardType}}</div>
            <div class="card-text">{{this.frontText}}</div>
            <div class="card-hint">Click to flip</div>
          </div>
          <div class="flashcard-back">
            <div class="card-type">{{this.cardType}}</div>
            <div class="card-text">{{this.backText}}</div>
          </div>
        </div>
      </div>

      {{#if this.isFlipped}}
        <div class="flashcard-actions">
          <button class="btn btn-success" type="button" {{on 'click' this.handleCorrect}}>
            ✓ Correct
          </button>
          <button class="btn btn-error" type="button" {{on 'click' this.handleIncorrect}}>
            ✗ Incorrect
          </button>
          <button class="btn btn-mastered" type="button" {{on 'click' this.handleMastered}}>
            ★ Mastered
          </button>
        </div>
      {{/if}}
    </div>

    <style>
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

      .btn-error {
        background: #f56565;
        color: white;
      }

      .btn-error:hover {
        background: #e53e3e;
      }

      .btn-mastered {
        background: #ed8936;
        color: white;
      }

      .btn-mastered:hover {
        background: #dd6b20;
      }

      @media (max-width: 640px) {
        .flashcard {
          width: 90vw;
          max-width: 400px;
        }
      }
    </style>
  </template>
}
