From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:35:16 +0100
Subject: [Ocfs2-devel] Fixes
Message-ID: <20081125143516.GA16678@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi Mark,

  the 10 patches I've just sent you are fixes which I currently have
for ocfs2 quotas (and also a bug I found in quotas for other filesystem
which has been introduced by ocfs2-quotas patchset). It should also fix two
build problems Stephen Roswell reported. In the patches is included also
the patch from Joel changing ocfs2_read_quota_block(). Please merge them.
The patches should be against your linux-next branch from today.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
