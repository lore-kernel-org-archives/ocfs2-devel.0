From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 Nov 2008 11:45:31 -0800
Subject: [Ocfs2-devel] [PATCH 01/15] ocfs2/xattr: Only extend xattr
	bucket in need.
In-Reply-To: <1225345335-11527-1-git-send-email-tao.ma@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20081106194531.GD15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 01:42:11PM +0800, Tao Ma wrote:
> When the first block of a bucket is filled up with xattr
> entries, we normally extend the bucket. But if we are
> just replace one xattr with small length, we don't need
> to extend it. This is important since we will calculate
> what we need before the transaction and in this situation
> no resources will be allocated.

Ok, looks good. Am I correct in thinking that this is a fix which should go
upstream before 2.6.28 is out?
	--Mark

--
Mark Fasheh
