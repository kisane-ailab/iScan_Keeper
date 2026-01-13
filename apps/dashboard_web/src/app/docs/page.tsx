import { Metadata } from 'next';
import { SwaggerUIClient } from './swagger-ui';
import spec from '@/shared/api/openapi.json';

export const metadata: Metadata = {
  title: 'API Documentation - iScan Keeper',
  description: 'iScan Keeper API 문서',
};

export default function DocsPage() {
  return (
    <main>
      <SwaggerUIClient spec={spec} />
    </main>
  );
}
