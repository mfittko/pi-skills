/**
 * Slide capture script for Playwright-based visual review.
 *
 * Usage:
 *   SLIDEV_PORT=3031 SLIDE_COUNT=9 OUT_DIR=tmp/deck-build/screenshots node capture-slides.mjs
 *
 * Requires: playwright-chromium (install via `npm i -D playwright-chromium`)
 */

import fs from "node:fs/promises";
import path from "node:path";
import { chromium } from "playwright-chromium";

const port = process.env.SLIDEV_PORT || "3031";
const slideCount = parseInt(process.env.SLIDE_COUNT || "9", 10);
const outDir = path.resolve(process.env.OUT_DIR || "tmp/deck-build/screenshots");

await fs.mkdir(outDir, { recursive: true });

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1456, height: 816 } });

for (let i = 1; i <= slideCount; i++) {
  await page.goto(`http://localhost:${port}/${i}`, { waitUntil: "networkidle" });
  await page.waitForTimeout(1500);
  const filename = String(i).padStart(2, "0") + ".png";
  await page.screenshot({ path: path.join(outDir, filename) });
  console.log(`Captured slide ${i} → ${filename}`);
}

await browser.close();
console.log(`Done. ${slideCount} slides saved to ${outDir}`);
