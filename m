From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Jun 2010 02:08:58 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <4C19DDBB.7060704@oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<20100617013930.GA14014@mail.oracle.com>
	<4C19DDBB.7060704@oracle.com>
Message-ID: <20100617090858.GB17748@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 17, 2010 at 01:32:59AM -0700, Srinivas Eeda wrote:
> On 6/16/2010 6:39 PM, Joel Becker wrote:
> As of today, we always get the lockres from the head of the
> dlm->purge_list. If it is in use, we keep trying. If that gets
> purged, we move to next res which again would be on the head of the
> dlm->purge_list. But with my change that won't be the case. If first
> (few) lockres are in use, we will try the one we could purge. So we
> should get the next lockres before list_del_init(&res->purge)
> happens and hence I moved the code. If you didn't like the delete
> code in dlm_run_purge_list, then we have to make dlm_purge_lockres
> to return the next lockres that should get purged.

	Or it does everything but the delete, and then you have
run_purge_list do the delete right after returning when the return code
is zero.  My problem wasn't that you moved the delete, it was that you
moved all the other checks and things.

> If you are suggesting that we move the lockres to the tail if we
> found it in use, then the code will be lot more readable. The
> current code doesn't move the unused lockres to tail, so wanted to
> preserve that logic as I am not sure what was the original intent.
> If move used lockres to tail, would you suggest we also update
> lockres->last_used?

	Like I responded to Sunil, it sure looks like the code wants the
same order.  If moving to the end is safe, that's obviously the best
answer.

> what would list_entry return, if the lockres was the last on the
> list. I was thinking it would return something random ..

	It returns the head of the list.  These are doubly-linked lists.
list_empty() actually checks whether head->next == head.  You can just
have the while loop say "while (lockres->list != head)" to exit at the last
item.  Then when you say 'lockres = list_entry(lockres->next);
continue;", the while loop exits properly at the end of the list.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
