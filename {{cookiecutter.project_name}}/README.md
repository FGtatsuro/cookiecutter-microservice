{{ cookiecutter.project_name }}
==================================================

[![Build Status](https://travis-ci.org/FGtatsuro/{{ cookiecutter.project_name }}.svg?branch=master)](https://travis-ci.org/FGtatsuro/{{ cookiecutter.project_name }})

{{ cookiecutter.project_description }}

Requirements
------------

The dependencies on other softwares/libraries for this service are as follows.

- Python (2.7.x)
- pip (>= 9.0.x)
- [Ansible](http://docs.ansible.com/ansible/index.html) (>= 2.2.x)
- [Ansible roles](./role_requirements.yml)
- Docker (>= 1.12.x)
- Docker Compose (>= 1.9.x)

For tests/utility tasks, it's better to install following softwares/libraries.

- Ruby (>= 2.2.x)
- Rake (>= 11.3.x)
- Bundler (>= 1.13.x)

And this service also depends on [ansible_utility](https://github.com/FGtatsuro/ansible_utility) module.
In default, we assume that both this service/the module have same parent directory like this:

```bash
$ ls -1 services
...
ansible_utility
{{ cookiecutter.project_name }}
...
```

Please use `utility_module_path` variable(Describe later) on build phase if you want to put `ansible_utility` module to another place.

Build
-----

At first, please install libraries to build this service.

```bash
$ pip install ansible
$ ansible-galaxy install -r role_requirements.yml
```

Before build, We must prepare the inventory including `{{ cookiecutter.project_name }}` group. For example,

```bash
$ cat tests/inventory/docker/hosts
[{{ cookiecutter.project_name }}]
service-{{ cookiecutter.project_name }}         utility_docker_base_image=fgtatsuro/infra-bridgehead:alpine-3.3 utility_docker_commit_image={{ cookiecutter.docker_organization }}/{{ cookiecutter.project_name }}:0.1

[{{ cookiecutter.project_name }}:vars]
ansible_connection=docker
ansible_user=root
utility_docker_image_committed=yes
```

After that, we can build this service as follows.

```bash
$ ansible-playbook provision/main.yml -i tests/inventory/docker/hosts -l {{ cookiecutter.project_name }}
```

### Variables

These are Ansible variables related to build process.
If you want to use not-default values, it's easy to set them via Ansible [--extra-vars](http://docs.ansible.com/ansible/playbooks_variables.html#passing-variables-on-the-command-line) option.

|name|description|default value|
|---|---|---|
|utility_module_path|Path `ansible_utility` module exists. You can use absolute path or relative path from `./provision/main.yml`.|../../ansible_utility|

Config
------

<!-- Section about configs set on build phase -->

Deploy
------

After build, we can start/stop it as follows.

```bash
# You must set specified environment variables before server starts. (Describe later)
# Start
$ (cd deploy/docker/ && docker-compose up -d)

# Stop
$ (cd deploy/docker/ && docker-compose down)
```

And helper tasks are defined to start/stop this service with environment variables.

```bash
# Start
$ bundle exec rake {{ cookiecutter.project_name }}:start

# Stop
$ bundle exec rake {{ cookiecutter.project_name }}:stop
```

### Variables

These are the environment variables to control this service. These must be set before this service starts.

|name|description|example value|
|---|---|---|
||||

Test
----

At first, please install libraries to test this service.

```bash
$ pip install ansible
$ ansible-galaxy install -r role_requirements.yml
$ gem install bundler
$ bundle install --path vendor/bundle
```

After that, please create containers for test, and run tests on them.

```bash
$ ansible-playbook provision/main.yml -i tests/inventory/docker/hosts -l {{ cookiecutter.project_name }}
$ bundle exec rake {{ cookiecutter.project_name }}:spec:all
```

Task
----

As we use tasks to deploy service/run tests, several utility tasks are defined. You can check them with `bundle exec rake -D`.

Note/Limitation
---------------

