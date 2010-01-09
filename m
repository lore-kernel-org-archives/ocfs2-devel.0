From: Andi Kleen <andi@firstfloor.org>
Date: Sat, 9 Jan 2010 07:41:08 +0100
Subject: [Ocfs2-devel]
	+	sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch	added
	to -mm tree
In-Reply-To: <m1r5q09jx0.fsf@fess.ebiederm.org>
References: <201001082354.o08NsLGV021886@imap1.linux-foundation.org>
	<20100109000853.GC24532@mail.oracle.com>
	<m1r5q09jx0.fsf@fess.ebiederm.org>
Message-ID: <20100109064108.GA20773@basil.fritz.box>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> Accesses would be:
>         char *str; 
> 	rcu_read_lock();
>         str = rcu_deref(NAME.str);
>         ....
> 	rcu_read_unlock();
> 
> Updates would be:
>         char *next;
> 	mutex_lock(&rcu_string_mutex);
>         next = rcu_string->data;
>         if (next == rcu_string->str)
>         	next = rcu_string->data + rcu_string->size;
>         memcpy(next, somestring_from_somewhere, rcu_string->size);
>         next[rcu_string->size - 1] = '\0';
>         rcu_string->str = next;
>         synchronize_rcu();
>         mutex_unlock(&rcu_string_mutex);

synchronize_rcu inside a lock is a bit nasty, but ok none of these
are critical.

> 
> Thoughts?

It's not fully clear to me how this is better than my solution?

-Andi
-- 
ak at linux.intel.com -- Speaking for myself only.
