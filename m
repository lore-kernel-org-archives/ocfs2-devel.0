From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 8 Jan 2009 18:15:14 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Access the xattr bucket only
	before modifying it.
In-Reply-To: <1231374103-5765-1-git-send-email-tao.ma@oracle.com>
References: <1231374103-5765-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090109021514.GD17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 08, 2009 at 08:21:43AM +0800, Tao Ma wrote:
> Hi Mark,
> 	This is the fix for 2.6.29(introduced by uniting the bucket journal
> access). Since I found no fixes-for-2.6.29 in your ocfs2.git, it is based
> on your original upstream-linus.

Sounds good - it's in ocfs2.git now  :)
	--Mark

--
Mark Fasheh
