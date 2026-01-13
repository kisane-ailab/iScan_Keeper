'use client';

import dynamic from 'next/dynamic';
import 'swagger-ui-react/swagger-ui.css';

const SwaggerUI = dynamic(() => import('swagger-ui-react'), { ssr: false });

interface SwaggerUIClientProps {
  spec: object;
}

export function SwaggerUIClient({ spec }: SwaggerUIClientProps) {
  return (
    <div className="swagger-wrapper">
      <SwaggerUI spec={spec} />
      <style jsx global>{`
        .swagger-wrapper {
          background: #fafafa;
          min-height: 100vh;
        }
        .swagger-ui .topbar {
          display: none;
        }
        .swagger-ui .info {
          margin: 20px 0;
        }
        .swagger-ui .info .title {
          font-size: 28px;
          font-weight: bold;
        }
      `}</style>
    </div>
  );
}
