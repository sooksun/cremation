import { mkdtempSync, writeFileSync, rmSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import { loadKnowledgeBase } from './knowledge-loader';

describe('loadKnowledgeBase', () => {
  let dir: string;
  beforeEach(() => {
    dir = mkdtempSync(join(tmpdir(), 'kb-'));
  });
  afterEach(() => {
    rmSync(dir, { recursive: true, force: true });
  });

  it('concatenates all .md files sorted by name with separators', () => {
    writeFileSync(join(dir, '02-b.md'), 'BODY_B');
    writeFileSync(join(dir, '01-a.md'), 'BODY_A');
    const result = loadKnowledgeBase(dir);
    expect(result).toBe('BODY_A\n\n---\n\nBODY_B');
  });

  it('ignores non-md files', () => {
    writeFileSync(join(dir, '01-a.md'), 'BODY_A');
    writeFileSync(join(dir, 'note.txt'), 'IGNORE');
    expect(loadKnowledgeBase(dir)).toBe('BODY_A');
  });

  it('throws when no .md files are found', () => {
    expect(() => loadKnowledgeBase(dir)).toThrow(/no knowledge/i);
  });
});
