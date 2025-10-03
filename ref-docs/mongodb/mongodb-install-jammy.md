<div id="std-label-install-mdb-community-ubuntu"></div>

# Install MongoDB Community Edition on Ubuntu

➤Community`mongodb-org`Ubuntu`apt``mongod`[MongoDB Atlas](https://www.mongodb.com/atlas/database?tck=docs_server) is a hosted MongoDB service option in the cloud which requires no installation overhead and offers a free tier to get started.

## Overview

Use this tutorial to install MongoDB 7.0 Community Edition on LTS (long-term support) releases of Ubuntu Linux using the `apt` package manager.

### MongoDB Version

This tutorial installs MongoDB 7.0 Community Edition. To install a different version of MongoDB Community, use the version drop-down menu in the upper-left corner of this page to select the documentation for that version.

## Considerations

### Platform Support

MongoDB 7.0 Community Edition supports the following 64-bit Ubuntu LTS (long-term support) releases on [x86_64](https://mongodb.com/docs/v7.0/administration/production-notes/#std-label-prod-notes-supported-platforms-x86_64) architecture:

- 22.04 LTS (Long Term Support) ("Jammy")

- 20.04 LTS (Long Term Support) ("Focal")

MongoDB only supports the 64-bit versions of these platforms. To determine which Ubuntu release your host is running, run the following command on the host's terminal:

```bash
cat /etc/lsb-release
```

MongoDB 7.0 Community Edition on Ubuntu also supports the [ARM64](https://mongodb.com/docs/v7.0/administration/production-notes/#std-label-prod-notes-supported-platforms-ARM64) architecture on select platforms.

See [Platform Support](https://mongodb.com/docs/v7.0/administration/production-notes/#std-label-prod-notes-supported-platforms) for more information.

### Production Notes

Before deploying MongoDB in a production environment, consider the [Production Notes for Self-Managed Deployments](https://mongodb.com/docs/v7.0/administration/production-notes/) document which offers performance considerations and configuration recommendations for production MongoDB deployments.

### Official MongoDB Packages

To install MongoDB Community on your Ubuntu system, these instructions will use the official `mongodb-org` package, which is maintained and supported by MongoDB Inc. The official `mongodb-org` package always contains the latest version of MongoDB, and is available from its own dedicated repo.

The `mongodb` package provided by Ubuntu is **not** maintained by MongoDB Inc. and conflicts with the official `mongodb-org` package. If you have already installed the `mongodb` package on your Ubuntu system, you **must** first uninstall the `mongodb` package before proceeding with these instructions.

See [MongoDB Community Edition Packages](https://mongodb.com/docs/v7.0/tutorial/install-mongodb-on-ubuntu/#std-label-ubuntu-package-content) for the complete list of official packages.

<div id="std-label-install-community-ubuntu-pkg"></div>

## Install MongoDB Community Edition

Follow these steps to install MongoDB Community Edition using the `apt` package manager.

### Import the public key.

From a terminal, install `gnupg` and `curl` if they are not already available:

```bash
sudo apt-get install gnupg curl
```

To import the MongoDB public GPG key, run the following command:

```bash
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
```

### Create the list file.

Create the list file `/etc/apt/sources.list.d/mongodb-org-7.0.list` for your version of Ubuntu.

<Tabs>

<Tab name="Ubuntu 22.04 (Jammy)">

Create the list file for Ubuntu 22.04 (Jammy):

```bash
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
```

</Tab>

<Tab name="Ubuntu 20.04 (Focal)">

Create the list file for Ubuntu 20.04 (Focal):

```bash
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
```

</Tab>

</Tabs>

### Reload the package database.

Issue the following command to reload the local package database:

```bash
sudo apt-get update
```

### Install MongoDB Community Server.

You can install either the latest stable version of MongoDB or a specific version of MongoDB.

<Tabs>

<Tab name="Latest Release">

To install the latest stable version, issue the following

```bash
sudo apt-get install -y mongodb-org
```

</Tab>

<Tab name="Specific Release">

To install a specific release, you must specify each component package individually along with the version number.

```sh
sudo apt-get install -y \
   mongodb-org=7.0.22 \
   mongodb-org-database=7.0.22 \
   mongodb-org-server=7.0.22 \
   mongodb-mongosh \
   mongodb-org-shell=7.0.22 \
   mongodb-org-mongos=7.0.22 \
   mongodb-org-tools=7.0.22 \
   mongodb-org-database-tools-extra=7.0.22
```

If you only install `mongodb-org=7.0.22` and do not include the component packages, the latest version of each MongoDB package will be installed regardless of what version you specified.

Optional. Although you can specify any available version of MongoDB, `apt-get` will upgrade the packages when a newer version becomes available. To prevent unintended upgrades, you can pin the package at the currently installed version:

```bash
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections
echo "mongodb-org-database-tools-extra hold" | sudo dpkg --set-selections
```

</Tab>

</Tabs>

For help with troubleshooting errors encountered while installing MongoDB on Ubuntu, see our [troubleshooting](https://mongodb.com/docs/v7.0/reference/installation-ubuntu-community-troubleshooting/#std-label-install-ubuntu-troubleshooting) guide.

## Run MongoDB Community Edition

### ulimit Considerations

Most Unix-like operating systems limit the system resources that a process may use. These limits may negatively impact MongoDB operation, and should be adjusted. See [UNIX `ulimit` Settings for Self-Managed Deployments](https://mongodb.com/docs/v7.0/reference/ulimit/) for the recommended settings for your platform.

If the `ulimit` value for number of open files is under `64000`, MongoDB generates a startup warning.

`mongodb``/var/lib/mongodb`

### Directories

If you installed through the package manager, the data directory `/var/lib/mongodb` and the log directory `/var/log/mongodb` are created during the installation.

By default, MongoDB runs using the `mongodb` user account. If you change the user that runs the MongoDB process, you **must** also modify the permission to the data and log directories to give this user access to these directories.

### Configuration File

The official MongoDB package includes a [configuration file](https://mongodb.com/docs/v7.0/reference/configuration-options/#std-label-conf-file) (/etc/mongod.conf). These settings (such as the data directory and log directory specifications) take effect upon startup. That is, if you change the configuration file while the MongoDB instance is running, you must restart the instance for the changes to take effect.

### Procedure

Follow these steps to run MongoDB Community Edition on your system. These instructions assume that you are using the official `mongodb-org` package -- not the unofficial `mongodb` package provided by Ubuntu --  and are using the default settings.

**Init System**

To run and manage your [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process, you will be using your operating system's built-in [init system](https://mongodb.com/docs/v7.0/reference/glossary/#std-term-init-system). Recent versions of Linux tend to use **systemd** (which uses the `systemctl` command), while older versions of Linux tend to use **System V init** (which uses the `service` command).

If you are unsure which init system your platform uses, run the following command:

```bash
ps --no-headers -o comm 1
```

Then select the appropriate tab below based on the result:

- `systemd` - select the **systemd (systemctl)** tab below.

- `init` - select the **System V Init (service)** tab below.

<Tabs>

<Tab name="systemd (systemctl)">

#### Start MongoDB.

You can start the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process by issuing the following command:

```sh
sudo systemctl start mongod

```

If you receive an error similar to the following when starting [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod):

`Failed to start mongod.service: Unit mongod.service not found.`

Run the following command first:

```sh
sudo systemctl daemon-reload

```

Then run the start command above again.

#### Verify that MongoDB has started successfully.

```sh
sudo systemctl status mongod

```

You can optionally ensure that MongoDB will start following a system reboot by issuing the following command:

```sh
sudo systemctl enable mongod

```

#### Stop MongoDB.

As needed, you can stop the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process by issuing the following command:

```sh
sudo systemctl stop mongod

```

#### Restart MongoDB.

You can restart the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process by issuing the following command:

```sh
sudo systemctl restart mongod

```

You can follow the state of the process for errors or important messages by watching the output in the `/var/log/mongodb/mongod.log` file.

#### Begin using MongoDB.

Start a [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh) session on the same host machine as the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod). You can run [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh) without any command-line options to connect to a [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) that is running on your localhost with default port 27017.

```shell

mongosh

```

For more information on connecting using [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh), such as to connect to a [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) instance running on a different host and/or port, see the [mongosh documentation](https://www.mongodb.com/docs/mongodb-shell/).

To help you start using MongoDB, MongoDB provides [Getting Started Guides](https://mongodb.com/docs/v7.0/tutorial/getting-started/#std-label-getting-started) in various driver editions. For the driver documentation, see [Start Developing with MongoDB](https://api.mongodb.com/).

</Tab>

<Tab name="System V Init (service)">

#### Start MongoDB.

Issue the following command to start [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod):

```sh
sudo service mongod start

```

#### Verify that MongoDB has started successfully

Verify that the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process has started successfully:

```sh
sudo service mongod status

```

You can also check the log file for the current status of the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process, located at: `/var/log/mongodb/mongod.log` by default. A running [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) instance will indicate that it is ready for connections with the following line:

`[initandlisten] waiting for connections on port 27017`

#### Stop MongoDB.

As needed, you can stop the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process by issuing the following command:

```sh
sudo service mongod stop

```

#### Restart MongoDB.

Issue the following command to restart [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod):

```sh
sudo service mongod restart

```

#### Begin using MongoDB.

Start a [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh) session on the same host machine as the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod). You can run [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh) without any command-line options to connect to a [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) that is running on your localhost with default port 27017.

```shell

mongosh

```

For more information on connecting using [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh), such as to connect to a [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) instance running on a different host and/or port, see the [mongosh documentation](https://www.mongodb.com/docs/mongodb-shell/).

To help you start using MongoDB, MongoDB provides [Getting Started Guides](https://mongodb.com/docs/v7.0/tutorial/getting-started/#std-label-getting-started) in various driver editions. For the driver documentation, see [Start Developing with MongoDB](https://api.mongodb.com/).

</Tab>

</Tabs>

## Uninstall MongoDB Community Edition

To completely remove MongoDB from a system, you must remove the MongoDB applications themselves, the configuration files, and any directories containing data and logs. The following section guides you through the necessary steps.

This process will *completely* remove MongoDB, its configuration, and *all* databases. This process is not reversible, so ensure that all of your configuration and data is backed up before proceeding.

### Stop MongoDB.

Stop the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) process by issuing the following command:

```sh
sudo service mongod stop

```

### Remove Packages.

Remove any MongoDB packages that you had previously installed.

```sh
sudo apt-get purge "mongodb-org*"

```

### Remove Data Directories.

Remove MongoDB databases and log files.

```sh
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb

```

## Additional Information

### Localhost Binding by Default

By default, MongoDB launches with [`bindIp`](https://mongodb.com/docs/v7.0/reference/configuration-options/#mongodb-setting-net.bindIp) set to `127.0.0.1`, which binds to the localhost network interface. This means that the `mongod` can only accept connections from clients that are running on the same machine. Remote clients will not be able to connect to the `mongod`, and the `mongod` will not be able to initialize a [replica set](https://mongodb.com/docs/v7.0/reference/glossary/#std-term-replica-set) unless this value is set to a valid network interface which is accessible from the remote clients.

This value can be configured either:

- in the MongoDB configuration file with [`bindIp`](https://mongodb.com/docs/v7.0/reference/configuration-options/#mongodb-setting-net.bindIp), or

- via the command-line argument [`--bind_ip`](https://mongodb.com/docs/v7.0/reference/program/mongod/#std-option-mongod.--bind_ip)

Before you bind your instance to a publicly-accessible IP address, you must secure your cluster from unauthorized access. For a complete list of security recommendations, see [Security Checklist for Self-Managed Deployments](https://mongodb.com/docs/v7.0/administration/security-checklist/#std-label-security-checklist). At minimum, consider [enabling authentication](https://mongodb.com/docs/v7.0/administration/security-checklist/#std-label-checklist-auth) and [hardening network infrastructure](https://mongodb.com/docs/v7.0/core/security-hardening/#std-label-network-config-hardening).

For more information on configuring [`bindIp`](https://mongodb.com/docs/v7.0/reference/configuration-options/#mongodb-setting-net.bindIp), see [IP Binding in Self-Managed Deployments](https://mongodb.com/docs/v7.0/core/security-mongodb-configuration/).

<div id="std-label-ubuntu-package-content"></div>

### MongoDB Community Edition Packages

MongoDB Community Edition is available from its own dedicated repository, and contains the following officially-supported packages:

<table>
<tr>
<th id="Package%20Name">
Package Name

</th>
<th id="Description">
Description

</th>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-org`

</td>
<td headers="Description">
A `metapackage` that automatically installs the component packages listed below.

</td>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-org-database`

</td>
<td headers="Description">
A `metapackage` that automatically installs the component packages listed below.

<table>
<tr>
<th id="Package%20Name">
Package Name

</th>
<th id="Description">
Description

</th>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-org-server`

</td>
<td headers="Description">
Contains the [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) daemon, associated init script, and a [configuration file](https://mongodb.com/docs/v7.0/reference/configuration-options/#std-label-conf-file) (`/etc/mongod.conf`). You can use the initialization script to start [`mongod`](https://mongodb.com/docs/v7.0/reference/program/mongod/#mongodb-binary-bin.mongod) with the configuration file. For details, see the "Run MongoDB Community Edition" section, above.

</td>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-org-mongos`

</td>
<td headers="Description">
Contains the [`mongos`](https://mongodb.com/docs/v7.0/reference/program/mongos/#mongodb-binary-bin.mongos) daemon.

</td>
</tr>
</table>

</td>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-mongosh`

</td>
<td headers="Description">
Contains the MongoDB Shell ([`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh)).

</td>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-org-tools`

</td>
<td headers="Description">
A `metapackage` that automatically installs the component packages listed below:

<table>
<tr>
<th id="Package%20Name">
Package Name

</th>
<th id="Description">
Description

</th>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-database-tools`

</td>
<td headers="Description">
Contains the following MongoDB database tools:

- [`mongodump`](https://www.mongodb.com/docs/database-tools/mongodump/#mongodb-binary-bin.mongodump)

- [`mongorestore`](https://www.mongodb.com/docs/database-tools/mongorestore/#mongodb-binary-bin.mongorestore)

- [`bsondump`](https://www.mongodb.com/docs/database-tools/bsondump/#mongodb-binary-bin.bsondump)

- [`mongoimport`](https://www.mongodb.com/docs/database-tools/mongoimport/#mongodb-binary-bin.mongoimport)

- [`mongoexport`](https://www.mongodb.com/docs/database-tools/mongoexport/#mongodb-binary-bin.mongoexport)

- [`mongostat`](https://www.mongodb.com/docs/database-tools/mongostat/#mongodb-binary-bin.mongostat)

- [`mongotop`](https://www.mongodb.com/docs/database-tools/mongotop/#mongodb-binary-bin.mongotop)

- [`mongofiles`](https://www.mongodb.com/docs/database-tools/mongofiles/#mongodb-binary-bin.mongofiles)

</td>
</tr>
<tr>
<td headers="Package%20Name">
`mongodb-org-database-tools-extra`

</td>
<td headers="Description">
Contains the [`install_compass`](https://mongodb.com/docs/v7.0/reference/program/install_compass/#std-label-install-compass) script

</td>
</tr>
</table>

</td>
</tr>
</table>