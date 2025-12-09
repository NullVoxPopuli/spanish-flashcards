import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import type Owner from '@ember/owner';
import cards from '#app/spanish.ts';

interface CardProgress {
  cardIndex: number;
  correctCount: number;
  incorrectCount: number;
  mastered: boolean;
  lastReviewed?: number;
}

interface ProgressData {
  cards: Record<string, CardProgress>;
}

const STORAGE_KEY = 'spanish-flashcards-progress';
const MASTERY_THRESHOLD = 3; // Need 3 correct in a row to master

export default class CardProgressService extends Service {
  @tracked progressData: ProgressData;

  constructor(owner: Owner) {
    super(owner);
    this.progressData = this.loadProgress();
  }

  private loadProgress(): ProgressData {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      try {
        return JSON.parse(stored);
      } catch (e) {
        console.error('Failed to parse stored progress', e);
      }
    }
    return { cards: {} };
  }

  private saveProgress(): void {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(this.progressData));
  }

  private getCardKey(cardIndex: number): string {
    const card = cards[cardIndex];
    if (!card) {
      throw new Error(`Card at index ${cardIndex} not found`);
    }
    return `${card.type}-${cardIndex}`;
  }

  getCardProgress(cardIndex: number): CardProgress {
    const key = this.getCardKey(cardIndex);
    if (!this.progressData.cards[key]) {
      this.progressData.cards[key] = {
        cardIndex,
        correctCount: 0,
        incorrectCount: 0,
        mastered: false,
      };
    }
    return this.progressData.cards[key];
  }

  recordCorrect(cardIndex: number): void {
    const progress = this.getCardProgress(cardIndex);
    progress.correctCount++;
    progress.lastReviewed = Date.now();

    // Check if card is mastered (3 correct in a row means no recent incorrect)
    if (progress.correctCount >= MASTERY_THRESHOLD &&
        (progress.incorrectCount === 0 || progress.correctCount - progress.incorrectCount >= MASTERY_THRESHOLD)) {
      progress.mastered = false; // Will be set via recordMastered
    }

    this.progressData = { ...this.progressData };
    this.saveProgress();
  }

  recordIncorrect(cardIndex: number): void {
    const progress = this.getCardProgress(cardIndex);
    progress.incorrectCount++;
    progress.lastReviewed = Date.now();
    progress.mastered = false; // Reset mastery on incorrect answer

    this.progressData = { ...this.progressData };
    this.saveProgress();
  }

  recordMastered(cardIndex: number): void {
    const progress = this.getCardProgress(cardIndex);
    progress.mastered = true;
    progress.lastReviewed = Date.now();

    this.progressData = { ...this.progressData };
    this.saveProgress();
  }

  getUnmasteredCards(): number[] {
    return cards
      .map((_, index) => index)
      .filter(index => !this.getCardProgress(index).mastered);
  }

  getAllProgress(): CardProgress[] {
    return cards.map((_, index) => this.getCardProgress(index));
  }

  resetProgress(): void {
    this.progressData = { cards: {} };
    this.saveProgress();
  }

  get totalCards(): number {
    return cards.length;
  }

  get masteredCount(): number {
    return this.getAllProgress().filter(p => p.mastered).length;
  }

  get progressPercentage(): number {
    return Math.round((this.masteredCount / this.totalCards) * 100);
  }
}

declare module '@ember/service' {
  interface Registry {
    'card-progress': CardProgressService;
  }
}
