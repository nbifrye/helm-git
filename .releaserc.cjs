module.exports = {
  release: {
    branches: ["master"]
  },
  plugins: [
    [
      '@semantic-release/commit-analyzer',
      {
        preset: 'conventionalcommits',
      },
    ],
    [
      '@semantic-release/release-notes-generator',
      {
        preset: 'conventionalcommits',
      }
    ],
    [
      "@semantic-release/exec",
      {
        prepareCmd: "VERSION=${nextRelease.version} npm run bump && npm run package",
      }
    ],
    [
      "@semantic-release/git",
      {
        assets: [
          "package.json",
          "package-lock.json",
          "plugin.yaml",
          "README.md"
        ],
        message: "chore(release): update versions to ${nextRelease.version} [skip ci]"
      }
    ],
    [
      "@semantic-release/github",
      {
        assets: [
          "dist/helm-git-*.tgz",
          "dist/helm-git-*.tgz.prov"
        ]
      }
    ],
    [
      "@semantic-release/npm",
      {
        npmPublish: false,
      },
    ],
  ],
  preset: "conventionalcommits",
};
