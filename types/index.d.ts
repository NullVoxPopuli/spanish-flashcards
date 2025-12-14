
import '@glint/template';

declare module '#app/spanish.ts' {
  import type { Card } from '#app/topics/types.ts';
  const allCards: Card[];
  export default allCards;
}

declare global {
  interface HTMLStyleElementAttributes {
    scoped: '';
    inline: '';
  }
}
