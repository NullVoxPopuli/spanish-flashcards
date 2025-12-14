import Component from '@glimmer/component';
import type { Card } from '#app/topics/types.ts';
import VocabCard from '#app/components/cards/vocab-card.gts';
import PhraseCard from '#app/components/cards/phrase-card.gts';

interface FlashcardSignature {
  Args: {
    card: Card;
    showEnglish: boolean;
    onCorrect: () => void;
    onIncorrect: () => void;
    onLearned: () => void;
  };
}

function isVocabCard(card: Card): card is { type: 'vocab'; english: string; spanish: string } {
  return card.type === 'vocab';
}

function isPhraseCard(card: Card): card is { type: 'phrase'; english: string; spanish: string } {
  return card.type === 'phrase';
}

export default class FlashcardComponent extends Component<FlashcardSignature> {
  <template>
    {{#if (isVocabCard @card)}}
      <VocabCard
        @english={{@card.english}}
        @spanish={{@card.spanish}}
        @showEnglish={{@showEnglish}}
        @onCorrect={{@onCorrect}}
        @onIncorrect={{@onIncorrect}}
        @onLearned={{@onLearned}}
      />
    {{else if (isPhraseCard @card)}}
      <PhraseCard
        @english={{@card.english}}
        @spanish={{@card.spanish}}
        @showEnglish={{@showEnglish}}
        @onCorrect={{@onCorrect}}
        @onIncorrect={{@onIncorrect}}
        @onLearned={{@onLearned}}
      />
    {{/if}}
  </template>
}
