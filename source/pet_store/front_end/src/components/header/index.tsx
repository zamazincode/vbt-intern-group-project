import Button from "../button";
import Logo from "../logo";
import Navbar from "./navbar";

export default function Header() {
    return (
        <header className="containerx py-2 flex justify-between items-center">
            <Logo isLink />

            <Navbar />

            <Button isLink href="/login">
                Giriş Yap
            </Button>
        </header>
    );
}
