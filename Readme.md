# OCR comparison

Most of the tools we tested support text in multiple languages but we only tested on English language documents. The Ruby scripts we used are all included in our [repository](LINK TK) if you want to test these OCR engines with other languages.

## [Tesseract](https://github.com/tesseract-ocr/tesseract)

[Tesseract](https://github.com/tesseract-ocr/tesseract) is a free and open source command line OCR engine that was developed at Hewlett-Packard in the late 90s, and has been maintained by Google since 2006. It is well documented and easy to use CHECK but DOES IT NEED TRAINING?

Their [installation instructions](https://github.com/tesseract-ocr/tesseract/wiki) are reasonably comprehensive. We were able to follow them and get Tesseract running without any additional troubleshooting.

Tesseract will return results as plain text, hOCR or in a PDF, text overlaid on the original image.

## [Google Cloud Vision API][GCP_Vision]

See the `google` directory for results

[GCP_Vision]: https://cloud.google.com/vision/

## [Microsoft Azure Computer Vision][Azure_Vision]

[Computer Vision](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/) is Microsoft Azure's OCR tool -- it's available as an API (that you can use at the command line) or as an SDK if you want to bake it into another application. 
. TED: YOU HAD SOME /THOUGHTS ABOUT SETUP CHALLENGES? There are a few steps to getting started with MS Azure.



[Azure_Vision]: https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/

See the `azure` directory for results

## [OCRopus][OCRopus_github]

[OCRopus](https://github.com/tmbdev/ocropy) is a collection of document analysis tools. TK: IS IT GENUINELY MORE THAN OCR? OR JUST MORE COMPLEX? ANY OTHER NOTES TO INCLUDE IN TEXT? WHAT ELSE IS WORTH SAYING HERE FOR CONTEXT?

OCRopus requires python 2.7 so you probably want to use `virtualenv` to install it and manage dependancies. We had hiccups using the installation instructions in the [Readme file](https://github.com/tmbdev/ocropy#running), but found workable [installation instructions](https://github.com/tmbdev/ocropy/issues/241) hiding in an issue. You'll also want to [follow some specialized instructions](https://markhneedham.com/blog/2018/05/04/python-runtime-error-osx-matplotlib-not-installed-as-framework-mac/) to get `matplotlib` running in a Python 2.7 `virutalenv`.




Notes:
Getting OCRopus set up is a pain in the ass.  It will only work on python 2.7, consequently it's probably best to use virtualenv to install and manage dependencies (or use docker? idk).

Trying to run `matplotlib` w/in py2.7 in virtualenv fails unless you [follow instructions](https://markhneedham.com/blog/2018/05/04/python-runtime-error-osx-matplotlib-not-installed-as-framework-mac/) to specify the framework ([that were cribbed from StackOverflow](https://stackoverflow.com/questions/34977388/matplotlib-runtimeerror-python-is-not-installed-as-a-framework)).

OCRopus requires images being processed to be 300 dpi, which is also a pain in the ass, but seems to have some scaling functions.

I followed [the instructions in the Readme](https://github.com/tmbdev/ocropy#running) and any time they didn't work, [i just followed github issue instructions](https://github.com/tmbdev/ocropy/issues/241).


[OCRopus_github]: https://github.com/tmbdev/ocropy

## Still to be tested

* [Abbyy Cloud API](https://www.ocrsdk.com/)
* [Adobe Acrobat](https://acrobat.adobe.com/us/en/acrobat/how-to/ocr-software-convert-pdf-to-text.html)
*
* Amazon Textract -- beta.
* [OCRopus](https://github.com/tmbdev/ocropy) (also see: [this blog post](https://www.danvk.org/2015/01/09/extracting-text-from-an-image-using-ocropus.html))
* [Calamari]()
* Swift OCR
* Kraken
* Attention OCR

We initially included [Amazon's Rekognition API](https://aws.amazon.com/rekognition/) on our list, but ultimately decided not to test it. Rekognition is primarily designed to identify text in images of signs and labels, rather than in documents. It's more challenging to implement than the other OCR tools we looked at and we didn't have a need for that level of power.

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
- [Unfortunate OCR in historic books](https://wraabe.wordpress.com/2009/03/07/an-ocr-cliche-into-hisher-anus/)
- [Dan Nguyen did some cool stuff](https://gist.github.com/dannguyen/a0b69c84ebc00c54c94d)