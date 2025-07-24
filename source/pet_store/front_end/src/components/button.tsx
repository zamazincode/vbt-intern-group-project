import type React from "react";
import { Link } from "react-router";

type ButtonProps = {
    isLink?: boolean;
    href?: string;
    classNames?: string;
    children: React.ReactElement[] | string;
};

export default function Button({
    isLink = false,
    href = "/",
    classNames = "",
    children,
}: ButtonProps) {
    const Component = isLink ? Link : "button";

    return (
        <Component
            to={isLink ? href : ""}
            className={`${classNames} text-white bg-primary rounded-full py-4 px-8 hover:bg-primary/90 transition-colors text-nowrap `}
        >
            {children}
        </Component>
    );
}
