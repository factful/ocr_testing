# OCR comparison

Most of the tools we tested support text in multiple languages but we only tested on English language documents. The Ruby scripts we used are all included in our [repository](LINK TK) if you want to test these OCR engines with other languages or sample documents. .

## [Tesseract](https://github.com/tesseract-ocr/tesseract)

[Tesseract](https://github.com/tesseract-ocr/tesseract) is a free and open source command line OCR engine that was developed at Hewlett-Packard in the late 90s, and has been maintained by Google since 2006. It is well documented and easy to use CHECK but DOES IT NEED TRAINING?

Their [installation instructions](https://github.com/tesseract-ocr/tesseract/wiki) are reasonably comprehensive. We were able to follow them and get Tesseract running without any additional troubleshooting.

Tesseract will return results as plain text, hOCR or in a PDF, text overlaid on the original image.

**Pricing:** Tesseract is free of charge.

## [Google Cloud Vision][GCP_Vision]
[GCP_Vision]: https://cloud.google.com/vision/

See the `google` directory for results

Dan Nguyen has published a [few additional Python scripts](https://gist.github.com/dannguyen/a0b69c84ebc00c54c94d) that he used to compare Cloud Vision and Tesseract.


**Pricing:** Your first 1000 pages each month are free. After that you'll pay $1.50 per thousand pages. In addition, Google Cloud Vision currently offers a free trial that will get you $300 in free credits, which is enough to process 200K pages in one month. When you get to 10 million pages the price drops to $0.60 per thousand pages.  

## [Microsoft Azure Computer Vision][Azure_Vision]
[Azure_Vision]: https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/


[Computer Vision](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/) is Microsoft Azure's OCR tool -- it's available as an API that you can use at the command line or as an SDK if you want to bake it into another application. Azure provides sample jupyter notebooks, which is helpful. Their API doesn't return plain text results, however. The only way to get those is to scrape the text out of the bounding boxes. Our script or their sample scripts will do that nicely though.

There are a handful of steps that you need to follow to use Computer Vision -- their [quickstart guide](https://docs.microsoft.com/en-us/azure/cognitive-services/Computer-vision/quickstarts/python-disk) spells them out, but you need to set up an Azure cloud account, set your permissions **TED: IN AZURE?** to create an application that you can get keys from and then get the subscription keys you need to actually use the API. The steps might seem a bit circular but you'll get there.


**Pricing:** Your first 5000 pages each month are free. After that you'll pay $1.50 per thousand pages and the per-thousand page price drops again at 1,000,000 pages and at 5,000,000 pages.

## [OCRopus][OCRopus_github]
[OCRopus_github]: https://github.com/tmbdev/ocropy


[OCRopus](https://github.com/tmbdev/ocropy) is a collection of document analysis tools. TK: IS IT GENUINELY MORE THAN OCR? OR JUST MORE COMPLEX? ANY OTHER NOTES TO INCLUDE IN TEXT? WHAT ELSE IS WORTH SAYING HERE FOR CONTEXT?

OCRopus requires python 2.7 so you probably want to use `virtualenv` to install it and manage dependancies. We had hiccups using the installation instructions in the [Readme file](https://github.com/tmbdev/ocropy#running), but found workable [installation instructions](https://github.com/tmbdev/ocropy/issues/241) hiding in an issue. You'll also want to [follow some specialized instructions](https://markhneedham.com/blog/2018/05/04/python-runtime-error-osx-matplotlib-not-installed-as-framework-mac/) to get `matplotlib` running in a Python 2.7 `virutalenv`.

 [this blog post is useful](https://www.danvk.org/2015/01/09/extracting-text-from-an-image-using-ocropus.html)


Notes:
Getting OCRopus set up is a pain in the ass.  It will only work on python 2.7, consequently it's probably best to use virtualenv to install and manage dependencies (or use docker? idk).

Trying to run `matplotlib` w/in py2.7 in virtualenv fails unless you [follow instructions](https://markhneedham.com/blog/2018/05/04/python-runtime-error-osx-matplotlib-not-installed-as-framework-mac/) to specify the framework ([that were cribbed from StackOverflow](https://stackoverflow.com/questions/34977388/matplotlib-runtimeerror-python-is-not-installed-as-a-framework)).

OCRopus requires images being processed to be 300 dpi, which is also a pain in the ass, but seems to have some scaling functions.

I followed [the instructions in the Readme](https://github.com/tmbdev/ocropy#running) and any time they didn't work, [i just followed github issue instructions](https://github.com/tmbdev/ocropy/issues/241).


**Pricing:**  OCRopus is free of charge.

## Still to be tested

* [Abbyy Cloud](https://www.ocrsdk.com/)
* [Adobe Acrobat](https://acrobat.adobe.com/us/en/acrobat/how-to/ocr-software-convert-pdf-to-text.html) -- TED WILL CHECK: DO THEY HAVE A CLOUD SERVICE?
* Amazon Textract -- TED IS STILL WAITING TO HEAR BACK FROM BETA
* [Calamari]() -- TED WILL TEST;
* Swift OCR -- TED WILL CONFIRM THERE'S NO RUNNER; WE'D NEED TO RUN SOFTWARE? TBD
* Kraken -- BUILT ON OCROPUS; WILL WORK INTO OCROPUS WRITEUP
* Attention OCR -- TED WILL EXPERIMENT WITH THEIR RUNNER

We initially included [Amazon's Rekognition API](https://aws.amazon.com/rekognition/) on our list, but ultimately decided not to test it. Rekognition is primarily designed to identify text in images of signs and labels, rather than in documents. It's more challenging to implement than the other OCR tools we looked at and we didn't have a need for that level of power.

# Post Intro

At Factful one of our projects is to build tools that make state of the art machine learning and artificial intelligence accessible to investigative reporters. One thing that means is that we need to spend some time testing the components that already exist so we can prioritize our own efforts. The first step in any kind of document analysis is OCR, or optical character recognition, which allows us to transform a scan or photograph of a letter or filing into searchable, sortable text that we can do more with.

[INSERT SOME NOTES FROM JORDAN ABOUT WHERE THE CUTTING EDGE IS HEADED]

With all that in mind, we identified a few sample documents to run through a handful of OCR systems so we could compare the results. We tested a few proprietary algorithms and a few that are free and open source.

All the tools we looked at will output a text file. Most will also output a JSON or hOCR file that includes geometry data about where each word and line sits on a particular page. [INSERT EXPLANATION OF hOCR] -- This is the data you'd need to [INSERT DO WHAT? WHAT CAN WE SAY IN PLAIN ENGLISH ABOUT HOW TO START THINKING ABOUT WHAT YOU CAN DO WITH HOCR]

We wanted to test a few representative document samples:

* A receipt --  we identified a register receipt with some hand writing on it, to make it a little more fun for the APIs. (This receipt, from one graffiti artist's time at Rikers, was included in [States of Incarceration](https://statesofincarceration.org/states/new-york-rikers-island-ny-11370-plain-sight), a collaborative storytelling project and traveling exhibition about incarceration in America.)
* A document with a decent amount of redacting -- [Carter Page's FISA warrant](http://www.kingpin.cc/wp-content/uploads/2018/11/Carter-Page-release-9-November-2018.pdf) is a heavily redacted legal filing, just the kind of exasperating thing reporters deal with all the time.
* A historical document -- [Executive Order 9066](https://www.archives.gov/historical-docs/todays-doc/?dod-date=219) authorized the internment of Japanese Americans in 1942. The scanned image available in the national archives is fairly high quality but it is still an old, typewritten document.
* A form -- This [Texas campaign finance report](http://204.65.203.5/public/100721233.pdf), from [a Texas Tribune story about abuses in the juvenile justice system](https://www.texastribune.org/2018/11/01/harris-county-texas-juvenile-judges-private-attorneys/amp/) has very clean text but the formatting is important to understanding the document.

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

## Pricing

Most cloud API services charge per thousand pages after some number of free pages per month. As of this writing, ... TK. 

## More

The most effective [CHECK] OCR tools use a combination of shape recognition and context to make the best guess about what any one letter glyph represents. That means that a tool that does a great job on English language text might struggle with other languages that use the same alphabet but don't tend to follow the same spelling patterns. (HI! IS THIS ACTUALLY ACCURATE? also what is a good example of a bigram that occurs a lot in other languages but not english? like `aa` or something?) and an OCR tool that is great on the latin alphabet doesn't necessarily know the first thing about Cyrillic or Kanji so there's definitely room to expand this testing to include more languages.
