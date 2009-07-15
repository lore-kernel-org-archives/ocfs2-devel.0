From: Jan Kara <jack@suse.cz>
Date: Wed, 15 Jul 2009 17:54:58 +0200
Subject: [Ocfs2-devel] [PATCH 0/6] Quota fixes for 2.6.31-rc4
Message-ID: <1247673304-31080-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  I did some more in-depth testing of OCFS2 quota code, especially with ECC
feature enabled and spotted some problems. First four patches fix them.
I need the fifth patch to be able to mount OCFS2 filesystem with 2.6.31-rc3.
The sixth patch fixes a potential problem when quota syncing interval is
updated while the cluster is running (which is not possible currently).
  Joel, could you please merge those patches? Thanks.

									Honza
