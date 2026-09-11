<div align="center">

# 🪹 TripNest
### by See u in MMU

**Team:** Yeat Jing Rong · Toh Shee Thong · Kimberly Chan · Tan Qian Wen  
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

Every year, people travel alone when they didn't want to — or travel with people who turn the trip into a compromise.

The problem isn't finding a destination. **It's finding the right people, aligning everyone's needs, and turning them into a trip that actually works.**

**Three major gaps stand out:**

### ① Finding the right travel companion is still a trust problem

People rely on Reddit, Facebook Groups, and WhatsApp to find travel buddies. But these platforms offer little identity verification or compatibility screening.

Budget, travel pace, interests, and daily routines can easily clash, yet these factors are rarely considered before people connect. Existing platforms focus on social discovery, not deep compatibility matching.

**Finding a travel companion is easy. Finding the right one is not.**

### ② Group travel planning is scattered

A typical trip uses WhatsApp for discussion, Google Maps for places, a document for ideas, an itinerary app for planning, and a spreadsheet for expenses.

These tools don't share the same context. A decision made in chat doesn't update the itinerary. A useful place gets buried in messages. Plans become outdated, conversations get repeated, and conflicts appear at the last minute.

**Planning becomes a coordination problem instead of an enjoyable part of the trip.**

### ③ AI can plan a destination, but not your group

AI can generate a 7-day Tokyo itinerary in seconds.

But it doesn't automatically know that one person hates early mornings, another has a RM250/night budget, and someone else can't walk more than 12,000 steps. The itinerary may look perfect on paper, **but not for the people taking the trip.**

So everyone edits it until the original AI plan is almost gone.

**The missing piece isn't better itinerary generation. It's understanding the people behind the trip.**

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
| 8 | 📔 **Memories** | A shared space to save and look back on the best photos and moments from your trip together. |
| 9 | 📓 **Shared Trip Notebook** | Drag any chat message into the Notebook; AI reads these to personalise the itinerary |
| 10 | ☑️ **Planning Check Cards** | Visual checklist generated from Notebook entries so nothing decided in chat is forgotten |
| 11 | 📰 **Social Travel Journal** | Post trip entries with public or friends-only visibility; a feed of real travel stories |
| 12 | 🎮 **TripCoins Gamification** | Earn coins for journaling, completing trips, and community engagement — drives retention |
| 13 | ⭐ **Reliability Score** | A trust metric per user built from past trip completion rate and response behaviour |

---

## 2. Ideation & Process 
### From a Broad Travel Platform to One Core Problem

Our initial concept was a general AI travel assistant covering the entire travel journey, from destination discovery and social-media inspiration to itinerary planning, preparation and expense splitting.

However, during mentor consultation, we realised that **solving many travel problems at once made our solution too general**. The question became:

> **What is the one problem TripNest should solve exceptionally well?**

We compared the problems travellers face before, during and after a trip and identified one particularly underserved problem:

### Finding the right person to travel with, and successfully planning the trip together.

For solo travellers, the problem begins before itinerary planning.

They may:

- Want to travel but have no travel companion.
- Search for strangers through Reddit, Facebook Groups or social media.
- Have safety concerns when meeting strangers online.

This led us to narrow TripNest's core problem to:

> **How might we help travellers find a compatible and trustworthy travel companion, then turn that match into a workable trip without switching between multiple apps?**
>

### 2.1 Ideas We Considered

Through team discussion and mentor feedback, we narrowed our solution around one core problem: **helping travellers find a compatible and trustworthy travel companion, then plan the trip together.**
| **Idea** | **Status** | **Reasoning** |
|---|---|---|
| **General AI Travel Chatbox** | 🔄 Refined | Originally intended to solve the entire travel-planning process. We kept it as an entry point, but reduced its role so it supports the core companion-to-trip journey rather than becoming the product itself. |
| **Social Media Travel Inspiration** | ❌ Dropped | not directly solve our core problem of finding a compatible and trustworthy travel companion. |
| **Destination / Travel Recommendation** | ❌ Deprioritised | “Where should I travel?” is already addressed by many travel platforms and is too broad to differentiate TripNest. |
| **Swipe-based Travel DNA Quiz** | ✅ Chosen | Creates a structured preference profile quickly and makes compatibility measurable instead of relying on vague profile descriptions. |
| **Compatibility Scoring** | ✅ Chosen | Gives travellers an immediate way to understand whether another person is likely to be a suitable travel partner. |
| **ID Verification** | ✅ Chosen | A major barrier to meeting strangers is trust. Verification directly addresses the safety concern behind companion matching. |
| **TravelID Profile** | ✅ Chosen | Makes a traveller's identity, travel style and verification status easy to understand before connecting. |
| **Solo Traveller Matching** | ✅ Core | This became the primary problem we wanted to solve: helping travellers find someone compatible to travel with. |
| **Group Chat** | ✅ Core Support | Matching alone is not enough. Once travellers connect, they need a place to communicate and make decisions without leaving TripNest. |
| **Group Preference & Harmony** | ✅ Core Support | Different travellers may have conflicting budgets, walking tolerance, pace and interests. The system helps turn these differences into practical compromises. |
| **Shared Trip Notebook** | ✅ Chosen | Decisions made in conversation can easily be forgotten. The Notebook connects discussion with actual trip planning. |
| **AI Itinerary Assistant** | ✅ Chosen | Instead of generating another generic itinerary, the AI uses the group's actual decisions to produce more relevant suggestions. |
| **Interactive Itinerary Map** | ✅ Chosen | Converts group decisions into a practical route that the travellers can review together. |
| **Three AI Plan Versions** | 🔄 Simplified | Budget / Balanced / Comfort demonstrates how AI can resolve different spending expectations, but it is secondary to the core matching problem. |
| **Trip Preparation** | 🔄 Supporting | Useful after the trip has been agreed upon, but not part of the core problem. |
| **AI Receipt / Expense Splitting** | ❌ Dropped | Not directly support our core problem of finding a compatible travel companion. |
| **Social Travel Journal** | ❌ Deprioritised | Useful for retention and memories, but unrelated to the primary problem we identified. |
| **TripCoins Gamification** | ❌ Deprioritised | Adds engagement but does not directly solve the problem. |
| **Live Flight & Hotel Booking** | ❌ Dropped | Requires complex booking infrastructure and payment integration. We only provide recommendations and price comparison. |
| **AR Destination Preview** | ❌ Dropped | High implementation complexity with limited connection to our core problem. |
| **In-app Video Calls** | ❌ Dropped | Existing platforms such as WhatsApp and FaceTime already solve this problem effectively. |
| **Local Guide Marketplace** | ❌ Dropped | Introduces a separate supply-side marketplace problem outside TripNest's core purpose. |
| **Real-time Collaborative Editing** | ❌ Dropped | Technically complex and unnecessary when group chat, Notebook and AI suggestions can support asynchronous collaboration. |
---

### 2.2 Ideation Boards

#### Problem Tree — Identifying the Core Problem

![Problem Tree](tripnest_problem_tree.png)

This problem tree maps the causes and effects of travelling without a suitable companion. We identified **lack of structured compatibility information** and **lack of trust when meeting strangers** as two major root causes, which led us to focus TripNest on safe and compatible traveller matching.

---

#### Idea Iteration — From General Travel Assistant to TripNest

![Iteration Timeline](tripnest_iteration_timeline.png)

Our idea evolved through several stages. We first explored a general AI travel assistant, then moved towards companion finding, and finally connected **matching → group discussion → preference alignment → itinerary planning**. This helped us narrow the product instead of continuously adding unrelated travel features.

---

#### Feature Mindmap — Exploring the Solution Space

![TripNest Feature Mindmap](tripnest_mindmap.png)

The mindmap captures the different features we considered during brainstorming. We used it to separate **core features that directly solve our selected problem** from supporting features and ideas that could be removed without affecting the main solution.

---

#### User Flow — From Finding a Companion to Planning a Trip

![TripNest User Flow](tripnest_user_flow.png)

The user flow shows the main TripNest journey:

**Verify → Match → Connect → Align → Plan**

It demonstrates how the different core features work together rather than functioning as separate travel tools.

---

### 2.3 Mentor Consultation

**Date: 7 Sep 2026** <br>
**Mentor: Daniel Koh Yu Hang** <br>

| **Feedback Received** | **What Was Changed** |
|---|---|
| **The app currently has too many functions and tries to solve too many travel problems.** | We narrowed our focus from a general travel platform to the specific problem of **finding a compatible and trustworthy travel companion and planning the trip together**. |
| **The problem should be specific rather than simply “making travel more convenient”.** | We defined specific pain points: lack of compatibility information, safety concerns when meeting strangers, preference conflicts and fragmented planning after matching. |
| **Think about what happens if a solo traveller does not have a group.** | We made **Solo Traveller Matching** the core feature, supported by Travel DNA, ID verification and compatibility scoring. |
| **After matching, users should be able to communicate with each other.** | We added a dedicated **Group Chat** inside the Trip Folder so matched travellers can discuss their trip without immediately moving to another platform. |
| **AI can detect useful places from social-media links.** | We kept **Social Inspiration** as a supporting feature. AI extracts places and useful information from shared travel content and adds them to the trip. |
| **Group preferences should be used as a reference when planning.** | We introduced **Group Preference & Harmony**, allowing TripNest to identify differences in budget, pace, walking tolerance and interests before generating the itinerary. |
| **The app does not need to become a booking system.** | We changed flight, hotel and transport functionality from direct booking to **recommendation and price comparison**. Users can make the final booking through the original provider. |
| **Focus on solving one problem well instead of adding more functions.** | We moved features such as gamification, journaling, AR, video calls and the guide marketplace away from the core prototype. |

### Final Direction

The mentor consultation helped us change our thinking from:

> **"How can we build an app that helps people travel?"**

to:

> **"How can we help someone who wants a travel companion find the right person, trust them, and successfully plan a trip together?"**

This became the core direction of **TripNest**:

**Find → Verify → Match → Connect → Align → Plan**

---

## 3. Design & Prototype

**UI Prototype:** `[ TODO — Insert your Figma / Canva / Netlify link here. Verify it opens in incognito. ]`

The app follows a cohesive design language: **Midnight Navy** (`#0F172A`) as the primary tone, **Azure Blue** (`#2563EB`) as the action accent, **Ice Blue** (`#EBF4FB`) as the background tint, and **Plus Jakarta Sans** as the type system throughout. 

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

Every existing travel app treats **finding a companion** and **planning a trip** as separate problems. TripNest treats them as one continuous loop. That's not an incremental feature addition, it's a fundamentally different product architecture.

---

### Novel Features & Differentiators

| Feature | What's novel | Why it matters |
|---|---|---|
| **Notebook-aware AI Itinerary** | The only travel AI that reads your group's actual decisions before suggesting changes. If your chat Notebook says "no early mornings" and "hotel budget ≤ RM250/night", the AI suggests a 10:30 AM Day 2 start and stays within budget — without you re-entering preferences anywhere. | Eliminates the #1 failure mode of AI travel planners: generic output that ignores group context |
| **Travel DNA Swipe Onboarding** | 5-topic binary swipe quiz (pace, budget, rhythm, vibe, planning style) builds a rich compatibility vector before the user sees a single match. | First-match relevance is instant — not after 10 failed connections |
| **ID Verification Gate** | Cannot send or receive match requests without verified identity. Not a badge, not an optional tick — a hard gate. | The only travel-buddy platform with a structural safety guarantee, not just a policy |
| **TravelID Badge** | A shareable, passport-inspired profile card surfacing travel style, MBTI, verification status, and compatibility score in one glance. | Replaces the wall-of-text profile that nobody reads with a single scannable artefact |
| **Drag-to-Notebook from Chat** | In-chat messages tagged by category can be dragged directly into the shared trip Notebook. The AI reads the Notebook — not a separate form. | Closes the WhatsApp-to-itinerary gap with zero extra effort from users |
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

TripNest is an **AI-assisted travel companion matching and group trip planning platform.**
The technology in this section supports one core journey:
**Find the right person → determine compatibility → establish trust → communicate → align preferences → plan the trip together.**

---

### 5.1 Tech Stack

#### Frontend

| Technology | Why we chose it | Expected constraints |
|---|---|---|
| **Flutter** | Single codebase for both iOS and Android. Reduces team size needed and development time significantly — critical for a 4-person, 2-week sprint. Rich widget ecosystem for building polished mobile UI without duplication. | Platform-specific permission dialogs (camera, storage) need testing on real devices. Hot reload speeds up iteration but complex state bugs can still be slow to debug. |
| **Riverpod** | Compile-safe, testable state management. Avoids the boilerplate of BLoC while being more robust than basic `setState` for multi-screen reactive state (user profile, match state, trip data). | Learning curve for developers unfamiliar with Riverpod's provider graph. |
| **Google Fonts** | Free, fast CDN-hosted fonts that give the app a professional, branded feel without any licensing concerns. | Requires internet on first load to cache; fallback to system fonts needed for offline use. |

---

#### Backend
> **Note:** The current prototype is frontend-only. The backend described here is the production architecture we plan to build during the building phase.

| Technology | Why we chose it | Expected constraints |
|---|---|---|
| **FastAPI (Python)** | Lightweight, async-capable Python web framework with automatic OpenAPI docs. Python is the natural language for AI/ML libraries (LangChain, ChromaDB client). Allows us to co-locate matching logic and AI orchestration in one service. | Requires a capable machine for the hackathon demo since Ollama runs locally alongside it. Not auto-scaling out of the box without Cloud Run. |
| **Firebase Auth** | Zero-backend-work authentication with email/password and social sign-in. SDKs for both Flutter and Python admin. Security rules are declarative and quick to configure. | Free Spark plan has limits on concurrent connections and storage. We may hit Firestore read/write quotas during heavy demo traffic. Auth tokens must be validated server-side in FastAPI, adding a verification step to every AI API call. |
| **Ollama (local)** |  Local LLM runtime for self-hosted open-source models — no per-token API cost; memory data stays on our own infrastructure (privacy-first). | Requires 8 GB+ VRAM for comfortable inference; for the hackathon demo, run on a team laptop or Google Colab with GPU |

---

#### Database & Storage

| Technology | Why we chose it | Expected constraints |
|---|---|---|
| **Firestore** | Real-time document database with offline support. Native Flutter SDK. Handles user profiles, trips, group chat, itinerary, and notebook data without a dedicated backend CRUD layer — saving development time. | Firestore's document model requires careful data modelling to avoid expensive reads (e.g. fetching all users for matching). We will use server-side filtering and indexed queries. Free Spark plan limits: 50k reads/day, 20k writes/day — sufficient for a hackathon demo. |
| **Firebase Storage** | Simple, rules-secured file storage for profile photos and TravelID prototype image uploads. Integrates directly with Firebase Auth for per-user access rules. | Free plan: 5 GB storage, 1 GB/day download. Sufficient for demo scale. |
| **ChromaDB (local)** | Zero-configuration open-source vector database. Runs as a local process alongside FastAPI. Used to store and retrieve User Memory embeddings for the matching engine. | ChromaDB running inside a container or co-located on ephemeral infrastructure (e.g. Cloud Run) is **not suitable for production** — data would be lost on container restart. For the hackathon, persistence is on the team workstation's local filesystem. A managed or self-hosted persistent vector database would be required for production. |

---

#### AI & Machine Learning

| Technology | Why we chose it | Expected constraints |
|---|---|---|
| **`nomic-embed-text` via Ollama** | Dedicated, lightweight embedding model for converting User Memory text into vector representations. Embedding is a separate responsibility from reasoning — we deliberately do not use Llama 3 8B for this task. Runs locally via Ollama at zero cost. | Embedding quality depends on model size; `nomic-embed-text` is a strong general-purpose choice but may not capture highly domain-specific travel nuances. |
| **Llama 3 8B via Ollama** | Open-source reasoning model used exclusively for **natural-language compatibility reasoning** — reading retrieved memories and generating a qualitative explanation of why two travellers are or are not compatible. Local inference preserves user privacy during the prototype stage. | 8B parameter model inference on CPU can be slow (10–30 seconds per request). A GPU-equipped workstation significantly improves this. We will cache compatibility results in Firestore to avoid repeated inference for the same pair. |
| **Google Gemini Flash** | Capable cloud LLM used for **AI itinerary generation**. Trip planning is an open-ended generative task well-suited to a large cloud model. Gemini Flash offers a free-tier API that is sufficient for hackathon usage. | Subject to API rate limits and daily quotas (varies by model version). The exact Gemini Flash model version is selected based on what is available and within quota at implementation time — we do not hard-code a specific version as an architectural dependency. Context window limits mean we must carefully curate what group context we pass to the prompt. |
| **LangChain (selective use)** | Used only where it genuinely simplifies orchestration — specifically for the ChromaDB retrieval chain and prompt templating in the matching service. We do not use it as a blanket abstraction layer. | Adds a dependency and can obscure behaviour if overused. We keep LangChain usage minimal and explicit. |

---

#### External APIs & Services

| Technology | Why we chose it | Expected constraints |
|---|---|---|
| **Google Maps SDK (Flutter)** | Native Flutter plugin for interactive map display and route visualisation on the trip itinerary screen. | Requires a Maps API key with billing enabled. Free monthly credit ($200) is more than sufficient for hackathon usage, but billing must be set up. Platform-specific API key configuration needed for Android and iOS. |
| **Google Places API** | Provides structured, permitted access to place data — name, address, rating, opening hours, photos, and coordinates. This is our primary source of real-world place information for itinerary suggestions. Replaces any dependency on web scraping. | Pay-per-use after free credit. Calls must be minimised with caching (Firestore) to avoid unexpected costs. Results are limited to what the Places API returns — we do not claim real-time web information beyond this. |

---

### 5.2 System Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                  Flutter Mobile App                     │
│  Matching │ Travel DNA │ Memories │ Profile / TravelID  │
│  Group Chat │ Shared Notebook │ Trip Itinerary          │
└────────────────────────┬────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          │                             │
          ▼                             ▼
┌─────────────────────┐     ┌──────────────────────────────────┐
│  Firebase (Cloud)   │     │  FastAPI Backend                 │
│                     │     │  [Hackathon: team workstation]   │
│  Auth               │     │                                  │
│  Firestore          │     │  ┌───────────────────────────┐   │
│  Storage            │     │  │     Matching Service      │   │
└─────────────────────┘     │  │                           │   │
                            │  │  Travel DNA Score         │   │
                            │  │  (deterministic formula)  │   │
                            │  │         ↓                 │   │
                            │  │  nomic-embed-text (Ollama)│   │
                            │  │  → User Memory embeddings │   │
                            │  │         ↓                 │   │
                            │  │  ChromaDB (local)         │   │
                            │  │  → retrieve top-k memories│   │
                            │  │         ↓                 │   │
                            │  │  Llama 3 8B (Ollama)      │   │
                            │  │  → compatibility reasoning│   │
                            │  │  → score + explanation    │   │
                            │  └───────────────────────────┘   │
                            │                                  │
                            │  ┌───────────────────────────┐   │
                            │  │   AI Planning Service     │   │
                            │  │                           │   │
                            │  │  Group Preferences        │   │
                            │  │  + Shared Notebook        │   │
                            │  │  + Current Itinerary      │   │
                            │  │  + Google Places API data │   │
                            │  │         ↓                 │   │
                            │  │  Google Gemini Flash      │   │
                            │  │  → AI itinerary output    │   │
                            │  │         ↓                 │   │
                            │  │  Google Maps (display)    │   │
                            │  └───────────────────────────┘   │
                            └──────────────────────────────────┘
```

---

### 5.3 How the Two AI Systems Work

We use two separate AI systems because they solve fundamentally different problems.

**System 1 — Local Matching AI** answers: *"Are these two people compatible travel partners?"*

The compatibility score is **not** generated arbitrarily by the LLM. It uses a two-layer design:

1. **Travel DNA base score (deterministic):** A weighted formula applied to both users' quiz answers across five dimensions — budget, travel pace, schedule flexibility, preferred activities, and food/lifestyle. This produces a numerical base score (e.g. 84%).

2. **Memory adjustment (LLM-assisted):** User Memory notes are embedded via `nomic-embed-text` and stored in ChromaDB. When matching, relevant memories for both users are retrieved and passed to Llama 3 8B, which reasons about semantic compatibility and may apply a small adjustment (e.g. −5%) along with a plain-language explanation.

**Final score = Travel DNA base ± memory adjustment** (e.g. 84% − 5% = **79% compatible**)

The LLM explains *why* — it does not invent the percentage.

---

**System 2 — AI Trip Planning (Gemini)** answers: *"What should this group do on their trip?"*

Group context (preferences, notebook entries, current itinerary, and Places API data) is assembled and sent to Google Gemini Flash, which generates itinerary suggestions grounded in what the group actually wants. No web scraping is involved — structured Places API data is the real-world information source.

---

### 5.4 Build Plan & Scope

We are a **4-person team building over approximately 2 weeks.** The scope below is deliberately narrow. A reviewer should be able to see a live, working demo of this entire journey: **FIND → VERIFY → MATCH → CONNECT → ALIGN → PLAN.**

#### What We Are Building (In Scope)

| # | Feature | Description |
|---|---|---|
| 1 | **Auth & Onboarding** | Firebase email/social sign-in, onboarding flow |
| 2 | **User Profile** | Photo, bio, travel style tags |
| 3 | **Travel DNA Quiz** | Structured quiz → deterministic compatibility base score |
| 4 | **User Memories** | Free-text input → embedded via `nomic-embed-text` → ChromaDB |
| 5 | **Matching Engine** | Travel DNA score + Llama reasoning layer → match result screen |
| 6 | **Compatibility Explanation** | Natural-language output from Llama 3 8B explaining the match |
| 7 | **Prototype TravelID Verification** | Image upload → Firestore verification state → "TravelID Verified" badge on profile *(no OCR or KYC — prototype flow only)* |
| 8 | **Group Chat** | Firestore-backed real-time messaging between matched travellers |
| 9 | **Group Preference & Harmony** | Shared preference voting → alignment view for the group |
| 10 | **Shared Notebook** | Group pinboard for trip ideas and notes |
| 11 | **Gemini Itinerary Assistant** | AI-generated itinerary suggestions from group context + Places API |
| 12 | **Google Maps Integration** | Map display of itinerary locations and routes |
| 13 | **Google Places API** | Structured place data powering itinerary suggestions |

#### What We Are Not Building (Out of Scope)

The following were deliberately dropped from TripNest's core scope. They are not a future afterthought — they are intentional cuts to keep the build feasible and the product focused.

| Out of Scope | Reason |
|---|---|
| Production KYC / real identity verification | Requires a dedicated KYC provider (e.g. Stripe Identity), compliance review, and is out of scope for a prototype |
| Web scraping (TripAdvisor, Google Maps) | Scraping-dependent architecture is brittle and legally complex; replaced by Google Places API |
| Direct flight / hotel booking | Third-party booking API integration complexity |
| AI expense / receipt splitting | Dropped from core product scope |
| Social travel journal | Dropped from core product scope |
| Gamification (TripCoins) | Dropped from core product scope |
| AR destination preview | Hardware complexity |
| In-app video calls | WebRTC / SDK complexity |
| Real-time collaborative editing | Conflict resolution and sync complexity |
| Social media link/inspiration extraction | Scraping risk and out of core scope |

#### 2-Week Sprint Breakdown

| Days | Focus | Milestone |
|---|---|---|
| **Day 1** | Infrastructure | Firebase project, Firestore rules, FastAPI scaffold, Ollama + ChromaDB running locally and confirmed |
| **Days 2–3** | Auth + Profile + Travel DNA | Sign-in flow, profile screen, Travel DNA quiz, deterministic scoring formula |
| **Days 4–5** | User Memories + Embeddings | Memory input UI, `nomic-embed-text` pipeline, ChromaDB storage and retrieval verified |
| **Days 6–7** | Matching Engine | Full compatibility score flow, Llama reasoning, match result screen with explanation |
| **Days 8–9** | Trip Workspace | Shared Notebook, Group Chat (Firestore real-time) |
| **Days 10–11** | Harmony + Itinerary AI | Group preference voting, Harmony view, Gemini itinerary assistant endpoint |
| **Day 12** | Maps + Places | Google Maps display, Places API integration feeding itinerary suggestions |
| **Days 13–14** | Integration + Polish + Demo | End-to-end testing, prototype TravelID flow, UI polish, demo script |

Some components (notably TravelID verification and the Gemini itinerary assistant) are intentionally **prototype implementations** — they demonstrate the concept and UX without production-grade backends.
