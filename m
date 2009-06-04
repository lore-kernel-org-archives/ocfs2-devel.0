From: Jan Kara <jack@suse.cz>
Date: Thu,  4 Jun 2009 15:26:48 +0200
Subject: [Ocfs2-devel] [PATCH 0/2] OCFS2 lockdep support
Message-ID: <1244122010-16766-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


  Hi,

  here comes the next version of OCFS2 lockdep support. I've dropped patches
with fixes from the series since they were already merged.
  As Joel suggested, I've simplified the main patch a bit so that we don't
have ifdefs around lock declarations and there are also a few other minor
improvements.

									Honza
