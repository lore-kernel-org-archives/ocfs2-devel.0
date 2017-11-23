From: =?UTF-8?Q?BASSAGET_C=C3=A9dric?= <cedric.bassaget.ml@gmail.com>
Date: Thu, 23 Nov 2017 11:23:39 +0100
Subject: [Ocfs2-devel] OCFS2 cluster debian8 / debian9
Message-ID: <CAN+OZjS0Rd71QNg6abJ1o_4Jp+P2oNg1duCdXiEZPEsObH5dUQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hello,
I'm trying to set-up an OCFS2 cluster between hosts running debian8 and
debian9

2*debian 8 : ocfs2-tools 1.6.4-3
1*debian 9 : ocfs2-tools 1.8.4-4

I created the FS on debian 8 node :
 mkfs.ocfs2 -L "ocfs2_new" -N 5 /dev/mapper/data_san_2

then mounted it without problem
mount /dev/mapper/data_san_2 /mnt/vol1_iscsi_san2/

I mounted it on second debian 8 host too, without problem.

Trying to mount in on debian9 returns :
mount.ocfs2: Cluster name is invalid while trying to join the group

I saw in "man mkfs.ocfs2" that debian9 version has --cluster-stack and
--cluster-name options.

Is this option mandatory on ocfs2 1.8 ? That would say that ocfs2 1.6 and
1.8 are not compatible ? Nothing is said about 1.8 on
https://oss.oracle.com/projects/ocfs2/

Any tip ?
Regards,
C?dric
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171123/2871d20a/attachment.html 
