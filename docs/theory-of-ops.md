

## How Laminar Works

One goal of Lamianr is to make the underpinning operations transparent enough to be readily hackable. It can be used as a configuration backbone that can be adjusted and augmented as needed.

Another goal is to support graceful scaling by finding components with demonstated abiliity to scale up while also being able scale down to a single node configuration that provides full operational control to an individual.  This allows for experimentation with less coordination overhead within and across teams.  At the same time, experimental results can be scaled up relatively directly without the need to switch technologies.   SaltStack, Docker and Minikube/Kubernetes scale up and down effectively.  

The backbone of Laminar is SaltStack, a configuration management and remote execution engine. As noted, SaltStack offers scaling in both directions.  It can scale up to manage thousands of machines and down to configure a single machine.  Laminar runs Salt as a *masterless minion* taking advantage of Salt's local configuration capabilities without requiring remote execution from the master.  It is worth noting that remote execution could be turned on, opening the opportunity for centralized, normalized administration of developer machines for devops technology.  Salt offers multiple levels of configuration control including a higher level declarative *state* specification of the targeted outcome as well as a more procedural *module* specification.  Largely Laminar adheres to the more declarative *state* specifications.

Laminar Lab currently targets Windows machines, but due the Salt backbone, the operational framework can be extended to other operating systems leveraging Salt's *grain* capabilities that expose the operating context allowing for different specifications for differnt platforms. Many of the higher level *state* specifications would be platform independent, but the ability to diverge can be explicitly managed.  The Laminar binding to the Windows platform requires some shell scripts.  The same would be true of other platforms, but likely less scripting would be needed as the component technologies leveraged by Laminar are Linux/Unix based.






![Salt Backbone](images/salt-super-struct.png)


[Back to Overview](index.md)
