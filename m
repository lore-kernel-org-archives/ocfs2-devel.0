From: Jan Kara <jack@suse.cz>
Date: Mon,  3 Aug 2009 15:23:30 +0200
Subject: [Ocfs2-devel] [PATCH 0/9] Quota support for ocfs2-tools (version 3)
Message-ID: <1249305819-7658-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  below comes a new version of the series of patches implementing quota support
for ocfs2-tools. I've fixed the calls of ocfs2_malloc_blocks() which were given
number of bytes instead of number of blocks. Besides that the series should be
the same.

									Honza
