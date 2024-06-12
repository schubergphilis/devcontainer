[![Release Status](https://github.com/schubergphilis/devcontainer/actions/workflows/pipeline.yml/badge.svg)](https://github.com/schubergphilis/devcontainer/actions/workflows/pipeline.yml)

# devcontainer

This project defines a container image to be used as a development environment
inside [Visual Studio Code](https://code.visualstudio.com/) through the
[Remote Dev Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

## What is devcontainer?

Devcontainer is a standard to define remote development environments using
containers and how editors and IDE's should integrate them. The standard is
described [here](https://containers.dev/).

## How can I use it?

First off, you need to use a text editor or IDE who supports devcontainers. The
most famous one is Visual Studio Code with the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
extension installed.

Your project should also define a `.devcontainer/devcontainer.json`
configuration that is loaded by the extension and then the remote environment
is built, started and attached to.

You can see the [grawsp](https://github.com/schubergphilis/grawsp/tree/main/.devcontainer)
project as an example. You can also read more about how to setup your own
development container in Visual Studio Code [here](https://code.visualstudio.com/docs/devcontainers/containers).

## Examples

Example of using this image directly in your `.devcontainer/devcontainer.json`:

```json
{
    "image": "ghcr.io/schubergphilis/devcontainer:latest"
}
```

You can also use it as a base image to your own container:

```
FROM ghcr.io/schubergphilis/devcontainer:latest
```

## License

```text
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the specific language governing
permissions and limitations under the License.
```
