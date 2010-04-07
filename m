From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 7 Apr 2010 14:53:16 -0700
Subject: [Ocfs2-devel] [RFC] ocfs2: Make ocfs2_extend_trans really
	extending.
In-Reply-To: <1269244904-5783-1-git-send-email-tao.ma@oracle.com>
References: <1269244904-5783-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100407215316.GQ11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 22, 2010 at 04:01:44PM +0800, Tao Ma wrote:
> Hi Joel/Mark/Sunil,
> 	This patch just want to make ocfs2_extend_trans(which used
> to restart the journal with only 'nblocks' in some case) really
> extending. I have met with many troubles when I used this function
> in implementing xattr support. And I used to think that it is
> my fault.
> 
> But I changed my mind when I saw that Joel(Sorry, Joel, ;) ) also use
> it wrongly. See
> http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=commitdiff;h=991f171d287781ae12d1ec06cb1917dae3334a9b;hp=f5abd5404e8d1551f1bf58b711543e3b5dcc1079
> 
> Acutally ocfs2_extend_trans in ocfs2_block_group_alloc_discontig
> has to be
> 	status = ocfs2_extend_trans(handle,
> 				    ocfs2_calc_bg_discontig_credits(osb->sb) +
> 				    handle->h_buffer_credits);
> because we will modify the bitmap file later which isn't included in
> ocfs2_calc_bg_discontig_credits.
> 
> That makes me to think more. So why we don't reserve the old blocks? I just
> skimmed all the callers of ocfs2_extend_trans, and to my surprise, 12 of 15
> callers added h_buffer_credits by themself to avoid the problem. Then why
> handle this in ocfs2_extend_trans? So here comes the patch. Please review.

Tao, this patch looks good to me. Thank you for taking on the time to fix up
this old interface. Have you tested the patch much? What are the results
like? Not only in stability, but does the new math inside
ocfs2_extend_trans() speed up any long-running operations?
	--Mark

--
Mark Fasheh
