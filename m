From: Eric Ren <zren@suse.com>
Date: Wed, 14 Oct 2015 23:20:46 +0800
Subject: [Ocfs2-devel] dlm: make dlm_posix_lock comply with posix file lock
	semanteme
Message-ID: <1444836047-8020-1-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi David and all,

After using this patch, deadlock test for posix file lock, both on local and
on cluster mode for ocfs2, acts the same now as other local fs like ext4.

But, I have no gfs2 environment to verify if this issue would happen and can
be fixed by this patch. Hope anyone working on gfs2 could comfirm on it with
me.

Thanks,
Eric
