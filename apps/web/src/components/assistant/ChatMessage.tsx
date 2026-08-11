'use client';

import ReactMarkdown from 'react-markdown';
import type { AssistantMessage } from '@/lib/assistant';

export function ChatMessage({ message }: { message: AssistantMessage }) {
  const isUser = message.role === 'user';
  return (
    <div className={`flex ${isUser ? 'justify-end' : 'justify-start'} mb-3`}>
      <div
        className={`max-w-[85%] rounded-2xl px-4 py-2 text-sm leading-relaxed ${
          isUser ? 'bg-primary-600 text-white' : 'bg-slate-100 text-slate-800'
        }`}
      >
        {isUser ? (
          <span className="whitespace-pre-wrap">{message.content}</span>
        ) : (
          <div className="prose prose-sm max-w-none prose-p:my-1 prose-ul:my-1">
            <ReactMarkdown>{message.content || '…'}</ReactMarkdown>
          </div>
        )}
      </div>
    </div>
  );
}
