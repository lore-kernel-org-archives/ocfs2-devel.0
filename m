From: Daniel Phillips <phillips@google.com>
Date: Fri, 10 Mar 2006 13:13:03 -0800
Subject: [Ocfs2-devel] Ocfs2 performance
In-Reply-To: <44116057.5060705@google.com>
References: <4408C2E8.4010600@google.com>	<20060303233617.51718c8e.akpm@osdl.org>	<440B9035.1070404@google.com>	<20060306025800.GA27280@ca-server1.us.oracle.com>	<440BC1C6.1000606@google.com>	<20060306195135.GB27280@ca-server1.us.oracle.com>	<p733bhvgc7f.fsf@verdi.suse.de>	<20060307045835.GF27280@ca-server1.us.oracle.com>	<440FCA81.7090608@google.com>	<20060310002121.GJ27280@ca-server1.us.oracle.com>
	<44116057.5060705@google.com>
Message-ID: <4411EBDF.30104@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@google.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Going back to that mysterious idle time fluctuation problem, I just noticed
something interesting here:

> With hashvec, (64K buckets)
> 
>       real user sys
>     29.62 23.87 3.02
>     28.80 24.16 3.07
>     50.95 24.11 3.04
>     28.17 23.95 3.20
>     61.21 23.89 3.16
>     28.61 23.88 3.30
> 
> With vmalloc (64K buckets)
> 
>       real user sys
>     29.67 23.98 2.88
>     28.35 23.96 3.13
>     52.29 24.16 2.89
>     28.39 24.07 2.97
>     65.13 24.08 3.01
>     28.08 24.02 3.16

Look, the real time artifacts show up in the same places in the two
different runs.  There was a reboot before each run.  There is a sync
before  and after each trial.  Each trial was initiated by hand, so this
isn't about something else going on in the machine at the same time.

Got to be a clue in there somewhere.

Regards,

Daniel
