From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Jun 2008 15:29:00 -0700
Subject: [Ocfs2-devel] [PATCH][BUGFIX] configfs: Fix symlink() to a
	removing item
In-Reply-To: <20080616180911.GV30804@localhost>
References: <20080616180911.GV30804@localhost>
Message-ID: <20080616222900.GD6441@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 16, 2008 at 08:09:11PM +0200, Louis Rilling wrote:
> This patch introduces a similar (weird?) behavior as with mkdir failures making
> rmdir fail: if symlink() races with rmdir() of the parent directory (or its
> youngest user-created ancestor if parent is a default group) or rmdir() of the
> target directory, and then fails in configfs_create(), this can make the racing
> rmdir() fail despite the concerned directory having no user-created entry (resp.
> no symlink pointing to it or one of its default groups) in the end.
> If this behavior is found unacceptable, I'll submit a fix in the same spirit as
> the racing mkdir() fix.

	Ahh, but you can't wait on the mutex like you do in mkdir(),
because they're not ordered - it can race rename again.

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
