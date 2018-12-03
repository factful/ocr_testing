# OCR comparison

## Tesseract

See the `tesseract` directory for results

## [Google Cloud Vision API][GCP_Vision]

See the `google` directory for results

[GCP_Vision]: https://cloud.google.com/vision/

## [Microsoft Azure Comptuational Vision API][Azure_Vision]

[Azure_Vision]: https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/

See the `azure` directory for results

## [OCRopus][OCRopus_github]

Getting OCRopus set up is a pain in the ass.  It will only work on python 2.7, consequently it's probably best to use virtualenv to install and manage dependencies (or use docker? idk).

Trying to run `matplotlib` w/in py2.7 in virtualenv fails unless you [follow instructions](https://markhneedham.com/blog/2018/05/04/python-runtime-error-osx-matplotlib-not-installed-as-framework-mac/) to specify the framework ([that were cribbed from StackOverflow](https://stackoverflow.com/questions/34977388/matplotlib-runtimeerror-python-is-not-installed-as-a-framework)).

OCRopus requires images being processed to be 300 dpi, which is also a pain in the ass, but seems to have some scaling functions.

I followed [the instructions in the Readme](https://github.com/tmbdev/ocropy#running) and any time they didn't work, [i just followed github issue instructions](https://github.com/tmbdev/ocropy/issues/241).



[OCRopus_github]: https://github.com/tmbdev/ocropy

## Still to be tested

* [Abbyy Cloud API](https://www.ocrsdk.com/)
* [Adobe Acrobat](https://acrobat.adobe.com/us/en/acrobat/how-to/ocr-software-convert-pdf-to-text.html)
* [Amazon Rekognition API](https://aws.amazon.com/rekognition/)
* [OCRopus](https://github.com/tmbdev/ocropy) (also see: [this blog post](https://www.danvk.org/2015/01/09/extracting-text-from-an-image-using-ocropus.html))
* [Calamari]()



