"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { authClient } from "@/lib/auth-client";

export default function AuthRedirect({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const { data: session, isPending } = authClient.useSession();
  const [isRedirecting, setIsRedirecting] = useState(false);

  useEffect(() => {
    // If the session is not loading and there is a session, redirect to dashboard
    if (!isPending && session && !isRedirecting) {
      setIsRedirecting(true);
      router.push("/dashboard");
    }
  }, [session, isPending, router, isRedirecting]);

  // If there's a session and we're redirecting, show a brief loading state
  if (!isPending && session && isRedirecting) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
        <p className="ml-4">Redirecting...</p>
      </div>
    );
  }

  // Render the children (login/signup form)
  return <>{children}</>;
}
