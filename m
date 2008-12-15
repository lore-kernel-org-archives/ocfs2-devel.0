From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 15 Dec 2008 15:16:02 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/quota: Add QUOTA in mlog_attribute.
In-Reply-To: <1229292221-5147-1-git-send-email-tao.ma@oracle.com>
References: <1229292221-5147-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20081215231602.GU8791@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2008 at 06:03:41AM +0800, Tao Ma wrote:
> A new mlog mask has to be added into mlog_attribute before it can
> be really used in mlog. ML_QUOTA is only added in masklog.h, so
> add it to the array to enable it.

Thanks, this is in merge_window now.
	--Mark

--
Mark Fasheh
