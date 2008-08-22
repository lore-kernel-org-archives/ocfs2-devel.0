From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 21 Aug 2008 17:42:40 -0700
Subject: [Ocfs2-devel] [PATCH] Go to the right place when we fail in
	ocfs2_expand_inline_dir.
In-Reply-To: <1219299267-11640-1-git-send-email-tao.ma@oracle.com>
References: <1219299267-11640-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20080822004239.GW4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 02:14:27PM +0800, Tao Ma wrote:
> When we fail to insert extent in ocfs2_expand_inline_dir, we should
> go to out_commit, not out.

This looks good, thanks.
	--Mark

--
Mark Fasheh
