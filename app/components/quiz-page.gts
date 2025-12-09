import Component from '@glimmer/component';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type RouterService from '@ember/routing/router-service';
import type CardProgressService from '#app/services/card-progress.ts';
import cards from '#app/spanish.ts';
import type { Card } from '#app/types.ts';
import Flashcard from '#app/components/flashcard.gts';

interface QuizPageSignature {
  Args: {
    mode: 'english-to-spanish' | 'spanish-to-english' | 'random';
  };
}

export default class QuizPage extends Component<QuizPageSignature> {
  @service declare router: RouterService;
  @service('card-progress') declare cardProgress: CardProgressService;

  @tracked currentCardIndex = 0;
  @tracked showEnglish = true;
  @tracked isComplete = false;
  @tracked masteredInSession = new Set<number>();

  initialQuizCards: number[];

  constructor(owner: any, args: QuizPageSignature['Args']) {
    super(owner, args);

    // Get unmastered cards
    const unmasteredCards = this.cardProgress.getUnmasteredCards();

    if (unmasteredCards.length === 0) {
      // If all cards are mastered, use all cards
      this.initialQuizCards = cards.map((_, index) => index);
    } else {
      this.initialQuizCards = unmasteredCards;
    }

    // Shuffle the cards
    this.initialQuizCards = this.shuffleArray([...this.initialQuizCards]);

    // Set the quiz direction based on mode
    const mode = this.args.mode;
    if (mode === 'english-to-spanish') {
      this.showEnglish = true;
    } else if (mode === 'spanish-to-english') {
      this.showEnglish = false;
    } else {
      // Random mode
      this.showEnglish = Math.random() > 0.5;
    }
  }

  get quizCards(): number[] {
    return this.initialQuizCards.filter(
      (cardIndex) => !this.masteredInSession.has(cardIndex)
    );
  }

  shuffleArray<T>(array: T[]): T[] {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j]!, shuffled[i]!];
    }
    return shuffled;
  }

  get currentCard(): Card | null {
    if (this.currentCardIndex >= this.quizCards.length) {
      return null;
    }
    const cardIndex = this.quizCards[this.currentCardIndex];
    return cardIndex !== undefined ? cards[cardIndex]! : null;
  }

  get currentCardOriginalIndex(): number {
    return this.quizCards[this.currentCardIndex]!;
  }

  get progress(): string {
    return `${this.currentCardIndex + 1} / ${this.quizCards.length}`;
  }

  get progressPercentage(): number {
    return Math.round(((this.currentCardIndex + 1) / this.quizCards.length) * 100);
  }

  get modeLabel(): string {
    if (this.args.mode === 'english-to-spanish') {
      return '🇺🇸 → 🇪🇸 English to Spanish';
    } else if (this.args.mode === 'spanish-to-english') {
      return '🇪🇸 → 🇺🇸 Spanish to English';
    } else {
      return '🔀 Random Mode';
    }
  }

  @action
  handleCorrect(): void {
    this.cardProgress.recordCorrect(this.currentCardOriginalIndex);
    this.nextCard();
  }

  @action
  handleIncorrect(): void {
    this.cardProgress.recordIncorrect(this.currentCardOriginalIndex);
    this.nextCard();
  }

  @action
  handleMastered(): void {
    this.cardProgress.recordMastered(this.currentCardOriginalIndex);
    // Mark this card as mastered in the current session
    this.masteredInSession.add(this.currentCardOriginalIndex);
    this.masteredInSession = new Set(this.masteredInSession);

    if (this.quizCards.length === 0 || this.currentCardIndex >= this.quizCards.length) {
      this.isComplete = true;
    } else {
      // Stay at the same index since we removed the current card from quizCards getter
      this.currentCardIndex = this.currentCardIndex;
    }
  }

  nextCard(): void {
    // For random mode, randomize direction for each card
    if (this.args.mode === 'random') {
      this.showEnglish = Math.random() > 0.5;
    }

    this.currentCardIndex++;

    if (this.currentCardIndex >= this.quizCards.length) {
      this.isComplete = true;
    }
  }

  @action
  returnHome(): void {
    this.router.transitionTo('index');
  }

  @action
  restartQuiz(): void {
    this.currentCardIndex = 0;
    this.isComplete = false;
    this.masteredInSession = new Set();

    // Re-randomize for random mode
    if (this.args.mode === 'random') {
      this.showEnglish = Math.random() > 0.5;
    }
  }

  <template>
    <div class="quiz-container">
      {{#if this.isComplete}}
        <div class="completion-card">
          <div class="completion-icon">🎉</div>
          <h1>Quiz Complete!</h1>
          <p class="completion-text">
            Great job! You've completed this quiz session.
          </p>
          <div class="completion-stats">
            <div class="stat">
              <div class="stat-value">{{this.cardProgress.masteredCount}}</div>
              <div class="stat-label">Cards Mastered</div>
            </div>
            <div class="stat">
              <div class="stat-value">{{this.cardProgress.progressPercentage}}%</div>
              <div class="stat-label">Overall Progress</div>
            </div>
          </div>
          <div class="completion-actions">
            <button class="btn btn-primary" type="button" {{on 'click' this.restartQuiz}}>
              Quiz Again
            </button>
            <button class="btn btn-secondary" type="button" {{on 'click' this.returnHome}}>
              Return Home
            </button>
          </div>
        </div>
      {{else}}
        <div class="quiz-header">
          <button class="btn-back" type="button" {{on 'click' this.returnHome}}>
            ← Back
          </button>
          <div class="quiz-info">
            <div class="quiz-mode">
              {{this.modeLabel}}
            </div>
            <div class="quiz-progress">
              {{this.progress}}
            </div>
          </div>
        </div>

        <div class="progress-bar-container">
          <div class="progress-bar-fill" style="width: {{this.progressPercentage}}%"></div>
        </div>

        {{#if this.currentCard}}
          <Flashcard
            @card={{this.currentCard}}
            @showEnglish={{this.showEnglish}}
            @onCorrect={{this.handleCorrect}}
            @onIncorrect={{this.handleIncorrect}}
            @onMastered={{this.handleMastered}}
          />
        {{/if}}
      {{/if}}
    </div>

    <style>
      .quiz-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 2rem;
        min-height: 100vh;
      }

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

      .quiz-info {
        flex: 1;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .quiz-mode {
        font-size: 1.125rem;
        font-weight: 600;
        color: #2d3748;
      }

      .quiz-progress {
        font-size: 1.125rem;
        font-weight: 600;
        color: #718096;
      }

      .progress-bar-container {
        width: 100%;
        height: 8px;
        background: #e2e8f0;
        border-radius: 4px;
        overflow: hidden;
        margin-bottom: 2rem;
      }

      .progress-bar-fill {
        height: 100%;
        background: linear-gradient(90deg, #4299e1, #3182ce);
        transition: width 0.3s ease;
      }

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
        .quiz-header {
          flex-direction: column;
          align-items: flex-start;
          gap: 1rem;
        }

        .quiz-info {
          flex-direction: column;
          align-items: flex-start;
          gap: 0.5rem;
          width: 100%;
        }

        .completion-stats {
          flex-direction: column;
          gap: 1rem;
        }
      }
    </style>
  </template>
}
