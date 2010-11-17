From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 17 Nov 2010 09:12:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlmfs: use GFP_KERNEL instead of
 GFP_NOFS
In-Reply-To: <4CE2BD0C.3020501@oracle.com>
References: <201011161537.oAG4gEQI002875@acsinet15.oracle.com>
	<4CE2BD0C.3020501@oracle.com>
Message-ID: <20101117011235.GA2289@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-11-16 09:19, Sunil Mushran wrote:
> We do NOFS allocs in the dlm to prevent deadlocks (not live locks).
> And you are right we don't have to do NOFS allocs here. But the sizes
> we are talking about are really small. Do we really care?

I didn't hit problem at the allocation with NOFS.
I just noticed it when looking at the codes.
Since the sizes are small, it shouldn't effects much.

The locks I meant is not dlm related. It's when system feel memory
pressure and causes filesystems sync data to disk to free memory. During that
time I think it's live lock if we allocate memory(GFP_KERNEL) when syncing data
to disk. no?

regards,
wengang.
> 
> On 11/16/2010 07:33 AM, Wengang Wang wrote:
> >There is no need for dlmfs to sync data to disk so that no memory is needed
> >for that purpose. So no worry about the live lock: sync data ->  alloc mem ->
> >sync data ->.... We'd better use GFP_KERNEL instead of GFP_NOFS to allow FS sync
> >during the memory allocation.
> >
