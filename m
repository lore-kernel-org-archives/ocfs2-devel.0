From: Daniel Phillips <phillips@google.com>
Date: Sun, 05 Mar 2006 20:59:50 -0800
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <20060306025800.GA27280@ca-server1.us.oracle.com>
References: <4408C2E8.4010600@google.com>
	<20060303233617.51718c8e.akpm@osdl.org>
	<440B9035.1070404@google.com>
	<20060306025800.GA27280@ca-server1.us.oracle.com>
Message-ID: <440BC1C6.1000606@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Sun, Mar 05, 2006 at 05:28:21PM -0800, Daniel Phillips wrote:
>>I think this table is per-ocfs2-mount, and really really, a meg is
>>nothing if it makes CPU cycles  go away.  That's .05% of the memory
>>on this box, which is a small box where clusters are concerned.  But
>>there is also some gratuitous cpu suck still happening in there that
>>needs investigating.  I would not be surprised at all to learn that
>>full_name_hash is a terrible hash function.
> 
> Can you try the attached patch?

With patch:

     Real  User  Sys
    31.93 23.72 3.69
    29.39 24.18 4.01
    53.36 24.25 4.80
    30.24 24.40 4.76
    63.60 24.09 5.03
    29.95 24.18 4.91

Without patch:

     Real  User  Sys
    30.15 23.90 3.58
    54.99 24.38 4.56
    31.49 24.63 5.28
    60.09 24.71 5.47
    31.44 24.34 5.72
    65.36 24.31 5.84

So that hack apparently improves the bucket distribution quite a bit, but
look, the bad old linear systime creep is still very obvious.  For that
there is no substitute for lots of buckets.

The hash function can be improved way more.  Your resource encoding is
also painfully wasteful.

As for optimizing the loop... most of the loop overhead comes from
loading cold cache lines no doubt.  The struct qstr is an impediment
there because it adds another cache line to every loop.  Speaking of
that, the qstr is so far away from the list.next pointer that you're
most probably getting an extra cache line load there too.  Just move
the qstr up next to the hash list.

Notice, those wildly gyrating real times are still manifesting.  Seen
them over there?

Regards,

Daniel
