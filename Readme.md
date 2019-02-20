# Welcome

This repository contains the scripts and outputs from our [OCR comparison tests](https://source.opennews.org/articles/so-many-ocr-options/). 

We identified a few sample documents to run through OCR systems so we could compare the results. The documents we used in our final write up are these:

+ A receipt -- This receipt from the Riker's commissary was included in States of Incarceration, a collaborative storytelling project and traveling exhibition about incarceration in America.
+ A heavily redacted document -- Carter Page's FISA warrant is a legal filing with a lot of redacted portions, just the kind of exasperating thing reporters deal with all the time.
+ Something historical -- Executive Order 9066 authorized the internment of Japanese Americans in 1942. The scanned image available in the national archives is fairly high quality but it is still an old, typewritten document.
+ A form -- This Texas campaign finance report, from a Texas Tribune story about abuses in the juvenile justice system has very clean text but the formatting is important to understanding the document.
+ Something wrinkled --  in early 2014 a group of divers retrieved hundreds of pages of documents from a lake at Ukrainian President Viktor Yanukovych's vast country estate. The former president or his staff had dumped the records there in the hopes of destroying them, but many pages were still at least somewhat legible. Reporters laid them out to dry and began the process of transcribing the waterlogged papers. We selected a page that is more or less readable to the human eye but definitely warped with water damage.

We also tested the OCR engines against a handful of alternate documents. We've preserved two of those documents here so that you can look them over, too. Both are relatively easy to read and all the OCR engines we tested handled them well.  

The first, `cepr_oversight_order`  is an order giving the Puerto Rico Energy Commission oversight powers over the Puerto Rico Electric Power Authority, after the latter authority's [highly unusual](https://www.reuters.com/article/us-usa-puertorico-power/tiny-montana-firms-puerto-rico-power-deal-draws-scrutiny-idUSKBN1CW1X1) [$300 Million contract](https://www.vox.com/policy-and-politics/2017/11/15/16648924/puerto-rico-whitefish-contract-congress-investigation) with Whitefish Energy came under scrutiny.

The second, `whitefish_energy_vs_commonwealth_puerto_rico` is the full text of a legal filing in the protracted fight over who is responsible for delays in rebuilding Puerto Rico's electric grid. These two articles are a great place to get more context:
* [Puerto Rico moves to cancel contract with Whitefish Energy to repair electric grid](https://www.washingtonpost.com/business/economy/puerto-rico-governor-says-contract-to-whitefish-company-should-be-canceled/2017/10/29/e5336cda-bcb8-11e7-97d9-bdab5a0ab381_story.html?utm_term=.685e693e654d), *The Washington Post*, Oct 29, 2017; and
* [Puerto Rico Grid Contractor Dispute Devolves Into Litigation](https://www.wsj.com/articles/puerto-rico-grid-contractor-dispute-devolves-into-litigation-1511396684), *The Wall Street Journal*, Nov 22, 2017

# Using this Repository

The `/lib/` directory includes the scripts that we used to test each OCR client. Each tool requires some setup, but once you've got a tool installed, you can invoke it with:

`ruby ./lib/ocr.rb {command}`

For example once you have installed Tesseract, `ruby ./lib/ocr.rb tesseract documents` will use Tesseract to OCR all the images in the "documents" directory.

Once you have set up Google Cloud services and stored your credentials, `ruby ./lib/ocr.rb google google_cloud_vision/credentials.json documents/historical-executive_order_9066-japanese_internment.jpg` will use Google Cloud Vision to OCR a single image.

## Installation

These scripts in this repository depend on a few ruby gems. Install them with:

- Install Bundler first: `gem install bundler`
- Then install gems in the Gemfile: `bundle install`

This script uses `mutool`, a PDF processing tool included in  [`mupdf`](https://mupdf.com/docs/index.html), to convert multi-page PDFs into images. Install with:

- Mac/Homebrew `brew install mupdf`
- Ubuntu `apt install mupdf-tools`

### Cloud Services

Each of the cloud services we tested requires you to authenticate your account. Our scripts look for those credentials in the `credentials.json` file in each directory.  

#### Google Cloud Vision

The Ruby Gems that Google Cloud Vision requires are included in the bundle install for this repository.  

Google Cloud Vision requires authentication credentials. Use the example in [`google_cloud_vision/credentials.sample.json`](https://github.com/factful/ocr_testing/blob/master/google_cloud_vision/credentials.sample.json) to create your own `credentials.json` and make sure to point to it when you invoke `./lib/ocr.rb`, eg.

 `ruby ./lib/ocr.rb google google_cloud_vision/credentials.json documents/document.jpg`

#### Microsoft Azure Computer Vision

The Ruby Gems that Microsoft Azure requires are included in the bundle install for this repository.  

Use the example in [`azure/credentials.sample.json`](https://github.com/factful/ocr_testing/blob/master/azure/credentials.sample.json) to create your own `credentials.json` and make sure to point to it when you invoke `./lib/ocr.rb`.

#### Abbyy

Abbyy provides a python script, which is what we used to test documents in Abbyy. You can feed your id and password to the script when you run it:

`ABBYY_APPID="{YOUR APPID}" ABBYY_PWD="{YOUR PASSWORD}" python process.py {PATH TO IMAGE} {PATH TO OUTPUT}`

### Command Line Tools

The free and open source tools that we tested are all command line applications that you'll run locally.

#### Tesseract

`tesseract` is far and away the best maintained and easiest to use of the command line tools we tested. You should be able to install it with a package manager.

MacOS: `brew install tesseract --with-all-languages`

Ubuntu/Debian: `apt install tesseract tesseract-ocr-*`

#### Calamari

Calamari depends on OCRopus's tools to improve contrast, and to deskew and split images. Unfortunately, Calamari requires python 3.x, and OCRopus requires python 2.x. Because TensorFlow has [issues with Python 3.7](https://github.com/tensorflow/tensorflow/issues/17022), we used Python 3.6. In retrospect, using `kraken` might been much smoother, but here's what we actually did:

We used [`pyenv`][pyenv] and [`virtualenv`][virtualenv] to manage multiple Python instances.  (If you're using `pyenv` please also note [their installation instructions](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)).

We installed Python 3.6 with `pyenv`, and then used `virtualenv` to create a space to install Calamari and its dependencies.

```
# from the root of this directory first install Python 3.6 and create a virtual env.
mkdir -p venv
pyenv install 3.6.8
virtualenv -p ~/.pyenv/versions/3.6.8/bin/python venv/calamari
# activate the virtualenv
source venv/calamari/bin/activate
```

```
# Clone the calamari code
cd ..
git clone https://github.com/Calamari-OCR/calamari.git
cd calamari
# then install the dependencies and library.
pip install -r requirements.txt
python setup.py install
```

Calamari provides some pre-trained data models to power its recognizer.  You should download them into a `models` directory in the Calamari directory.

```
git clone https://github.com/Calamari-OCR/calamari_models.git models
```

If your installation was successful, `calamari-predict` will be available at the command line, and you can run `ruby ./lib/ocr.rb calamari {filename}` to OCR files with Calamari.

#### OCRopus

OCRopus requires python 2.7, so it's helpful to use `pyenv` to manage instances.

```
mkdir -p venv
pyenv install 2.7
virtualenv -p ~/.pyenv/versions/2.7/bin/python venv/ocropus
```
Clone OCRopus with

`git clone https://github.com/tmbdev/ocropy.git`

```
# activate the ocropus virtualenv
source venv/ocropus/bin/activate
# find the ocropus source directory
cd ../ocropy
# and install the dependencies
pip install -r requirements.txt
python setup.py install
```

To get OCRopus working you'll also need to download trained models.  [Prebuilt models for OCRopus can be found on the OCRopus wiki](https://github.com/tmbdev/ocropy/wiki/Models#latin-scripts).  You should download the english model into a `models` directory in the OCRopus directory.

If your installation was successful, `ocropus-rpred` will be available at the command line, and you can run `ruby ./lib/ocr.rb calamari {filename}` to OCR files with Calamari.


[pyenv]: https://github.com/pyenv/pyenv
[virtualenv]: https://virtualenv.pypa.io/en/latest/
