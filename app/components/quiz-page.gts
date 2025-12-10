import Component from '@glimmer/component';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import type RouterService from '@ember/routing/router-service';
import type CardProgressService from '#app/services/card-progress.ts';
import cards from '#app/spanish.ts';
import type { Card } from '#app/types.ts';
import Flashcard from '#app/components/flashcard.gts';
import QuizHeader from '#app/components/quiz-header.gts';
import QuizCompletion from '#app/components/quiz-completion.gts';

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

  @action
  handleCorrect(): void {
    const cardIndex = this.currentCardOriginalIndex;
    this.cardProgress.recordCorrect(cardIndex);
    
    // Check if this card just became mastered
    const progress = this.cardProgress.getCardProgress(cardIndex);
    if (progress.mastered) {
      // Remove from session since it's now mastered
      this.masteredInSession.add(cardIndex);
      this.masteredInSession = new Set(this.masteredInSession);
      
      // Check if all cards are now mastered
      if (this.quizCards.length === 0) {
        this.isComplete = true;
        return;
      }
    }
    
    this.nextCard();
  }

  @action
  handleIncorrect(): void {
    this.cardProgress.recordIncorrect(this.currentCardOriginalIndex);
    this.nextCard();
  }

  @action
  handleMastered(): void {
    const cardIndex = this.currentCardOriginalIndex;
    this.cardProgress.recordMastered(cardIndex);
    
    // Remove this card from the session
    this.masteredInSession.add(cardIndex);
    this.masteredInSession = new Set(this.masteredInSession);

    // Check if all cards are now mastered
    if (this.quizCards.length === 0) {
      this.isComplete = true;
    }
    // Note: Don't advance to next card, the current index will now point to the next card
    // since we removed the current one from quizCards getter
  }

  nextCard(): void {
    // For random mode, randomize direction for each card
    if (this.args.mode === 'random') {
      this.showEnglish = Math.random() > 0.5;
    }

    this.currentCardIndex++;

    // If we've gone through all remaining cards, cycle back to the beginning
    if (this.currentCardIndex >= this.quizCards.length) {
      this.currentCardIndex = 0;
      // Re-shuffle the remaining cards for variety
      this.initialQuizCards = this.shuffleArray([...this.initialQuizCards]);
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
        <QuizCompletion
          @cardProgress={{this.cardProgress}}
          @onRestart={{this.restartQuiz}}
          @onReturnHome={{this.returnHome}}
        />
      {{else}}
        <QuizHeader
          @mode={{@mode}}
          @onBack={{this.returnHome}}
        />

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
    </style>
  </template>
}
