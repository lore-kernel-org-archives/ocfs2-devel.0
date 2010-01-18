From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 19 Jan 2010 00:17:31 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <20100118130638.GA3549@laptop.oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
Message-ID: <20100118161731.GA3709@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-01-18 21:06, Wengang Wang wrote:
> Hi Sunil,
> 
> On 10-01-15 18:22, Sunil Mushran wrote:
> > Apart from this, you have to handle edge conditions. Like umount
> > and mount. What if the freeze is issued just before a node is about
> > to umount. Or, another node tries to mount the volume while it is
> > frozen.
> 
> Yes. there is problem when umount the volume when it's frozen.

the problem is the umount succeeded but ocfs2_cluster_lock()(NL->PR) still hanging
there waiting for thaw.

ocfs2_cluster_lock() is default a non-noqueue version of cluster lock. we can use a
noqueue version of ocfs2_freeze_lock(), say ocfs2_freeze_lock_giveup_on_unmount().
in the later function, it

1) checkes if the volume is being unmounted.
	sb->s_flags & MS_ACTIVE
if yes, return with error(which error number?).

2) calls ocfs2_cluster_lock() with DLM_LKF_NOQUEUE.
   if ocfs2_cluster_lock() returns -EAGAIN, goes to step 3).
   else return the value turned by ocfs2_cluster_lock() --0(lock got) or
other error.

3) sleep 5ms then go to step 1). 

we use ocfs2_freeze_lock_giveup_on_unmount() instead of
ocfs2_freeze_lock() in ocfs2_freeze_worker(). so it can jump out when
unmount comes instead of hanging up the ocfs2_wq worker queue.

no test for the above yet. what's your comment?

regards,
wengang.
