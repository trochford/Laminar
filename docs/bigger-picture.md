

## Web Scale Infrastructure and B2B ISVs

### Summary

Web scale ISVs (upper right quadrant) are the providers of Web platform services with millions of users. They might be search engines, retailers, B2B marketplaces, social media or other online services.  Because of their vast scale, these organizations are compelled to deal with operational issues such as ensuring their service is available when some fraction of their server inventory goes down on a daily basis, or managing deployment process across thousands of machines efficiently and reliably. They operate at the level of scale where such daily operational challenges must be addressed in a predictable and efficient way.  To meet these challenges, Web scale ISVs make infrastructure investments and produce innovations not required of smaller Web platforms.

![Market breakdown by User Scale and Business Model](images/markets.png)

Mid scale B2B ISVs (lower left quadrant) with smaller user bases may not be able to justify the creation of such Web-scale infrastructure, but they *can* justify the use of it, though with a different balance of benefits than B2C Web-scale ISVs.  Collateral benefits stemming from addressing Web-scale challenges are applicable to problems faced by B2B ISVs. But their challenges are:

1. Climbing the learning curve on the use of Web scale infrastructure,

2. Internalizing the organizational mind-shift required,

3. And prioritizing its benefits in the context of business needs that differ from Web scale ISVs.

A low overhead, fast path to getting hands-on experience with these infrastructure building blocks can help technology teams meet those challenges. Rapid experimentation into new ways of packaging, deploying and managing the ISV's software builds grounded confidence and insight into what new team practices will be needed.

Laminar can provide that path.


### Infrastructure Innovation & Adoption Drivers and Challenges

[Web scale ISVs] [5] have been refining their technology infrastructure for about 20 years now, and at this point, some scale to the order of a million servers to deliver their online services. This is part of the well known, long term trend of consumer markets superseding businesses as the driver of tech innovation. The "curves crossed" around the late nineties-[2000] [6] about the time Web growth was dramatically accelerating through the low 100's of millions of users opening the opportunity for new kinds of businesses to reach millions of consumers.

Consumer Web Scale [CWS] ISVs have been creatively using a variety of economic models, including both commercial and open source, to provide their infrastructure innovations to the Web platform market. Defraying their infrastructure costs across a base wider than their business provides a competitive advantage. B2B ISVs in the mid-scale make up a bigger fraction of the [ISV industry] [12] by count.  Both CWS ISVs and mid-scale B2B ISVs benefit if Web scale infrastructure can be adopted productively by mid-scale ISVs. So what is the incentives B2b ISVs to adopt, and what are the challenges?

Throughout the economy, competitive forces are driving businesses to take on more of their customers' operational costs and risk. Examples include [fulfillment in retailing] [11], [payment models in healthcare] [10] and [ISV SaaS or Cloud models] [13]. These relentless forces require B2B ISVs to rethink their business models and figure out how to transition to new target models while not undermining their businesses.

Notably the business models for B2B ISVs can be quite different from those of CWS ISVs.  Differences include:

* Revenue models
* Pricing
* Channels and sales cycles
* Market power relative to their customers
* Customer switching costs
* Regulations
* Customer planning horizons
* The need for organizational vs individual changes of behavior, including some stakeholders who stand to lose
* Potentially deeper integration needs
* Deeper backward compatibility needs
* Negotiated SLAs
* Business continuity models

The list goes on. B2B ISVs can be grouped based on their "deployment heritage" - i.e. where and how the ISVs software has actually been deployed.  Has the software been deployed on-premise, in a hosting facility, and/or a public cloud? The combinations result in more than three groups, some ISV software can deployed only one of the three ways, while others may have all three kinds of deployment.  

Business model and heritage affect the consideration of how to make best use of Web scale infrastructure sourced (often) from CWS ISVs who have different business models, deployment heritages and organizational priorities.  An ISV with only on-premise or hosted deployments has more to think through, including figuring out which public Cloud services to leverage (or not) or what component technologies to use, but often there are more rudimentary considerations - what do I have to do to move my application to a cloud form - [is it a good fit?] [7]  Assuming the application can be made [cloud ready] [8], another wave of questions about the new target model arises:

* How does my organization need to change?
* What kinds of skills will more organization need?
* What delineation of responsibilities is needed and how to coordinate between them?
* *How deep to these changes need to be?*

That last question is contextual, i.e. it depends on the ISV's organization and business situation, but it is the more revealing question. It asks at what level will we need to re-optimize? Will changes be to individuals, teams, groups, or the full organization?  Is the organization's whole mission changing or just some objectives or goals?

Let's take an example based of an ISV who deploys their product in a hosting facility. The development and QA teams employ an agile process to build the product and vet it is ready for production.  It is then handed off to be deployed in production where access is limited to the IT Operations team. The product is accompanied by release notes and some scripts used by development for staging deployment. Assuming development followed good continuous delivery principles with code binaries separated from configuration, configurations well managed under source control, etc., there still remains coordination challenges needing to be addressed.

There are multiple disciplines required to make a successful deployment from a customer's perspective - that is a healthy deployment with no downtime. Development and IT Operations have different expertise and priorities, the way in which they work together is critical to success.

* Does the operations team have to reverse engineer the product to make it run in the production environment?
* How good a facsimile of production is production-staging environment?
* How does development gain insight into the work of operations and vise versa?
* Who provided the criteria used to decide what deployment packaging to use? Development? QA? Operation?
* Is there a way to better project operational constraints and realities upstream into development?
* Is there a better way to project the dynamics of product change downstream into operations?

As the B2B ISVs takes on more operational responsibilities, the multiple disciplines challenge arises regardless of deployment model. Whether hosted, on-premise or cloud, the manner in which teams work together in meeting those operational responsibilities is critical.

### Rethinking from an Interdisciplinary Perspective

Accommodating  operational expense and risk on behalf of your customers will  have an impact on the ISV's mission and business model.  As the business model is affected, the impact is felt widely - marketing, sales, engineering and services all need adjustments. And those groups may have to work together in unprecedented ways.  The key intersection of groups to  leverage Web-scale infrastructure in the business model transition is that of engineering, QA and operations. This is the arena of [DevOps] [14]. Engineering and QA had already been transforming with agile practices.  DevOps extends that transformation to include operations. Optimally those three groups are able to work together as an interdisciplinary team combining their different kinds of expertise to set new goals, establish new metrics and refine new practices.

Large, messy, complex endeavors such as in [healthcare] [15] or [military missions] [3] have used interdisciplinary teams to be able to adapt to changing conditions that overwhelm initial planning. Operationalizing software is such a complex endeavor. Here is a summary of some guiding principles cited by Randy Cadieux in his insightful article relating DevOps teams and combat flight crews (worth a read):


1. Wipe out the zero defect mentality with regard to human performance.
2. Acknowledge the reality that there is a gap between Work-As-Designed and Work-As-Performed.
3. Understand that human error and blaming people for problems doesn’t fix system problems.
4. Don’t base success simply on outcomes because the end doesn't necessarily justify the means.
5. Acknowledge the need for adaptability and adaptive capacity.
6. Break down the authority gradient between ranks or positions for open communications to speed up execution and foster a bias for action.
7. Build a shared understanding of each team member’s work, so that team members can understand the immediate impact of decisions and cascading impacts across the team.

These guidelines do not suggest a set of experts operating independently.  Rather they suggest group of individuals establishing a new governing set of shared values so they can work interdependently in an effective way. The individuals in this group work to have a broader perspective than their own expertise. To this end, they need a way to explore and experience the work their teammates do.

### Building Blocks for the Transition

In addition to the need for interdisciplinary teamwork in DevOps, there is also a need for clean coordination and clear contracts between the groups. At the software packaging level, [containers] [17] such as [Docker] [16] can serve as such a contract between groups. For those unfamiliar, a container can be thought of as a light weight virtual machine that has a much smaller footprint and initiates much faster. The trade-off is that the container cannot host a guest operating system. All containers on a host use the host's operating system. In practice for the CWS ISVs, the container trade-off relative to virtual machines has been an effective one. Containers have become a primary building block of Web-scale infrastructure. The adoption rate for containers is picking up more broadly, Docker in particular.  

Where are we in the transition to the use of containers? Here are a couple of data points:


- [Datadog June 2016 survey] [1]
  - As of June 2016, Docker runs on 10% of the hosts Datadog monitors.
  - Larger companies are leading adoption. This is thought to be driven by the larger volume of servers that larger companies will employ.
- [RightScale May 2016 survey] [2.5]
  - Enterprises are using containers more than SMBs. 29 percent of enterprises have workloads running in containers versus 24 percent of SMBs, and 41 percent of enterprises are experimenting as compared to 33 percent of SMBs.
  - Evaluating Docker adoption across different geographies, industries, and roles, RightScale found that current use of Docker is heaviest among tech organizations (32 percent), enterprises (29 percent), and developers (28 percent).
  - For respondents who are not currently using containers, lack of experience was by far the top challenge (39 percent).
  - The top container initiative in 2016 will be getting more educated (62 percent), followed by conducting more experiments with containers in dev/test (44 percent) and production (28 percent), as well as expanding container use in dev/test (28 percent)

Though it is difficult to map these statistics directly to the B2B ISV population, it would appear that containers are moving from early to mainstream production adoption.  And gaining experience with containers is key to further adoption.

And beyond container's packaging capabilities is the ability to manage clusters of containers. Container cluster managers are additional Web-scale infrastructure components providing Web scale-out capabilities, but they also address reliability and resilience needs - both germane to B2B ISVs.  One such manager is Kubernetes which has been open sourced by Google.  A summary description from Kubernetes:

[Kubernetes] [9] satisfies a number of common needs of applications running in production, such as:

* co-locating helper processes,
* facilitating composite applications
* preserving the one-application-per-container model,
* mounting storage systems,
* distributing secrets,
* application health checking,
* replicating application instances,
* horizontal auto-scaling,
* naming and discovery,
* load balancing,
* rolling updates,
* resource monitoring,
* log access and ingestion,
* support for introspection and debugging, and
* identity and authorization.

Kubernetes builds on top of containers such as Docker and was designed to address issues that arise most dramatically at Web-scale level deployments - issues such as server and component failure.  At Web-scale, such failures are a daily event.  CWS ISVs had to tackle recovery and resilience issues head on and so built in redundancy and health-check mechanisms into their cluster management. They also had to deal with large scale, new version application rollouts and the need to be able to rollback with no downtime in the event something went wrong.  However, B2B ISVs would benefit from these capabilities even though they are not operating at Web-scale.

Combining these technologies with [Immutable Infrastructure] [18] practices, which extend [Continuous Delivery] [19] principles, presents to B2B ISVs the opportunity to have a more robust and reliable experience both for their teams internally and for their customers. Key to this combination of technology and practice is having the safety net to rollback system upgrades rapidly and reliably without having to take the system down.  A change in delivery mind-set is required to gain this benefit. The technology is an enabler, achieving the benefit is up to the DevOps team.

A further benefit of adopting containers for the B2B ISV is the ability to more rapidly assimilate new technologies as they become available.  Many new technologies that may be relevant to the B2B ISV are now delivered in container form, e.g. machine learning, NLP, big data, blockchain, etc. These technologies are often constructed as multiple services needing to work together.  Orchestrated containers are a very good form factor for such delivery. Competence in this kind of packaging increases the organizations ability to explore and absorb new technologies that can extend the B2B ISV's value proposition.



**In theory there is no difference between practice and theory, in practice there is.**

But the price is the investment of having members of the interdisciplinary DevOps team gain experience with these Infrastructure building blocks.  The team has to be provided the *adaptive capacity*, to borrow from Cadieux's phrasing, to explore how to exploit the technologies to the benefit of the B2B ISV. Hands-on experience is needed to work through the hard realities of making system change, deployment and management a predictable, efficient and largely automate process.

There are many excellent "how to" articles on working with containers and cluster managers. But most DevOps practitioners have constraints on the time-slice they can allocate to experimentation.  Replicating an article's recipes requires setup time. And multiple articles require multiple setups.  The demand of setup time is especially true in the Windows environment as many of these tools have a Unix, if not more specifically Linux, orientation. Streamlining the DevOps learning process by reducing redundant setup effort and drawing conclusions from one consistent baseline would expedite getting to well grounded, practical new practices.   

Ideally one automated setup yielding a replicable, scaled-down version of the technologies, in a effect a lab, where the tools are available, live and ready to work together would help enable useful experiments to happen and shorten the time to insight into the needed new practices.

Laminar Lab makes available a replicable, scaled down version of these  technologies.  It is open source, downloadable from Github, easy to try out, and repeatable. A link to an overview is available below.  A lab addresses only one factor in the multiple needed to manage through the evolution of the B2B ISV model, but its simplicity eases exploration and experimentation and hopefully accelerates the learning needed to build out new practices to support the new operational responsibilities.

[An Overview of Laminar Lab](index.md)


  [1]: https://www.datadoghq.com/docker-adoption/   "Datadog 06/2016 Survey Article"
  [2]: http://www.rightscale.com/blog/cloud-industry-insights/cloud-computing-trends-2016-state-cloud-survey#security  "Cloud Computing Trends: 2016 State of the Cloud Survey"
  [2.5]: http://www.rightscale.com/blog/cloud-industry-insights/new-devops-trends-2016-state-cloud-survey "New DevOps Trends: 2016 State of the Cloud Survey - May 2016"
  [3]: http://www.v-speedsafety.com/blog/2016/9/7/devops-teams-and-combat-flight-crews-an-interdisciplinary-approach-to-learning-and-improvement "DevOps Teams and Combat Flight Crews-An Interdisciplinary Approach to Learning and Improvement"
  [4]: https://pdfs.semanticscholar.org/9fe2/1a478bda61908d3d506fd994ad3ac307618b.pdf "Sources of Failure in the Public Switched Telephone Network"
  [5]: http://expandedramblings.com/index.php/resource-how-many-people-use-the-top-social-media/ "Web Scale Companies"
  [6]: http://www.nytimes.com/2001/06/21/business/technology-computer-gains-driven-by-consumer-products.html "Long trend of consumer driven technology"
  [7]: http://learn.cloudvelox.com/h/i/290603118-selecting-applications-bad-candidates-for-cloud-migration-ten-factors-4 "Bad Candidates for Cloud Migration"
  [8]: https://12factor.net/ "The Twelve-Factor App"
  [9]: https://kubernetes.io/docs/whatisk8s/ "What is Kubernetes?"
  [10]: https://www.acponline.org/about-acp/about-internal-medicine/career-paths/residency-career-counseling/guidance/understanding-capitation "Understanding Capitation"
  [11]: http://www.mwpvl.com/html/internet_retail_distribution_challenges.html "Internet Retailers: Challenges in Order Fullfillment and Distribution Operations"
  [12]: http://www.isvworld.com/ "ISVWorld: The software industry database"
  [13]: http://www.davidchappell.com/writing/white_papers/How_SaaS_Changes_an_ISVs_Business--Chappell_v1.0.pdf "How SaaS Changes and ISVs Business"
  [14]: https://en.wikipedia.org/wiki/DevOps "DevOps"
  [15]: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3662612/table/T5/ "Characteristics of a good interdisciplinary team"
  [16]: https://www.docker.com/what-docker "What is Docker?"
  [17]: https://en.wikipedia.org/wiki/Operating-system-level_virtualization "Container Virtualization"
  [18]: http://thenewstack.io/a-brief-look-at-immutable-infrastructure-and-why-it-is-such-a-quest/ "A Brief Look at Immutable Infrastructure and Why it is Such a Quest"
  [19]: https://continuousdelivery.com/ "What is Continuous Delivery?"
