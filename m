From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 09 Mar 2006 18:26:07 +1100
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <440FCA81.7090608@google.com>
References: <4408C2E8.4010600@google.com>	<20060303233617.51718c8e.akpm@osdl.org>	<440B9035.1070404@google.com>	<20060306025800.GA27280@ca-server1.us.oracle.com>	<440BC1C6.1000606@google.com>	<20060306195135.GB27280@ca-server1.us.oracle.com>	<p733bhvgc7f.fsf@verdi.suse.de>
	<20060307045835.GF27280@ca-server1.us.oracle.com>
	<440FCA81.7090608@google.com>
Message-ID: <440FD88F.4010603@yahoo.com.au>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@google.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Daniel Phillips wrote:

> After untarring four kernel trees, number of locks hits a peak of 128K.
> With 64K buckets the hash, a typical region of the table looks like:
> 
>  3 0 3 6 1 2 2 1 2 6 1 0 1 2 1 0 0 3 1 2 2 3 1 2 5 3 2 2 1 0 3 1
>  1 1 3 5 2 2 1 0 2 3 3 1 3 0 5 2 2 3 0 2 1 3 1 2 4 2 0 2 5 1 4 3
>  5 3 3 3 3 1 4 1 2 1 2 6 2 1 3 0 2 2 2 8 1 2 2 2 3 1 0 1 3 2 1 1
>  1 2 2 2 2 3 2 0 2 2 2 5 2 3 2 1 1 2 6 6 1 2 2 4 2 0 3 0 3 3 3 0
>  2 2 1 1 2 3 2 0 2 3 3 1 3 3 3 1 4 2 8 3 2 2 2 4 3 0 1 2 3 4 2 0
>  3 1 0 1 2 2 3 1 4 2 1 1 3 3 4 3 3 3 4 2 1 4 2 1 5 2 1 3 1 2 3 2
>  1 0 1 5 3 2 1 2 3 0 1 1 2 3 4 4 4 1 3 1 4 3 2 2 4 4 1 3 1 0 0 1
>  3 1 1 3 0 3 0 1 1 1 1 1 3 4 4 2 4 3 4 2 3 3 0 3 4 2 1 5 4 1 3 1
>  1 0 1 0 1 4 1 2 1 4 2 0 2 2 5 2 1 1 1 2 3 6 4 5 5 1 1 2 3 1 5 1
>  3 0 1 0 3 3 2 0 2 1 2 1 0 4 3 2 1 0 1 0 2 7 1 3 2 1 1 2 4 1 3 1
>  2 2 3 1 3 3 1 2 0 2 1 3 1 2 0 4 4 1 2 1 2 3 3 6 0 5 2 1 1 0 3 0
>  1 0 2 0 4 3 2 1 0 0 2 0 1 4 2 4 5 1 0 1 3 2 2 1 1 3 2 3 0 2 1 1
>  3 0 0 0 2 5 3 1 0 2 0 1 0 0 2 0 4 2 1 2 4 3 0 1 2 4 1 3 0 0 1 4
> 
> A poor distribution as you already noticed[1].
[...]
 > [1] And this is our all-important dentry hash function.  Oops.

Why do you say that? I don't think it is particularly bad. Your sample
has an average of 2.06, and a standard deviation of 1.49 while a random
assignment using glibc's random() here has a standard deviation of 1.44

I can't remember much stats, but I think that means in your sample of
over 400, you're likely to find several instances of "6" and not
unlikely to find some higher. Actually given that it is bound at zero
and so not a normal distribution, that is likely to move results a bit
further to the right [I'm sure there's a formula for that], which is
pretty consistent with what you have, and you would hardly notice a
difference using rand()

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
