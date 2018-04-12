From: Larry Chen <lchen@suse.com>
Date: Thu, 12 Apr 2018 11:17:18 +0800
Subject: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
In-Reply-To: <HE1PR0401MB2538E747C7443019BF22F0FCEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
References: <HE1PR0401MB25389DFE7BFEC86453C3CB21EDBE0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<HE1PR0401MB2538AC4F7C387503A082235FEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<cded7750-a411-3bd8-9728-c86e41d37295@suse.com>
	<HE1PR0401MB2538C6A144D96B2B567B1710EDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<7a6b0949-d564-8443-c232-b3b76c86b193@suse.com>
	<HE1PR0401MB2538E747C7443019BF22F0FCEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
Message-ID: <17d70b73-14d9-ea07-229a-89d17c97df88@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,

Thanks for your report.
I'll try to reproduce this bug as you did.

I'm afraid there may be some bugs on the collaboration of cgroups and ocfs2.

Thanks
Larry


On 04/11/2018 08:24 PM, Daniel Sobe wrote:
> Hi Larry,
>
> below is an example config file like I use it for LXC containers. I followed the instructions (https://urldefense.proofpoint.com/v2/url?u=https-3A__wiki.debian.org_LXC&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=g0D3je5kgCEJiDPFKQ1Yw-c8S8eNY8KJhFC8PNVcGZM&s=k1_NjIjuXW6KE2FAAuAd77CTAy09r-nVBvnfMYcsAEw&e=) and downloaded a Debian 8 container as user (unprivileged) and adapted the config file. Several of those containers run on one host and share the OCFS2 directory as you can see at the "lxc.mount.entry" line.
>
> Meanwhile I'm trying whether the problem can be reproduced with shared mounts in one namespace, as you suggested. So far with no success, will report once anything happens.
>
> Regards,
>
> Daniel
>
> ----
>
> # Distribution configuration
> lxc.include = /usr/share/lxc/config/debian.common.conf
> lxc.include = /usr/share/lxc/config/debian.userns.conf
> lxc.arch = x86_64
>
> # Container specific configuration
> lxc.id_map = u 0 624288 65536
> lxc.id_map = g 0 624288 65536
>
> lxc.utsname = container1
> lxc.rootfs = /storage/uvirtuals/unpriv/container1/rootfs
>
> lxc.network.type = veth
> lxc.network.flags = up
> lxc.network.link = bridge1
> lxc.network.name = eth0
> lxc.network.veth.pair = aabbccddeeff
> lxc.network.ipv4 = XX.XX.XX.XX/YY
> lxc.network.ipv4.gateway = ZZ.ZZ.ZZ.ZZ
>
> lxc.cgroup.cpuset.cpus = 63-86
>
> lxc.mount.entry = /storage/ocfs2/sw            sw            none bind 0 0
>
> lxc.cgroup.memory.limit_in_bytes       = 240G
> lxc.cgroup.memory.memsw.limit_in_bytes = 240G
>
> lxc.include = /usr/share/lxc/config/common.conf.d/00-lxcfs.conf
>
> ----
>
>
>
>
> -----Original Message-----
> From: Larry Chen [mailto:lchen at suse.com]
> Sent: Mittwoch, 11. April 2018 13:31
> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>
>
>
> On 04/11/2018 07:17 PM, Daniel Sobe wrote:
>> Hi Larry,
>>
>> this is what I was doing. The 2nd node, while being "declared" in the cluster.conf, does not exist yet, and thus everything was happening on one node only.
>>
>> I do not know in detail how LXC does the mount sharing, but I assume it simply calls "mount --bind /original/mount/point /new/mount/point" in a separate namespace (or, somehow unshares the mount from the original namespace afterwards).
> I thought of there is a way to share a directory between host and docker container, like
>   ?? docker run -v /host/directory:/container/directory -other -options image_name command_to_run That's different from yours.
>
> How did you setup your lxc or container?
>
> If you could, show me the procedure, I'll try to reproduce it.
>
> And by the way, if you get rid of lxc, and just mount ocfs2 on several different mount point of local host, will the problem recur?
>
> Regards,
> Larry
>> Regards,
>>
>> Daniel
>>
