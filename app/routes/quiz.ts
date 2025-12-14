import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type CardProgressService from '#app/services/card-progress.ts';
import cards from '#app/spanish.ts';
import { topics } from '#app/topics/index.ts';
import type { Card } from '#app/topics/types.ts';

interface QuizRouteModel {
  kind: 'english-to-spanish' | 'spanish-to-english' | 'random';
  quizCards: number[];
  showEnglish: boolean;
  topic: string;
}

export default class QuizRoute extends Route {
  @service declare router: RouterService;
  @service('card-progress') declare cardProgress: CardProgressService;

  queryParams = {
    topic: {
      refreshModel: true
    }
  };

  model(params: { kind: string; topic?: string }): QuizRouteModel {
    const kind = params.kind as QuizRouteModel['kind'];
    const topic = params.topic || 'all';

    // Validate kind parameter
    if (!['english-to-spanish', 'spanish-to-english', 'random'].includes(kind)) {
      this.router.transitionTo('index');
      throw new Error('Invalid quiz kind');
    }

    // Get the cards for the selected topic
    let topicCards: Card[];
    if (topic === 'all') {
      topicCards = cards;
    } else if (topic in topics) {
      topicCards = topics[topic as keyof typeof topics];
    } else {
      // Invalid topic, default to all
      topicCards = cards;
    }

    // Build a map from topic cards to their indices in the full card set
    const topicCardIndices: number[] = [];
    topicCards.forEach(topicCard => {
      const index = cards.findIndex(card => {
        if (card.type !== topicCard.type) return false;
        // Compare based on type-specific properties
        if (card.type === 'vocab' && topicCard.type === 'vocab') {
          return card.spanish === topicCard.spanish && card.english === topicCard.english;
        } else if (card.type === 'phrase' && topicCard.type === 'phrase') {
          return card.spanish === topicCard.spanish && card.english === topicCard.english;
        }
        // For other types, use JSON stringify as a simple comparison
        return JSON.stringify(card) === JSON.stringify(topicCard);
      });
      if (index !== -1) {
        topicCardIndices.push(index);
      }
    });

    // Get unlearned cards from the topic
    const allUnlearnedCards = this.cardProgress.getUnlearnedCards();
    const unlearnedCards = allUnlearnedCards.filter(index => topicCardIndices.includes(index));

    let quizCards: number[];
    if (unlearnedCards.length === 0) {
      // If all cards in topic are learned, use all topic cards
      quizCards = topicCardIndices;
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
      topic,
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
