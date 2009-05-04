From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 3 May 2009 19:49:16 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <49FD976B.3000508@panasas.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<49FD976B.3000508@panasas.com>
Message-ID: <20090504024916.GC24653@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sun, May 03, 2009 at 04:08:59PM +0300, Boaz Harrosh wrote:
> On 05/03/2009 09:15 AM, Joel Becker wrote:
> > int reflink(const char *oldpath, const char *newpath);
> > 
> > The reflink(2) system call creates reference-counted links.  It creates
> > a new file that shares the data extents of the source file in a
> > copy-on-write fashion.  Its calling semantics are identical to link(2).
> > Once complete, programs see the new file as a completely separate entry.
> > 
> 
> Please forgive my complete Unix jargon novice-ness, but from here it looks like the
> name is very wrong, and confusing.
> 
> if I put data to link graph then:
> 
> [data]<--[hard-link (one or more)]<--[soft-link(zero or more)]
> 
> The data is other-wise just there on disk but is un available until
> it is linked to a dir-entry, at-least one. The middle hard-link is reference
> counted and once all uses are removed data can be garbage collected. Soft links
> don't follow on-disk data but follow a dir-entry. So if we have a completely
> different on disk data we're still in agreement with the dir-entry.

	A reflink creates a dir entry.  That's what newpath is about.
Using your graph:


[data]<--[reflink (zero or more)]<--[hard-link (one or more)]<--[soft-link(zero or more)]

 
> As my first impression when I read the title of the patch, an English reflink
> I would imagine is something more to the left of above graph, between hard-link
> and soft-link, something like: link to an invisible dir-entry that is gone once
> all soft-links to it are gone.

	There is no "invisible dir entry".  The target is a new file
with a new dir entry.  It just shares the data extents of the source.
Perhaps I can clarify that better.

Joel

-- 

"Maybe the time has drawn the faces I recall.
 But things in this life change very slowly,
 If they ever change at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
