From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 14:32:06 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2)
	system	call.
In-Reply-To: <20090505212417.GO3209@webber.adilger.int>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
Message-ID: <20090505213206.GM7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>
Cc: linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 03:24:17PM -0600, Andreas Dilger wrote:
> On May 05, 2009  09:56 -0700, Joel Becker wrote:

<snip a bunch of stuff about how quota obviously works correctly if we
 change ownership>
 
> > 	No, because the last thing rsync will do is rename(.temporary,
> > source).  All the references from the source will be decremented, and
> > any blocks only owned by the source will be freed.  Space usage is
> > identical before and after, like a copying rsync, but there is less
> > space used and less I/O done during the rsync process.
> 
> What I was objecting to is "when overwriting someone elses file, the old
> copy behaviour is fine".  If we are implementing a copy-on-write API,
> why hamstring it to not work in the expected manner by a normal "cp"?

	We're implementing an inode-level snapshot/clone that also
happens to be very convenient for many cp-like operations.

> > 	If you define that 'reflink sets the attributes as if it was a
> > new file', then you should be creating the file with a new security
> > context, not with the security context from the existing inode.  And
> > then you can't really snapshot.
> > 	A mixed behavior, like "if you own it, I'll preserve the entire
> > security context, but if not I will treat it with a new context" is
> > confusing at best.
> 
> I don't find it confusing.  The security context would be inherited from
> the creating process, just like creating a new file would.  If it is the
> same user as the file owner then the security context will be the same.

	The same as what?  If you reflink your own file, it preserves
the security context of the original or it appears with the default
security context of yourself?  They are not the same.  "Treat it like
link(2)" argues for the former - which precludes changing ownership.
That's what reflink is designed to do.  "Treat it like cp" is a
different behavior.

Joel

-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
