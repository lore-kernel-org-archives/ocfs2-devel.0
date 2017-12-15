From: Eric Ren <zren@suse.com>
Date: Fri, 15 Dec 2017 15:03:45 +0800
Subject: [Ocfs2-devel] OCFS2 cluster debian8 / debian9
In-Reply-To: <CAN+OZjR1x_Xyq9uK2siu+qMJBdDy4G2xG1etPrGyYzgLeKKW1w@mail.gmail.com>
References: <CAN+OZjS0Rd71QNg6abJ1o_4Jp+P2oNg1duCdXiEZPEsObH5dUQ@mail.gmail.com>
	<534b1978-775f-a60a-a370-8f0b88631e6c@suse.com>
	<CAN+OZjR0XU8VBmYSrSZShHS6tJ5n5ZUvXYT552T_fEeahstgpQ@mail.gmail.com>
	<CAN+OZjTSdz2FgFCSDSKpW4bc5VD7GME=o6mWAgT4QyY4_G+05Q@mail.gmail.com>
	<4a391e51-72d9-461f-a838-f380ba9616d8@suse.com>
	<CAN+OZjRCND5M1S+UZDaWR+um2-99E60nijYO=Sobxa0LQbMCpA@mail.gmail.com>
	<CAN+OZjR1x_Xyq9uK2siu+qMJBdDy4G2xG1etPrGyYzgLeKKW1w@mail.gmail.com>
Message-ID: <37437018-4f35-e936-1a36-7a2ac55236c0@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,


On 12/05/2017 11:19 PM, BASSAGET C?dric wrote:
> Hello
> Retried from scratch; and still have an error when trying to bring up 
> the second cluster :
>
> root at LAB-virtm6:/# o2cb register-cluster ocfs2new
> o2cb: Internal logic failure while registering cluster 'ocfs2new'
>
> root at LAB-virtm6:/mnt/vol1_iscsi_san1# o2cb list-clusters
> ocfs2
> ocfs2new
>
> Can anybody help me please ?

I don't know if o2cb stack can have multiple clusters on the same node. 
With pacemaker
stack, once we setup a pacemaker cluster stack, we can have multiple 
ocfs2 instance, i.e
mkfs and mount multiple ocfs2 FS on the same node.

Why do you want to setup multiple o2cb cluster on the same node?? I 
never know this need
of usage so far :)

Maybe, others can help on your question.

Thanks,
Eric

>
>
> 2017-11-29 8:28 GMT+01:00 BASSAGET C?dric 
> <cedric.bassaget.ml at gmail.com <mailto:cedric.bassaget.ml@gmail.com>>:
>
>     Hello,
>     I guess I did something wrong the first time.
>     I retried three times, and it worked three times. So I guess ocfs
>     1.6 and 1.8 are compatibles :)
>
>     Not it's time to set up a second ocfs2 cluster on my debian 9
>     server (ocfs 1.8), and I get this error when trying to mkfs.ocfs2 :
>
>     root at LAB-virtm6:~# mkfs.ocfs2 /dev/mapper/data_san_2
>     mkfs.ocfs2 1.8.4
>     On disk cluster (o2cb,ocfs2new,0) does not match the active
>     cluster (o2cb,ocfs2,0).
>     mkfs.ocfs2 will not be able to determine if this operation can be
>     done safely.
>     To skip this check, use --force or -F
>
>
>     The running cluster on this host is :
>     root at LAB-virtm6:~# o2cluster -r
>     o2cb,ocfs2,local
>
>     I'm trying to add an "ocfs2new" cluster :
>     root at LAB-virtm6:~# o2cb add-cluster ocfs2new
>     root at LAB-virtm6:~# o2cb add-node --ip 192.168.0.12 --port 7777
>     --number 1 ovfs2new LAB-virtm6
>     root at LAB-virtm6:~# o2cb add-node --ip 192.168.0.13 --port 7777
>     --number 2 ovfs2new LAB-virtm7
>
>     root at LAB-virtm6:~# o2cb list-clusters
>     ocfs2
>     ocfs2new
>
>     root at LAB-virtm6:~# o2cb cluster-status
>     Cluster 'ocfs2' is online
>
>     Even if I restart services or reboot, cluster 'ocfs2new' never
>     goes online.
>
>     What am I doing wrong ?
>

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171215/08c5de86/attachment.html 
