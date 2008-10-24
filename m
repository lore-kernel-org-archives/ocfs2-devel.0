From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 15:47:49 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Set journal descriptor to	NULL
	after journal shutdown
In-Reply-To: <1224707069-14173-1-git-send-email-sunil.mushran@oracle.com>
References: <1224707069-14173-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20081024224749.GH9302@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 22, 2008 at 01:24:29PM -0700, Sunil Mushran wrote:
> Patch sets journal descriptor to NULL after the journal is shutdown.
> This ensures that jbd2_journal_release_jbd_inode(), which removes the
> jbd2 inode from txn lists, can be called safely from ocfs2_clear_inode()
> even after the journal has been shutdown.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	This is now in my xattr-28 branch.

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
