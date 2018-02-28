From: Jan Kara <jack@suse.cz>
Date: Wed, 28 Feb 2018 12:17:56 +0100
Subject: [Ocfs2-devel] [PATCH 0/6] ocfs2: Fix various quota recovery
Message-ID: <20180228111802.23967-1-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

this patch series fixes various issues I've found with ocfs2 quota recovery.
There were possible quota recovery failures or deadlocks when it raced with
umount in a wrong way. Also quota recovery would fail if the filesystem was
mounted read-only. The final patch is an unrelated fix for mount option
parsing I've found when testing my changes. Warning! I've tested these
patches only in local mode (as I don't have ocfs2 clustered setup available
for testing). Can someone please verify things also work properly in clustered
mode when recovery of quotas from other nodes happens? Thanks!

								Honza
