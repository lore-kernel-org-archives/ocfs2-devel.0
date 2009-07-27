From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Jul 2009 19:53:28 +0200
Subject: [Ocfs2-devel] [PATCH 0/8] Quota support for ocfs2-tools
Message-ID: <1248717216-26617-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  I'm sending a series of patches implementing quota support into ocfs2-tools.
It's the same as the original huge patch I've sent but now it's split as Joel
asked. I've also realized that when disabling SPARSE feature, we should update
quota information. That piece of code is missing, I'll implement it soon.
  Comments welcome.

									Honza
