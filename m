From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 28 Oct 2009 23:03:02 -0700
Subject: [Ocfs2-devel] [PATCH] Set return value to -EINVAL if superblock
 probe failed
In-Reply-To: <1255339004-20310-1-git-send-email-toth.laszlo.attila@balabit.hu>
References: <1255339004-20310-1-git-send-email-toth.laszlo.attila@balabit.hu>
Message-ID: <20091029060301.GD16472@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 12, 2009 at 11:16:44AM +0200, Laszlo Attila Toth wrote:
> In case of non-modular kernels the root filesystem is mounted by trying
> several filesystems. If ocfs2 is tried before the actual filesystem type,
> such as squashfs, the mount is failed because ocfs2_fill_super's return
> value was -EAGAIN and normally it should return with -EINVAL, which means
> the filesystem is non-ocfs2.

	ocfs2_sb_probe() shouldn't be returning -EAGAIN in the first
place.  I've done a different patch to the same effect, and it is now in
the fixes branch of ocfs2.git.

Joel

-- 

"What does it say about a society's priorities when the time you
 spend in meetings on Monday is greater than the total number of
 hours you spent sleeping over the weekend?"
	- Nat Friedman

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
