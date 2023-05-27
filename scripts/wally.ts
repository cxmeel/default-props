import fs from "node:fs"

import meow from "meow"
import toml from "@iarna/toml"
import deepmerge from "deepmerge"

const MANIFEST: { [key: string]: string } = {
  react: "react.wally.toml",
  roact: "roact.wally.toml",
}

const cli = meow(`
Usage:
  $ wally --type react

Options:
  --type, -t  Type of project to generate
`, {
  importMeta: import.meta,
  flags: {
    type: {
      type: "string",
      choices: Object.keys(MANIFEST),
      aliases: ["t"],
      isRequired: true,
    },
  },
})

const baseManifest = toml.parse(fs.readFileSync("base.wally.toml", "utf8"))
const manifest = toml.parse(fs.readFileSync(MANIFEST[cli.flags.type], "utf8"))

const output = deepmerge(baseManifest, manifest)

fs.writeFileSync("wally.toml", toml.stringify(output))
