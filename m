From: Jeff Moyer <jmoyer@redhat.com>
Date: Thu, 31 May 2012 10:09:09 -0400
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: clear unaligned io flag when
	dio fails
In-Reply-To: <1338437550-24499-2-git-send-email-junxiao.bi@oracle.com>
	(Junxiao Bi's message of "Thu, 31 May 2012 12:12:30 +0800")
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	<1338437550-24499-2-git-send-email-junxiao.bi@oracle.com>
Message-ID: <x49fwagcuii.fsf@segfault.boston.devel.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, joe.jin@oracle.com

Junxiao Bi <junxiao.bi@oracle.com> writes:

> The unaligned io flag is set in the kiocb when an unaligned
> dio is issued, it should be cleared even when the dio fails,
> or it may affect the following io which are using the same
> kiocb.

What code is re-using kiocbs, much less re-using them without
re-initializing them?

-Jeff
