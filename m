From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 23 Jun 2008 15:20:44 -0700
Subject: [Ocfs2-devel] [PATCH 0/2]v2 configfs: symlink() fixes
In-Reply-To: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
References: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080623222043.GG592@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 23, 2008 at 02:16:16PM +0200, Louis Rilling wrote:
> The following patchset fixes incorrect symlinks to dead items in configfs, which
> are forbidden by specification.
> 
> The first patch actually prevents such dangling symlinks from being created, but
> introduces a weird(?) behavior where a failing symlink() can make a racing
> rmdir() fail in the symlink's parent and in the symlink's target as well. This
> behavior is fixed with the next patch.

	Silly question: you've tested this, right?

Joel

-- 

"I almost ran over an angel
 He had a nice big fat cigar.
 'In a sense,' he said, 'You're alone here
 So if you jump, you'd best jump far.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
