# PapilonIDRecognitioniOS


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 13+

## Installation

PapilonIDRecognitioniOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PapilonIDRecognitioniOS', '0.3.0'
```
## Setup PapilonIDRecognitioniOS
You will need to have a licence token to run this SDK. Please contact [Papilon Savunma](https://papilon.com.tr/tr/) or send an E-mail to kaganerbay@papilon.com.tr

## Usage

Simply create an object with class `IDRecognizer`, with initializers `id_type`, `token` and `licence_id`. The "token" and "licence_id" will be given from Papilon Savunma.


**IMPORTANT:** *The token you take belongs only to you and you must not lose it. If there is a problem with the token or package contact Papilon Savunma with `licence_id` that is given to you.*

This package has ID Recognition features for several countries' ID cards, passports and driving liciences.
Here are the options for ID recognitions:


| Parameter | Type     | Value | Description |
| :-------- | :------- | :---- | :------------------------- |
| `id_type` | `string` | `0`   | TC New ID Card Front |
| `id_type` | `string` | `1`   | TC New ID Card Back |
| `id_type` | `string` | `2`   | TC Old ID Card Front |
| `id_type` | `string` | `3`   | TC Old ID Card Back |
| `id_type` | `string` | `4`   | TC New Passport |
| `id_type` | `string` | `5`   | TC Old Passport (under development)| 
| `id_type` | `string` | `6`   | TC New Driving Licence Front |
| `id_type` | `string` | `7`   | TC New Driving Licence Back |
| `id_type` | `string` | `8`   | TC Old Driving Licence Front (under development)|
| `id_type` | `string` | `9`   | TC Old Driving Licence Back (under development)|
| `id_type` | `string` | `10`  | AZR ID Front (under development)| 
| `id_type` | `string` | `11`  | AZR Passport (under development)| 
| `id_type` | `string` | `12`  | IR Passport (under development)| 
| `id_type` | `string` | `13`  | PK NIC ID Front |
| `id_type` | `string` | `14`  | PK NIC ID Back |
| `id_type` | `string` | `15`  | PK NICOP ID Front |
| `id_type` | `string` | `16`  | PK NICOP ID Back |

When creating an object simply give the ID code that will be recognized and insert the token as property. For instance;

```swift
import PaplilonIDRecognitioniOS

let idRecognizer = IDRecognizer(id_type: "0", token: "###TOKEN_TAKEN_FROM_PAPILON###", licence_id: "###LICENCE_ID_TAKEN_FROM_PAPILION###")
```

Call the id recognizer and OCR function and feed the function with live images `CVPixelBuffer`. For instance;


```swift
func captureOutput(_ output: AVCaptureOutput,didOutput sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        let resultDictionary = self.idRecognizer.detectIDCard(in: frame)
        if resultDictionary.isEmpty {
        }else  {
            self.captureSession.stopRunning()
            print(resultDictionary) // You can see the results here
            DispatchQueue.main.sync {
                self.capturedImageView.image = idRecognizer.IDUIImage
            }
        }
    }
```
`detectIDCard` function returns the results as a dictionary. Also you can call `idRecognizer.IDUIImage` as UIImage for the cropped ID image.

## License

See the LICENSE file for more info.
