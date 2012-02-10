From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Feb 2012 17:03:58 +0100
Subject: [Ocfs2-devel] [PATCH 0/4] Generic O_SYNC AIO DIO handling
Message-ID: <1328889842-23231-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com


  Hi Jeff,

  these patches implement generic way of handling O_SYNC AIO DIO. They work
for all filesystems except for ext4 and xfs. Thus together with your patches,
all filesystems should handle O_SYNC AIO DIO correctly. I've tested ext3,
btrfs, and xfs (to check that I didn't break anything when the generic code
is unused) and things seem to work fine. Will you add these patches to your
series please? Thanks.

								Honza
