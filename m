From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 23 Apr 2010 13:45:45 -0700
Subject: [Ocfs2-devel] [RFC] ocfs2: Make ocfs2_extend_trans really
	extending.
In-Reply-To: <1271820579-29614-1-git-send-email-tao.ma@oracle.com>
References: <20100407235403.GA4573@mail.oracle.com>
	<1271820579-29614-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100423204545.GB10637@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 21, 2010 at 11:29:39AM +0800, Tao Ma wrote:
> I have finished the tests on xattr and reflink(I use reflink for b-tree
> test because it also use b-tree heavily and also it has a stress test
> case which create a b-tree with depth=2 easily). Both test cases works.
> So please consider including it in the merge window. Thanks.

	I think I'm happy to take this patch, but a couple things first.

> I also changed the patch a little in the beginning of ocfs2_extend_trans.
> -	BUG_ON(!nblocks);
> +	if (nblocks <= 0)
> +		return 0;
> +
> The reason is that some b-tree codes now will extend transcation with
> tree depth. So sometimes it may give us a '0' and we will just return back.

	Well, negative nblocks is still a bug, right?  shouldn't we at
least warn or make it an unsigned int?

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
