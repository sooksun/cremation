import { getAssistantConfig } from './assistant.config';

describe('getAssistantConfig', () => {
  const OLD = process.env;
  beforeEach(() => {
    process.env = { ...OLD };
  });
  afterEach(() => {
    process.env = OLD;
  });

  it('returns the API key as-is when it is a real key', () => {
    process.env.OPENROUTER_API_KEY = 'sk-or-v1-realkey';
    expect(getAssistantConfig().apiKey).toBe('sk-or-v1-realkey');
  });

  it('trims surrounding whitespace from the API key', () => {
    process.env.OPENROUTER_API_KEY = '  sk-or-v1-realkey\n';
    expect(getAssistantConfig().apiKey).toBe('sk-or-v1-realkey');
  });

  it.each([
    'CHANGE_ME',
    'change-me',
    'PASTE_YOUR_OPENROUTER_KEY_HERE',
    'YOUR_API_KEY_HERE',
    '<your-key>',
    '   ',
  ])('treats placeholder %p as not configured', (value) => {
    process.env.OPENROUTER_API_KEY = value;
    expect(getAssistantConfig().apiKey).toBe('');
  });
});
