From: Larry Chen <lchen@suse.com>
Date: Fri, 11 May 2018 15:01:24 +0800
Subject: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
In-Reply-To: <HE1PR0401MB2538AE0195A130AD527C2B31EDBC0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
References: <HE1PR0401MB25389DFE7BFEC86453C3CB21EDBE0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<HE1PR0401MB2538AC4F7C387503A082235FEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<cded7750-a411-3bd8-9728-c86e41d37295@suse.com>
	<HE1PR0401MB2538C6A144D96B2B567B1710EDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<7a6b0949-d564-8443-c232-b3b76c86b193@suse.com>
	<HE1PR0401MB2538E747C7443019BF22F0FCEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<17d70b73-14d9-ea07-229a-89d17c97df88@suse.com>
	<HE1PR0401MB2538950D0996DD98740B5620EDBC0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<8c66f7cd-2de3-ad9e-8ec5-dc6ab934f16a@suse.com>
	<HE1PR0401MB2538AE0195A130AD527C2B31EDBC0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
Message-ID: <dcd88f8c-7f0f-f232-3c3b-19290128be26@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,

On 04/12/2018 08:20 PM, Daniel Sobe wrote:
> Hi Larry,
>
> this is, in a nutshell, what I do to create a LXC container as "ordinary user":
>
> * Install the LXC packages from the distribution
> * run the command "lxc-create -n test1 -t download"
> ** first run might prompt you to generate a ~/.config/lxc/default.conf to define UID mappings
> ** in a corporate environment it might be tricky to set the http_proxy (and maybe even https_proxy) environment variables correctly
> ** once the list of images is shown, select for instance "debian" "jessie" "amd64"
> * the container downloads to ~/.local/share/lxc/
> * adapt the "config" file in that directory to add the shared ocfs2 mount like in my example below
> * if you're lucky, then "lxc-start -d -n test1" already works, which you can confirm by "lxc-ls --fancy", and attach to the container with "lxc-attach -n test1"
> ** if you want to finally enable networking, most distributions arrange a dedicated bridge (lxcbr0) which you can configure similar to my example below
> ** in my case I had to install cgroup related tools and reboot to have all cgroups available, and to allow use of lxcbr0 bridge in /etc/lxc/lxc-usernet
>
> Now if you access the mount-shared OCFS2 file system from with several containers, the bug will (hopefully) trigger on your side as well. I don't know the conditions under which this will occur, unfortunately.
>
> Regards,
>
> Daniel
>
>
> -----Original Message-----
> From: Larry Chen [mailto:lchen at suse.com]
> Sent: Donnerstag, 12. April 2018 11:20
> To: Daniel Sobe <daniel.sobe@nxp.com>
> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>
> Hi Daniel,
>
> Quite an interesting issue.
>
> I'm not familiar with lxc tools, so it may take some time to reproduce it.
>
> Do you have a script to build up your lxc environment?
> Because I want to make sure that my environment is quite the same as yours.
>
> Thanks,
> Larry
>
>
> On 04/12/2018 03:45 PM, Daniel Sobe wrote:
>> Hi Larry,
>>
>> not sure if it helps, the issue wasn't there with Debian 8 and kernel 3.16 - but that's a long history. Unfortunately, the only machine where I could try to bisect, does not run any kernel < 4.16 without other issues ?
>>
>> Regards,
>>
>> Daniel
>>
>>
>> -----Original Message-----
>> From: Larry Chen [mailto:lchen at suse.com]
>> Sent: Donnerstag, 12. April 2018 05:17
>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>
>> Hi Daniel,
>>
>> Thanks for your report.
>> I'll try to reproduce this bug as you did.
>>
>> I'm afraid there may be some bugs on the collaboration of cgroups and ocfs2.
>>
>> Thanks
>> Larry
>>
>>
>> On 04/11/2018 08:24 PM, Daniel Sobe wrote:
>>> Hi Larry,
>>>
>>> below is an example config file like I use it for LXC containers. I followed the instructions (https://urldefense.proofpoint.com/v2/url?u=https-3A__emea01.safelinks.protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Fwiki.debian.org-252FLXC-26data-3D02-257C01-257Cdaniel.sobe-2540nxp.com-257C11fd4f062e694faa287a08d5a023f22b-257C686ea1d3bc2b4c6fa92cd99c5c301635-257C0-257C0-257C636590998614059943-26sdata-3DZSqSTx3Vjxy-252FbfKrXdIVGvUqieRFxVl4FFnr-252FPTGAhc-253D-26reserved-3D0&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=EEKBYUthmGW6dmlK0mKda8ET_52Dw7AzLknUfRWu4CM&s=U_Q9zZpmHwanY55E01YBaTOA5wQC8fsTGebfuh8E3dc&e=) and downloaded a Debian 8 container as user (unprivileged) and adapted the config file. Several of those containers run on one host and share the OCFS2 directory as you can see at the "lxc.mount.entry" line.
>>>
>>> Meanwhile I'm trying whether the problem can be reproduced with shared mounts in one namespace, as you suggested. So far with no success, will report once anything happens.
>>>
>>> Regards,
>>>
>>> Daniel
>>>
>>> ----
>>>
>>> # Distribution configuration
>>> lxc.include = /usr/share/lxc/config/debian.common.conf
>>> lxc.include = /usr/share/lxc/config/debian.userns.conf
>>> lxc.arch = x86_64
>>>
>>> # Container specific configuration
>>> lxc.id_map = u 0 624288 65536
>>> lxc.id_map = g 0 624288 65536
>>>
>>> lxc.utsname = container1
>>> lxc.rootfs = /storage/uvirtuals/unpriv/container1/rootfs
>>>
>>> lxc.network.type = veth
>>> lxc.network.flags = up
>>> lxc.network.link = bridge1
>>> lxc.network.name = eth0
>>> lxc.network.veth.pair = aabbccddeeff
>>> lxc.network.ipv4 = XX.XX.XX.XX/YY
>>> lxc.network.ipv4.gateway = ZZ.ZZ.ZZ.ZZ
>>>
>>> lxc.cgroup.cpuset.cpus = 63-86
>>>
>>> lxc.mount.entry = /storage/ocfs2/sw            sw            none bind 0 0
>>>
>>> lxc.cgroup.memory.limit_in_bytes       = 240G
>>> lxc.cgroup.memory.memsw.limit_in_bytes = 240G
>>>
>>> lxc.include = /usr/share/lxc/config/common.conf.d/00-lxcfs.conf
>>>
>>> ----
>>>
>>>
>>>
>>>
>>> -----Original Message-----
>>> From: Larry Chen [mailto:lchen at suse.com]
>>> Sent: Mittwoch, 11. April 2018 13:31
>>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>
>>>
>>>
>>> On 04/11/2018 07:17 PM, Daniel Sobe wrote:
>>>> Hi Larry,
>>>>
>>>> this is what I was doing. The 2nd node, while being "declared" in the cluster.conf, does not exist yet, and thus everything was happening on one node only.
>>>>
>>>> I do not know in detail how LXC does the mount sharing, but I assume it simply calls "mount --bind /original/mount/point /new/mount/point" in a separate namespace (or, somehow unshares the mount from the original namespace afterwards).
>>> I thought of there is a way to share a directory between host and docker container, like
>>>     ?? docker run -v /host/directory:/container/directory -other -options image_name command_to_run That's different from yours.
>>>
>>> How did you setup your lxc or container?
>>>
>>> If you could, show me the procedure, I'll try to reproduce it.
>>>
>>> And by the way, if you get rid of lxc, and just mount ocfs2 on several different mount point of local host, will the problem recur?
>>>
>>> Regards,
>>> Larry
>>>> Regards,
>>>>
>>>> Daniel
>>>>

Sorry for this delayed reply.

I tried with lxc + ocfs2 in your mount-shared way.

But I can not reproduce your bugs.

What I use is opensuse tumbleweed.

The procedure I try to reproduce your bugs:
0. set-up ha cluster stack and mount ocfs2 fs on host's /mnt with command
 ?? mount /dev/xxx /mnt
 ?? then it shows
 ?? 207 65 254:16 / /mnt rw,relatime shared:94
 ?? I think this *shared* is what you want. And this mount point will be 
shared within multiple namespaces.

1. Start Virtual Machine Manager.
2. add a local LXC connection by clicking File ? Add Connection.
 ?? Select LXC (Linux Containers) as the hypervisor and click Connect.
3. Select the localhost (LXC) connection and click File New Virtual 
Machine menu.
4. Activate Application container and click Forward.
 ?? Set the path to the application to be launched. As an example, the 
field is filled with /bin/sh, which is fine to create a first container. 
Click Forward.
5. Choose the maximum amount of memory and CPUs to allocate to the 
container. Click Forward.
6. Type in a name for the container. This name will be used for all 
virsh commands on the container.
 ?? Click Advanced options. Select the network to connect the container 
to and click Finish. The container will be created and started. A 
console will be opened automatically.

If possible, could you please provide a shell script to show what you 
did with you mount point.

Thanks
Larry
