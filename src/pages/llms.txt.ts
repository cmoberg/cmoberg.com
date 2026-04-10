import { getCollection } from 'astro:content';
import type { APIContext } from 'astro';

export async function GET(context: APIContext) {
  const posts = await getCollection('posts', ({ data }) => !data.draft);
  const sorted = posts.sort((a, b) => b.data.date.valueOf() - a.data.date.valueOf());

  const base = context.site?.toString().replace(/\/$/, '') ?? 'https://cmoberg.com';

  const firstSentence = (body: string): string => {
    const text = body
      .replace(/^---[\s\S]*?---/, '')   // strip frontmatter
      .replace(/!\[.*?\]\(.*?\)/g, '')  // strip images
      .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1') // strip links, keep text
      .replace(/[#*`_]/g, '')           // strip markdown syntax
      .trim();
    const match = text.match(/[^.!?]*[.!?]/);
    return match ? match[0].trim() : text.slice(0, 120).trim();
  };

  const postLines = sorted
    .map((post) => `- [${post.data.title}](${base}/blog/${post.id}/): ${post.data.summary ?? firstSentence(post.body ?? '')}`)
    .join('\n');

  const body = `# Carl Moberg

> Technology executive, co-founder, and Field CTO based in Stockholm. Writer of a TIL (Today I Learned) blog covering curious facts across history, science, language, and culture.

Carl Moberg is a technology executive with a 25-year track record in infrastructure automation and AI deployment. Co-founder and CTO of Avassa Systems. Previously Senior Director of Product Management at Cisco following the $175M acquisition of Tail-f Systems. Published author, patent holder, and conference speaker.

## Pages

- [CV](${base}/cv): Full professional background including work history, board experience, patents, publications, and selected talks.

## Blog

${postLines}
`;

  return new Response(body, {
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
    },
  });
}
