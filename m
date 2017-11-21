From: John Lightsey <john@nixnuts.net>
Date: Mon, 20 Nov 2017 22:24:56 -0600
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
 /build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
In-Reply-To: <5A1397BE.9070808@huawei.com>
References: <1511204090.3644.6.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
	<5A1397BE.9070808@huawei.com>
Message-ID: <1511238296.2765.1.camel@nixnuts.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2017-11-21 at 11:04 +0800, piaojun wrote:
> > > ?	new = NULL;
> > > ?unlock:
> > > ?	spin_unlock(&oi->ip_lock);
> > > @@ -2246,7 +2250,7 @@ static int ocfs2_dio_get_block(struct inode
> > > *inode, sector_t iblock,
> > > ?		ue->ue_phys = desc->c_phys;
> > > ?
> > > ?		list_splice_tail_init(&wc->w_unwritten_list,
> > > &dwc->dw_zero_list);
> > > -		dwc->dw_zero_count++;
> > > +		dwc->dw_zero_count += wc->w_unwritten_count;
> 
> I prefer using a loop to calculate 'dwc->dw_zero_count' rather than
> introducing a new variable as below:
> 
> list_for_each(iter, &wc->w_unwritten_list)
> 	dwc->dw_zero_count++;

If you want to iterate through the list to calculate the length rather
than tracking the length as the list grows, it would make more sense to
remove dw_zero_count.

If you'd prefer walking all of the elements to calculate the length,
this can just be done in ocfs2_dio_end_io_write() where the length of
the list is actually used.

I assumed that the intent of dw_zero_count was to avoid an unnecessary
iteration through dw_zero_list to determine the length.
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 833 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171120/85820571/attachment-0001.bin 
