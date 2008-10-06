From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 6 Oct 2008 10:54:05 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Fix a bug when inserting
	xattr.
In-Reply-To: <1221833794-15198-1-git-send-email-tao.ma@oracle.com>
References: <1221833794-15198-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20081006175405.GI4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 19, 2008 at 10:16:34PM +0800, Tao Ma wrote:
> During the process of xatt insertion, we use binary search
> to find the right place and "low" is set to it. But when
> there is one xattr which has the same name hash as the inserted
> one, low is the wrong value. So set it to the right position.
> 

Great, thanks Tao.
	--Mark

--
Mark Fasheh
