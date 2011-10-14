From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 14 Oct 2011 10:56:54 -0700
Subject: [Ocfs2-devel] avoid being purged when queued for assert_master
In-Reply-To: <20111014085713.GB13004@laptop.jp.oracle.com>
References: <4E964332.1020201@oracle.com>
	<20111013015137.GA5565@laptop.jp.oracle.com>
	<20111013020712.GB5565@laptop.jp.oracle.com>
	<4E9648E1.3070508@oracle.com>
	<20111013021356.GD5565@laptop.jp.oracle.com>
	<4E970D2E.2080206@oracle.com>
	<20111013233549.GA2982@laptop.jp.oracle.com>
	<4E977644.2020902@oracle.com>
	<20111014001913.GA5162@laptop.jp.oracle.com>
	<4E97818A.5070902@oracle.com>
	<20111014085713.GB13004@laptop.jp.oracle.com>
Message-ID: <4E9877E6.8080307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/14/2011 01:57 AM, Wengang Wang wrote:
> Problem reproduced(against mainline) with the above patch applied. Also with the hacking
> patch(attached).
>
> testcase is attached.
>
> (kworker/u:2,14465,1):dlm_assert_master_handler:1828 ERROR: DIE! Mastery
> assert from 0, but current owner is 1! (master)
> lockres: master, owner=1, state=0
>    last used: 0, refcnt: 3, on purge list: no
>    on dirty list: no, on reco list: no, migrating pending: no
>    inflight locks: 0, asts reserved: 0
>    refmap nodes: [ ], inflight=0
>    granted queue:
>      type=5, conv=-1, node=1, cookie=1:28, ref=2, ast=(empty=y,pend=n),
> bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
>    converting queue:
>    blocked queue:

Name the nodes such that the node numbers are obvious. Easier
to debug that way.

This won't reproduce if you move the sleep 30000 in dlm_do_assert_master()
after we set DLM_LOCK_RES_SETREF_INPROG. Is that correct?
