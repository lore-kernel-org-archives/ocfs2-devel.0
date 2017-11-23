From: Eric Ren <zren@suse.com>
Date: Thu, 23 Nov 2017 20:41:24 +0800
Subject: [Ocfs2-devel] OCFS2 cluster debian8 / debian9
In-Reply-To: <CAN+OZjS0Rd71QNg6abJ1o_4Jp+P2oNg1duCdXiEZPEsObH5dUQ@mail.gmail.com>
References: <CAN+OZjS0Rd71QNg6abJ1o_4Jp+P2oNg1duCdXiEZPEsObH5dUQ@mail.gmail.com>
Message-ID: <534b1978-775f-a60a-a370-8f0b88631e6c@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 11/23/2017 06:23 PM, BASSAGET C?dric wrote:
> hello,
> I'm trying to set-up an OCFS2 cluster between hosts running debian8 
> and debian9
>
> 2*debian 8 :?ocfs2-tools 1.6.4-3
> 1*debian 9 :?ocfs2-tools 1.8.4-4
>
> I created the FS on debian 8 node :
> ?mkfs.ocfs2 -L "ocfs2_new" -N 5 /dev/mapper/data_san_2
>
> then mounted it without problem
> mount /dev/mapper/data_san_2 /mnt/vol1_iscsi_san2/
>
> I mounted it on second debian 8 host too, without problem.
>
> Trying to mount in on debian9 returns :
> mount.ocfs2: Cluster name is invalid while trying to join the group
>
> I saw in "man mkfs.ocfs2" that debian9 version has?--cluster-stack and 
> --cluster-name options.
>
> Is this option mandatory on ocfs2 1.8 ? That would say that ocfs2 1.6 
> and 1.8 are not compatible ? Nothing is said about 1.8 on 
> https://oss.oracle.com/projects/ocfs2/'re
> <https://oss.oracle.com/projects/ocfs2/>

Not sure if they're compatible. So can you try again with 
--cluster-stack and --cluster-name?

# o2cluster -o /dev/sda1
pcmk,cluster,none

pcmk is the cluster-stack, cluster is the name.

Usually, these two option is optional, the tools will detect the right 
cluster stack automatically.

Eric
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171123/2df07b4e/attachment.html 
