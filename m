From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 9 Feb 2009 19:23:37 -0800
Subject: [Ocfs2-devel] Problem with ordered mode handling on truncate
In-Reply-To: <20090203153415.GC24630@duck.suse.cz>
References: <20090203153415.GC24630@duck.suse.cz>
Message-ID: <20090210032337.GE4341@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 03, 2009 at 04:34:16PM +0100, Jan Kara wrote:
>   Hi,
> 
>   I've looked at how OCFS2 call jbd2_journal_begin_ordered_truncate()
> (because I've been adding some comments about how is should be used) and
> noticed that OCFS2 has a potential race in truncate vs transaction commit
> leading to stale data in file. In particular: There is a race if someone
> writes new data and we start committing the transaction after
> jbd2_journal_begin_ordered_truncate() is called but before transaction
> adding inode to orphan list is started. Because then data written by the new
> write are discarded in the truncate but if we crash before the truncate
> itself is committed, we see old data instead of newly written one.
> Maybe more understandable as a diagram:
> 	   CPU 1:					CPU 2:
> jbd2_journal_begin_ordered_truncate(inode, 0)
> 							write(trans, inode, ...)
> discard data of "inode"
> 							commit "trans"
> ---- CRASH
> 
>   The correct fix to this problem is to call
> jbd2_journal_begin_ordered_truncate() after inode has been added to orphan
> list (new i_size written respectively). That function is called from two
> places:
> 1) ocfs2_truncate_for_delete() - easy to fix, just move the call just after
>    the write of the inode.
> 2) ocfs2_setattr() - we can move the call into ocfs2_truncate_file() but
>    that would mean calling jbd2_journal_begin_ordered_truncate()
>    and consequently ocfs2_write_page() under ip_alloc_sem - not too nice.
>    Furthermore ocfs2_orphan_for_truncate() zeros the last cluster
>    beyond i_size and we cannot do that before writing out previous
>    content... Not sure how to solve that yet.
> 
>   Any ideas welcome.

	Well, we don't actually orphan the inode ;-)
	Is this the same crash as you specified in the later patch to
lock the journal?  Or something different and ocfs2-specific?

Joel

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
