From: =?UTF-8?Q?BASSAGET_C=C3=A9dric?= <cedric.bassaget.ml@gmail.com>
Date: Wed, 29 Nov 2017 08:28:25 +0100
Subject: [Ocfs2-devel] OCFS2 cluster debian8 / debian9
In-Reply-To: <4a391e51-72d9-461f-a838-f380ba9616d8@suse.com>
References: <CAN+OZjS0Rd71QNg6abJ1o_4Jp+P2oNg1duCdXiEZPEsObH5dUQ@mail.gmail.com>
	<534b1978-775f-a60a-a370-8f0b88631e6c@suse.com>
	<CAN+OZjR0XU8VBmYSrSZShHS6tJ5n5ZUvXYT552T_fEeahstgpQ@mail.gmail.com>
	<CAN+OZjTSdz2FgFCSDSKpW4bc5VD7GME=o6mWAgT4QyY4_G+05Q@mail.gmail.com>
	<4a391e51-72d9-461f-a838-f380ba9616d8@suse.com>
Message-ID: <CAN+OZjRCND5M1S+UZDaWR+um2-99E60nijYO=Sobxa0LQbMCpA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,
I guess I did something wrong the first time.
I retried three times, and it worked three times. So I guess ocfs 1.6 and
1.8 are compatibles :)

Not it's time to set up a second ocfs2 cluster on my debian 9 server (ocfs
1.8), and I get this error when trying to mkfs.ocfs2 :

root at LAB-virtm6:~# mkfs.ocfs2 /dev/mapper/data_san_2
mkfs.ocfs2 1.8.4
On disk cluster (o2cb,ocfs2new,0) does not match the active cluster
(o2cb,ocfs2,0).
mkfs.ocfs2 will not be able to determine if this operation can be done
safely.
To skip this check, use --force or -F


The running cluster on this host is :
root at LAB-virtm6:~# o2cluster -r
o2cb,ocfs2,local

I'm trying to add an "ocfs2new" cluster :
root at LAB-virtm6:~# o2cb add-cluster ocfs2new
root at LAB-virtm6:~# o2cb add-node --ip 192.168.0.12 --port 7777 --number 1
ovfs2new LAB-virtm6
root at LAB-virtm6:~# o2cb add-node --ip 192.168.0.13 --port 7777 --number 2
ovfs2new LAB-virtm7

root at LAB-virtm6:~# o2cb list-clusters
ocfs2
ocfs2new

root at LAB-virtm6:~# o2cb cluster-status
Cluster 'ocfs2' is online

Even if I restart services or reboot, cluster 'ocfs2new' never goes online.

What am I doing wrong ?

2017-11-24 3:30 GMT+01:00 Eric Ren <zren@suse.com>:

> Hi,
>
> On 11/23/2017 09:42 PM, BASSAGET C?dric wrote:
>
> Tried to mkfs.ocfs2 on the debian 9 side (ocfs 1.8) :
>
> root at LAB-virtm6:~# o2cluster -o /dev/mapper/data_san_2
> o2cb,ocfs2new,local
>
>
> Sorry, my fault. For mount failure, first thing is to check if your o2cb
> stack
> is running via o2cb init service `rco2cb status` IIRC. Then, it's probably
> a compatible issue: see the "FEATURE FLAGS" section in `man ocfs2`
> for more instructions.
>
>
> root at LAB-virtm6:~# mount /dev/mapper/data_san_2 /mnt/vol1_iscsi_san2
> *mount.ocfs2: Cluster name is invalid while trying to join the group*
>
>
> Quote from `man ocfs2`:
> """
> DETECTING FEATURE INCOMPATIBILITY
>
>               Say one tries to mount a volume with an incompatible
> feature. What happens then? How does
>               one detect the problem? How does one know the name of that
> incompatible feature?
>
>               To begin with, one should look for error messages in
> dmesg(8). Mount  failures  that  are
>               due to an incompatible feature will always result in an
> error message like the following:
>
>               ERROR: couldn't mount because of unsupported optional
> features (200).
>
>               Here  the  file  system is unable to mount the volume due to
> an unsupported optional fea-
>               ture. That means that that feature is an Incompat feature.
> By  referring  to  the  table
>               above,  one can then deduce that the user failed to mount a
> volume with the xattr feature
>               enabled. (The value in the error message is in hexadecimal.)
> """
>
> Please show your dmesg.
>
> Eric
>
>
> root at LAB-virtm6:~# cat /etc/ocfs2/cluster.conf
> node:
>         ip_port = 7777
>         ip_address = 192.168.0.11
>         number = 1
>         name = LAB-virtm5
>         cluster = ocfs2new
> node:
>         ip_port = 7777
>         ip_address = 192.168.0.12
>         number = 2
>         name = LAB-virtm6
>         cluster = ocfs2new
> node:
>         ip_port = 7777
>         ip_address = 192.168.0.13
>         number = 3
>         name = LAB-virtm7
>         cluster = ocfs2new
> cluster:
>         node_count = 5
>         name = ocfs2new
>
>
>
>
> 2017-11-23 14:02 GMT+01:00 BASSAGET C?dric <cedric.bassaget.ml@gmail.com>:
>
>> Hi Eric
>> on debian 9 (ocfs2 v1.8) :
>>
>> # o2cluster -o /dev/mapper/data_san_2
>> default
>>
>> on debian 8 (ocfs2 v1.6), I don't have the "o2cluster" tool
>>
>> :(
>>
>>
>>
>> 2017-11-23 13:41 GMT+01:00 Eric Ren <zren@suse.com>:
>>
>>> Hi,
>>>
>>> On 11/23/2017 06:23 PM, BASSAGET C?dric wrote:
>>>
>>> hello,
>>> I'm trying to set-up an OCFS2 cluster between hosts running debian8 and
>>> debian9
>>>
>>> 2*debian 8 : ocfs2-tools 1.6.4-3
>>> 1*debian 9 : ocfs2-tools 1.8.4-4
>>>
>>> I created the FS on debian 8 node :
>>>  mkfs.ocfs2 -L "ocfs2_new" -N 5 /dev/mapper/data_san_2
>>>
>>> then mounted it without problem
>>> mount /dev/mapper/data_san_2 /mnt/vol1_iscsi_san2/
>>>
>>> I mounted it on second debian 8 host too, without problem.
>>>
>>> Trying to mount in on debian9 returns :
>>> mount.ocfs2: Cluster name is invalid while trying to join the group
>>>
>>> I saw in "man mkfs.ocfs2" that debian9 version has --cluster-stack and
>>> --cluster-name options.
>>>
>>> Is this option mandatory on ocfs2 1.8 ? That would say that ocfs2 1.6
>>> and 1.8 are not compatible ? Nothing is said about 1.8 on
>>> https://oss.oracle.com/projects/ocfs2/'re
>>> <https://oss.oracle.com/projects/ocfs2/>
>>>
>>>
>>> Not sure if they're compatible. So can you try again with
>>> --cluster-stack and --cluster-name?
>>>
>>> # o2cluster -o /dev/sda1
>>> pcmk,cluster,none
>>>
>>> pcmk is the cluster-stack, cluster is the name.
>>>
>>> Usually, these two option is optional, the tools will detect the right
>>> cluster stack automatically.
>>>
>>> Eric
>>>
>>
>>
>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171129/122373dc/attachment.html 
