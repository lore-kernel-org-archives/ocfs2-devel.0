From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 10 Jan 2006 11:08:47 -0800
Subject: [Ocfs2-devel] [PATCH 00/11] ocfs2: implement userspace
	clustering interface
In-Reply-To: <20060110104319.GU14816@marowsky-bree.de>
References: <20060109223942.GA8721@locomotive.unixthugs.org>
	<20060110042959.GJ3313@ca-server1.us.oracle.com>
	<43C33D62.1000804@suse.com>
	<20060110104319.GU14816@marowsky-bree.de>
Message-ID: <20060110190847.GS3313@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 10, 2006 at 11:43:19AM +0100, Lars Marowsky-Bree wrote:
> We don't have working user-space code for integrating with the new OCFS2
> interface by Jeff yet :-( However, we've been working together to make
> sure the interface is "right" for us to use - the good thing about the
> new API is that in theory it can be driven from shell scripts for
> testing w/no cluster involved at all ;-)
Ok. Personally I'd like to see the beginnings of that before pushing your
patch into our tree, but I think we're still at the early stages of review
anyway.

> We're a bit caught up in general deadline frenzy right now, but intend
> to have working code for driving OCFS2 within the next 2-3 weeks I
> guess. As Jeff said, the major parts of the stack are done already, just
> the integration piece seems missing...
Heh, I know what that frenzy can be like :)

> So, I'd be grateful if you could tell us whether you consider the
> direction where this is taking OCFS2 evil, acceptable or wonderful - if
> the first, us pursuing that direction would be a waste of time and we'd
> need to invent something else, quickly ;-) If merely acceptable, we also
> should consider whether we can improve.
Oh, I think folks over here are pretty happy with the direction you've been
headed in. Of course there'll always be some things to change, etc. But if
you're worried that anyone here is considering it out and out wrong, that's
certainly not the case.

What I'm trying to do right now is list out all the requirements that OCFS2
and the DLM has of their cluster stack so I can examine those one by one
against your patch.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
