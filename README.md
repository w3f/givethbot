[![CircleCI](https://circleci.com/gh/w3f/givethbot.svg?style=svg)](https://circleci.com/gh/w3f/givethbot)

# givethbot

Defines the Docker file and Helm chart for packaging [Giveth bot](https://github.com/Giveth/giveth-bot).
Also includes automation files for testing and deploying to W3F platform.

## Configuration

When the application is deployed to the kubernetes production cluster it uses
[this configmap](charts/givethbot/templates/configmap.yaml) for getting the
configuration settings.

## Files

These are the main directories in the repo:

* `charts`: contains the givethbot helm chart, besides the deployment and
service resources it contains manifests for these custom resources:

  * `configmap`: basic configuration of the bot, including messages for the
  interaction room, id of the kudos spreadsheet and calendar source url.

  * `secret`: credential files for matrix and spreadsheet API.

* `.circleci`: defines the CI/CD configuration.

* `scripts`: contains:

  * `integration-tests.sh`: automated checks to verify that the components can
  be properly deployed.

  * `deploy.sh`: commands to release the application to the production cluster
  using the published chart.

* `Dockerfile`: definition of the image used to deploy the bot. Just clones the
upstream repo at https://github.com/Giveth/giveth-bot and install the dependencies.

## Environment variables

In order to be able to deploy to production, these environment variables must be
available:

* `$DIGITALOCEAN_ACCESS_TOKEN`

* `$GITHUB_BOT_TOKEN`

* `$DOCKER_USER`

* `$DOCKER_PASSWORD`

* `$MAIN_ROOM`

* `$BOT_CREDENTIALS`

* `$CREDENTIALS`

* `$CLIENT_SECRET`

These values are already set on CI, and are available on 1Password, under the
Infrastructure vault, the GitHub bot token in an item called `GitHub bot`, the
Docker credentials in an item called `Docker Hub Bot`  and the Digital Ocean
access token in the `DigitalOcean API credentials` item; the rest, specific to
the bot, can be found in the `Giveth bot` item.

## CI/CD Workflow

When a PR is proposed to this repo, the integration tests defined by
`scripts/integration-tests.sh` are executed on a Kubernetes cluster created on
CI using the code from the PR, currently they just check that the component can
be deployed and deleted without errors.

After the PR is merged into master, when a semantic version tag (`vX.Y.Z`) is
pushed the tests are run again and, if all is ok, the chart is published and the
probe is deployed to production. Note that the tag version pushed must match the
version in [./charts/givethbot/Chart.yaml]()

## Running tests

Tests can be run and debugged locally, you need to have [docker](https://docs.docker.com/install/)
and [CircleCI CLI](https://circleci.com/docs/2.0/local-cli/) installed, then run
the integration tests (involving k8s component deployment) with:
```
$ circleci local execute --job integrationTests
```
