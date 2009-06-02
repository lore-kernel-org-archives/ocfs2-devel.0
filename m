From: Jan Kara <jack@suse.cz>
Date: Tue,  2 Jun 2009 14:23:58 +0200
Subject: [Ocfs2-devel] [PATCH 0/7] [RESEND] Fix some deadlocks in quota code
	and implement lockdep for cluster locks
Message-ID: <1243945445-25847-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


  Hi,

  I'm resending this patch series. It's rediffed against linux-next branch of
Joel's git tree. The first four patches are obvious fixes of deadlocks in quota
code and should go in as soon as possible. The other three patches implement
lockdep support for OCFS2 cluster locks. So you can have a look whether the
code make sence to you and possibly merge them. They should be NOP when lockdep
is disabled and help a lot when debugging various locking problems (with these
patches I found the problems fixed in the beginning of the series).
  BTW: Currently lockdep complains about some configfs issue and turns itself
off so that's why I didn't get to finding more deadlocks ;)

									Honza
