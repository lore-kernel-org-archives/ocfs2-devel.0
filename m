From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Mon, 4 May 2009 18:36:58 +1200
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090504024612.GB24653@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090503080112.GA27287@infradead.org>
	<20090504024612.GB24653@mail.oracle.com>
Message-ID: <cfd18e0f0905032336v4e43cf77l4c4d02555ba9fe7a@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com

On Mon, May 4, 2009 at 2:46 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Sun, May 03, 2009 at 04:01:12AM -0400, Christoph Hellwig wrote:
>> On Sat, May 02, 2009 at 11:15:01PM -0700, Joel Becker wrote:
>> > int reflink(const char *oldpath, const char *newpath);
>> >
>> > The reflink(2) system call creates reference-counted links. ?It creates
>> > a new file that shares the data extents of the source file in a
>> > copy-on-write fashion. ?Its calling semantics are identical to link(2).
>> > Once complete, programs see the new file as a completely separate entry.
>>
>> Just send this as a manpage to Michael, no need to duplicate a
>> pseudo-manpage in the kernel tree.
>
> ? ? ? ?The manpage style was just a convenient way to organize my
> thoughts. ?The goal was to document the behavior of reflink() for
> implementors. ?If the pseudo-manpage doesn't work, perhaps I'll try some
> other form.

So, I'm late to this thread.  Is reflink() (to be) a user-visible syscall?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
