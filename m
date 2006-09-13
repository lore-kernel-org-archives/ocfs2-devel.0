From: Mathieu Avila <mathieu.avila@seanodes.com>
Date: Wed Sep 13 01:44:50 2006
Subject: [Ocfs2-devel] cluster/heartbeat.c::compute_max_sectors is invalid.
In-Reply-To: <20060908182833.GF8792@ca-server1.us.oracle.com>
References: <44FFEF06.5030001@seanodes.com>
	<20060908182833.GF8792@ca-server1.us.oracle.com>
Message-ID: <20060913104442.6d8a541b@mathieu.toulouse>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Le Fri, 8 Sep 2006 11:28:33 -0700,
Mark Fasheh <mark.fasheh@oracle.com> a ?crit :

> On Thu, Sep 07, 2006 at 12:05:58PM +0200, Mathieu Avila wrote:
> > One of the device i use has "q->max_sectors"=8. Therefore,
> > max_pages should be 1. This is not the case, due to the :
> > max_pages--; /* Handle I/Os that straddle a page */
> > Therefore heartbeating doesn't work on my cluster, as it is
> > defined. When i force pow_two_sectors to be 8, it works fine, it
> > heartbeats and i can mount the device. 
> Hmm, interesting. Can I trouble you to send us a patch for that? It's
> trivial, but since I don't have access to any of that hardware around
> here I can't test it.
> 

A proposal patch (against the 2.6.17.11 vanilla kernel) for this is
attached. It works for me, and shouldn't break any existing device.

> 
> 
> It doesn't allocate bios in advance. That function, "setup_one_bio()"
> does the allocation. One bio at a time. We just figure out how many
> bio's we'll need ahead of time so that we can size an array. 

And i still think that it is a bad idea to try figuring out how many
BIOs are needed, because it really depends on the underlying
architecture of the device. Although it might work on most hardware,
some strange one might break one day...

> Your
> problem was initially with o2hb_compute_request_limits() which
> definitely has a bug. Everything that happened after that was a
> result of the bad calculation. --Mark
> 

Agreed.

--
Mathieu
-------------- next part --------------
A non-text attachment was scrubbed...
Name: heartbeat-sector-calculation.patch
Type: text/x-patch
Size: 514 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20060913/29bea8f2/heartbeat-sector-calculation.bin
