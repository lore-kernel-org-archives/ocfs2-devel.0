From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 22 Aug 2008 13:18:08 -0700
Subject: [Ocfs2-devel] [PATCH 0/16] OCFS2: Add extended attributes
	support. V4
In-Reply-To: <48ABEB4B.2040003@oracle.com>
References: <48A929A4.90103@oracle.com> <20080819231613.GC8070@wotan.suse.de>
	<48ABEB4B.2040003@oracle.com>
Message-ID: <20080822201808.GA4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 20, 2008 at 06:00:43PM +0800, Tao Ma wrote:
> >Tiger, what is the likelyhood we can get some working mkfs and debugfs
> >patches soon? I'd really like to be able to run this and analyze the
> >effectivenes of our scheme.
> >  
> Tiger already has the patch for mkfs. See
> http://oss.oracle.com/pipermail/ocfs2-tools-devel/2008-August/000977.html

Is there any possibility of a debugfs patch soon, at least one that lets us
list EA's? I think it's important that we be able to analyze their
distribution in the btree...
	--Mark

--
Mark Fasheh
