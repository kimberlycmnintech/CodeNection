<div align="center">

# 🪹 TripNest
### by See u in MMU

**Team:** Yeat Jing Rong · Toh Shee Thong · Kim · Tan Qian Wen  
**Problem Statement:** Travel Planner

[🎥 Video Presentation](Unlisted_Youtube_Link) · [📑 Presentation Slides](Public_Link)

<br>

> *“You can find a destination in seconds.*  
> *But **finding someone** who shares your budget, your pace, your interests, and your idea of fun?*  
> ***That’s the real journey.***”

<br>

**Different people. Different dreams. One journey — why compromise?**

</div>

---

## 1. Project Overview

### The Problem

Every year, millions of people either travel alone when they didn't want to, or travel with the wrong person and wish they hadn't. This isn't a niche frustration — it's a structural failure baked into how travel planning currently works.

**Three root causes drive it:**

**① No safe, structured way to find a compatible travel companion.**
Existing options are dangerous and unstructured: Reddit threads, Facebook Groups, and WhatsApp status posts let users broadcast "travel buddy wanted" messages to strangers with zero identity verification, no compatibility screening, and no trust signal. A 2023 solo travel safety survey found that **over 60% of solo female travellers** cite safety as their primary reason for not travelling with people they met online. The tools that do exist (Tourlina, Travello) are social discovery apps, not compatibility-matching engines — they don't screen for budget alignment, travel pace, or daily rhythm before connecting two people.

**② Group planning is catastrophically fragmented.**
A typical group trip involves: a shared Google Doc for ideas, a WhatsApp group chat for decisions, a Wanderlog link for the itinerary, and a spreadsheet for expenses. These tools don't talk to each other. Decisions made in chat never propagate to the itinerary. By the time someone opens the plan, it's already stale. The result: repeated conversations, last-minute conflicts, and trips planned by whoever has the most patience rather than the best ideas.

**③ AI travel planners are blind to who you're travelling with.**
ChatGPT can generate a 7-day Tokyo itinerary in seconds. But it doesn't know that one person in your group hates early mornings, another has a RM250/night hotel ceiling, and the third can't walk more than 12,000 steps. So its output looks polished and is practically useless — everyone edits it back to a blank slate.

---

**Stakeholders:**

| Stakeholder | Pain Point |
|---|---|
| **Solo travellers (18–35)** | Can't find a trusted, compatible companion; end up going alone or not at all |
| **Small friend groups (2–4 pax)** | Planning chaos across too many tools; no single source of truth |
| **Couples travelling together** | Misaligned expectations on pace/budget surface too late, during the trip |
| **Digital nomads** | Repeatedly need new companions in new cities; no platform remembers their travel DNA |

---

**Why existing apps fall short:**

| App | What it does | The gap |
|---|---|---|
| **Wanderlog** | Collaborative itinerary builder | No companion matching, no group chat, no AI that reads *your* group's preferences |
| **Tourlina / Travello** | Travel social network & buddy search | Interest-based only, no compatibility scoring, no ID verification, no planning workspace |
| **TripIt** | Auto-organiser from confirmation emails | Purely personal, no social layer, no planning, no matching |
| **Google Travel** | Flight & hotel discovery | Inspiration tool only — no planning workspace or collaborative features |
| **ChatGPT / Gemini** | AI itinerary generation | Generic output — has no idea who you're travelling with or what you've already decided |

**The gap is total.** Not one of these connects safe companion discovery → compatibility-screened matching → preference-aware AI planning → group coordination → social sharing in a single, coherent product.

---

### Our Solution

**TripNest is the first app that closes the loop between finding a compatible travel companion and planning a trip together.**

Users swipe through a 5-topic travel-DNA quiz on first launch. They find a verified, compatibility-scored match. They plan inside a shared trip workspace where an AI reads their group chat's saved decisions and proactively optimises their itinerary — no generic suggestions, only ones grounded in what the group actually agreed on.

**The Complete Feature Set:**

| # | Feature | What it does |
|---|---|---|
| 1 | 🎯 **Travel DNA Onboarding** | Swipe left/right across 5 lifestyle topics to build a preference vector in under 2 minutes |
| 2 | 🪪 **TravelID Badge** | A passport-style shareable profile card showing travel style, MBTI, verification status, and compatibility score at a glance |
| 3 | 🔐 **ID Verification Gate** | Hard identity check before any match request can be sent — a safety-first design decision |
| 4 | 🤝 **Compatibility-Scored Matching** | Match list ranked by % compatibility across pace, budget, interests, MBTI, destination, and dates |
| 5 | 🗓️ **Trip Folder Workspace** | Trip folders with status tracking (Upcoming / Ongoing / Completed), list and calendar views |
| 6 | 🗺️ **Interactive Itinerary Map** | Day stops rendered on a live Google Maps view with walking estimates and transit methods |
| 7 | ✨ **Context-Aware AI Assistant** | Reads your group's Notebook and suggests itinerary changes grounded in your actual decisions |
| 8 | 🔄 **3 AI Plan Versions** | Switch the same trip between Balanced / Budget / Comfort plans without manual editing |
| 9 | 💬 **Categorised Group Chat** | Messages tagged by type (💰 Budget, 🍜 Food, 🏨 Accommodation, 🚌 Transport…) |
| 10 | 📓 **Shared Trip Notebook** | Drag any chat message into the Notebook; AI reads these to personalise the itinerary |
| 11 | ☑️ **Planning Check Cards** | Visual checklist generated from Notebook entries so nothing decided in chat is forgotten |
| 12 | 📰 **Social Travel Journal** | Post trip entries with public or friends-only visibility; a feed of real travel stories |
| 13 | 🎮 **TripCoins Gamification** | Earn coins for journaling, completing trips, and community engagement — drives retention |
| 14 | ⭐ **Reliability Score** | A trust metric per user built from past trip completion rate and response behaviour |

---

## 2. Ideation & Process

### 2.1 Ideas We Considered

The table below documents every distinct idea our team generated — keeping, refining, or dropping each with explicit reasoning.

| Idea | Status | Why kept / dropped |
|---|---|---|
| **Swipe-based travel DNA onboarding quiz** | ✅ Chosen | Removes form fatigue. Binary left/right swipes across 5 lifestyle topics (pace, budget, rhythm, vibe, planning style) produce a rich preference vector in under 2 minutes. The gesture is immediately intuitive — zero learning curve. |
| **Compatibility scoring algorithm** | ✅ Chosen | An objective % score based on pace, budget, MBTI, interests, and date overlap removes ambiguity from "are we a good match?" It builds trust before users commit to anything. Originally we considered a text-based questionnaire — dropped in favour of swipes. |
| **ID verification gate before matchmaking** | ✅ Chosen | Safety was identified as the #1 blocker preventing solo travellers (especially women) from trusting strangers online. A hard gate — you cannot send or receive match requests until verified — makes the trust promise enforceable, not just aspirational. |
| **TravelID badge (passport-style profile card)** | ✅ Chosen | Makes travel identity tangible and instantly readable. Originally proposed as a standard profile page — we realised a shareable "travel card" format conveys personality far faster and doubles as a social artefact. |
| **Shared trip Notebook fed from group chat** | ✅ Chosen | Solves the core fragmentation problem. Drag-to-notebook creates a zero-friction bridge between conversation and structured plan. Emerged from our "why does WhatsApp feel better than our planning tool?" reflection session. |
| **AI itinerary assistant that reads the Notebook** | ✅ Chosen | The breakthrough insight: if the AI reads your group's actual Notebook decisions, its suggestions stop being generic. Tested against the alternative (a static prompt-based AI) — the Notebook-aware version required dramatically less manual correction. |
| **Three AI plan versions (Balanced / Budget / Comfort)** | ✅ Chosen | Lets co-travellers explore different budget interpretations of the same trip without manual stop editing. Reduces plan conflict in mixed-budget groups — a common pain point in friend groups where one person earns more. |
| **Reliability Score alongside Compatibility Score** | ✅ Chosen | Compatibility tells you *if* you'd enjoy travelling together. Reliability tells you *if* they'll actually show up and commit. Both matter equally for safety and trust. |
| **TripCoins gamification loop** | ✅ Chosen | Drives retention through journaling and trip completion rewards. Uniquely, TripCoins are earned through travel actions (not generic points), which keeps the incentive authentic. Also improves social feed quality by incentivising journals. |
| **Social journal feed with dual-visibility control** | ✅ Chosen | Public posts grow community and discoverability. Friends-only posts keep personal trip details private. The dual-visibility model is a deliberate trust design — users shouldn't have to choose between sharing and privacy. |
| **Live flight & hotel booking integration** | ❌ Dropped | Requires payment partnerships, OTA API licensing, and complex booking flow edge cases. Out of scope for the build phase. Bookmarking links to external sites covers the need without the complexity. |
| **Real-time collaborative itinerary editing (multi-cursor, like Figma)** | ❌ Dropped | Conflict resolution for simultaneous edits is a hard distributed systems problem. Async chat + AI suggestions covers 90% of co-planning needs without any of that infrastructure complexity. |
| **Built-in budget tracker with expense splitting** | ❌ Dropped | Splitwise already does this extremely well and our users already use it. Building a duplicate would dilute focus. TripNest tags budget *style* (preference), not individual expenses. |
| **AR destination preview (point camera at landmark)** | ❌ Dropped | ARKit/ARCore integration, camera permission flows, and 3D asset sourcing are too complex for the hackathon timeline. Saved as a future v2 roadmap item. |
| **In-app video calls between matched travellers** | ❌ Dropped | FaceTime and WhatsApp video already exist and users trust them. Rebuilding video infrastructure creates zero competitive advantage and massive infra cost for zero differentiation. |
| **Marketplace for local guides** | ❌ Dropped | Requires a separate supply-side product (guide recruitment, vetting, payment flows). A different company problem — not TripNest's core value proposition. |

---

### 2.2 Ideation Boards

#### Problem Tree — Root Causes, Core Problem & Downstream Effects

![Problem Tree](C:\Users\tstho\.gemini\antigravity-ide\brain\f1a42586-d36e-40ce-b853-8c14fa14682a\tripnest_problem_tree_1789117630548.jpg)

*We started by asking "what actually goes wrong?" and mapped upwards from the structural root causes to the painful downstream effects travellers experience. This revealed that the core problem sits at the intersection of two gaps — safety/trust and planning fragmentation — neither of which any single existing app bridges. This framing drove every major design decision that followed.*

---

#### Idea Iteration — How TripNest Evolved Through Three Versions

![Iteration Timeline](C:\Users\tstho\.gemini\antigravity-ide\brain\f1a42586-d36e-40ce-b853-8c14fa14682a\tripnest_iteration_timeline_1789117675504.jpg)

*Our first idea was a pure companion-finder (v0.1). After mapping what happened post-match, we realised users had no planning space — so v0.2 added a basic itinerary builder. But the planning tool and the group chat were still separate — the original fragmentation problem persisted in a different form. v1.0 introduced the Notebook layer as the connective tissue: chat decisions flow into the Notebook, the AI reads the Notebook, and the itinerary becomes a live reflection of what the group actually agreed on.*

---

#### Feature Space Mindmap

![TripNest Feature Mindmap](C:\Users\tstho\.gemini\antigravity-ide\brain\f1a42586-d36e-40ce-b853-8c14fa14682a\tripnest_mindmap_1789116901534.jpg)

*After committing to the v1.0 concept, we expanded all possible features into four clusters. This map drove the kept/dropped decisions in section 2.1 — features that didn't serve at least two clusters were deprioritised.*

---

#### User Flow — Core Journey

![TripNest User Flow](C:\Users\tstho\.gemini\antigravity-ide\brain\f1a42586-d36e-40ce-b853-8c14fa14682a\tripnest_user_flow_1789116931279.jpg)

*End-to-end user journey from sign-up through the three main value paths: companion matching (purple), itinerary planning (teal), and social journaling (coral). The ID verification decision gate on the matching path was a deliberate safety design decision that emerged from mapping this flow — it became clear that without a hard gate, all the compatibility scoring downstream would be undermined by unverified identities.*

---

### 2.3 Mentor Consultation

| Date | Mentor | Feedback Received | What Was Changed |
|---|---|---|---|
| — | — | *(To be completed after consultation session)* | — |

---

## 3. Design & Prototype

**UI Prototype:** `[ TODO — Insert your Figma / Canva / Netlify link here. Verify it opens in incognito. ]`

The app follows a cohesive design language: **Midnight Navy** (`#0F172A`) as the primary tone, **Azure Blue** (`#2563EB`) as the action accent, **Ice Blue** (`#EBF4FB`) as the background tint, and **Plus Jakarta Sans** as the type system throughout. Every screen uses the same spacing grid, icon weight, and border-radius system — a deliberately polished visual identity that reflects the premium positioning of the app.

**Key screens covering the end-to-end flow:**

| Screen | Interaction it demonstrates |
|---|---|
| **Splash + Auth** | Branded entry point; Google Sign-In → auth gate |
| **Travel DNA Onboarding Quiz** | Swipe left/right between two illustrated lifestyle options across 5 topics |
| **Home Feed** | Personalised discovery cards (flights, hotels, experiences) + current active trip banner |
| **Find Buddy — Set Preferences** | Filter by destination, dates, budget, pace, interests, MBTI |
| **Find Buddy — Match List** | Compatibility-scored cards with TravelID badge preview on tap |
| **ID Verification Modal** | Photo-upload prompt with verification status indicator |
| **Trip Workspace — Day Timeline** | Day-by-day stop list with time, category icon, walking estimate, travel method |
| **Interactive Itinerary Map** | Google Maps embed with day pins; expand to full-screen; tap pin for place detail |
| **Group Chat + Notebook** | Categorised messages with category badge chips; drag-to-save; Notebook panel below |
| **AI Assistant Panel** | Contextual suggestion cards with one-tap "Apply" and reasoning shown |
| **Social Feed** | Journal cards with public/friends-only badge; write journal FAB |
| **Profile Page** | TravelID badge, travel style tags, Reliability Score, Boarding Pass ticket view |

---

## 4. What Makes It Different

### The Central Insight

Every existing travel app treats **finding a companion** and **planning a trip** as separate problems. TripNest treats them as one continuous loop. That's not an incremental feature addition — it's a fundamentally different product architecture.

---

### Novel Features & Differentiators

| Feature | What's novel | Why it matters |
|---|---|---|
| **Notebook-aware AI Itinerary** | The only travel AI that reads your group's actual decisions before suggesting changes. If your chat Notebook says "no early mornings" and "hotel budget ≤ RM250/night", the AI suggests a 10:30 AM Day 2 start and stays within budget — without you re-entering preferences anywhere. | Eliminates the #1 failure mode of AI travel planners: generic output that ignores group context |
| **Travel DNA Swipe Onboarding** | 5-topic binary swipe quiz (pace, budget, rhythm, vibe, planning style) builds a rich compatibility vector before the user sees a single match. | First-match relevance is instant — not after 10 failed connections |
| **ID Verification Gate** | Cannot send or receive match requests without verified identity. Not a badge, not an optional tick — a hard gate. | The only travel-buddy platform with a structural safety guarantee, not just a policy |
| **TravelID Badge** | A shareable, passport-inspired profile card surfacing travel style, MBTI, verification status, and compatibility score in one glance. | Replaces the wall-of-text profile that nobody reads with a single scannable artefact |
| **Drag-to-Notebook from Chat** | In-chat messages tagged by category can be dragged directly into the shared trip Notebook. The AI reads the Notebook — not a separate form. | Closes the WhatsApp-to-itinerary gap with zero extra effort from users |
| **Three AI Plan Versions** | Switch the same trip between Balanced / Budget / Comfort without editing a single stop manually. | Resolves mixed-budget group conflicts without a fight |
| **Reliability Score** | A second trust metric (separate from Compatibility %) built from past trip completion, response rate, and journal engagement. | Screens matches for dependability, not just compatibility |
| **TripCoins tied to travel actions** | Coins earned specifically for journaling, completing trips, and helping other travellers — not generic platform engagement. | Retention loop that improves the social feed as a side effect |

### Comparison Table

| Capability | TripNest | Wanderlog | Tourlina | ChatGPT |
|---|---|---|---|---|
| Companion matching | ✅ Scored | ❌ | ✅ Basic | ❌ |
| ID verification | ✅ Hard gate | ❌ | ❌ | ❌ |
| Travel style compatibility | ✅ 5-axis score | ❌ | ❌ | ❌ |
| Trip planning workspace | ✅ | ✅ | ❌ | ❌ |
| Group chat | ✅ | ❌ | ❌ | ❌ |
| Chat → Notebook → Itinerary loop | ✅ | ❌ | ❌ | ❌ |
| Context-aware AI (reads decisions) | ✅ | ❌ | ❌ | ❌ |
| Social travel journal | ✅ | ❌ | ✅ Basic | ❌ |
| Gamification / retention loop | ✅ TripCoins | ❌ | ❌ | ❌ |

---

## 5. Technical Architecture & Feasibility

### Tech Stack

| Layer | Technology | Why chosen | Constraints & mitigations |
|---|---|---|---|
| **Mobile Frontend** | Flutter (Dart) | Single codebase for iOS & Android; rich animation APIs; fast iteration cycle well-suited to the hackathon timeline | Dart ecosystem is smaller than React Native — mitigated by Flutter's comprehensive pub.dev package library |
| **State Management** | `setState` + widget-tree prop passing | Zero external dependency; sufficient for the current prototype scope | Will need migration to Riverpod or BLoC when data becomes fully async from Firestore |
| **Auth** | Firebase Auth | Free tier; Google Sign-In built in; tightly integrated with Firestore security rules | Rate limits on phone-number auth — use email + Google OAuth first |
| **Database** | Cloud Firestore | Real-time listeners suit chat; offline persistence built in; flexible schema for evolving trip models | Pricing scales per read/write at production scale — mitigated by Firestore caching and batched writes |
| **AI / LLM** | Google Gemini API (via Firebase Cloud Functions) | Free tier available; context window large enough for Notebook + itinerary; multimodal capability for future ID verification | API key must be kept server-side → Cloud Functions proxy required; free tier rate limits apply |
| **Maps** | Google Maps Flutter SDK + Places API | Native plugin; rich POI data; walking distance + transit route calculation built in | Billing account required even on free tier; implement daily quota guard |
| **Storage** | Firebase Storage | Profile photos, ID verification uploads, journal images — all as blobs integrated with Firebase Auth rules | Free tier: 5 GB / 1 GB download per day — sufficient for hackathon; add CDN at scale |
| **Fonts** | Google Fonts (`plus_jakarta_sans`) | Runtime loading via the `google_fonts` package; no asset bundling | Requires internet on first launch; fonts cached after first run |
| **Hosting** | Firebase Hosting (web demo) | Free, zero config, integrated with project | Production mobile distribution via TestFlight (iOS) + Play Internal Track (Android) |

---

### System Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                      Flutter Mobile App                          │
│                                                                  │
│  ┌──────────────┐  ┌───────────────┐  ┌──────────┐  ┌────────┐ │
│  │   Matching   │  │  Itinerary &  │  │  Chat /  │  │ Social │ │
│  │   Module     │  │  Trip Folders │  │ Notebook │  │  Feed  │ │
│  └──────┬───────┘  └───────┬───────┘  └────┬─────┘  └───┬────┘ │
│         └──────────────────┴───────────────┴─────────────┘      │
│                         Firebase SDK                             │
└───────────────────────────────┬──────────────────────────────────┘
                                │
            ┌───────────────────┼──────────────────┐
            ▼                   ▼                  ▼
     Firebase Auth        Cloud Firestore    Firebase Storage
     (identity,           (users, trips,     (avatars, ID docs,
      verification)        chats, notebooks,  journal images)
                           journals, coins)
                                │
                         Cloud Functions
                                │
                     ┌──────────┴──────────┐
                     ▼                     ▼
               Gemini API           Google Maps /
            (AI itinerary,          Places API
             suggestion engine)    (map, POI, routes)
```

---

### Resource & Time Awareness

**Team composition assumed:** 3–4 members with Flutter experience and at least one member comfortable with Firebase and Cloud Functions.

**Cost estimate (hackathon phase — all free tiers):**

| Service | Free tier limit | Expected usage |
|---|---|---|
| Firebase Auth | 10,000 verifications/month | Well within |
| Firestore | 50,000 reads / 20,000 writes / day | Well within for demo |
| Firebase Storage | 5 GB / 1 GB download/day | Well within |
| Gemini API | 15 requests/min (free) | Sufficient for demo |
| Google Maps / Places | $200/month credit | Sufficient for demo |
| **Total cost** | **$0** | **Free tier covers the full hackathon** |

**Time estimate (building phase — approximately 2 weeks):**

| Sprint | Days | Deliverables |
|---|---|---|
| 0 — Setup | 1 | Firebase project, Auth, Firestore rules, project structure |
| 1 — Core Profile & Onboarding | 2 | Travel DNA quiz, user profile Firestore write, TravelID badge |
| 2 — Matching | 2 | Compatibility score computation, match list screen, ID verification flow |
| 3 — Trip Workspace | 3 | Trip folder CRUD, day stops, Google Maps embed, calendar view |
| 4 — Chat + Notebook | 2 | Real-time Firestore chat, category tagging, Notebook save |
| 5 — AI Assistant | 2 | Cloud Function → Gemini API, Notebook context injection, suggestion cards |
| 6 — Social + Polish | 2 | Journal feed, TripCoins increment, end-to-end UI polish |

---

### Build Plan — Explicit In-Scope vs. Out-of-Scope

**✅ In scope (building phase):**
- Firebase Auth (email + Google Sign-In)
- Firestore-backed user profiles with travel-style preferences
- 5-topic swipe onboarding quiz
- Buddy match list with computed compatibility score
- ID verification upload flow (image → Firestore status flag; no live OCR in v1)
- TravelID badge generation
- Trip folder creation, editing, and status management
- Day-by-day itinerary with place stops (Firestore-backed)
- Google Maps embedded view with itinerary pins and walking estimates
- Real-time group chat per trip with Firestore listeners
- Message category tagging + drag-to-Notebook
- Gemini-powered AI assistant that reads Notebook and returns suggestions
- Social journal feed with public / friends-only post visibility
- TripCoins balance incremented on journal post and trip completion
- Reliability Score display on profile (computed from Firestore activity data)

**❌ Out of scope (post-hackathon roadmap):**
- Live OCR / government ID verification (requires third-party KYC provider, e.g. Jumio or Onfido)
- Reliable Reliability Score engine (needs historical behaviour data — at launch, display as "New User")
- Flight / hotel booking integration (OTA partnership required)
- Expense splitting / budget ledger (Splitwise integration is the pragmatic path)
- Multi-cursor real-time itinerary co-editing (async Notebook + AI covers 90% of the need)
- AR destination preview
- In-app video calls

---

## Why TripNest Will Grow

**The path to scale is built into the product.**

1. **Network effects:** Every new verified user makes the match pool stronger for everyone else. A user in Kuala Lumpur benefits from a user registering in Berlin — they might both want to visit Tokyo.

2. **Social layer as organic acquisition:** Journal posts are public by default. A well-written post about a Kyoto trip appears in search, is shareable on Instagram, and brings new users into the app through content — not paid ads.

3. **Travel DNA as a portable identity:** A user's compatibility vector travels with them across every trip. The more they use TripNest, the richer and more accurate their profile becomes — creating a switching cost that no generic app can replicate.

4. **Expansion surface:** The Notebook-aware AI, the reliability infrastructure, and the trust layer are all applicable to **group travel beyond just duos** — families, team retreats, alumni trips. The core architecture is already built for n ≥ 2 travellers.

**The before/after for a TripNest user:**

| Stage | Without TripNest | With TripNest |
|---|---|---|
| Finding a companion | Scroll Reddit, post in Facebook groups, hope for the best | Swipe through 5 preference topics → see ranked, verified matches with % scores |
| Vetting a stranger | No verification, no trust signal | TravelID badge + ID verification gate + Reliability Score |
| Planning together | WhatsApp for decisions, Wanderlog for itinerary, two tools that never sync | One app: chat → Notebook → AI reads Notebook → itinerary updates |
| Managing disagreements on budget | Manual negotiation, often unresolved | Switch AI plan version (Budget / Balanced / Comfort) and compare |
| Remembering what you agreed | Scroll back 300 messages | Open the Notebook — everything is there, categorised and searchable |
| Sharing the experience | Post to Instagram, lose the context | Write a journal entry, earn TripCoins, build your travel identity |

