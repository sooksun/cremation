import { readdirSync, readFileSync } from 'fs';
import { join } from 'path';

export function loadKnowledgeBase(dir: string): string {
  const files = readdirSync(dir)
    .filter((f) => f.toLowerCase().endsWith('.md'))
    .sort();

  if (files.length === 0) {
    throw new Error(`No knowledge (.md) files found in ${dir}`);
  }

  return files
    .map((f) => readFileSync(join(dir, f), 'utf-8').trim())
    .join('\n\n---\n\n');
}
