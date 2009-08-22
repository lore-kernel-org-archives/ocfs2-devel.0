From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 22 Aug 2009 08:31:28 +0800
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <20090821234210.GH4330@mail.oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-19-git-send-email-tao.ma@oracle.com>
	<20090821211259.GD4330@mail.oracle.com>
	<4A8F2B23.9060903@oracle.com>
	<20090821234210.GH4330@mail.oracle.com>
Message-ID: <4A8F3C60.4070905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Sat, Aug 22, 2009 at 07:17:55AM +0800, Tao Ma wrote:
>   
>> Joel Becker wrote:
>> yes, that is anticipated. We CoW 1MB at most at a time.
>>     
>
> 	No!  We want to CoW the entire write_len at once!  That's why I
> wrote cal_cow_cluters() the way I did!
>   
oh, yes. My brain is stuck in the old "MAX_COW_BYTES".  now we have 
"MAX_CONTIG_BYTES".
>   
>> yes, we can put a check there, but we can't resolve the 1MB issue
>> you mentioned above either. Maybe we can make ocfs2_refcount_cow
>> more intelligent? But I would say let us leave it as-is and this can
>> be a future improvement.
>>     
>
> 	If you make ocfs2_refcount_cow() into ocfs2_refcount_cow_hunk()
> like I described in my email, make the your ocfs2_refcount_cluters()
> into a new ocfs2_refcount_cow() like I described, then we can CoW the
> entire write at once.
>
>   
>> oh, yes, this is really a bug. I don't think of O_DIRECT when I
>> created this patch set. So I may really need to add a check in
>> ocfs2_prepare_inode_for_write(I guess just need to call
>> ocfs2_refcount_cow and make write_len<=1MB).
>>     
>
> 	No, you pass a write_len of the full I/O!  We don't want to
> fragment the thing, and there's no reason to :-)
>   
yes.
>   
>> This also make me think that we can cal ocfs2_refcount_cow right
>> before we populate_write_desc, so that we don't need to call it
>> twice and we can directly BUG_ON(ext_flags & REFCOUNTED) in it.
>>     
>
> 	With the new ocfs2_refcount_cow() that loops over the entire
> write, absolutely.
>   
sure.

Regards,
Tao
