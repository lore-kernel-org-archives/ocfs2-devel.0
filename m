From: Daniel Phillips <phillips@google.com>
Date: Wed, 03 May 2006 17:46:01 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <44594AE2.9080802@oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
Message-ID: <44594EC9.3040407@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Zach Brown wrote:
> Daniel Phillips wrote:
>>Sorry about the lag.  Here's an easy feature nobody has mentioned so far, and
>>from my reading isn't supported: separate journal, like Ext3.
> 
> Yeah, I think this would be a fine piece to have some day.

Ext3 has it today.

> I'm not sure it's a high priority, though, given that the vast majority
> of deployments are already using hardware that has either some form of
> write caching or so many spindles that external journals just aren't
> worth the time they take to configure.

The journal has different, less demanding mirroring requirements than the
filesystem proper.  It is unnecessary and redundant to have a dirty map for
the journal mirror.  It is also unnecessary and stupid to snapshot the
journal.  These two things add up to a _huge_ performance boost for the
journal, if it can be separated.

It is worth remembering that not every OCFS2 user will be running it on a
big expensive SAN.  Probably not even the majority.

> I'd be interested in seeing more careful write ordering in JBD before
> worrying about external journals, personally.

IMHO, the separate journal on NVRAM will yield a much bigger gain and be
much less work besides.  Agreed that improvements to JBD are good.  They
are also scary.

Regards,

Daniel
