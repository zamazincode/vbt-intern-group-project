import { Route, Routes } from "react-router";
import RootLayout from "./pages/RootLayout";
import Home from "./pages/home";
import NotFound from "./pages/not-found";
import Login from "./pages/auth/login";
import PetList from "./pages/PetList";

function App() {
    return (
        <Routes>
            <Route path="/" element={<RootLayout />}>
                <Route index element={<Home />} />

                <Route path="ilanlar" element={<PetList />} />

                <Route path="auth/login" element={<Login />} />
                <Route path="*" element={<NotFound />} />
            </Route>
        </Routes>
    );
}

export default App;
