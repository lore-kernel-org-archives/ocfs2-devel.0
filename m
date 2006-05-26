From: Daniel Phillips <phillips@google.com>
Date: Fri, 26 May 2006 10:23:02 -0700
Subject: [Ocfs2-devel] Fencing in OCFS2
In-Reply-To: <4476232F.2070700@google.com>
References: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>
	<4476232F.2070700@google.com>
Message-ID: <44773976.1060607@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Daniel Phillips wrote:
> so with:
> 
>    A = 2
>    B = 2
>    H = 2 seconds
>    L = .5 seconds
>    W = 10 seconds
> 
> we have:
> 
>    8 + 1 + 10 = 19 seconds

Oops, sorry, I should not have set W (maximum latency between watchdog
trigger and shutdown) as high as 10, since the panic shuts down
interrupts much faster than that, which in theory stops any disk or
network hardware from transmitting.  This should just take a few ms,
however there may be write traffic in flight, so we need to set W to
a second or two.  This gets our "safe" watchdog wait down to 10 seconds
or so, which is still twice as bad as the 5 seconds we get with storage
side fencing.

Regards,

Daniel
