From: Lars Marowsky-Bree <lmb@suse.de>
Date: Tue, 10 Jan 2006 11:43:19 +0100
Subject: [Ocfs2-devel] [PATCH 00/11] ocfs2: implement userspace
	clustering interface
In-Reply-To: <43C33D62.1000804@suse.com>
References: <20060109223942.GA8721@locomotive.unixthugs.org>
	<20060110042959.GJ3313@ca-server1.us.oracle.com>
	<43C33D62.1000804@suse.com>
Message-ID: <20060110104319.GU14816@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2006-01-09T23:51:46, Jeffrey Mahoney <jeffm@suse.com> wrote:

> > Is there any userspace source available that makes use of this yet? Hmm, I
> > see that you sent a description of what's required from userspace. Perhaps
> > that'll answer some more questions :)
> Unfortunately, not yet. I've been focusing on the kernel component and
> need to work with Lars Marowsky-Bree and Andrew Beekhof on integration
> with the hb2 code.

We don't have working user-space code for integrating with the new OCFS2
interface by Jeff yet :-( However, we've been working together to make
sure the interface is "right" for us to use - the good thing about the
new API is that in theory it can be driven from shell scripts for
testing w/no cluster involved at all ;-)

We're a bit caught up in general deadline frenzy right now, but intend
to have working code for driving OCFS2 within the next 2-3 weeks I
guess. As Jeff said, the major parts of the stack are done already, just
the integration piece seems missing...

So, I'd be grateful if you could tell us whether you consider the
direction where this is taking OCFS2 evil, acceptable or wonderful - if
the first, us pursuing that direction would be a waste of time and we'd
need to invent something else, quickly ;-) If merely acceptable, we also
should consider whether we can improve.



Sincerely,
    Lars Marowsky-Br?e

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
