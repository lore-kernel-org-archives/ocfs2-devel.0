From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Jul 2009 17:51:49 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <4A53BC84.5000405@suse.com>
References: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>
	<1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>
	<20090622192509.GB3902@mail.oracle.com> <4A3FE900.30405@oracle.com>
	<20090622210631.GC3902@mail.oracle.com> <4A53B410.3040704@suse.com>
	<4A53B967.10909@oracle.com> <4A53BC84.5000405@suse.com>
Message-ID: <20090710005148.GB8522@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 07, 2009 at 05:22:12PM -0400, Jeff Mahoney wrote:
> Subject: ocfs2: Fixup orphan scan cleanup after failed mount
> 
> 
>  If the mount fails for any reason, ocfs2_dismount_volume calls
>  ocfs2_orphan_scan_stop. It requires that ocfs2_orphan_scan_init
>  be called to setup the mutex and work queues, but that doesn't
>  happen if the mount has failed and we oops accessing an uninitialized
>  work queue.
> 
>  This patch splits the init and startup of the orphan scan, eliminating
>  the oops.

	This patch is now part of the fixes branch of ocfs2.git.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
