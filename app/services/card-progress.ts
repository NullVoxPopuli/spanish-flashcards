import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import type Owner from '@ember/owner';
import cards from '#app/spanish.ts';

interface CardProgress {
  cardIndex: number;
  consecutiveCorrect: number;
  totalCorrect: number;
  totalIncorrect: number;
  learned: boolean;
  lastReviewed?: number;
}

interface ProgressData {
  cards: Record<string, CardProgress>;
}

const STORAGE_KEY = 'spanish-flashcards-progress';
const LEARNED_THRESHOLD = 10; // Need 10 correct in a row to mark as learned

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
        consecutiveCorrect: 0,
        totalCorrect: 0,
        totalIncorrect: 0,
        learned: false,
      };
    }
    return this.progressData.cards[key]!;
  }

  recordCorrect(cardIndex: number): void {
    const progress = this.getCardProgress(cardIndex);
    progress.consecutiveCorrect++;
    progress.totalCorrect++;
    progress.lastReviewed = Date.now();

    // Check if card is learned (10 correct in a row)
    if (progress.consecutiveCorrect >= LEARNED_THRESHOLD) {
      progress.learned = true;
    }

    this.progressData = { ...this.progressData };
    this.saveProgress();
  }

  recordIncorrect(cardIndex: number): void {
    const progress = this.getCardProgress(cardIndex);
    progress.consecutiveCorrect = 0; // Reset consecutive counter
    progress.totalIncorrect++;
    progress.lastReviewed = Date.now();
    progress.learned = false; // Reset learned status on incorrect answer

    this.progressData = { ...this.progressData };
    this.saveProgress();
  }  recordLearned(cardIndex: number): void {
    const progress = this.getCardProgress(cardIndex);
    progress.learned = true;
    progress.lastReviewed = Date.now();

    this.progressData = { ...this.progressData };
    this.saveProgress();
  }

  getUnlearnedCards(): number[] {
    return cards
      .map((_, index) => index)
      .filter(index => !this.getCardProgress(index).learned);
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

  get learnedCount(): number {
    return this.getAllProgress().filter(p => p.learned).length;
  }

  get progressPercentage(): number {
    return Math.round((this.learnedCount / this.totalCards) * 100);
  }
}

declare module '@ember/service' {
  interface Registry {
    'card-progress': CardProgressService;
  }
}
