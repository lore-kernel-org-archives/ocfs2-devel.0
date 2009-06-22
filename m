From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 22 Jun 2009 14:06:31 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <4A3FE900.30405@oracle.com>
References: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>
	<1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>
	<20090622192509.GB3902@mail.oracle.com> <4A3FE900.30405@oracle.com>
Message-ID: <20090622210631.GC3902@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 22, 2009 at 01:26:40PM -0700, Sunil Mushran wrote:
> Joel Becker wrote:
> > On Mon, Jun 22, 2009 at 11:40:07AM -0700, Sunil Mushran wrote:
> >> Local and Hard-RO mounts do not need orphan scanning.
> > 	I just realized that we hold the os->os_lock around everything
> > we do here.  The orphan scan state doesn't need to be atomic_t.
> 
> No we don't hold it across all ops. In ocfs2_orphan_scan_stop(), we set
> it inactive before taking the mutex. This allows ocfs2_queue_orphan_scan()
> to bail out without queuing the tasks. The idea is to prevent umount 
> slowdown
> - as much as possible.

	It still strikes me as over-optimized, but it was a criticism
better leveled at the initial patch.  This patch is about local and
hard-readonly, and it's ready to go.

Joel

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
