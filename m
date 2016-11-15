From: Eric Ren <zren@suse.com>
Date: Tue, 15 Nov 2016 10:13:06 +0800
Subject: [Ocfs2-devel] [DRAFT 2/2] ocfs2: fix deadlock caused by
 recursive cluster locking
In-Reply-To: <26309248-87ca-7c69-c87f-1e2c6b5b0ff1@suse.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
	<1476854382-28101-3-git-send-email-zren@suse.com>
	<5817233C.4060703@huawei.com>
	<27420c84-c2db-ea00-dbce-33036674de9b@suse.com>
	<582450CF.4030705@huawei.com>
	<968237e5-b308-84cc-2c99-637cdd13bd4c@suse.com>
	<58294EE2.1000900@huawei.com>
	<26309248-87ca-7c69-c87f-1e2c6b5b0ff1@suse.com>
Message-ID: <b09d7fec-9b0b-0a51-9882-d9b77d6bbb8a@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
> Thanks for your attention. Actually, I tried different versions of draft patch locally.
> Either of them can satisfy myself so far.

Sorry, I meat "neither of them".

Eric
> Some rules I'd like to follow:
> 1) check and avoid recursive cluster locking, rather than allow it which Junxiao had tried
> before;
> 2) Just keep track of lock resource that meets the following requirements:
>        a. normal inodes (non systemfile);
>        b. inode metadata lockres (not open, rw lockres);
> why? to avoid more special cluster locking usecases, like journal systemfile, "LOST+FOUND"
> open lockres, that lock/unlock
> operations are performed by different processes, making tracking task more tricky.
> 3) There is another problem if we follow "check + avoid" pattern, which I have mentioned in
> this thread:
> """
> This is wrong. We also depend ocfs2_inode_lock() pass out "bh" for later use.
>
> So, we may need another function something like ocfs2_inode_getbh():
>        if (!oh)
>           ocfs2_inode_lock();
>      else
>          ocfs2_inode_getbh();
> """
>
> Hope we can work out a nice solution for this tricky issue ;-)
>
> Eric
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
