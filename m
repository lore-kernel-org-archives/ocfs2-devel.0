From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jun  8 23:29:09 2004
Subject: [Ocfs2-devel] ATTN: OCFS2 coders and testers
In-Reply-To: <3ACA40606221794F80A5670F0AF15F840493009B@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F840493009B@pdsmsx403>
Message-ID: <20040609042904.GE4380@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2004 at 11:01:14AM +0800, Ling, Xiaofeng wrote:
> >From result of profile, the ocfs_bh_sem_lookup occupy most of the CPU time,
That's what I feared. I'm glad someone got some good profiling info there
though. The real challenge of course is to replace this without making
things worse :)

> Do you mean it will be removed soon?
> Is there still a semaphore for each buffer_head? 
Yes and yes. Right now, we're running with both, ip_io_sem (the eventual
replacement) and the bh sem hash. The thing with the bh sem hash though is
that it's wired to BUG when you try to do something to a buffer that you
should be locked out from. This means that any time you do a GET_DATA_WRITE,
if you have to wait on someone elses write lock, we BUG, and similarly in
GET_DATA_READ if we have to wait on some's write lock we also BUG. The issue
of concurrent reads still hasn't been completely solved, but I think we
should be safe there in most cases (and in fact, it'd be cool to somehow
avoid locking for only reads of buffer data).

What I really need help with is two fold:

1) Finding any more places that aren't protected other than bh sem hash (and
in fact, if it's protected, but not straight forward, then a documentation
patch will be accepted)

2) Finding any deadlocks due to the ip_io_sem. It's pretty straightforward
and simple in it's use, but I'm not perfect :)
	--Mark

> >-----Original Message-----
> >From: ocfs2-devel-bounces@oss.oracle.com 
> >[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
> >Sent: 2004??6??9?? 6:53
> >To: ocfs2-devel@oss.oracle.com
> >Subject: [Ocfs2-devel] ATTN: OCFS2 coders and testers
> >
> >Ok, as of SVN revision 1024 I've commited some changes which 
> >include a set
> >of BUG() assertions. If you hit a BUG() on an acquire_lockres, 
> >or any bh sem
> >hash related functions (get data, get data write, etc) please 
> >copy and send
> >the entire output to me and/or to the list (both is prolly good).
> >
> >Since this stuff is going away soon, I didn't bother to put 
> >the assertions
> >in the replacement functions which are used when BH_SEM_DEBUG 
> >is defined.
> >Please don't build with that enabled in the Makefile (it is disabled by
> >default).
> >
> >What we're trying to do here is use an alternative locking 
> >scheme for I/O
> >instead of the acquire_lockres and bh sem hash stuff. When 
> >we're comfortable
> >that the new scheme works, we'll be removing those two.
> >
> >The hope is that by putting this out a bit early we can get 
> >any corner cases
> >we've missed.
> >	--Mark
> >
> >--
> >Mark Fasheh
> >Software Developer, Oracle Corp
> >mark.fasheh@oracle.com
> >_______________________________________________
> >Ocfs2-devel mailing list
> >Ocfs2-devel@oss.oracle.com
> >http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
> >
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
