import Component from '@glimmer/component';
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

function isVocabCard(card: Card): card is { type: 'vocab'; english: string; spanish: string } {
  return card.type === 'vocab';
}

function isPhraseCard(card: Card): card is { type: 'phrase'; english: string | string[]; spanish: string | string[] } {
  return card.type === 'phrase';
}

export default class FlashcardComponent extends Component<FlashcardSignature> {
  get isVocab(): boolean {
    return isVocabCard(this.args.card);
  }

  get isPhrase(): boolean {
    return isPhraseCard(this.args.card);
  }

  get vocabCard() {
    const card = this.args.card;
    if (isVocabCard(card)) {
      return card;
    }
    return null;
  }

  get phraseCard() {
    const card = this.args.card;
    if (isPhraseCard(card)) {
      return card;
    }
    return null;
  }

  <template>
    {{#if this.isVocab}}
      {{#if this.vocabCard}}
        <VocabCard
          @english={{this.vocabCard.english}}
          @spanish={{this.vocabCard.spanish}}
          @showEnglish={{@showEnglish}}
          @onCorrect={{@onCorrect}}
          @onIncorrect={{@onIncorrect}}
          @onMastered={{@onMastered}}
        />
      {{/if}}
    {{else if this.isPhrase}}
      {{#if this.phraseCard}}
        <PhraseCard
          @english={{this.phraseCard.english}}
          @spanish={{this.phraseCard.spanish}}
          @showEnglish={{@showEnglish}}
          @onCorrect={{@onCorrect}}
          @onIncorrect={{@onIncorrect}}
          @onMastered={{@onMastered}}
        />
      {{/if}}
    {{else}}
      <div>Unsupported card type: {{@card.type}}</div>
    {{/if}}
  </template>
}
