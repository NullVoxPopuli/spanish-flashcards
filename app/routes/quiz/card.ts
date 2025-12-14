import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type CardProgressService from '#app/services/card-progress.ts';
import cards from '#app/spanish.ts';
import type { Card } from '#app/topics/types.ts';

interface CardRouteModel {
  card: Card;
  cardIndex: number;
  cardNumber: number;
  kind: string;
  totalCards: number;
  quizCards: number[];
  showEnglish: boolean;
  learnedInSession: Set<number>;
}

export default class QuizCardRoute extends Route {
  @service declare router: RouterService;
  @service('card-progress') declare cardProgress: CardProgressService;

  model(params: { cardNumber: string }): CardRouteModel {
    const cardNumber = parseInt(params.cardNumber, 10);

    // Get parent route model
    const parentModel = this.modelFor('quiz') as {
      kind: string;
      quizCards: number[];
      showEnglish: boolean;
    };

    const { kind, quizCards, showEnglish } = parentModel;

    // Validate card number
    if (isNaN(cardNumber) || cardNumber < 0 || cardNumber >= quizCards.length) {
      this.router.transitionTo('quiz', kind);
      throw new Error('Invalid card number');
    }

    const cardIndex = quizCards[cardNumber]!;
    const card = cards[cardIndex]!;

    return {
      card,
      cardIndex,
      cardNumber,
      kind,
      totalCards: quizCards.length,
      quizCards,
      showEnglish,
      learnedInSession: new Set<number>(),
    };
  }
}
