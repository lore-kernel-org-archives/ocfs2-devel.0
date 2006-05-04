From: Daniel Phillips <phillips@google.com>
Date: Thu, 04 May 2006 15:23:47 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <445A6A61.2090009@oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
	<44594EC9.3040407@google.com> <445A6A61.2090009@oracle.com>
Message-ID: <445A7EF3.2000701@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Zach Brown wrote:
>>journal.  These two things add up to a _huge_ performance boost for the
>>journal, if it can be separated.
> 
> Sure, I don't doubt the high level theory.  Does anyone have numbers to
> show it's relative effect in practice?  That'd be interesting.

I will have Ext3 numbers pretty soon.

>>It is worth remembering that not every OCFS2 user will be running it on a
>>big expensive SAN.  Probably not even the majority.
> 
> Well, that's debatable.  My only point, though, is that there are higher
> priority things that we should get to first because they affect *everyone*.

By all means, prioritize them.  Did separate journals make the list, even
if well towards the end?

> If the lack of external journals makes you sad, well, I'm sorry to hear
> that.  We certainly wouldn't turn away patches if someone got to it
> before us.

By proposing a feature that I do not also implicitly propose that Oracle
employees have to do the work.  This is a quick hack after all, I would be
happy to contribute.

>>IMHO, the separate journal on NVRAM will yield a much bigger gain and be
>>much less work besides.
> 
> So noted.  I'm curious, though.  What sort of NVRAM hardware do you have
> in mind?

For the moment, iRAM cards.  Yes I know they suck for throughput, but
there are faster SATA NVRAM cards coming down the pipe, they are still
much faster than IDE disks, and there is no seeking.

Regards,

Daniel
