From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 30 Oct 2008 16:34:08 -0700
Subject: [Ocfs2-devel] [PATCH 19/29] ocfs2: Fix check of return value of
	ocfs2_start_trans()
In-Reply-To: <12248861042458-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861042458-git-send-email-jack@suse.cz>
Message-ID: <20081030233408.GM15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:08:12AM +0200, Jan Kara wrote:
> On failure, ocfs2_start_trans() returns values like ERR_PTR(-ENOMEM).
> Thus checks for !handle are wrong. Fix them to use IS_ERR().

Btw, this is in the 'fixes' branch of ocfs2.git. now.
	--Mark

--
Mark Fasheh
