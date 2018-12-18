
# Post Intro

At Factful one of our projects is to build tools that make state of the art machine learning and artificial intelligence accessible to investigative reporters. One thing that means is that we need to spend some time testing the components that already exist so we can prioritize our own efforts. The first step in any kind of document analysis is OCR, or optical character recognition, which allows us to transform a scan or photograph of a letter or filing into searchable, sortable text that we can do more with.

[INSERT SOME NOTES FROM JORDAN ABOUT WHERE THE CUTTING EDGE IS HEADED; BIGRAMS? ]
START NOTES

Scene text recognition is going to change everything, in part because it can't rely on underlying OCR techniques like line detection. Signs aren't always aligned on a straight line.

scene recognition vs. document recognition

most of what we're looking at is document recognition. Often OCR falls down in document engines because document recognition chokes on font changes, inline graphics, and skewed text. So Scene recognition is better about spotting glyphs.

Some use bigrams (and dictionaries?) to improve guesses

tesseract will let you supply a dictionary. how is it using the dictionary?

TED WILL DOUBLE CHECK TO MAKE SURE WE UNDERSTAND HOW TESSERACT USES BIGRAMS AND DICTIONARIES

Interesting advances in pre-processing:
* automatically de-warping images -- straightening out distorted text
* super resolution -- boosting missing details based on probability from other pictures.
* text in arbitrary locations
* accomodating lower resolution text

Papers worth reading are forthcoming from Jordan.


END NOTES

With all that in mind, we identified a few sample documents to run through a handful of OCR systems so we could compare the results. We tested a few proprietary algorithms and a few that are free and open source.

All the tools we looked at will output a text file. Most will also output JSON or hOCR files that include data about where each word and line sits on a particular page. [hOCR](http://kba.cloud/hocr-spec/1.2/) is an open standard for representing OCR results -- there are a few open source CSS and JavaScript libraries that can help you view and display hOCR formats. Check out [hocrjs](http://kba.cloud/hocrjs/), [hOCR Proofreader](https://github.com/not-implemented/hocr-proofreader), and [hOCR JavaScript](https://github.com/ultrasaurus/hocr-javascript) for some good starting points for actually taking advantage of hOCR.

We identified a few loosely representative document samples to try each OCR library against:

* A **receipt** -- This receipt from the Riker's commisary was included in [States of Incarceration](https://statesofincarceration.org/states/new-york-rikers-island-ny-11370-plain-sight), a collaborative storytelling project and traveling exhibition about incarceration in America.
* A **heavily redacted document** -- [Carter Page's FISA warrant](http://www.kingpin.cc/wp-content/uploads/2018/11/Carter-Page-release-9-November-2018.pdf) is legal filing with a lot of redacted portions, just the kind of exasperating thing reporters deal with all the time.
* **Something old** -- [Executive Order 9066](https://www.archives.gov/historical-docs/todays-doc/?dod-date=219) authorized the internment of Japanese Americans in 1942. The scanned image available in the national archives is fairly high quality but it is still an old, typewritten document.
* A **form** -- This [Texas campaign finance report](http://204.65.203.5/public/100721233.pdf), from [a Texas Tribune story about abuses in the juvenile justice system](https://www.texastribune.org/2018/11/01/harris-county-texas-juvenile-judges-private-attorneys/amp/) has very clean text but the formatting is important to understanding the document.

The tools we tested support text in multiple languages but we only tested on English language documents. The Ruby scripts we used are all included in our [repository](LINK TK) if you want to test these OCR engines with other languages or sample documents.

## [Tesseract](https://github.com/tesseract-ocr/tesseract)

[Tesseract](https://github.com/tesseract-ocr/tesseract) is a free and open source command line OCR engine that was developed at Hewlett-Packard in the mid 80s, and has been maintained by Google since 2006. It is well documented. Tesseract is written in C/C++. Their [installation instructions](https://github.com/tesseract-ocr/tesseract/wiki) are reasonably comprehensive. We were able to follow them and get Tesseract running without any additional troubleshooting.

Tesseract will return results as plain text, hOCR or in a PDF, with text overlaid on the original image.

**Pricing:** Tesseract is free and open source software.

## [Google Cloud Vision](https://cloud.google.com/vision/)

Google's cloud services include an OCR tool, Vision. Of all the tools we tested, Vision did the best job of extracting useful results from the low resolution images we fed it. There are a few steps to getting it up and running, but [the documentation](https://cloud.google.com/vision/docs/how-to) covers them well. If you follow the setup instructions

Dan Nguyen has published a [few additional Python scripts](https://gist.github.com/dannguyen/a0b69c84ebc00c54c94d) that he used to compare Cloud Vision and Tesseract.


**Pricing:** Your first 1000 pages each month are free. After that you'll pay $1.50 per thousand pages. In addition, Google Cloud Vision currently offers a free trial that will get you $300 in free credits, which is enough to process 200K pages in one month. When you get to 10 million pages the price drops to $0.60 per thousand pages.  

## [Microsoft Azure Computer Vision](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/)

[Computer Vision](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/) is Microsoft Azure's OCR tool. It's available as an API or as an SDK if you want to bake it into another application. Azure provides sample jupyter notebooks, which is helpful. Their API doesn't return plain text results, however. The only way to get those is to scrape the text out of the bounding boxes. Our script or their sample scripts will do that nicely though.

There are a handful of steps that you need to follow to use Computer Vision -- their [quickstart guide](https://docs.microsoft.com/en-us/azure/cognitive-services/Computer-vision/quickstarts/python-disk) spells them out, but you need to set up an Azure cloud account, set your permissions **TED: IN AZURE?** to create an application that you can get keys from and then get the subscription keys you need to actually use the API. The steps might seem a bit circular but you'll get there.

**Pricing:** Your first 5000 pages each month are free. After that you'll pay $1.50 per thousand pages and the per-thousand page price drops again at 1,000,000 pages and at 5,000,000 pages.

## [OCRopus](https://github.com/tmbdev/ocropy)

[OCRopus](https://github.com/tmbdev/ocropy) is a collection of document analysis tools that add up to functional OCR engine if you throw in a final script to stitch the `recognize` output into a text file. OCRopus will output hOCR.

OCRopus requires python 2.7 so you probably want to use `virtualenv` to install it and manage dependencies. We had hiccups using the installation instructions in the [Readme file](https://github.com/tmbdev/ocropy#running), but found workable [installation instructions](https://github.com/tmbdev/ocropy/issues/241) hiding in an issue. You'll also need to [follow some specialized instructions](https://markhneedham.com/blog/2018/05/04/python-runtime-error-osx-matplotlib-not-installed-as-framework-mac/) to get `matplotlib` running in a Python 2.7 `virtualenv`.

Dan Vanderkam's [blog post](https://www.danvk.org/2015/01/09/extracting-text-from-an-image-using-ocropus.html) about his experiences with OCRopus is also helpful.

OCRopus needs higher resolution images than the other OCR engines we tested -- you'll [see a lot of errors](https://github.com/tmbdev/ocropy/wiki/FAQ#what-exactly-is-meant-by-300-dpi-for-digital-images) if your resolution is below 300 dpi.

### [Kraken](http://kraken.re/)
[Kraken](http://kraken.re/) is a turnkey OCR system forked from OCRopus. Kraken does output geometry in hOCR or ALTO format. (Analyzed Layout and Text Object is an XML schema for text and layout information. It's a well developed standard but we didn't encounter other tools that output ALTO in our testing.) TODO: TEST hOCR OUTPUT

**Pricing:**  OCRopus and Kraken are free and open source software.

## [Adobe Acrobat](https://acrobat.adobe.com/us/en/acrobat/how-to/ocr-software-convert-pdf-to-text.html)

Adobe doesn't provide API access to their OCR tools, but they will batch process documents.

RESULTS TK

**Pricing:**

## Still to be tested

* [Abbyy Cloud](https://www.ocrsdk.com/)
* [Calamari]() -- TED WILL TEST;
* Swift OCR -- TED WILL CONFIRM THERE'S NO RUNNER; WE'D NEED TO RUN SOFTWARE? TBD
* Attention OCR -- TED WILL EXPERIMENT WITH THEIR RUNNER

We initially included [Amazon's Rekognition API](https://aws.amazon.com/rekognition/) on our list, but ultimately decided not to test it. Rekognition is primarily designed to identify text in images of signs and labels, rather than in documents. It's more challenging to implement than the other OCR tools we looked at and we didn't have a need for that level of power.

Amazon Textract is a new service from Amazon. We applied for access to the beta but hadn't received a response by the time we went to press.  


# More on what we learned

None of the tools we worked with got perfect results, but all of them were good enough to make documents more comprehensible. In most cases if you need a complete transcription you'll have to do some additional review and correction.

# Working with OCR'd documents


## Types of tasks

- search indexing
- transcription
- layout analysis
- information extraction
- document classification

OCR tools vary in quality and robustness.  Whether they will do a good job depend on the task you'd like to accomplish.  Literal transcription of text, where exact accuracy is important, may be hard to accomplish automatically without additional review by a person.

On the other hand, searching for documents keywords may not require exact accuracy to surface documents.  For example, a name may be mentioned multiple times in a document, and so long as it's recognized correctly _once_, a search query will find it.

Sometimes

### Searching Text & what to be aware of

- OCR engines are far from perfect.
- basic literal search isn't going to produce perfect results.
- even regular expressions aren't going to be great (word breaks, recognition errors)
- What kinds of errors do OCR engines produce?

### Layout analysis

- Position data can help, and sometimes it's necessary
- OCR systems do some basic layout analysis.
- What if you need to do more analysis?

# Goofy things

- [Darius Kazemi's Reverse OCR](http://reverseocr.tumblr.com/)
- [Tesseract.js](https://github.com/naptha/tesseract.js)
- Skip. [Unfortunate OCR in historic books](https://wraabe.wordpress.com/2009/03/07/an-ocr-cliche-into-hisher-anus/)
-

## SKIP Pricing

SKIP Most cloud API services charge per thousand pages after some number of free pages per month. As of this writing, ... TK.

## More

The most effective [CHECK] OCR tools use a combination of shape recognition and context to make the best guess about what any one letter glyph represents. That means that a tool that does a great job on English language text might struggle with other languages that use the same alphabet but don't tend to follow the same spelling patterns. (HI! IS THIS ACTUALLY ACCURATE? also what is a good example of a bigram that occurs a lot in other languages but not english? like `aa` or something?) and an OCR tool that is great on the latin alphabet doesn't necessarily know the first thing about Cyrillic or Kanji so there's definitely room to expand this testing to include more languages.
