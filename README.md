# Potential and Pitfalls of Multi-Armed Bandits for Decentralized Spatial Reuse in WLANs
### Authors
* [Francesc Wilhelmi](https://fwilhelmi.github.io/)
* [Sergio Barrachina-Muñoz](https://github.com/sergiobarra)
* [Boris Bellalta](http://www.dtic.upf.edu/~bbellalt/)
* [Cristina Cano](http://ccanobs.github.io/)
* [Anders Jonsson](http://www.tecn.upf.es/~jonsson/)
* [Gergely Neu](http://cs.bme.hu/~gergo/)

### Project description
Spatial Reuse (SR) has recently gained attention for performance maximization in IEEE 802.11 Wireless Local Area Networks (WLANs). Decentralized mechanisms are expected to be key in the development of SR solutions for next-generation WLANs, since many deployments are characterized by being uncoordinated by nature. However, the potential of decentralized mechanisms is limited by the significant lack of knowledge with respect to the overall wireless environment. To shed some light on this subject, we show the main considerations and possibilities of applying online learning to address the SR problem in uncoordinated WLANs. In particular, we provide a solution based on Multi-Armed Bandits (MABs) whereby independent WLANs dynamically adjust their frequency channel, transmit power and sensitivity threshold. To that purpose, we provide two different strategies, which refer to selfish and environment-aware learning. While the former stands for pure individual behavior, the second one aims to consider the performance experienced by surrounding networks, thus taking into account the impact of individual actions on the environment. Through these two strategies we delve into practical issues of applying MABs in wireless networks, such as convergence guarantees or adversarial effects. Our simulation results illustrate the potential of the proposed solutions for enabling SR in future WLANs, showing that substantial improvements on network performance can be achieved regarding throughput and fairness.
### Repository description
This repository contains the Code and the LaTeX files used for the journal article "Potential and Pitfalls of Multi-Armed Bandits for Decentralized Spatial Reuse in WLANs", which has been sent to "Journal of Network and Computer Applications".

The results obtained from this work can be found in [zenodo link to be inserted here]

### Running instructions
To run the code, just

1. "add to path" all the folders and subfolders in "./Code",
2. Access to "Code" folder
3. Execute scripts in folder "./Code/Experiments/". Inside the Experiments folder, there are several subfolders containing the different simulation scripts, belonging to different results shown along the paper.

Additional notes:

1. The "configuration_system.m" file contains the information regarding the simulation parameters (e.g., floor noise, allowed transmit power levels, etc.).
2. The "configuration_agents.m" file contains the information regarding the operation on intelligent agents. 
3. "constants_sfctmn_framework.m" and "constants_thompson_sampling.m" contain constants for the proper operation of the code.
4. The experiments output can be found in the "./Code/Output/" folder, in which we store figures and the workspaces.

### Contribute

If you want to contribute, please contact to [francisco.wilhelmi@upf.edu](francisco.wilhelmi@upf.edu)