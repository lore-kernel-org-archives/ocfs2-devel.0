From: Eric Ren <zren@suse.com>
Date: Thu, 12 Jan 2017 19:24:26 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix deadlocks when taking
 inode lock at vfs entry points
In-Reply-To: <8789b9ff-b951-2569-8e80-2aabd503215d@suse.com>
References: <1483630262-22227-1-git-send-email-zren@suse.com>
	<1483630262-22227-3-git-send-email-zren@suse.com>
	<dbf37786-9620-77fe-c500-881fdd455964@gmail.com>
	<2bfda278-6d7f-87c1-a053-8cbb9fb2463e@suse.com>
	<6450d035-1eec-88a0-57c2-cc3dcc115a46@gmail.com>
	<1dbd531e-39c3-d352-1052-bdbcb771a2c0@suse.com>
	<e8fb854e-14eb-4e14-0329-0807f0c43177@gmail.com>
	<2cc2b35f-9c93-0093-2365-e3fb02d46078@suse.com>
	<d1c38a46-f721-8f29-d395-9d8b67dc1330@gmail.com>
	<f983a441-68b9-c793-c7e6-30ad02c40136@suse.com>
	<5c114d4b-8d6b-a26c-be05-ea2604f0b37c@gmail.com>
	<8789b9ff-b951-2569-8e80-2aabd503215d@suse.com>
Message-ID: <340218da-57ae-dcdb-2ad3-b934632b0ab9@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <jiangqi903@gmail.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Joel Becker <jlbec@evilplan.org>, Gang He <ghe@suse.com>, Junxiao Bi <junxiao.bi@oracle.com>, mfasheh@versity.com

Hi Joseph,

On 01/09/2017 10:13 AM, Eric Ren wrote:
>>>> So you are trying to fix it by making phase3 finish without really doing
>>> Phase3 can go ahead because this node is already under protection of cluster lock.
>> You said it was blocked...
> Oh, sorry, I meant phase3 can go ahead if this patch set is applied;-)
>
>> "Another hand, the recursive cluster lock (the second one) will be blocked in
>> __ocfs2_cluster_lock() because of OCFS2_LOCK_BLOCKED."
>>>> __ocfs2_cluster_lock, then Process B can continue either.
>>>> Let us bear in mind that phase1 and phase3 are in the same context and
>>>> executed in order. That's why I think there is no need to check if locked
>>>> by myself in phase1.
> Sorry, I still cannot see it. Without keeping track of the first cluster lock, how can we
> know if
> we are under a context that has already been in the protecting of cluster lock? How can we
> handle
> the recursive locking (the second cluster lock) if we don't have this information?
>>>> If phase1 finds it is already locked by myself, that means the holder
>>>> is left by last operation without dec holder. That's why I think it is a bug
>>>> instead of a recursive lock case.
> I think I got your point here. Do you mean that we should just add the lock holder at the
> first locking position
> without checking before that? Unfortunately, it's tricky here to know exactly which ocfs2
> routine will be the first vfs
> entry point, such as ocfs2_get_acl() which can be both the first vfs entry point and the
> second vfs entry point after
> ocfs2_permission(), right?
>
> It will be a coding bug if the problem you concern about happens. I think we don't need to
> worry about this much because
> the code logic here is quite simple;-)
Ping...

Did I clear your doubts by the last email? I really want to get your point, if not.

If there's any problem, I will fix them in the next version;-)

Thanks,
Eric

>
> Thanks for your patience!
> Eric
>
>>> D
