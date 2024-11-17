# QB-CarRentals

A comprehensive vehicle rental system for FiveM QBCore servers, featuring an advanced rental system with insurance, loyalty rewards, and dynamic pricing.

## 🌟 Features

### 🚗 Core Rental System
- Multiple rental locations across the map
- Diverse vehicle categories (Economy, Compact, Sedan, Sports, Muscle, SUV, Van, Off-Road)
- Flexible rental durations
- Deposit system with damage calculations
- Vehicle condition tracking
- Multiple return locations

### 💎 Premium Features

#### 🛡️ Insurance System
- Three tiers of insurance:
  - No Insurance (Full damage liability)
  - Basic Insurance (50% damage coverage)
  - Premium Insurance (100% damage coverage)
- Dynamic pricing based on insurance level
- Automatic damage assessment on return

#### 🏆 Loyalty Program
- Earn points for each rental
- Points based on rental cost
- Three discount tiers:
  - Bronze: 5% discount (100 points)
  - Silver: 10% discount (250 points)
  - Gold: 15% discount (500 points)
- Lifetime rental statistics tracking

#### 🕒 Extended Rental Options
- Extend your rental up to 3 times
- Use `/extendRental` command while in vehicle
- 10% extension fee
- Flexible duration options

#### 💰 Special Discounts
- New customer discount (10% off first rental)
- Weekly special vehicle category (20% off)
- Bulk rental discount (15% off 7+ day rentals)

## 📋 Dependencies
- QBCore Framework
- qb-target
- LegacyFuel (optional)

## 🔧 Installation

1. Ensure you have all dependencies installed
2. Drop the `qb-carrentals` folder into your `resources/[qb]` directory
3. Add `ensure qb-carrentals` to your server.cfg
4. Configure rental locations and vehicles in `config.lua`

## 💻 Usage

### Renting a Vehicle
1. Visit any rental location (marked on map)
2. Use the interaction point to open rental menu
3. Select vehicle category
4. Choose your vehicle
5. Select rental duration
6. Choose insurance option
7. Confirm rental

### Returning a Vehicle
1. Drive to any return location (red car icon on map)
2. Park the vehicle
3. Use the interaction point to return
4. Receive deposit back (minus any damage charges)

### Extending a Rental
1. While in the rental vehicle, use `/extendRental`
2. Select new duration from menu
3. Pay extension fee
4. Rental period will be extended

## ⚙️ Configuration

### Rental Locations
Edit `config.lua` to modify:
- Rental locations
- Return locations
- Spawn points
- Blip settings

### Vehicle Categories
Customize available vehicles in `config.lua`:
- Vehicle models
- Pricing
- Category organization
- Fuel capacity

### Insurance & Loyalty
Adjust in `config.lua`:
- Insurance coverage rates
- Point earning rates
- Discount tiers
- Special discount conditions

## 🔍 Features In Detail

### Vehicle Condition Monitoring
- Real-time health tracking
- Damage threshold notifications:
  - Minor damage (below 900 health)
  - Moderate damage (below 700 health)
  - Severe damage (below 400 health)

### Rental Benefits
- Full tank of fuel on rental
- Automatic key assignment
- Clean vehicle condition
- Multiple payment methods

### Security Features
- Server-side validation
- Ownership verification
- Anti-exploit measures
- Secure transaction handling

## 🛠️ Commands

- `/extendRental` - Extend current rental period
- Additional commands can be added in `config.lua`

## 💡 Tips
- Choose insurance based on your driving style
- Longer rentals qualify for bulk discounts
- Return vehicles in good condition to avoid charges
- Use the loyalty program for best prices
- Check weekly specials for best deals

## ⚠️ Support
For support:
1. Check the configuration file
2. Verify all dependencies are installed
3. Ensure your QBCore version is compatible
4. Check server console for errors

## 📜 License
This resource is licensed under MIT License. Feel free to modify and share!
