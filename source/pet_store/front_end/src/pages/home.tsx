import Button from "../components/button";
import { IMAGES } from "../constants";

export default function Home() {
    return (
        <>
            {/* Hero Section */}
            <section className="containerx flex-center max-md:flex-col-reverse  mt-6">
                <div className="flex-1 space-y-8 max-md:text-center">
                    <h1 className="text-6xl font-medium leading-20">
                        Sadece Bir Evcil Hayvan Değil, <br />
                        <span className="text-primary font-payton-one">
                            Bir Aile Üyesi.
                        </span>
                    </h1>

                    <p className="md:max-w-[45ch]">
                        Lorem ipsum dolor sit, amet consectetur adipisicing
                        elit. Adipisci asperiores delectus voluptatum sit ipsum
                        eaque officia, fugit vitae autem odit harum quia
                        assumenda ratione! Exercitationem aliquid qui soluta
                        nihil sunt.
                    </p>

                    <Button isLink href="/ilanlar" className="px-18">
                        Göz At
                    </Button>
                </div>

                <div className="flex-1">
                    <img
                        src={IMAGES.heroImg}
                        alt="Dog and Cat Image"
                        className="object-cover w-full"
                    />
                </div>
            </section>
        </>
    );
}
