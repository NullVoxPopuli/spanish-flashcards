import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';

export default class QuizIndexRoute extends Route {
  @service declare router: RouterService;

  beforeModel(): void {
    const parentModel = this.modelFor('quiz') as {
      kind: string;
      quizCards: number[];
    };

    // Redirect to first card
    if (parentModel.quizCards.length > 0) {
      this.router.replaceWith('quiz.card', parentModel.kind, 0);
    } else {
      // No cards available, go back home
      this.router.replaceWith('index');
    }
  }
}
