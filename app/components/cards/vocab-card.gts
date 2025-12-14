import Component from '@glimmer/component';
import FlippableCard from './flippable-card.gts';

interface VocabCardSignature {
  Args: {
    english: string;
    spanish: string;
    showEnglish: boolean;
    onCorrect: () => void;
    onIncorrect: () => void;
    onLearned: () => void;
  };
}

export default class VocabCard extends Component<VocabCardSignature> {
  get frontText(): string {
    return this.args.showEnglish ? this.args.english : this.args.spanish;
  }

  get backText(): string {
    return this.args.showEnglish ? this.args.spanish : this.args.english;
  }

  <template>
    <FlippableCard
      @frontText={{this.frontText}}
      @backText={{this.backText}}
      @cardType="vocab"
      @typeColor="var(--indigo-9)"
      @onCorrect={{@onCorrect}}
      @onIncorrect={{@onIncorrect}}
      @onLearned={{@onLearned}}
    />
  </template>
}
