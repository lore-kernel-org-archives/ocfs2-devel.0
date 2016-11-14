From: Eric Ren <zren@suse.com>
Date: Mon, 14 Nov 2016 18:03:44 +0800
Subject: [Ocfs2-devel] [DRAFT 2/2] ocfs2: fix deadlock caused by
 recursive cluster locking
In-Reply-To: <58294EE2.1000900@huawei.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
	<1476854382-28101-3-git-send-email-zren@suse.com>
	<5817233C.4060703@huawei.com>
	<27420c84-c2db-ea00-dbce-33036674de9b@suse.com>
	<582450CF.4030705@huawei.com>
	<968237e5-b308-84cc-2c99-637cdd13bd4c@suse.com>
	<58294EE2.1000900@huawei.com>
Message-ID: <26309248-87ca-7c69-c87f-1e2c6b5b0ff1@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 11/14/2016 01:42 PM, piaojun wrote:
> Hi Eric,
>
>
> OCFS2_LOCK_BLOCKED flag of this lockres is set in BAST (ocfs2_generic_handle_bast) when downconvert is needed
> on behalf of remote lock request.
>
> The recursive cluster lock (the second one) will be blocked in __ocfs2_cluster_lock() because of OCFS2_LOCK_BLOCKED.
> But the downconvert cannot be done, why? because there is no chance for the first cluster lock on this node to be unlocked -
> we blocked ourselves in the code path.
>
> Eric
> You clear my doubt. I will look through your solution.

Thanks for your attention. Actually, I tried different versions of draft patch locally. 
Either of them can satisfy myself so far.
Some rules I'd like to follow:
1) check and avoid recursive cluster locking, rather than allow it which Junxiao had tried 
before;
2) Just keep track of lock resource that meets the following requirements:
      a. normal inodes (non systemfile);
      b. inode metadata lockres (not open, rw lockres);
why? to avoid more special cluster locking usecases, like journal systemfile, "LOST+FOUND" 
open lockres, that lock/unlock
operations are performed by different processes, making tracking task more tricky.
3) There is another problem if we follow "check + avoid" pattern, which I have mentioned in 
this thread:
"""
This is wrong. We also depend ocfs2_inode_lock() pass out "bh" for later use.

So, we may need another function something like ocfs2_inode_getbh():
      if (!oh)
         ocfs2_inode_lock();
    else
        ocfs2_inode_getbh();
"""

Hope we can work out a nice solution for this tricky issue ;-)

Eric

>
