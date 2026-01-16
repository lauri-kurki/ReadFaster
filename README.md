# ReadFaster

Speed reading training app using RSVP (Rapid Serial Visual Presentation).

## Features

- **Training Mode**: 5 progressive lessons from 150 to 750 WPM
- **Free Reading**: Paste any text and read at your chosen speed
- **ORP Highlighting**: Optimal Recognition Point centered for faster reading
- **Progress Tracking**: Completed levels are saved

## Platforms

- **iOS App**: Native SwiftUI app in `/ReadFaster`
- **Web App**: Mobile-first web version in `/web` (deployed on Vercel)

## Development

### iOS
Open `ReadFaster.xcodeproj` in Xcode and run on simulator or device.

### Web
```bash
cd web
python3 -m http.server 8080
# Open http://localhost:8080
```

## Deployment

The `/web` folder is deployed to Vercel. Push to main branch to auto-deploy.
