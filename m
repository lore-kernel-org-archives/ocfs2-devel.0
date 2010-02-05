From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 4 Feb 2010 22:01:49 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc thread
 and an unlock ast message
In-Reply-To: <4B6B21BE.10708@oracle.com>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
	<20100204102729.GA4339@laptop.oracle.com>
	<4B6B21BE.10708@oracle.com>
Message-ID: <20100205060148.GA3416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 04, 2010 at 11:36:30AM -0800, Sunil Mushran wrote:
> I meant ocfs2_unlock_ast. Specifically cancel convert. That is one case
> that does not change l_blocking directly.
> 
> However, that does not change the l_level too. So I am unsure what sequence
> of asts and basts (multiple ofcourse) can lead to this situation.

	Why cancel convert?  Why not an actual unlock.  That's what I
thought you meant when you proposed the patch.  After all, David's bug
was at DLM_LOCK_IV, not NL.
	Cancel isn't in play here.  Cancel only happens on the dc
thread, and the dc thread has gotten past BUSY.  So the lock isn't busy
anymore.  It does downconvert_worker in an unlocked state.  When it
comes back to recheck, another thread can't have done a cancel.
	That's why I asked about unlink.  Imagine the dc thread is
handling a bast while the unlink thread has gotten to clear_inode.
Could ocfs2_drop_lock() be racing the downconvert?

Joel

-- 

Life's Little Instruction Book #173

	"Be kinder than necessary."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
