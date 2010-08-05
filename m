From: Jan Kara <jack@suse.cz>
Date: Thu,  5 Aug 2010 20:32:44 +0200
Subject: [Ocfs2-devel] [PATCH 0/2 v3] OCFS2 bugfix in fdatasync and a cleanup
Message-ID: <1281033166-12485-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


  Hi,

  I've updated the changelog since the last version. Otherwise the patches are
the same. They add a forgotten cache flush in fdatasync path and sligthly
cleanup fdatasync code. Joel, could you please merge them?  Thanks.

								Honza
