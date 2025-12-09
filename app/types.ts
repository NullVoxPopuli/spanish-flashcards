export type Card = Vocab | Phrase | Conjugation | Picture | FillInTheBlank;

interface Vocab {
  type: "vocab";
  spanish: string;
  english: string;
}

interface Phrase {
  type: "phrase";
  spanish: string | string[];
  english: string | string[];
}

interface Conjugation {
  type: "conjugation";
  verb: string;
  tense: string;
  person: string;
  spanish: string;
}

interface Picture {
  type: "picture";
  spanish: string;
  imageUrl: string;
}

interface FillInTheBlank {
  type: "fill-in-the-blank";
  sentence: string;
  answer: string;
}

export function cards(cards: Card[]): Card[] {
  return cards;
}
