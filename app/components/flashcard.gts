import Component from '@glimmer/component';
import { eq } from 'ember-truth-helpers';
import type { Card } from '#app/types.ts';
import VocabCard from '#app/components/cards/vocab-card.gts';
import PhraseCard from '#app/components/cards/phrase-card.gts';

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
  <template>
    {{#if (eq @card.type 'vocab')}}
      <VocabCard
        @english={{@card.english}}
        @spanish={{@card.spanish}}
        @showEnglish={{@showEnglish}}
        @onCorrect={{@onCorrect}}
        @onIncorrect={{@onIncorrect}}
        @onMastered={{@onMastered}}
      />
    {{else if (eq @card.type 'phrase')}}
      <PhraseCard
        @english={{@card.english}}
        @spanish={{@card.spanish}}
        @showEnglish={{@showEnglish}}
        @onCorrect={{@onCorrect}}
        @onIncorrect={{@onIncorrect}}
        @onMastered={{@onMastered}}
      />
    {{else}}
      <div>Unsupported card type: {{@card.type}}</div>
    {{/if}}
  </template>
}
