From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 12 Oct 2011 17:32:16 -0700
Subject: [Ocfs2-devel] avoid being purged when queued for assert_master
In-Reply-To: <20111012070433.GA11852@laptop.jp.oracle.com>
References: <20111012070433.GA11852@laptop.jp.oracle.com>
Message-ID: <4E963190.1080803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So you are saying a lockres can get purged before the node is asserting
master to other nodes?

The main place where we dispatch assert is during master_query.
There we set refmap before dispatching. Meaning refmap will protect
us from purging.

But I think it could happen in master_requery, which only comes into
play if a node dies during migration.

Is that the case here?

On 10/12/2011 12:04 AM, Wengang Wang wrote:
> Hi Sunil/Joel/Mark and anyone who has interest,
>
> This is not a patch but a discuss.
>
> Currently we have a problem:
> When a lockres is still queued(in dlm->work_list) for sending an
> assert_master(or in processing of sending), the lockres can't be
> purged(removed from hash). there is no flag/state,on lockres its self,dinotes
> this situation.
>
> The badness is that if the lockres is purged(surely not the owner at the
> moment), and the assert_master is after the purge. it can confuse other
> nodes. On another node, the owner now can be any other nodes, thus on
> receiving the assert_master, it can trigger a BUG() because 'owner'
> doesn't match.
>
> So we'd better to prevent the lockres from be purged when it's queued
> for something(assert_master).
>
> Srini and I discussed some possible fixes:
> 1) adding a flag to lockres->state.
>     this does not work. A lockres can have multiple instances in the queue list.
>     A simple flag is not safe. And the instances are not nested, so even
>     saving a previous flags doesn't work. Neither can we merge the instances
>     because they can be for different purposes.
>
> 2) checking if the lockres if queued before purging it.
>    this works, but doesn't sounds good. it needs changes of current behaviour
>    on the queue list.   Also, we have no idea on the performance of the checking
>    (searching list).
>
> 3) making use of lockres->inflight_locks.
>    this works, but seems to be a mis-use of inflight_locks.
>
> 4) adding a new member to lockres counting the queued time.
>     this works and simple. but needs extra memory.
>
> I prefer to the 4).
>
> What's your idea?
>
> thanks,
> wengang.
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
