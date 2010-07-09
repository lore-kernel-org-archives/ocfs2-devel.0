From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 09 Jul 2010 11:38:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make xattr extension work with new
 local alloc reservation.
In-Reply-To: <20100708185134.GD17445@mail.oracle.com>
References: <4C1AE141.60707@oracle.com>
	<1276830171-5908-1-git-send-email-tao.ma@oracle.com>
	<20100708185134.GD17445@mail.oracle.com>
Message-ID: <4C3699B9.3010204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 07/09/2010 02:51 AM, Joel Becker wrote:
> On Fri, Jun 18, 2010 at 11:02:50AM +0800, Tao Ma wrote:
>> @@ -735,8 +736,9 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
>>   					     ctxt->data_ac,
>>   					     ctxt->meta_ac,
>>   					&why);
>
> 	Btw, this code was already buggy.
> ocfs2_xattr_extend_allocation() calls ocfs2_add_clusters_in_btree(),
> which can return with RESTART_TRANS just because the filesystem is
> fragmented.  We would just fail with EAGAIN in that case, which makes no
> sense to a user.
> 	So this fix actually matters to older kernels and non-reflink
> operations too.  Would you agree it should go to the stable tree?  If
> so, add the Cc: to your commit message.
yes, the old kernel should be affected by this and we should have it in 
stable tree.

But I just have one concern: should I add stable to cc list the first 
time I create the patch? I am afraid not since it may be changed may 
times and have many revisions.

So my suggestion is that we go on the normal process, and when my patch 
get acked, I will resend it, add your ack and cc to stable. Agree? The 
same goes to other's patches.

Regards,
Tao
