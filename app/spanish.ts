import { topics } from '#app/topics/index.ts';
import type { Card } from '#app/topics/types.ts';

// Combine all topics into a single array of cards
const allCards: Card[] = Object.values(topics).flat();

export default allCards;
