import Component from '@glimmer/component';
import { on } from '@ember/modifier';

interface QuizHeaderSignature {
  Args: {
    mode: 'english-to-spanish' | 'spanish-to-english' | 'random';
    onBack: () => void;
  };
}

export default class QuizHeader extends Component<QuizHeaderSignature> {
  get modeLabel(): string {
    if (this.args.mode === 'english-to-spanish') {
      return 'English → Spanish';
    } else if (this.args.mode === 'spanish-to-english') {
      return 'Spanish → English';
    } else {
      return 'Random Mode';
    }
  }

  <template>
    <div style="display: flex; align-items: center; gap: var(--size-5); margin-block-end: var(--size-3);">
      <button
        type="button"
        {{on 'click' @onBack}}
        style="background: transparent; border: none; color: var(--gray-8); font-size: var(--font-size-2); cursor: pointer; padding: var(--size-2);"
      >
        ← Back
      </button>
      <div style="font-size: var(--font-size-2); font-weight: var(--font-weight-6); color: var(--gray-9);">
        {{this.modeLabel}}
      </div>
    </div>

    <style scoped>
      button:hover { color: var(--gray-9); }

      @media (width <= 640px) {
        div { gap: var(--size-2); margin-block-end: var(--size-1); flex-shrink: 0; }
        button, div > div { font-size: clamp(var(--font-size-0), 2vw, var(--font-size-1)); }
        button { padding: var(--size-1) var(--size-2); }
      }

      @media (width <= 640px) and (max-aspect-ratio: 3/4) {
        div { gap: var(--size-3); margin-block-end: var(--size-2); }
        button, div > div { font-size: var(--font-size-2); }
        button { padding: var(--size-2) var(--size-3); }
      }

      @media (height <= 500px) {
        div { gap: var(--size-1); margin-block-end: var(--size-00); }
        button, div > div { font-size: var(--font-size-0); }
        button { padding: var(--size-1) var(--size-2); }
      }
    </style>
  </template>
}
