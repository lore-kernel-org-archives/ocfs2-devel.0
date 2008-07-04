From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 4 Jul 2008 18:32:40 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup
	after mkdir()	failure
In-Reply-To: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080704163240.GQ30545@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Joel,

Sorry for posting to a wrong address (really fun to see you working at Kerlabs
;)). I've just discovered that git-send-email is case-sensitive with email
aliases while mutt is not...

Cheers,

Louis

On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
>  [ applies on top of http://lkml.org/lkml/2008/6/23/145 aka symlink() fixes ]
> 
> Hi,
> 
> This patchset fixes two kinds of bugs happening when
> configfs_attach_group()/configfs_attach_item() fail and userspace races with
> mkdir() or symlink().
> 
> Please read the first patch header for a detailed scenario explaining the bugs.
> 
> Louis
> 
> Changelog:
>   - Few code reworks as requested by Joel (details in patch headers)
> 
> Summary (2):
>   configfs: Prevent userspace from creating new entries under attaching
>     directories
>   configfs: Lock new directory inodes before removing on cleanup after
>     failure
> 
>  fs/configfs/configfs_internal.h |    2 +
>  fs/configfs/dir.c               |  141 ++++++++++++++++++++++++++++++++-------
>  fs/configfs/symlink.c           |   15 ++++
>  3 files changed, 133 insertions(+), 25 deletions(-)
> 
> -- 
> Dr Louis Rilling			Kerlabs
> Skype: louis.rilling			Batiment Germanium
> Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
> http://www.kerlabs.com/			35700 Rennes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080704/ff9e1f00/attachment.bin 
