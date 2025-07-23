import { Navigate } from "react-router";

type ProtectedRouteProps = {
    user: "" | null;
    redirectPath?: string;
    children: React.ReactNode;
};

export default function ProtectedRoute({
    user,
    redirectPath = "/",
    children,
}: ProtectedRouteProps) {
    if (!user) {
        return <Navigate to={redirectPath} />;
    }

    return children;
}
