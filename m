From: John Lightsey <john@nixnuts.net>
Date: Fri, 29 Dec 2017 15:15:59 -0600
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: try to reuse extent block in
 dealloc without meta_alloc
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2909D75@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F2908FC7@H3CMLB12-EX.srv.huawei-3com.com>
	<5A448D59.4040603@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2909D75@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <1514582159.2812.5.camel@nixnuts.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 2017-12-28 at 06:38 +0000, Changwei Ge wrote:
> Hi Alex,
> 
> On 2017/12/28 14:22, alex chen wrote:
> > We has doubled extent number in ocfs2_populate_write_desc(), so
> > here we don't need to double again.
> 
> I think your comment here makes sense.
> I will remove the multiplier 2 in my next version of this patch.
> 

This may have made it function in testing where it should have failed.

I backported this patch to Debian's 4.9.65 kernel today, removed the *2
multiplier, and hit a related assertion failure in this codepath:

ocfs2_mark_extent_written
 ocfs2_change_extent_flag
   ocfs2_split_extent
    ocfs2_split_and_insert
     ocfs2_grow_tree
      ocfs2_add_branch
       ocfs2_create_new_meta_bhs
        ocfs2_claim_metadata

The assertion failure in ocfs2_claim_metadata() was

BUG_ON(ac->ac_bits_wanted < (ac->ac_bits_given + bits_wanted));

My guess is that meta_ac was allocated at the beginning of the write,
then the tree was truncated during the write, so the actual allocation
is requesting more than was originally reserved.

It seems like the codepaths where meta_ac != NULL also need to know
about the list of extents available in et_dealloc.

The Perl code I used to hit this bug is attached.
-------------- next part --------------
A non-text attachment was scrubbed...
Name: directio.pl
Type: application/x-perl
Size: 2145 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171229/396d8318/attachment.bin 
