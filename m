From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jan 2010 18:36:11 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2:freeze-thaw: initialization and
 cleanup
In-Reply-To: <20100115022628.GB3760@laptop.oracle.com>
References: <201001091802.o09I2ZlW017091@acsinet15.oracle.com>
	<4B4FCA90.1090601@oracle.com>
	<20100115022628.GB3760@laptop.oracle.com>
Message-ID: <4B4FD49B.6040809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> if you meant ocfs2_freeze_unlock() in ocfs2_umount_volume() instead of
> at the end of ocfs2_mount_volume(), it's NG.
> if cleanup when umount, then we always have a ro_holder, freeze/thaw
> doesn't work.
>
> and we dont need to clean it up in umount if we already cleanup it in
> mount_volume. this is because the lock/unlock is used in pairs.
>   

What's NG?

And I am not following you. Don't we have to free all locks during
umount?
