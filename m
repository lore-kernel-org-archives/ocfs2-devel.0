From: Nicolas Ecarnot <nicolas@ecarnot.net>
Date: Fri, 03 Oct 2014 17:05:11 +0200
Subject: [Ocfs2-devel] Frangmentation, localalloc
Message-ID: <542EBB27.1020909@ecarnot.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

We have a 2 nodes cluster using two LUNs (3To and 1To) for ctdb+samba 
file sharing, setup and working fine for 2 years.
In January 2014, we were hit by an issue similar to what is described here :
https://oss.oracle.com/pipermail/ocfs2-users/2013-July/006087.html
except we see nothing related to DLM, but may seem related to allocation.

I'm not an expert in OCFS2, but what I witnessed was that at this time, 
the writing of tons of small files was efficient, but writing only one 
big file hung the whole cluster (2 nodes).

Too many googling lead me to understand I had to decrease the localalloc 
in the fstab options. I choose 16, remounted and it went all right until 
now (october 2014).

The exact same symptoms are showing : the big file eventually gets 
written, but at the price of a long delay and a complete pause of the 
filesystem.

Every threads I read about this issue speak of fragmentation, and note 
there is no cure.

I'll be happy to provide many details, but now, is the only solution to 
transfer all these files into another LUN?

Some details :

# lsb_release -a
Description:	Oracle Linux Server release 6.5

# uname -a
Linux 3.8.13-44.1.1.el6uek.x86_64 #2 SMP Wed Sep 10 06:10:25 PDT 2014 
x86_64 x86_64 x86_64 GNU/Linux

# modinfo ocfs2
filename: 
/lib/modules/3.8.13-44.1.1.el6uek.x86_64/kernel/fs/ocfs2/ocfs2.ko
license:        GPL
author:         Oracle
version:        1.8.0
description:    OCFS2 1.8.0
srcversion:     8A17E03E6F2326F4623E595
depends:        jbd2,ocfs2_stackglue,ocfs2_nodemanager
intree:         Y
vermagic:       3.8.13-44.1.1.el6uek.x86_64 SMP mod_unload modversions

# rpm -qa |grep ocfs2
ocfs2-tools-1.8.0-11.el6.x86_64

About the log files : ctdb is giving some error message about the big 
number of attemps it needs to get a lock, but it seems to me a direct 
effect of the issue above.

-- 
Nicolas Ecarnot
