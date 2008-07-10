From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 10 Jul 2008 16:34:43 -0700
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Add incompatible flag for
	extended attribute v2
In-Reply-To: <20080710232228.GE11809@mail.oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-3-git-send-email-tiger.yang@oracle.com>
	<20080710230002.GA32459@wotan.suse.de>
	<20080710232228.GE11809@mail.oracle.com>
Message-ID: <20080710233443.GD32459@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 10, 2008 at 04:22:28PM -0700, Joel Becker wrote:
> 	Actually, why does ro recover orphans?  That strikes me as
> beyond the bounds of RO.  Replaying the journal is different, because it
> is required for functional consistency.  A RO mount doesn't need to
> allocate, so it wouldn't worry about unrecovered orphans.

Maybe it doesn't? I'm just going by memory. Unfortunately, I don't think we
scan the orphan dir unless the dirty flag on the journal is set, so if they
don't get recovered then...


> 	Of course, we already have versions in the wild that recover
> orphans in RO mode, so perhaps the question is moot.

True, that.
	--Mark

--
Mark Fasheh
