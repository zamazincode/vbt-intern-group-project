import Navbar from "../header/navbar";
import Logo from "../logo";
import Socials from "./socials";

export default function Footer() {
    return (
        <footer className="bg-[#ede8e8] md:px-12 p-8 containerx rounded-tl-2xl rounded-tr-2xl">
            <div className="flex items-end justify-between max-sm:flex-col max-sm:items-center gap-6">
                <Logo />
                <Navbar />
                <Socials />
            </div>
            <div className="w-full h-0.25 bg-gray rounded-full my-8" />
            <div>
                <p className="text-center text-copy/60">
                    ©2025 - All rights reserved
                </p>
            </div>
        </footer>
    );
}
