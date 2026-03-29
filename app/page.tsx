const quickPoints = [
  "Watches Downloads, Desktop, and Documents.",
  "Suggests cleaner names for screenshots, installers, folders, and AI exports.",
  "Lets you rename one item, batch rename many, or run Clean My Mess instantly.",
];

const examples = [
  {
    before: "Screenshot 2026-03-29 at 7.03.07 PM.png",
    after: "screenshot-mar-29-2026-1903.png",
  },
  {
    before: "ChatGPT Image Mar 29, 2026 at 7_01_12 PM.png",
    after: "chatgpt-concept-image-mar-29-2026.png",
  },
  {
    before: "final-final-copy-v2.pdf",
    after: "project-brief-mar-2026.pdf",
  },
];

const features = [
  {
    title: "Clean My Mess",
    body: "One click to sweep Downloads and fix obvious filename disasters fast.",
  },
  {
    title: "Batch Rename",
    body: "Select multiple files or folders from anywhere and clean them up in one pass.",
  },
  {
    title: "AI-aware",
    body: "ChatGPT, Claude, Grok, and other generated assets get more precise suggestions.",
  },
];

export default function Home() {
  return (
    <main className="shell">
      <section className="hero">
        <div className="eyebrow">macOS utility</div>
        <h1>Rename Police</h1>
        <p className="lede">
          A cleaner Mac starts with cleaner filenames.
        </p>
        <p className="sublede">
          Rename messy downloads, screenshots, folders, and AI exports without leaving the menu bar.
        </p>
        <div className="actions">
          <a
            className="button primary"
            href="https://github.com/Reelai-ha/rename-police/releases/latest"
            target="_blank"
            rel="noreferrer"
          >
            Download for Mac
          </a>
          <a
            className="button secondary"
            href="https://github.com/Reelai-ha/rename-police"
            target="_blank"
            rel="noreferrer"
          >
            View Source
          </a>
        </div>
        <p className="microcopy">
          No DMG required for v1. The download can ship as a signed <code>.app.zip</code> from GitHub Releases.
        </p>
      </section>

      <section className="preview card">
        <div className="section-head">
          <h2>Instant cleanup</h2>
          <span className="section-note">Before → After</span>
        </div>
        <div className="example-list">
          {examples.map((example) => (
            <div className="example-row" key={example.before}>
              <div className="name before">{example.before}</div>
              <div className="arrow">→</div>
              <div className="name after">{example.after}</div>
            </div>
          ))}
        </div>
      </section>

      <section className="grid">
        <div className="card compact-card">
          <h2>Why it works</h2>
          <ul className="bullet-list">
            {quickPoints.map((point) => (
              <li key={point}>{point}</li>
            ))}
          </ul>
        </div>
        <div className="card compact-card stat-card">
          <div className="stat-label">Built for v1</div>
          <div className="stat-value">Fast</div>
          <p>
            Open source, local-first, and lightweight enough to stay out of your way.
          </p>
        </div>
      </section>

      <section className="feature-grid">
        {features.map((feature) => (
          <article className="card feature-card" key={feature.title}>
            <h3>{feature.title}</h3>
            <p>{feature.body}</p>
          </article>
        ))}
      </section>

      <section className="card support-card">
        <div className="section-head">
          <h2>Support the project</h2>
          <span className="section-note">Chat or contribute</span>
        </div>
        <p>
          If Rename Police saved you time, you can either reach out directly or support development with a one-time payment.
        </p>
        <div className="support-actions">
          <a
            className="button tertiary"
            href="https://x.com/kiaan_mittal"
            target="_blank"
            rel="noreferrer"
          >
            Chat with Kiaan
          </a>
          <span className="support-or">or</span>
          <a
            className="button support"
            href="https://checkout.dodopayments.com/buy/pdt_0NbXyrsvTTZkdAcj0ApHq?quantity=1"
            target="_blank"
            rel="noreferrer"
          >
            Support Me
          </a>
        </div>
      </section>

      <footer className="footer">
        <a href="https://x.com/kiaan_mittal" target="_blank" rel="noreferrer">
          Made by Kiaan
        </a>
        <span>Open source. Local-first. No accounts.</span>
      </footer>
    </main>
  );
}
