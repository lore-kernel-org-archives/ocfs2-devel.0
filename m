From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 07 Jul 2009 14:08:55 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <4A53B410.3040704@suse.com>
References: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>	<1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>	<20090622192509.GB3902@mail.oracle.com>
	<4A3FE900.30405@oracle.com> <20090622210631.GC3902@mail.oracle.com>
	<4A53B410.3040704@suse.com>
Message-ID: <4A53B967.10909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jeff Mahoney wrote:
> There's a problem with this patch that I ran into while testing
> 2.6.31-rc2. ocfs2_orphan_scan_stop expects that ocfs2_orphan_scan_init
> was called. If the mount fails for any reason, ocfs2_dismount_volume
> calls ocfs2_orphan_scan_stop. The thing is that ocfs2_dismount_volume
> will never get called in that path after ocfs2_orphan_scan_init is
> called, so we oops when calling cancel_delayed_work on an uninitialized
> work queue.
>
> The attached patch fixes it up.
>
> -Jeff

Jeff, Thanks. For some reason, my mounts don't fail. ;)

My only quibble with the patch would be that ocfs2_orphan_scan_init()
should be called before ocfs2_recovery_init(). Else we'll encounter the
same problem if say ocfs2_recovery_init() fails.
