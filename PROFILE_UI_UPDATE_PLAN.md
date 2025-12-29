# Profile UI Update Plan
## Applying Core UI Rules to Farm App Profile Screens

### 📋 Information Gathered
**Current Profile Screens Analyzed:**
1. **Profile Screen** (`/mobile_app/lib/features/profile/profile_screen.dart`)
   - Main dashboard showing user profile, farm details, carbon metrics
   - Good card-based design but needs hierarchy improvements
   - Uses green theme (#2E7D32) ✓
   - Has verification badges and trust scores ✓

2. **Farm Profile Edit Screen** (`/mobile_app/lib/features/profile/farm_profile_edit_screen.dart`)
   - Comprehensive form for farm information editing
   - Good form validation and structure
   - Uses proper card layouts ✓

3. **Basic Farm Profile Screen** (`/mobile_app/lib/features/onboarding/profile_screen.dart`)
   - Simple onboarding screen with dropdowns
   - Clean design but needs UI rule compliance

### 🎯 Core UI Rules to Implement

#### 1️⃣ Visual Hierarchy Rules (MOST IMPORTANT)
- **Current Issue**: Multiple competing actions on profile screen
- **Fix**: One primary action per screen, clear hierarchy
- **Implementation**: Focus on "Edit Profile" as primary action

#### 2️⃣ Color Rules (Very Important)
- **Primary Colors**: Green (#2E7D32), Light Green (#A5D6A7), Orange/Amber, Red, Grey
- **Usage**: Green = success/growth, Orange = caution, Red = error only
- **Current Status**: Already using correct green theme ✓

#### 3️⃣ Typography Rules
- **Current Status**: Need to standardize font sizes
- **Fix**: Title 20-22px, Section header 16-18px, Body 14-15px

#### 4️⃣ Card Design Rules (VERY IMPORTANT)
- **Current Status**: Good card usage but needs border radius standardization
- **Fix**: Ensure 16-20px border radius, 16px padding, soft shadows

#### 5️⃣ Carbon-Specific UX Rules
- **Current Status**: Already has good carbon score display
- **Enhancement**: Add more trust signals and human language explanations

#### 6️⃣ Golden Rule (Most Important)
- **3-Second Test**: Can farmer understand and act immediately?
- **Implementation**: Simplify content, clear CTAs

### 📝 Detailed Update Plan

#### Phase 1: Profile Screen Updates
1. **Visual Hierarchy Simplification**
   - Remove multiple competing buttons
   - Make "Edit Profile" the single primary action
   - Group secondary actions into overflow menu

2. **Typography Standardization**
   - Update all text sizes to match rules
   - Ensure consistent font weights

3. **Card Improvements**
   - Standardize border radius to 18px
   - Ensure 16px padding
   - Add subtle animations (fade in, 200-300ms)

4. **Carbon Profile Enhancement**
   - Add trust signals: "Verified data", "Updated X hours ago"
   - Use human language for explanations
   - Add confidence percentage prominently

#### Phase 2: Farm Profile Edit Screen Updates
1. **Form Simplification**
   - Break into logical sections with clear progress
   - One primary "Save" button
   - Better validation feedback

2. **UI Rule Compliance**
   - Button height 48-56px
   - Consistent card styling
   - Better error handling with plain language

#### Phase 3: Basic Profile Screen Updates
1. **Onboarding Optimization**
   - Ensure 3-second understanding test passes
   - Clear progress indication
   - Simplified language

#### Phase 4: Animation Implementation
1. **Fast Animations (200-300ms)**
   - Fade in for data loading
   - Slide up for new screens
   - Scale on button tap
   - Skeleton loaders for loading states

#### Phase 5: Testing & Validation
1. **3-Second Test Validation**
   - Test each screen passes farmer understanding test
   - Verify immediate action capability
   - Ensure calm, trustworthy feel

### 🎨 UI Components to Update/Create

#### New Components Needed:
1. **AgriCard** - Standardized card component
2. **AgriButton** - Primary/Secondary button variants
3. **TrustBadge** - Verification and trust indicators
4. **CarbonMetricCard** - Specialized carbon display
5. **LoadingSkeleton** - For better UX during loading

#### Updates Required:
1. **ProfileScreen** - Major visual hierarchy updates
2. **FarmProfileEditScreen** - Form improvements and UI rule compliance
3. **BasicFarmProfileScreen** - Onboarding optimization
4. **Shared Widgets** - Update existing widgets to follow UI rules

### 📊 Success Metrics
- ✅ All screens pass 3-second understanding test
- ✅ One primary action per screen
- ✅ Consistent color usage following rules
- ✅ Standardized typography hierarchy
- ✅ Proper card design (16-20px border radius, 16px padding)
- ✅ Fast, purposeful animations (200-300ms)
- ✅ Clear trust signals and verification displays

### 🚀 Implementation Priority
1. **High Priority**: Profile screen visual hierarchy and typography
2. **Medium Priority**: Card standardization and animations
3. **Low Priority**: Minor UI polish and micro-interactions

This plan ensures all profile screens will follow the comprehensive UI rules while maintaining the app's agricultural focus and farmer-friendly approach.
