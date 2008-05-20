From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 20 May 2008 14:56:39 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
	groups	lockdep-friendly
In-Reply-To: <20080520095810.1d50d247@infradead.org>
References: <20080520163320.025971210@kerlabs.com>
	<20080520095810.1d50d247@infradead.org>
Message-ID: <20080520215639.GG26609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjan van de Ven <arjan@infradead.org>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, May 20, 2008 at 09:58:10AM -0700, Arjan van de Ven wrote:
> On Tue, 20 May 2008 18:33:20 +0200
> Louis Rilling <Louis.Rilling@kerlabs.com> wrote:
> 
> > The following patches fix lockdep warnings resulting from (correct)
> > recursive locking in configfs.
> >
> > ...
> >
> > Since lockdep does not handle such correct recursion, the idea is to
> > insert lockdep_off()/lockdep_on() for inode mutexes as soon as the
> > level of recursion of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency
> > pattern increases.
> 
> I'm... not entirely happy with such a solution ;(
> 
> there must be a better one.

	We're trying to find it.  I really appreciate Louis taking the
time to approach the issue.  His first pass was to add 1 to MUTEX_CHILD
for each level of recursion.  This has a very tight limit (4 or 5
levels), but probably covers all users that exist and perhaps all that
ever will exist.  However, it means passing the lockdep annotation level
throughout the entire call chain across multiple files.  It was
definitely less readable.
	This approach takes a different tack - it's very readable, but
it assumes that the currently correct locking will always remain so - a
particular invariant that lockdep exists to verify :-)
	Louis, what about sticking the recursion level on
configfs_dirent?  That is, you could add sd->s_level and then use it
when needed.  THis would hopefully avoid having to pass the level as an
argument to every function.  Then we can go back to your original
scheme.  If they recurse too much and hit the lockdep limit, just rewind
everything and return -ELOOP.

Joel

-- 

Dort wo man B?cher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
