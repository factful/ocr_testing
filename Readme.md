Text was moved to Google Drive for easier collaboration with editors.

https://docs.google.com/document/d/1dIocW88gOFAAVihjHxU1seqQrYskCvlMvmbQ2KBpuPs/edit#
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
