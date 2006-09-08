From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Sep  8 11:28:38 2006
Subject: [Ocfs2-devel] cluster/heartbeat.c::compute_max_sectors is invalid.
In-Reply-To: <44FFEF06.5030001@seanodes.com>
References: <44FFEF06.5030001@seanodes.com>
Message-ID: <20060908182833.GF8792@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 07, 2006 at 12:05:58PM +0200, Mathieu Avila wrote:
> One of the device i use has "q->max_sectors"=8. Therefore, max_pages 
> should be 1. This is not the case, due to the :
> max_pages--; /* Handle I/Os that straddle a page */
> Therefore heartbeating doesn't work on my cluster, as it is defined. 
> When i force pow_two_sectors to be 8, it works fine, it heartbeats and i 
> can mount the device. 
Hmm, interesting. Can I trouble you to send us a patch for that? It's
trivial, but since I don't have access to any of that hardware around here I
can't test it.


> Allocating BIOs in advance by making assumptions on the behaviour of the 
> device (o2hb_compute_request_limits) is a bad idea, it seems. Instead, 
> it should add pages until the device refuses to add another one. With 
> the current code, i don't know whether it would take time to correct 
> that, however...
It doesn't allocate bios in advance. That function, "setup_one_bio()" does
the allocation. One bio at a time. We just figure out how many bio's we'll
need ahead of time so that we can size an array. Your problem was initially
with o2hb_compute_request_limits() which definitely has a bug. Everything
that happened after that was a result of the bad calculation.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
