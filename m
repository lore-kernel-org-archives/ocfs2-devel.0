From: John Lightsey <john@nixnuts.net>
Date: Mon, 20 Nov 2017 20:45:09 -0600
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
 /build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
References: <1511204090.3644.6.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <1511232309.3644.14.camel@nixnuts.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2017-11-21 at 00:58 +0000, Changwei Ge wrote:
> > @@ -873,6 +875,7 @@ static int ocfs2_alloc_write_ctxt(struct
> > ocfs2_write_ctxt **wcp,
> > ?
> > ?	ocfs2_init_dealloc_ctxt(&wc->w_dealloc);
> > ?	INIT_LIST_HEAD(&wc->w_unwritten_list);
> > +	wc->w_unwritten_count = 0;
> 
> I think you don't have to evaluate ::w_unwritten_count to zero since?
> kzalloc already did that.

Very true. I was following the example of how dwc was handling the
dw_zero_count. You'll have to forgive me a bit. I'm very unfamiliar
with the linux kernel codebase.

> 
> > ?
> > ?	*wcp = wc;
> > ?
> > @@ -1373,6 +1376,7 @@ static int ocfs2_unwritten_check(struct inode
> > *inode,
> > ?	desc->c_clear_unwritten = 0;
> > ?	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
> > ?	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
> > +	wc->w_unwritten_count++;
> 
> You increase ::w_unwritten_coun once a new _ue_ is attached to?
> ::w_unwritten_list. So if no _ue_ ever is attached,
> ::w_unwritten_list?
> is still empty. I think your change has the same effect with origin.
> 
> Moreover I don't see the relation between the reported crash issue
> and?your patch change. Can you elaborate further?

The important part is in the next segment in the patch. This block is
just using w_unwritten_count to track the size of w_unwritten_list.

> > @@ -2246,7 +2250,7 @@ static int ocfs2_dio_get_block(struct inode
> > *inode, sector_t iblock,
> > ?		ue->ue_phys = desc->c_phys;
> > ?
> > ?		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
> > -		dwc->dw_zero_count++;
> > +		dwc->dw_zero_count += wc->w_unwritten_count;
> > ?	}
> > ?
> > 

dw_zero_count is tracking the number of elements in dw_zero_list.

The old version assumed that after dw_zero_list and w_unwritten_list
were spliced together, that the new length was dw_zero_count + 1. This
assumption is not correct if w_unwritten_list contained more than one
element.

The length of dw_zero_list is used by ocfs2_dio_end_io_write() to
determine whether or not meta_ac will be needed to complete the write:

????ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
????????????????????&data_ac, &meta_ac);

This will return with success and a null meta_ac if there are at least
dw_zero_count * 2 extents available for the write.

Since dw_zero_count was not being calculated correctly, this will
occasionally result in the write getting into ocfs2_grow_tree() with a
null meta_ac following this chain:

ocfs2_dio_end_io_write()
ocfs2_mark_extent_written()
ocfs2_change_extent_flag()
ocfs2_split_extent()
ocfs2_split_and_insert()
ocfs2_grow_tree()

That's my understanding of what's causing the bug.

Our OCFS2 cluster was crashing every two to three hours after we
upgraded to a 4.x kernel. We've gone about 18 hours with this patch
applied and no crashes.
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 833 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171120/b68bb5fa/attachment.bin 
