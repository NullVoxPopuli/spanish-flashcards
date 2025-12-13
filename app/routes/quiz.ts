import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type CardProgressService from '#app/services/card-progress.ts';
import cards from '#app/spanish.ts';
import type { Card } from '#app/topics/types.ts';

interface QuizRouteModel {
  kind: 'english-to-spanish' | 'spanish-to-english' | 'random';
  quizCards: number[];
  showEnglish: boolean;
}

export default class QuizRoute extends Route {
  @service declare router: RouterService;
  @service('card-progress') declare cardProgress: CardProgressService;

  model(params: { kind: string }): QuizRouteModel {
    const kind = params.kind as QuizRouteModel['kind'];

    // Validate kind parameter
    if (!['english-to-spanish', 'spanish-to-english', 'random'].includes(kind)) {
      this.router.transitionTo('index');
      throw new Error('Invalid quiz kind');
    }

    // Get unlearned cards
    const unlearnedCards = this.cardProgress.getUnlearnedCards();

    let quizCards: number[];
    if (unlearnedCards.length === 0) {
      // If all cards are learned, use all cards
      quizCards = cards.map((_card: Card, index: number) => index);
    } else {
      quizCards = unlearnedCards;
    }

    // Shuffle the cards
    quizCards = this.shuffleArray([...quizCards]);

    // Set the quiz direction based on mode
    let showEnglish: boolean;
    if (kind === 'english-to-spanish') {
      showEnglish = true;
    } else if (kind === 'spanish-to-english') {
      showEnglish = false;
    } else {
      // Random mode
      showEnglish = Math.random() > 0.5;
    }

    return {
      kind,
      quizCards,
      showEnglish,
    };
  }

  shuffleArray<T>(array: T[]): T[] {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j]!, shuffled[i]!];
    }
    return shuffled;
  }
}
