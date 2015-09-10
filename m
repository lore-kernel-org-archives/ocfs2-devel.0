From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 10 Sep 2015 19:23:29 +0800
Subject: [Ocfs2-devel] Performance issue about localalloc
Message-ID: <55F16831.5060702@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
I have encountered a performance issue about localalloc.

ocfs2 volume information:
block size = 4k, cluster size = 1M, mount option with localalloc=2048

So in the above circumstance, gd size is 32256M. Suppose I want to
create a normal file with size of 50G. Since the localalloc window is
2G, it will eventually allocate space like, 2Gfrom gd0, 2G from gd1,
..., and this will lead to poor performance because of the
dis-contiguous file with large span.

One way to resolve this issue is changing the mount option with
localalloc=31104, but this will make end user confused because 31G is
"missing" even he has only used 2M.

So I wander if we can let the allocation continues with the last gd if
it has enough space for a localalloc window. I have blamed the code
history and found that firstly you have already designed like this but
disabled in the commit "ocfs2: properly set and use inode group alloc
hint". I wander why?

A simply code hack is,
static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
{
	if (res->sr_blkno == 0)
		return 0;  // This will set the hint to 0
	...
}

Am I missing something?

Thanks,
Joseph
