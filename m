From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 13 Jan 2010 11:14:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
 lock
In-Reply-To: <20100113075752.GA23372@mail.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>	<20100107020005.GC20095@mail.oracle.com>	<20100109180521.GA5148@laptop.oracle.com>	<20100112015946.GE20285@mail.oracle.com>	<20100113032049.GA4045@laptop.oracle.com>
	<20100113075752.GA23372@mail.oracle.com>
Message-ID: <4B4E1BA8.3060408@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Jan 13, 2010 at 11:20:49AM +0800, Wengang Wang wrote:
>> before update_holders, the lock could be DCed(since no BUSY flag set by
>> here).
>>
>> and even after update_holders, the lock could be DCed too.
>>
>> so that we get ocfs2_cluster_lock()(with holders increased) returned sucessfully
>> but actually we don't hold the dlm lock. --thus more than one node is
>> considering that they have the (EX) lock.
>
> 	You make a good point.  I don't like the solution you propose,
> though.  Another flag that's almost the same?  Eww!  There's got to be a
> better way.

I don't see how we can resolve this without another flag. It could
be a mirror image of the PENDING flag. PENDING takes care of the gap
between BUSY set and calling dlm_lock(). This flag has to take care
of the gap between BUSY clear and inc_holders.

Am working on improving Wengang's patch.

Mark is strangely silent.
