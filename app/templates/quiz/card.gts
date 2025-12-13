import Component from '@glimmer/component';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import type RouterService from '@ember/routing/router-service';
import type CardProgressService from '#app/services/card-progress.ts';
import Flashcard from '#app/components/flashcard.gts';
import QuizHeader from '#app/components/quiz-header.gts';
import QuizCompletion from '#app/components/quiz-completion.gts';
import type { Card } from '#app/topics/types.ts';

interface CardRouteModel {
  card: Card;
  cardIndex: number;
  cardNumber: number;
  kind: 'english-to-spanish' | 'spanish-to-english' | 'random';
  totalCards: number;
  quizCards: number[];
  showEnglish: boolean;
  learnedInSession: Set<number>;
}

interface QuizCardSignature {
  Args: {
    model: CardRouteModel;
  };
}

export default class QuizCardRoute extends Component<QuizCardSignature> {
  @service declare router: RouterService;
  @service('card-progress') declare cardProgress: CardProgressService;

  @tracked learnedInSession = new Set<number>();

  get card(): Card {
    return this.args.model.card;
  }

  get cardIndex(): number {
    return this.args.model.cardIndex;
  }

  get cardNumber(): number {
    return this.args.model.cardNumber;
  }

  get kind(): 'english-to-spanish' | 'spanish-to-english' | 'random' {
    return this.args.model.kind;
  }

  get totalCards(): number {
    return this.args.model.totalCards;
  }

  get quizCards(): number[] {
    return this.args.model.quizCards;
  }

  get showEnglish(): boolean {
    return this.args.model.showEnglish;
  }

  get remainingCards(): number[] {
    return this.quizCards.filter(
      (_cardIdx, idx) => !this.learnedInSession.has(this.quizCards[idx]!)
    );
  }

  get isComplete(): boolean {
    return this.remainingCards.length === 0;
  }

  @action
  handleCorrect(): void {
    this.cardProgress.recordCorrect(this.cardIndex);

    // Check if this card just became learned
    const progress = this.cardProgress.getCardProgress(this.cardIndex);
    if (progress.learned) {
      // Remove from session since it's now learned
      this.learnedInSession.add(this.cardIndex);
      this.learnedInSession = new Set(this.learnedInSession);

      // Check if all cards are now learned
      if (this.isComplete) {
        return;
      }
    }

    this.nextCard();
  }

  @action
  handleIncorrect(): void {
    this.cardProgress.recordIncorrect(this.cardIndex);
    this.nextCard();
  }

  @action
  handleLearned(): void {
    this.cardProgress.recordLearned(this.cardIndex);

    // Remove this card from the session
    this.learnedInSession.add(this.cardIndex);
    this.learnedInSession = new Set(this.learnedInSession);

    // Check if all cards are now learned - if so, don't navigate
    if (this.isComplete) {
      return;
    }

    // Navigate to the same card number (which will now show the next unlearned card)
    this.nextCard();
  }

  nextCard(): void {
    // Calculate the next card number
    let nextCardNumber = this.cardNumber + 1;

    // If we've gone through all remaining cards, cycle back to the beginning
    if (nextCardNumber >= this.remainingCards.length) {
      nextCardNumber = 0;
    }

    // Navigate to the next card
    this.router.transitionTo('quiz.card', this.kind, nextCardNumber);
  }

  @action
  returnHome(): void {
    this.router.transitionTo('index');
  }

  @action
  restartQuiz(): void {
    this.learnedInSession = new Set();
    this.router.transitionTo('quiz', this.kind);
  }

  <template>
    {{#if this.isComplete}}
      <QuizCompletion
        @cardProgress={{this.cardProgress}}
        @onRestart={{this.restartQuiz}}
        @onReturnHome={{this.returnHome}}
      />
    {{else}}
      <QuizHeader
        @mode={{this.kind}}
        @onBack={{this.returnHome}}
      />

      <Flashcard
        @card={{this.card}}
        @showEnglish={{this.showEnglish}}
        @onCorrect={{this.handleCorrect}}
        @onIncorrect={{this.handleIncorrect}}
        @onLearned={{this.handleLearned}}
      />
    {{/if}}
  </template>
}
