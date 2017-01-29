

## How Laminar Works

One goal of Lamianr is to make the underpinning operations transparent enough to be readily hackable. It can be used as a configuration backbone that can be adjusted and augmented as needed.

Another goal is to support graceful scaling by finding components with demonstated ability to scale up while also being able scale down to a single node configuration that provides full operational control to an individual.  This allows for experimentation with less coordination overhead within and across teams.  At the same time, experimental results can be scaled up relatively directly without the need to switch technologies.   SaltStack, Docker and Minikube/Kubernetes scale up and down effectively.  

A third goal is that Laminar promote Immutable Infrastructure principles. There are lucid articles and posts explaining the benefits of immutability in infrastructure.  This [post by BOTCHAGALUPE] [1] and the [referenced paper] [2] docomposed infrastructure management into three categories: divergent, convergent and congruent. Divergent infrastructure management essentially lacks control, convergent is controlled but with some lack of reliability and congruent is strict repeatibility from the same initial state always delivering the same result.  Laminar attempts to pushed repeatibility upstream into the development process itself.  As downloaded, it offers a diluted repeatibility.  That is, not all packages downloaded are strictly versioned violating the *same initial state* requirement for congruence.  This dilution is intended to allow Laminar-the-download to evolve with changing infrastructure, while Laminar in specific use would benefit from tieing down specific component versions. This directly relates to goal #1.

The backbone of Laminar is SaltStack, a configuration management and remote execution engine. As noted, SaltStack offers scaling in both directions.  It can scale up to manage thousands of machines and down to configure a single machine.  Laminar runs Salt as a *masterless minion* taking advantage of Salt's local configuration capabilities without requiring remote execution from the master.  It is worth noting that remote execution could be turned on, opening the opportunity for centralized, normalized administration of developer machines for devops technology.  Salt offers multiple levels of configuration control including a higher level declarative *state* specification of the targeted outcome as well as a more procedural *module* specification.  Largely Laminar adheres to the more declarative *state* specifications.

Laminar Lab currently targets Windows machines, but due the Salt backbone, the operational framework can be extended to other operating systems leveraging Salt's *grain* capabilities that expose the operating context allowing for different specifications for different platforms. Many of the higher level *state* specifications would be platform independent, but the ability to diverge can be explicitly managed.  The Laminar binding to the Windows platform requires some shell scripts.  The same would be true of other platforms, but likely less scripting would be needed as the component technologies leveraged by Laminar are Linux/Unix based.

A diagram depicting Laminar can be seen below.  The blue boxes represent shell scripts and the gray indicate Salt *sls* files. These files can be found in *windows-salt* and *linux-salt* directories within the Laminar directory hierarchy.

![Salt Backbone](images/salt-super-struct.png)

The `laminar` script dispatches the Laminar commands, `bootstrap` performs the preliminary tasks needed to setup Salt to take over, and `saltcall` is a small convenience wrapper around the Salt `salt-call` command.  This wrapper provides configuration information such as the minion configuration and the location of key directories passed through a Salt command line pillar argument.

Both `bootstrap` and `saltcall` can be called directly, though for obvious reasons,  `bootstrap` would not be called frequently.

Since `saltcall` is a wrapper around Salt's [salt-call] [3] command, looking at the Salt doc will allow more nuanced use, but largely the syntax most used is:

```
    saltcall state.apply [sls-filename-w/o-the-type]   
```
E.g. saltcall state.appy laminar-up

The Salt *pillar* argument can be overridden with a syntax that looks like this:

```
  saltcall state.apply my_sls_file pillar='{"hello": "world"}'
```
However, the pillar argument will be completely overridden, so if the called state needs directory information passed, that directory information should be included in the piller dictionary passed.

  [1]: https://theagileadmin.com/tag/immutable-infrastructure/   "Immutable Delivery"
  [2]: http://www.infrastructures.org/papers/turing/turing.html  "Why Order Matters: Turing Equivalence in Automated Systems Administration"
  [3]: https://docs.saltstack.com/en/latest/ref/cli/salt-call.html "Salt-Call Documentation"





[Back to Overview](index.md)
