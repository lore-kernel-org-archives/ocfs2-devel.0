From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 12 Jun 2008 16:51:15 -0700
Subject: [Ocfs2-devel] [PATCH 3/8] Make ocfs2_lock_allocators generic
	for extent	allocation.v1
In-Reply-To: <48507E90.1080408@oracle.com>
References: <484792D1.3080802@oracle.com>
	<20080605073240.GA19775@tma-pc2.cn.oracle.com>
	<20080611233108.GN28100@wotan.suse.de>
	<48507E90.1080408@oracle.com>
Message-ID: <20080612235115.GS28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 12, 2008 at 09:40:32AM +0800, Tao Ma wrote:
> Hi Mark,
> 	Thanks for the review.
> 	I will modify it according to your suggestions.
> 
> Mark Fasheh wrote:
> >The rest of this looks good. It's a big patch, but it looks good :) The 
> >only
> >conern I have isn't really with your code per se, but with layout of our
> >source files. Alloc.c keeps growing... and growing... and growing... At 
> >some
> >point it might be worth our while to split things out at least so that we
> >have a 'core btree operations' file.
> Yes, now alloc.c have more than 6000 lines. And maybe a new file name 
> btree.c can be split out from this file that will do the real work of 
> btree operation since with my patch, btree now isn't used by inode only. ;)
> I will handle this after the xattr patch is committed. Thanks.

Btree.c sounds good to me. I think maybe we can split out some parts of the
indexed btree code into their own file as well - that last patch looks
pretty big  ;)
	--Mark


> 
> Regards,
> Tao
--
Mark Fasheh
