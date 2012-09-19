From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 18 Sep 2012 17:10:58 -0700
Subject: [Ocfs2-devel] ocfs2 discontig localalloc patches (ver 2)
Message-ID: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel, et al,

sorry for the delay in resending discontiguous localalloc patches. Can you please review when you get a chance. I'll email the tools patches once kernel patches are approved.


I came across two use cases where this feature will help.

1. On a customer site, after running an application that creates, deletes ~200 hundred files per second, filesystem got fragmented which impacts localalloc bitmap. Filesystem usage was about 52%. The fragmentation significantly reduces localalloc bitmap size from about 256 mb to closer to 1M and eventually gets disabled.

2. A filesystem of 2TB has a cluster size of 4K which divides filesystem into about 16000 subgroups. In the begining, localalloc bitmap looks for about 2048 contiguous clusters(8mb). In the begining customer was seeing about 600Mb/sec throughput. But once the filesystem was used to about 51% usage, there are very few contiguous chunks that are larger than 2048 clusters(but are scattered). So everytime localalloc bitmap needs to be refilled, it has to scan quite a bit of subgroups before finding one big chunk.This behavior brought down throughput from 600mb/sec down to around < 15mb/sec. When I reduced the bitmap to half, performance was back up.


Changes:
1. Allow localalloc bitmap to use multiple contiguous chunks.

2. Each localalloc extent is 128K to start with. This doesn't limit the bitmap from getting one big chunk to fill the bitmap.


I have recreated customer filesystem on an iscsi storage with the o2image captured from the customer system. When ran a test of creating 100Mb files, I see a throughput of ~70M/sec without the discontig-la feature and about 280M/sec with discontig-la.

Thanks,
--Srini
