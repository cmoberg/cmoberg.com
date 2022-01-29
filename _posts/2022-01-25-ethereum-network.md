---
layout: post
title: "Unto the blockchain"
---

I have found it increasingly hard to avoid spontaneuously forming an opinion on the topic of _web3_. But I also find it hard to find reasonably deep and technical write-ups about the infrastructure underpinning the whole thing, i.e. blockchains to form a more informed opinion.

As with most networked technologies, I assumed blockchains consist of computers running computer programs that accept input and produce output. They have configuration and can tell users what they are doing over time through some logging mechanism. So I planned to pick one, install a node, attach it to the network and observe its behaviour.

> *Please note* that I will not be spending any time explaining fundamental concepts or terminology of the blockchain world. There are many, many, many sources for that.

I wanted to dig deeper into a blockchain technology that supports NFTs, given the crazy amount of noise around them. I ended up picking [Ethereum](https://ethereum.org/), an "L1" blockchain meaning that it is one of the core blockchain technologies currently carrying a substantial part of the transactions and market cap in the cryptocurrency economy. It helped that two of the test networks for Ethereum are named after subway stations (:wave: [Ropsten](https://ropsten.etherscan.io/) and [Rinkeby](https://rinkeby.etherscan.io/)) close to where I grew up in Stockholm, Sweden.

I wanted to run a [full node](https://ethereum.org/en/developers/docs/nodes-and-clients/) as I wanted to host the full blockchain and watch blocks getting processed in real time. I can avoid all the advanced configuration and setup tasks since I don't plan on actually contribute to mining blocks. Mostly because the return of investment on household hardware is absolutely tiny. A back-of-the-envelope calculation based on the current price of electricity here tells me that mining with my son's Nvidia GTX 1050 would actually lose us money. The cost of power here currently exceeds the potential revenue from contributing to block mining with common (gaming) hardware.

There are several implementations of the Ethereum protocol. I picked [Go Ethereum](https://github.com/ethereum/go-ethereum) because I wanted to learn more about Rust and it is trivial to [install on Linux](https://geth.ethereum.org/docs/install-and-build/installing-geth#install-on-ubuntu-via-ppas). I installed it on Ubuntu on an Intel NUC with an i7-10710U CPU with 32 GB RAM and 500 GB SSD disk which is plenty for this setup.

```terminal
$ sudo add-apt-repository -y ppa:ethereum/ethereum
$ sudo apt-get updat
$ sudo apt-get install ethereum
```

- Install geth
- Start geth
- Conclusion

Now I could go learn more about the many things that the log output hints at. Web3 enthusiasts often talk about how blockchains are the fundamental building blocks of the next version of the internet. [DNS node discovery](https://eips.ethereum.org/EIPS/eip-1459)